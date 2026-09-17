package com.tresmuebles.model;

import java.util.List;

public class Propiedad {
    private int idPropiedad;
    private String matriculaInmobiliaria;
    private Ciudad ciudad;
    private TipoPropiedad tipo;
    private Usuario agente;
    
    private String titulo;
    private String descripcion;
    private double precio;
    private double area;
    private int habitaciones;
    private int banos;
    private String estadoPublicacion;
    
    private List<ImagenPropiedad> imagenes;
    private List<Caracteristica> caracteristicas;

    public Propiedad() {}

    // Getters y Setters
    public int getIdPropiedad() { return idPropiedad; }
    public void setIdPropiedad(int idPropiedad) { this.idPropiedad = idPropiedad; }

    public String getMatriculaInmobiliaria() { return matriculaInmobiliaria; }
    public void setMatriculaInmobiliaria(String matriculaInmobiliaria) { this.matriculaInmobiliaria = matriculaInmobiliaria; }

    public Ciudad getCiudad() { return ciudad; }
    public void setCiudad(Ciudad ciudad) { this.ciudad = ciudad; }

    public TipoPropiedad getTipo() { return tipo; }
    public void setTipo(TipoPropiedad tipo) { this.tipo = tipo; }

    public Usuario getAgente() { return agente; }
    public void setAgente(Usuario agente) { this.agente = agente; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public double getPrecio() { return precio; }
    public void setPrecio(double precio) { this.precio = precio; }

    public double getArea() { return area; }
    public void setArea(double area) { this.area = area; }

    public int getHabitaciones() { return habitaciones; }
    public void setHabitaciones(int habitaciones) { this.habitaciones = habitaciones; }

    public int getBanos() { return banos; }
    public void setBanos(int banos) { this.banos = banos; }

    public String getEstadoPublicacion() { return estadoPublicacion; }
    public void setEstadoPublicacion(String estadoPublicacion) { this.estadoPublicacion = estadoPublicacion; }

    public List<ImagenPropiedad> getImagenes() { return imagenes; }
    public void setImagenes(List<ImagenPropiedad> imagenes) { this.imagenes = imagenes; }

    public List<Caracteristica> getCaracteristicas() { return caracteristicas; }
    public void setCaracteristicas(List<Caracteristica> caracteristicas) { this.caracteristicas = caracteristicas; }
    
    // Método helper para obtener la imagen principal (o la primera)
    public String getImagenPrincipalUrl() {
        if (imagenes != null && !imagenes.isEmpty()) {
            for (ImagenPropiedad img : imagenes) {
                if (img.isEsPrincipal()) return img.getUrlImagen();
            }
            return imagenes.get(0).getUrlImagen();
        }
        return "https://via.placeholder.com/500x300?text=Sin+Imagen";
    }
}
