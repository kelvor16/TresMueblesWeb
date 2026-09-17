package com.tresmuebles.model;

import java.time.LocalDateTime;
import java.util.List;

public class Solicitud {
    private int idSolicitud;
    private Propiedad propiedad;
    private Usuario cliente;
    private String tipo;
    private String estado;
    private LocalDateTime fechaRadicacion;
    private List<DocumentoSolicitud> documentos;

    public Solicitud() {}

    public int getIdSolicitud() { return idSolicitud; }
    public void setIdSolicitud(int idSolicitud) { this.idSolicitud = idSolicitud; }

    public Propiedad getPropiedad() { return propiedad; }
    public void setPropiedad(Propiedad propiedad) { this.propiedad = propiedad; }

    public Usuario getCliente() { return cliente; }
    public void setCliente(Usuario cliente) { this.cliente = cliente; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public LocalDateTime getFechaRadicacion() { return fechaRadicacion; }
    public void setFechaRadicacion(LocalDateTime fechaRadicacion) { this.fechaRadicacion = fechaRadicacion; }

    public List<DocumentoSolicitud> getDocumentos() { return documentos; }
    public void setDocumentos(List<DocumentoSolicitud> documentos) { this.documentos = documentos; }
}
