package com.tresmuebles.controller;

import com.tresmuebles.dao.UsuarioDAO;
import com.tresmuebles.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    
    private UsuarioDAO usuarioDAO;

    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            login(request, response);
        } else if ("registro".equals(action)) {
            registro(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("index.jsp");
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave");
        
        Usuario usuario = usuarioDAO.autenticar(correo, clave);
        
        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", usuario);
            new com.tresmuebles.dao.AuditoriaDAO().registrar(usuario.getIdUsuario(), "Inicio de sesión", "Autenticación");
            
            if (usuario.hasRol("Administrador")) {
                response.sendRedirect("panel/admin/reportes");
            } else if (usuario.hasRol("Inmobiliaria")) {
                response.sendRedirect("panel/agente/propiedades?action=listar");
            } else {
                response.sendRedirect("panel/cliente/dashboard");
            }
        } else {
            request.setAttribute("error", "Credenciales incorrectas o usuario inactivo.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void registro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave");
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String documento = request.getParameter("documento");
        
        boolean exito = usuarioDAO.registrarUsuario(correo, clave, nombres, apellidos, documento);
        
        if (exito) {
            request.setAttribute("mensaje", "Registro exitoso. Ahora puede iniciar sesión.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Error al registrar. Es posible que el correo o documento ya existan.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        }
    }
}
