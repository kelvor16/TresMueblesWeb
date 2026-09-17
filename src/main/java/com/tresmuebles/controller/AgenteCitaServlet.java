package com.tresmuebles.controller;

import com.tresmuebles.dao.AuditoriaDAO;
import com.tresmuebles.dao.OperacionDAO;
import com.tresmuebles.model.Cita;
import com.tresmuebles.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/panel/agente/citas")
public class AgenteCitaServlet extends HttpServlet {

    private OperacionDAO operacionDAO;
    private AuditoriaDAO auditoriaDAO;

    @Override
    public void init() {
        operacionDAO = new OperacionDAO();
        auditoriaDAO = new AuditoriaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario agente = (Usuario) session.getAttribute("usuarioLogueado");

        if (agente == null || (!agente.hasRol("Inmobiliaria") && !agente.hasRol("Administrador"))) {
            response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
            return;
        }

        List<Cita> citas = operacionDAO.listarCitasPorAgente(agente.getIdUsuario());
        request.setAttribute("citas", citas);
        request.getRequestDispatcher("citas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario agente = (Usuario) session.getAttribute("usuarioLogueado");

        if (agente == null || (!agente.hasRol("Inmobiliaria") && !agente.hasRol("Administrador"))) {
            response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("cambiarEstado".equals(action)) {
            int idCita = Integer.parseInt(request.getParameter("idCita"));
            String nuevoEstado = request.getParameter("estado");
            boolean ok = operacionDAO.cambiarEstadoCitaAgente(idCita, nuevoEstado);
            if (ok) {
                auditoriaDAO.registrar(agente.getIdUsuario(), "Cita ID " + idCita + " marcada como " + nuevoEstado, "Citas");
                response.sendRedirect("citas?mensaje=Estado+de+la+cita+actualizado+a+" + nuevoEstado);
            } else {
                response.sendRedirect("citas?error=No+se+pudo+actualizar+el+estado+de+la+cita");
            }
        } else {
            response.sendRedirect("citas");
        }
    }
}
