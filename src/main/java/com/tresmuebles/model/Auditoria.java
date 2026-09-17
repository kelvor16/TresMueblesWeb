package com.tresmuebles.model;

import java.time.LocalDateTime;

public class Auditoria {
    private int idAuditoria;
    private Integer idUsuario;
    private String correoUsuario;
    private String accion;
    private String modulo;
    private LocalDateTime fechaHora;

    public Auditoria() {}

    public Auditoria(int idAuditoria, Integer idUsuario, String correoUsuario, String accion, String modulo, LocalDateTime fechaHora) {
        this.idAuditoria = idAuditoria;
        this.idUsuario = idUsuario;
        this.correoUsuario = correoUsuario;
        this.accion = accion;
        this.modulo = modulo;
        this.fechaHora = fechaHora;
    }

    public int getIdAuditoria() {
        return idAuditoria;
    }

    public void setIdAuditoria(int idAuditoria) {
        this.idAuditoria = idAuditoria;
    }

    public Integer getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(Integer idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getCorreoUsuario() {
        return correoUsuario;
    }

    public void setCorreoUsuario(String correoUsuario) {
        this.correoUsuario = correoUsuario;
    }

    public String getAccion() {
        return accion;
    }

    public void setAccion(String accion) {
        this.accion = accion;
    }

    public String getModulo() {
        return modulo;
    }

    public void setModulo(String modulo) {
        this.modulo = modulo;
    }

    public LocalDateTime getFechaHora() {
        return fechaHora;
    }

    public void setFechaHora(LocalDateTime fechaHora) {
        this.fechaHora = fechaHora;
    }
}
