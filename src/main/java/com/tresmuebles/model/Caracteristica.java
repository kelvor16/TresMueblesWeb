package com.tresmuebles.model;

public class Caracteristica {
    private int idCaracteristica;
    private String nombre;

    public Caracteristica() {}
    
    public Caracteristica(int idCaracteristica, String nombre) {
        this.idCaracteristica = idCaracteristica;
        this.nombre = nombre;
    }

    public int getIdCaracteristica() { return idCaracteristica; }
    public void setIdCaracteristica(int idCaracteristica) { this.idCaracteristica = idCaracteristica; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
}
