package com.tresmuebles.controller;

import com.tresmuebles.dao.PerfilDAO;
import com.tresmuebles.model.Perfil;
import com.tresmuebles.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/panel/perfil")
public class PerfilServlet extends HttpServlet {
    
    private PerfilDAO perfilDAO;

    @Override
    public void init() {
        perfilDAO = new PerfilDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/perfil.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (usuario != null && usuario.getPerfil() != null) {
            Perfil p = usuario.getPerfil();
            p.setNombres(request.getParameter("nombres"));
            p.setApellidos(request.getParameter("apellidos"));
            p.setDocumento(request.getParameter("documento"));
            p.setTelefono(request.getParameter("telefono"));
            p.setDireccion(request.getParameter("direccion"));
            
            boolean ok = perfilDAO.actualizarPerfil(p);
            if (ok) {
                // Actualizar el perfil en la sesión
                usuario.setPerfil(p);
                session.setAttribute("usuarioLogueado", usuario);
                request.setAttribute("mensaje", "Perfil actualizado con éxito.");
            } else {
                request.setAttribute("error", "Ocurrió un error al actualizar el perfil.");
            }
        }
        request.getRequestDispatcher("/perfil.jsp").forward(request, response);
    }
}
