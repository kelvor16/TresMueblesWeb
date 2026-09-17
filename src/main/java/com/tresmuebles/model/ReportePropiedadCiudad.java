package com.tresmuebles.model;

public class ReportePropiedadCiudad {
    private String ciudad;
    private String departamento;
    private String estado;
    private int cantidad;
    private double precioPromedio;

    public ReportePropiedadCiudad() {}

    public String getCiudad() { return ciudad; }
    public void setCiudad(String ciudad) { this.ciudad = ciudad; }

    public String getDepartamento() { return departamento; }
    public void setDepartamento(String departamento) { this.departamento = departamento; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }

    public double getPrecioPromedio() { return precioPromedio; }
    public void setPrecioPromedio(double precioPromedio) { this.precioPromedio = precioPromedio; }
}
