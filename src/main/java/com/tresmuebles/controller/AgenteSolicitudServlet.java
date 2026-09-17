package com.tresmuebles.controller;

import com.tresmuebles.dao.OperacionDAO;
import com.tresmuebles.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/panel/agente/solicitudes")
public class AgenteSolicitudServlet extends HttpServlet {
    private OperacionDAO operacionDAO;

    @Override
    public void init() {
        operacionDAO = new OperacionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        if (usuario == null || (!usuario.hasRol("Inmobiliaria") && !usuario.hasRol("Administrador"))) {
            response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
            return;
        }

        request.setAttribute("solicitudes", operacionDAO.listarSolicitudesPorAgente(usuario.getIdUsuario()));
        request.getRequestDispatcher("solicitudes.jsp").forward(request, response);
    }
}
