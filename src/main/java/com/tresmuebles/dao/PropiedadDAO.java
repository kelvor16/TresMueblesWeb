package com.tresmuebles.dao;

import com.tresmuebles.model.Caracteristica;
import com.tresmuebles.model.Ciudad;
import com.tresmuebles.model.ImagenPropiedad;
import com.tresmuebles.model.Propiedad;
import com.tresmuebles.model.TipoPropiedad;
import com.tresmuebles.model.Usuario;
import com.tresmuebles.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class PropiedadDAO {

    public boolean registrarPropiedad(Propiedad p) {
        String sqlProp = "INSERT INTO propiedad (matricula_inmobiliaria, id_tipo, id_ciudad, id_agente, titulo, descripcion, precio, area, habitaciones, banos, estado_publicacion) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String sqlImg = "INSERT INTO imagen_propiedad (id_propiedad, url_imagen, es_principal) VALUES (?, ?, ?)";
        String sqlCarac = "INSERT INTO propiedad_caracteristica (id_propiedad, id_caracteristica) VALUES (?, ?)";

        Connection con = null;
        try {
            con = ConexionDB.getInstancia().getConexion();
            con.setAutoCommit(false); // Iniciar transacción

            // 1. Insertar propiedad
            int idPropiedad = 0;
            try (PreparedStatement psProp = con.prepareStatement(sqlProp, Statement.RETURN_GENERATED_KEYS)) {
                psProp.setString(1, p.getMatriculaInmobiliaria());
                psProp.setInt(2, p.getTipo().getIdTipo());
                psProp.setInt(3, p.getCiudad().getIdCiudad());
                psProp.setInt(4, p.getAgente().getIdUsuario());
                psProp.setString(5, p.getTitulo());
                psProp.setString(6, p.getDescripcion());
                psProp.setDouble(7, p.getPrecio());
                psProp.setDouble(8, p.getArea());
                psProp.setInt(9, p.getHabitaciones());
                psProp.setInt(10, p.getBanos());
                psProp.setString(11, p.getEstadoPublicacion());
                psProp.executeUpdate();

                try (ResultSet rs = psProp.getGeneratedKeys()) {
                    if (rs.next()) {
                        idPropiedad = rs.getInt(1);
                    }
                }
            }

            // 2. Insertar Imágenes
            if (p.getImagenes() != null && !p.getImagenes().isEmpty()) {
                try (PreparedStatement psImg = con.prepareStatement(sqlImg)) {
                    for (ImagenPropiedad img : p.getImagenes()) {
                        psImg.setInt(1, idPropiedad);
                        psImg.setString(2, img.getUrlImagen());
                        psImg.setBoolean(3, img.isEsPrincipal());
                        psImg.addBatch();
                    }
                    psImg.executeBatch();
                }
            }

            // 3. Insertar Características
            if (p.getCaracteristicas() != null && !p.getCaracteristicas().isEmpty()) {
                try (PreparedStatement psCarac = con.prepareStatement(sqlCarac)) {
                    for (Caracteristica carac : p.getCaracteristicas()) {
                        psCarac.setInt(1, idPropiedad);
                        psCarac.setInt(2, carac.getIdCaracteristica());
                        psCarac.addBatch();
                    }
                    psCarac.executeBatch();
                }
            }

            con.commit();
            return true;
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public List<Propiedad> listarPorAgente(int idAgente) {
        List<Propiedad> lista = new ArrayList<>();
        String sql = "SELECT p.*, t.nombre as tipo_nombre, c.nombre as ciudad_nombre, c.departamento " +
                     "FROM propiedad p " +
                     "INNER JOIN tipo_propiedad t ON p.id_tipo = t.id_tipo " +
                     "INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad " +
                     "WHERE p.id_agente = ?";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idAgente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Propiedad p = mapearPropiedadBasica(rs);
                    p.setImagenes(obtenerImagenes(p.getIdPropiedad(), con));
                    lista.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Propiedad> buscarPropiedades(Integer idCiudad, Integer idTipo, Double precioMin, Double precioMax) {
        List<Propiedad> lista = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, t.nombre as tipo_nombre, c.nombre as ciudad_nombre, c.departamento " +
            "FROM propiedad p " +
            "INNER JOIN tipo_propiedad t ON p.id_tipo = t.id_tipo " +
            "INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad " +
            "WHERE p.estado_publicacion = 'disponible'"
        );
        
        List<Object> parametros = new ArrayList<>();

        if (idCiudad != null && idCiudad > 0) {
            sql.append(" AND p.id_ciudad = ?");
            parametros.add(idCiudad);
        }
        if (idTipo != null && idTipo > 0) {
            sql.append(" AND p.id_tipo = ?");
            parametros.add(idTipo);
        }
        if (precioMin != null) {
            sql.append(" AND p.precio >= ?");
            parametros.add(precioMin);
        }
        if (precioMax != null) {
            sql.append(" AND p.precio <= ?");
            parametros.add(precioMax);
        }

        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
             
            for (int i = 0; i < parametros.size(); i++) {
                ps.setObject(i + 1, parametros.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Propiedad p = mapearPropiedadBasica(rs);
                    p.setImagenes(obtenerImagenes(p.getIdPropiedad(), con));
                    lista.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Propiedad obtenerPropiedad(int idPropiedad) {
        Propiedad p = null;
        String sql = "SELECT p.*, t.nombre as tipo_nombre, c.nombre as ciudad_nombre, c.departamento " +
                     "FROM propiedad p " +
                     "INNER JOIN tipo_propiedad t ON p.id_tipo = t.id_tipo " +
                     "INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad " +
                     "WHERE p.id_propiedad = ?";
                     
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPropiedad);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    p = mapearPropiedadBasica(rs);
                    p.setImagenes(obtenerImagenes(idPropiedad, con));
                    p.setCaracteristicas(obtenerCaracteristicas(idPropiedad, con));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return p;
    }

    public boolean cambiarEstado(int idPropiedad, String nuevoEstado, int idAgente) {
        String sql = "UPDATE propiedad SET estado_publicacion = ? WHERE id_propiedad = ? AND id_agente = ?";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idPropiedad);
            ps.setInt(3, idAgente);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean actualizarPropiedad(Propiedad p) {
        String sql = "UPDATE propiedad SET matricula_inmobiliaria = ?, id_tipo = ?, id_ciudad = ?, " +
                     "titulo = ?, descripcion = ?, precio = ?, area = ?, habitaciones = ?, banos = ? " +
                     "WHERE id_propiedad = ? AND id_agente = ?";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getMatriculaInmobiliaria());
            ps.setInt(2, p.getTipo().getIdTipo());
            ps.setInt(3, p.getCiudad().getIdCiudad());
            ps.setString(4, p.getTitulo());
            ps.setString(5, p.getDescripcion());
            ps.setDouble(6, p.getPrecio());
            ps.setDouble(7, p.getArea());
            ps.setInt(8, p.getHabitaciones());
            ps.setInt(9, p.getBanos());
            ps.setInt(10, p.getIdPropiedad());
            ps.setInt(11, p.getAgente().getIdUsuario());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Helper methods
    private Propiedad mapearPropiedadBasica(ResultSet rs) throws SQLException {
        Propiedad p = new Propiedad();
        p.setIdPropiedad(rs.getInt("id_propiedad"));
        p.setMatriculaInmobiliaria(rs.getString("matricula_inmobiliaria"));
        p.setTitulo(rs.getString("titulo"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setPrecio(rs.getDouble("precio"));
        p.setArea(rs.getDouble("area"));
        p.setHabitaciones(rs.getInt("habitaciones"));
        p.setBanos(rs.getInt("banos"));
        p.setEstadoPublicacion(rs.getString("estado_publicacion"));

        TipoPropiedad tp = new TipoPropiedad();
        tp.setIdTipo(rs.getInt("id_tipo"));
        tp.setNombre(rs.getString("tipo_nombre"));
        p.setTipo(tp);

        Ciudad c = new Ciudad();
        c.setIdCiudad(rs.getInt("id_ciudad"));
        c.setNombre(rs.getString("ciudad_nombre"));
        c.setDepartamento(rs.getString("departamento"));
        p.setCiudad(c);
        
        Usuario ag = new Usuario();
        ag.setIdUsuario(rs.getInt("id_agente"));
        p.setAgente(ag);

        return p;
    }

    private List<ImagenPropiedad> obtenerImagenes(int idPropiedad, Connection con) throws SQLException {
        List<ImagenPropiedad> lista = new ArrayList<>();
        String sql = "SELECT * FROM imagen_propiedad WHERE id_propiedad = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPropiedad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ImagenPropiedad img = new ImagenPropiedad();
                    img.setIdImagen(rs.getInt("id_imagen"));
                    img.setIdPropiedad(idPropiedad);
                    img.setUrlImagen(rs.getString("url_imagen"));
                    img.setEsPrincipal(rs.getBoolean("es_principal"));
                    lista.add(img);
                }
            }
        }
        return lista;
    }

    private List<Caracteristica> obtenerCaracteristicas(int idPropiedad, Connection con) throws SQLException {
        List<Caracteristica> lista = new ArrayList<>();
        String sql = "SELECT c.id_caracteristica, c.nombre FROM caracteristica c " +
                     "INNER JOIN propiedad_caracteristica pc ON c.id_caracteristica = pc.id_caracteristica " +
                     "WHERE pc.id_propiedad = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPropiedad);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(new Caracteristica(rs.getInt("id_caracteristica"), rs.getString("nombre")));
                }
            }
        }
        return lista;
    }
}
