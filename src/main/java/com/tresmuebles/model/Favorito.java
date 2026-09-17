package com.tresmuebles.model;

import java.time.LocalDateTime;

public class Favorito {
    private int idFavorito;
    private Propiedad propiedad;
    private Usuario cliente;
    private LocalDateTime fechaAgregado;

    public Favorito() {}

    public int getIdFavorito() { return idFavorito; }
    public void setIdFavorito(int idFavorito) { this.idFavorito = idFavorito; }

    public Propiedad getPropiedad() { return propiedad; }
    public void setPropiedad(Propiedad propiedad) { this.propiedad = propiedad; }

    public Usuario getCliente() { return cliente; }
    public void setCliente(Usuario cliente) { this.cliente = cliente; }

    public LocalDateTime getFechaAgregado() { return fechaAgregado; }
    public void setFechaAgregado(LocalDateTime fechaAgregado) { this.fechaAgregado = fechaAgregado; }
}
