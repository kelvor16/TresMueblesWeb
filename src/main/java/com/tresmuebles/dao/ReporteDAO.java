package com.tresmuebles.dao;

import com.tresmuebles.model.Propiedad;
import com.tresmuebles.model.ReportePropiedadCiudad;
import com.tresmuebles.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReporteDAO {

    // REPORTE CON INNER JOIN, GROUP BY y HAVING
    public List<ReportePropiedadCiudad> reportePropiedadesPorCiudad() {
        List<ReportePropiedadCiudad> lista = new ArrayList<>();
        String sql = "SELECT c.nombre AS ciudad, c.departamento, p.estado_publicacion AS estado, " +
                     "COUNT(p.id_propiedad) as cantidad, AVG(p.precio) as precio_promedio " +
                     "FROM propiedad p " +
                     "INNER JOIN ciudad c ON p.id_ciudad = c.id_ciudad " +
                     "GROUP BY c.nombre, c.departamento, p.estado_publicacion " +
                     "HAVING COUNT(p.id_propiedad) > 0 " +
                     "ORDER BY c.nombre, p.estado_publicacion";
        
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                ReportePropiedadCiudad r = new ReportePropiedadCiudad();
                r.setCiudad(rs.getString("ciudad"));
                r.setDepartamento(rs.getString("departamento"));
                r.setEstado(rs.getString("estado"));
                r.setCantidad(rs.getInt("cantidad"));
                r.setPrecioPromedio(rs.getDouble("precio_promedio"));
                lista.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    // REPORTE CON LEFT JOIN (Propiedades sin citas)
    public List<Propiedad> reportePropiedadesSinCitas() {
        List<Propiedad> lista = new ArrayList<>();
        String sql = "SELECT p.matricula_inmobiliaria, p.titulo, p.precio " +
                     "FROM propiedad p " +
                     "LEFT JOIN cita c ON p.id_propiedad = c.id_propiedad " +
                     "WHERE c.id_cita IS NULL";
                     
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                Propiedad p = new Propiedad();
                p.setMatriculaInmobiliaria(rs.getString("matricula_inmobiliaria"));
                p.setTitulo(rs.getString("titulo"));
                p.setPrecio(rs.getDouble("precio"));
                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}
