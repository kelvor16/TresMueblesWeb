package com.tresmuebles.model;

public class DocumentoSolicitud {
    private int idDocumento;
    private int idSolicitud;
    private String nombreDocumento;
    private String urlDocumento;

    public DocumentoSolicitud() {}

    public int getIdDocumento() { return idDocumento; }
    public void setIdDocumento(int idDocumento) { this.idDocumento = idDocumento; }

    public int getIdSolicitud() { return idSolicitud; }
    public void setIdSolicitud(int idSolicitud) { this.idSolicitud = idSolicitud; }

    public String getNombreDocumento() { return nombreDocumento; }
    public void setNombreDocumento(String nombreDocumento) { this.nombreDocumento = nombreDocumento; }

    public String getUrlDocumento() { return urlDocumento; }
    public void setUrlDocumento(String urlDocumento) { this.urlDocumento = urlDocumento; }
}
