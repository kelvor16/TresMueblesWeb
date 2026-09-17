package com.tresmuebles.dao;

import com.tresmuebles.model.Auditoria;
import com.tresmuebles.util.ConexionDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class AuditoriaDAO {

    public boolean registrar(Integer idUsuario, String accion, String modulo) {
        String sql = "INSERT INTO auditoria (id_usuario, accion, modulo) VALUES (?, ?, ?)";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (idUsuario != null) {
                ps.setInt(1, idUsuario);
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            ps.setString(2, accion);
            ps.setString(3, modulo);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Auditoria> listarRecientes(int limite) {
        List<Auditoria> lista = new ArrayList<>();
        String sql = "SELECT a.*, u.correo " +
                     "FROM auditoria a " +
                     "LEFT JOIN usuario u ON a.id_usuario = u.id_usuario " +
                     "ORDER BY a.fecha_hora DESC LIMIT ?";
        try (Connection con = ConexionDB.getInstancia().getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limite);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Auditoria aud = new Auditoria();
                    aud.setIdAuditoria(rs.getInt("id_auditoria"));
                    int idU = rs.getInt("id_usuario");
                    if (!rs.wasNull()) {
                        aud.setIdUsuario(idU);
                    }
                    aud.setCorreoUsuario(rs.getString("correo") != null ? rs.getString("correo") : "Sistema / Desconocido");
                    aud.setAccion(rs.getString("accion"));
                    aud.setModulo(rs.getString("modulo"));
                    Timestamp ts = rs.getTimestamp("fecha_hora");
                    if (ts != null) {
                        aud.setFechaHora(ts.toLocalDateTime());
                    }
                    lista.add(aud);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}
