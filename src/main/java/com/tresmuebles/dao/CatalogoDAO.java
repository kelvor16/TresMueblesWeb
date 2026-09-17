package com.tresmuebles.dao;

import com.tresmuebles.model.Caracteristica;
import com.tresmuebles.model.Ciudad;
import com.tresmuebles.model.TipoPropiedad;
import com.tresmuebles.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CatalogoDAO {

    public List<Ciudad> obtenerCiudades() {
        List<Ciudad> lista = new ArrayList<>();
        String sql = "SELECT * FROM ciudad ORDER BY nombre";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Ciudad c = new Ciudad();
                c.setIdCiudad(rs.getInt("id_ciudad"));
                c.setNombre(rs.getString("nombre"));
                c.setDepartamento(rs.getString("departamento"));
                lista.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<TipoPropiedad> obtenerTiposPropiedad() {
        List<TipoPropiedad> lista = new ArrayList<>();
        String sql = "SELECT * FROM tipo_propiedad ORDER BY nombre";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                TipoPropiedad tp = new TipoPropiedad();
                tp.setIdTipo(rs.getInt("id_tipo"));
                tp.setNombre(rs.getString("nombre"));
                lista.add(tp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Caracteristica> obtenerCaracteristicas() {
        List<Caracteristica> lista = new ArrayList<>();
        String sql = "SELECT * FROM caracteristica ORDER BY nombre";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new Caracteristica(rs.getInt("id_caracteristica"), rs.getString("nombre")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}
