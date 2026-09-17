package com.tresmuebles.model;

import java.util.List;

public class Usuario {
    private int idUsuario;
    private String correo;
    private String clave;
    private String estado;
    
    // Lista de roles asociados (N:M)
    private List<Rol> roles;
    
    // Perfil asociado (1:1)
    private Perfil perfil;

    public Usuario() {}

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getCorreo() { return correo; }
    public void setCorreo(String correo) { this.correo = correo; }

    public String getClave() { return clave; }
    public void setClave(String clave) { this.clave = clave; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public List<Rol> getRoles() { return roles; }
    public void setRoles(List<Rol> roles) { this.roles = roles; }

    public Perfil getPerfil() { return perfil; }
    public void setPerfil(Perfil perfil) { this.perfil = perfil; }
    
    public boolean hasRol(String nombreRol) {
        if (roles == null) return false;
        return roles.stream().anyMatch(r -> {
            if (r.getNombre().equalsIgnoreCase(nombreRol)) return true;
            if (nombreRol.equalsIgnoreCase("Admin") && r.getNombre().equalsIgnoreCase("Administrador")) return true;
            if (nombreRol.equalsIgnoreCase("Administrador") && r.getNombre().equalsIgnoreCase("Admin")) return true;
            if (nombreRol.equalsIgnoreCase("Agente") && r.getNombre().equalsIgnoreCase("Inmobiliaria")) return true;
            if (nombreRol.equalsIgnoreCase("Inmobiliaria") && r.getNombre().equalsIgnoreCase("Agente")) return true;
            return false;
        });
    }
}
