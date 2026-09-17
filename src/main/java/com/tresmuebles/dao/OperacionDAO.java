package com.tresmuebles.dao;

import com.tresmuebles.model.Cita;
import com.tresmuebles.model.DocumentoSolicitud;
import com.tresmuebles.model.Favorito;
import com.tresmuebles.model.Propiedad;
import com.tresmuebles.model.Solicitud;
import com.tresmuebles.model.Usuario;
import com.tresmuebles.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OperacionDAO {

    public boolean agendarCita(int idPropiedad, int idCliente, String fechaHoraStr) throws SQLException {
        String sql = "INSERT INTO cita (id_propiedad, id_cliente, fecha_hora) VALUES (?, ?, ?)";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPropiedad);
            ps.setInt(2, idCliente);
            ps.setString(3, fechaHoraStr);
            return ps.executeUpdate() > 0;
        }
        // Excepción de clave UNIQUE (id_propiedad, fecha_hora) será arrojada hacia arriba
    }

    public boolean marcarFavorito(int idPropiedad, int idCliente) {
        String sql = "INSERT IGNORE INTO favorito (id_propiedad, id_cliente) VALUES (?, ?)";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPropiedad);
            ps.setInt(2, idCliente);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminarFavorito(int idPropiedad, int idCliente) {
        String sql = "DELETE FROM favorito WHERE id_propiedad = ? AND id_cliente = ?";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPropiedad);
            ps.setInt(2, idCliente);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cancelarCita(int idCita, int idCliente) {
        String sql = "UPDATE cita SET estado = 'cancelada' WHERE id_cita = ? AND id_cliente = ?";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCita);
            ps.setInt(2, idCliente);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean editarCita(int idCita, int idCliente, String nuevaFechaHora) throws SQLException {
        String sql = "UPDATE cita SET fecha_hora = ? WHERE id_cita = ? AND id_cliente = ?";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevaFechaHora);
            ps.setInt(2, idCita);
            ps.setInt(3, idCliente);
            return ps.executeUpdate() > 0;
        }
        // Excepción de clave UNIQUE será arrojada si hay cruce
    }

    public boolean radicarSolicitud(int idPropiedad, int idCliente, String tipo, String docNombre, String docUrl) {
        String sqlSol = "INSERT INTO solicitud (id_propiedad, id_cliente, tipo) VALUES (?, ?, ?)";
        String sqlDoc = "INSERT INTO documento_solicitud (id_solicitud, nombre_documento, url_documento) VALUES (?, ?, ?)";
        
        Connection con = null;
        try {
            con = ConexionDB.getInstancia().getConexion();
            con.setAutoCommit(false);

            int idSolicitud = 0;
            try (PreparedStatement psSol = con.prepareStatement(sqlSol, Statement.RETURN_GENERATED_KEYS)) {
                psSol.setInt(1, idPropiedad);
                psSol.setInt(2, idCliente);
                psSol.setString(3, tipo);
                psSol.executeUpdate();
                try (ResultSet rs = psSol.getGeneratedKeys()) {
                    if (rs.next()) idSolicitud = rs.getInt(1);
                }
            }

            if (docUrl != null && !docUrl.isEmpty()) {
                try (PreparedStatement psDoc = con.prepareStatement(sqlDoc)) {
                    psDoc.setInt(1, idSolicitud);
                    psDoc.setString(2, docNombre);
                    psDoc.setString(3, docUrl);
                    psDoc.executeUpdate();
                }
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) try { con.rollback(); } catch(Exception ex){}
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) try { con.setAutoCommit(true); con.close(); } catch(Exception ex){}
        }
    }

    public List<Favorito> listarFavoritosPorCliente(int idCliente) {
        List<Favorito> lista = new ArrayList<>();
        String sql = "SELECT f.*, p.titulo, p.precio FROM favorito f INNER JOIN propiedad p ON f.id_propiedad = p.id_propiedad WHERE f.id_cliente = ?";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Favorito f = new Favorito();
                    f.setIdFavorito(rs.getInt("id_favorito"));
                    Propiedad p = new Propiedad();
                    p.setIdPropiedad(rs.getInt("id_propiedad"));
                    p.setTitulo(rs.getString("titulo"));
                    p.setPrecio(rs.getDouble("precio"));
                    f.setPropiedad(p);
                    lista.add(f);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Cita> listarCitasPorCliente(int idCliente) {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, p.titulo FROM cita c INNER JOIN propiedad p ON c.id_propiedad = p.id_propiedad WHERE c.id_cliente = ? ORDER BY c.fecha_hora DESC";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cita c = new Cita();
                    c.setIdCita(rs.getInt("id_cita"));
                    c.setEstado(rs.getString("estado"));
                    if (rs.getTimestamp("fecha_hora") != null) {
                        c.setFechaHora(rs.getTimestamp("fecha_hora").toLocalDateTime());
                    }
                    Propiedad p = new Propiedad();
                    p.setIdPropiedad(rs.getInt("id_propiedad"));
                    p.setTitulo(rs.getString("titulo"));
                    c.setPropiedad(p);
                    lista.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Solicitud> listarSolicitudesPorAgente(int idAgente) {
        List<Solicitud> lista = new ArrayList<>();
        String sql = "SELECT s.*, p.titulo, u.correo, d.nombre_documento, d.url_documento FROM solicitud s " +
                     "INNER JOIN propiedad p ON s.id_propiedad = p.id_propiedad " +
                     "INNER JOIN usuario u ON s.id_cliente = u.id_usuario " +
                     "LEFT JOIN documento_solicitud d ON s.id_solicitud = d.id_solicitud " +
                     "WHERE p.id_agente = ? ORDER BY s.fecha_radicacion DESC";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idAgente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Solicitud s = new Solicitud();
                    s.setIdSolicitud(rs.getInt("id_solicitud"));
                    s.setTipo(rs.getString("tipo"));
                    s.setEstado(rs.getString("estado"));
                    if (rs.getTimestamp("fecha_radicacion") != null) {
                        s.setFechaRadicacion(rs.getTimestamp("fecha_radicacion").toLocalDateTime());
                    }
                    
                    Propiedad p = new Propiedad();
                    p.setTitulo(rs.getString("titulo"));
                    s.setPropiedad(p);
                    
                    Usuario u = new Usuario();
                    u.setCorreo(rs.getString("correo"));
                    s.setCliente(u);

                    String urlDoc = rs.getString("url_documento");
                    if (urlDoc != null && !urlDoc.isEmpty()) {
                        DocumentoSolicitud doc = new DocumentoSolicitud();
                        doc.setNombreDocumento(rs.getString("nombre_documento"));
                        doc.setUrlDocumento(urlDoc);
                        List<DocumentoSolicitud> docs = new ArrayList<>();
                        docs.add(doc);
                        s.setDocumentos(docs);
                    }
                    
                    lista.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Cita> listarCitasPorAgente(int idAgente) {
        List<Cita> lista = new ArrayList<>();
        String sql = "SELECT c.*, p.titulo, cli.correo, per.nombres, per.apellidos, per.telefono " +
                     "FROM cita c " +
                     "INNER JOIN propiedad p ON c.id_propiedad = p.id_propiedad " +
                     "INNER JOIN usuario cli ON c.id_cliente = cli.id_usuario " +
                     "LEFT JOIN perfil per ON cli.id_usuario = per.id_usuario " +
                     "WHERE p.id_agente = ? " +
                     "ORDER BY c.fecha_hora DESC";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idAgente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cita c = new Cita();
                    c.setIdCita(rs.getInt("id_cita"));
                    c.setEstado(rs.getString("estado"));
                    if (rs.getTimestamp("fecha_hora") != null) {
                        c.setFechaHora(rs.getTimestamp("fecha_hora").toLocalDateTime());
                    }
                    Propiedad p = new Propiedad();
                    p.setIdPropiedad(rs.getInt("id_propiedad"));
                    p.setTitulo(rs.getString("titulo"));
                    c.setPropiedad(p);

                    Usuario cli = new Usuario();
                    cli.setIdUsuario(rs.getInt("id_cliente"));
                    cli.setCorreo(rs.getString("correo"));
                    com.tresmuebles.model.Perfil per = new com.tresmuebles.model.Perfil();
                    per.setNombres(rs.getString("nombres") != null ? rs.getString("nombres") : "");
                    per.setApellidos(rs.getString("apellidos") != null ? rs.getString("apellidos") : "");
                    per.setTelefono(rs.getString("telefono") != null ? rs.getString("telefono") : "");
                    cli.setPerfil(per);
                    c.setCliente(cli);

                    lista.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean cambiarEstadoCitaAgente(int idCita, String nuevoEstado) {
        String sql = "UPDATE cita SET estado = ? WHERE id_cita = ?";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idCita);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Solicitud> listarSolicitudesPorCliente(int idCliente) {
        List<Solicitud> lista = new ArrayList<>();
        String sql = "SELECT s.*, p.titulo, d.nombre_documento, d.url_documento FROM solicitud s " +
                     "INNER JOIN propiedad p ON s.id_propiedad = p.id_propiedad " +
                     "LEFT JOIN documento_solicitud d ON s.id_solicitud = d.id_solicitud " +
                     "WHERE s.id_cliente = ? ORDER BY s.fecha_radicacion DESC";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Solicitud s = new Solicitud();
                    s.setIdSolicitud(rs.getInt("id_solicitud"));
                    s.setTipo(rs.getString("tipo"));
                    s.setEstado(rs.getString("estado"));
                    if (rs.getTimestamp("fecha_radicacion") != null) {
                        s.setFechaRadicacion(rs.getTimestamp("fecha_radicacion").toLocalDateTime());
                    }
                    
                    Propiedad p = new Propiedad();
                    p.setTitulo(rs.getString("titulo"));
                    s.setPropiedad(p);
                    
                    String urlDoc = rs.getString("url_documento");
                    if (urlDoc != null && !urlDoc.isEmpty()) {
                        DocumentoSolicitud doc = new DocumentoSolicitud();
                        doc.setNombreDocumento(rs.getString("nombre_documento"));
                        doc.setUrlDocumento(urlDoc);
                        List<DocumentoSolicitud> docs = new ArrayList<>();
                        docs.add(doc);
                        s.setDocumentos(docs);
                    }
                    
                    lista.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean cambiarEstadoSolicitud(int idSolicitud, String estado) {
        String sql = "UPDATE solicitud SET estado = ? WHERE id_solicitud = ?";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setInt(2, idSolicitud);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
