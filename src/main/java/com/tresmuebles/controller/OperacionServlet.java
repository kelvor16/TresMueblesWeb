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
import java.sql.SQLException;

@WebServlet("/operacion")
public class OperacionServlet extends HttpServlet {
    
    private OperacionDAO operacionDAO;

    @Override
    public void init() {
        operacionDAO = new OperacionDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if ("favorito".equals(action)) {
            int idPropiedad = Integer.parseInt(request.getParameter("idPropiedad"));
            operacionDAO.marcarFavorito(idPropiedad, usuario.getIdUsuario());
            response.sendRedirect(request.getContextPath() + "/buscador?action=detalle&id=" + idPropiedad + "&mensaje=Agregado+a+favoritos");
            
        } else if ("agendar".equals(action)) {
            int idPropiedad = Integer.parseInt(request.getParameter("idPropiedad"));
            String fechaHora = request.getParameter("fechaHora"); // Formato 'YYYY-MM-DDTHH:MM'
            
            try {
                // MySQL expects 'YYYY-MM-DD HH:MM:SS' for timestamp, input type="datetime-local" gives 'YYYY-MM-DDTHH:MM'
                String fechaFormateada = fechaHora != null ? fechaHora.replace("T", " ") : "";
                if (fechaFormateada.length() == 16) {
                    fechaFormateada += ":00";
                }
                operacionDAO.agendarCita(idPropiedad, usuario.getIdUsuario(), fechaFormateada);
                response.sendRedirect(request.getContextPath() + "/buscador?action=detalle&id=" + idPropiedad + "&mensaje=Cita+agendada+con+exito");
            } catch (SQLException e) {
                // Si ocurre una excepción de cruce (UNIQUE)
                response.sendRedirect(request.getContextPath() + "/buscador?action=detalle&id=" + idPropiedad + "&error=La+propiedad+ya+tiene+una+cita+en+esa+fecha+y+hora.+Elige+otra.");
            }
            
        } else if ("radicar".equals(action)) {
            int idPropiedad = Integer.parseInt(request.getParameter("idPropiedad"));
            String tipo = request.getParameter("tipo"); // compra o arriendo
            if (tipo != null) {
                tipo = tipo.toLowerCase().trim();
            }
            String docUrl = request.getParameter("documentoUrl"); // simulado
            String docNombre = "Documento de " + tipo;
            
            operacionDAO.radicarSolicitud(idPropiedad, usuario.getIdUsuario(), tipo, docNombre, docUrl);
            response.sendRedirect(request.getContextPath() + "/buscador?action=detalle&id=" + idPropiedad + "&mensaje=Solicitud+radicada+con+exito");
            
        } else if ("quitarFavorito".equals(action)) {
            int idPropiedad = Integer.parseInt(request.getParameter("idPropiedad"));
            operacionDAO.eliminarFavorito(idPropiedad, usuario.getIdUsuario());
            response.sendRedirect(request.getContextPath() + "/panel/cliente/dashboard?mensaje=Favorito+eliminado");
            
        } else if ("cancelarCita".equals(action)) {
            int idCita = Integer.parseInt(request.getParameter("idCita"));
            operacionDAO.cancelarCita(idCita, usuario.getIdUsuario());
            response.sendRedirect(request.getContextPath() + "/panel/cliente/dashboard?mensaje=Cita+cancelada");
            
        } else if ("editarCita".equals(action)) {
            int idCita = Integer.parseInt(request.getParameter("idCita"));
            String nuevaFechaHora = request.getParameter("fechaHora"); // YYYY-MM-DDTHH:MM
            try {
                String fechaFormateada = nuevaFechaHora != null ? nuevaFechaHora.replace("T", " ") : "";
                if (fechaFormateada.length() == 16) {
                    fechaFormateada += ":00";
                }
                operacionDAO.editarCita(idCita, usuario.getIdUsuario(), fechaFormateada);
                response.sendRedirect(request.getContextPath() + "/panel/cliente/dashboard?mensaje=Cita+reprogramada+con+exito");
            } catch (SQLException e) {
                response.sendRedirect(request.getContextPath() + "/panel/cliente/dashboard?error=Esa+fecha+y+hora+ya+esta+ocupada");
            }
            
        } else if ("estadoSolicitud".equals(action)) {
            if (usuario.hasRol("Inmobiliaria") || usuario.hasRol("Administrador") || usuario.hasRol("Admin")) {
                int idSolicitud = Integer.parseInt(request.getParameter("id"));
                String estado = request.getParameter("estado"); // aprobada o rechazada
                operacionDAO.cambiarEstadoSolicitud(idSolicitud, estado);
                new com.tresmuebles.dao.AuditoriaDAO().registrar(usuario.getIdUsuario(), "Solicitud ID " + idSolicitud + " actualizada a " + estado, "Solicitudes");
                response.sendRedirect(request.getContextPath() + "/panel/agente/solicitudes?mensaje=Estado+actualizado");
            }
        }
    }
}
