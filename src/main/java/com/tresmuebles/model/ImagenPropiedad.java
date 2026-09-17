package com.tresmuebles.model;

public class ImagenPropiedad {
    private int idImagen;
    private int idPropiedad;
    private String urlImagen;
    private boolean esPrincipal;

    public ImagenPropiedad() {}

    public int getIdImagen() { return idImagen; }
    public void setIdImagen(int idImagen) { this.idImagen = idImagen; }

    public int getIdPropiedad() { return idPropiedad; }
    public void setIdPropiedad(int idPropiedad) { this.idPropiedad = idPropiedad; }

    public String getUrlImagen() { return urlImagen; }
    public void setUrlImagen(String urlImagen) { this.urlImagen = urlImagen; }

    public boolean isEsPrincipal() { return esPrincipal; }
    public void setEsPrincipal(boolean esPrincipal) { this.esPrincipal = esPrincipal; }
}
