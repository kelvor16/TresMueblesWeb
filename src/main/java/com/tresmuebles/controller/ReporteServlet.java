package com.tresmuebles.controller;

import com.tresmuebles.dao.AuditoriaDAO;
import com.tresmuebles.dao.ReporteDAO;
import com.tresmuebles.dao.UsuarioDAO;
import com.tresmuebles.model.Auditoria;
import com.tresmuebles.model.Propiedad;
import com.tresmuebles.model.ReportePropiedadCiudad;
import com.tresmuebles.model.Rol;
import com.tresmuebles.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/panel/admin/reportes")
public class ReporteServlet extends HttpServlet {
    
    private ReporteDAO reporteDAO;
    private UsuarioDAO usuarioDAO;
    private AuditoriaDAO auditoriaDAO;

    @Override
    public void init() {
        reporteDAO = new ReporteDAO();
        usuarioDAO = new UsuarioDAO();
        auditoriaDAO = new AuditoriaDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (usuario == null || (!usuario.hasRol("Administrador") && !usuario.hasRol("Admin"))) {
            response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
            return;
        }

        // 1. Reportes SQL
        List<ReportePropiedadCiudad> repCiudad = reporteDAO.reportePropiedadesPorCiudad();
        List<Propiedad> repSinCitas = reporteDAO.reportePropiedadesSinCitas();

        // 2. Gestión de Usuarios y Roles (Historia 4)
        List<Usuario> listaUsuarios = usuarioDAO.listarTodos();
        List<Rol> listaRoles = usuarioDAO.listarRolesDisponibles();

        // 3. Auditoría (Historia 13)
        List<Auditoria> listaAuditoria = auditoriaDAO.listarRecientes(100);

        request.setAttribute("reporteCiudad", repCiudad);
        request.setAttribute("reporteSinCitas", repSinCitas);
        request.setAttribute("listaUsuarios", listaUsuarios);
        request.setAttribute("listaRoles", listaRoles);
        request.setAttribute("listaAuditoria", listaAuditoria);

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Usuario admin = (Usuario) session.getAttribute("usuarioLogueado");
        
        if (admin == null || (!admin.hasRol("Administrador") && !admin.hasRol("Admin"))) {
            response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("cambiarEstado".equals(action)) {
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            String nuevoEstado = request.getParameter("estado");
            boolean ok = usuarioDAO.cambiarEstado(idUsuario, nuevoEstado);
            if (ok) {
                auditoriaDAO.registrar(admin.getIdUsuario(), "Cambio de estado usuario ID " + idUsuario + " a " + nuevoEstado, "Seguridad");
            }
            response.sendRedirect("reportes?tab=usuarios&mensaje=Estado+del+usuario+actualizado+exitosamente");
        } else if ("asignarRol".equals(action)) {
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            int idRol = Integer.parseInt(request.getParameter("idRol"));
            boolean ok = usuarioDAO.asignarRol(idUsuario, idRol);
            if (ok) {
                auditoriaDAO.registrar(admin.getIdUsuario(), "Asignación de rol ID " + idRol + " a usuario ID " + idUsuario, "Seguridad");
            }
            response.sendRedirect("reportes?tab=usuarios&mensaje=Rol+asignado+exitosamente");
        } else if ("revocarRol".equals(action)) {
            int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
            int idRol = Integer.parseInt(request.getParameter("idRol"));
            boolean ok = usuarioDAO.revocarRol(idUsuario, idRol);
            if (ok) {
                auditoriaDAO.registrar(admin.getIdUsuario(), "Revocación de rol ID " + idRol + " a usuario ID " + idUsuario, "Seguridad");
                response.sendRedirect("reportes?tab=usuarios&mensaje=Rol+revocado+exitosamente");
            } else {
                response.sendRedirect("reportes?tab=usuarios&error=No+es+posible+revocar+el+rol:+el+usuario+debe+tener+al+menos+un+rol+asignado");
            }
        } else {
            response.sendRedirect("reportes");
        }
    }
}
