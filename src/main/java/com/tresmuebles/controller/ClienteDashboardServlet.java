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

@WebServlet("/panel/cliente/dashboard")
public class ClienteDashboardServlet extends HttpServlet {
    private OperacionDAO operacionDAO;

    @Override
    public void init() {
        operacionDAO = new OperacionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        if (usuario == null || !usuario.hasRol("Cliente")) {
            response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
            return;
        }

        request.setAttribute("citas", operacionDAO.listarCitasPorCliente(usuario.getIdUsuario()));
        request.setAttribute("favoritos", operacionDAO.listarFavoritosPorCliente(usuario.getIdUsuario()));
        request.setAttribute("solicitudes", operacionDAO.listarSolicitudesPorCliente(usuario.getIdUsuario()));
        
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
