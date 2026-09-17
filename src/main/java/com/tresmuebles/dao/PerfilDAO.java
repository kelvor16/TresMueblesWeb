package com.tresmuebles.dao;

import com.tresmuebles.model.Perfil;
import com.tresmuebles.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class PerfilDAO {
    
    public boolean actualizarPerfil(Perfil perfil) {
        String sql = "UPDATE perfil SET nombres = ?, apellidos = ?, documento = ?, telefono = ?, direccion = ? WHERE id_usuario = ?";
        
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, perfil.getNombres());
            ps.setString(2, perfil.getApellidos());
            ps.setString(3, perfil.getDocumento());
            ps.setString(4, perfil.getTelefono());
            ps.setString(5, perfil.getDireccion());
            ps.setInt(6, perfil.getIdUsuario());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
