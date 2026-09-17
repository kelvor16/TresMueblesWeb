<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tresmuebles.model.Usuario" %>
<%@ page import="com.tresmuebles.model.Rol" %>
<%@ page import="com.tresmuebles.model.Auditoria" %>
<%@ page import="com.tresmuebles.model.ReportePropiedadCiudad" %>
<%@ page import="com.tresmuebles.model.Propiedad" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null || (!usuario.hasRol("Administrador") && !usuario.hasRol("Admin"))) {
        response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
        return;
    }
    List<ReportePropiedadCiudad> reporteCiudad = (List<ReportePropiedadCiudad>) request.getAttribute("reporteCiudad");
    List<Propiedad> reporteSinCitas = (List<Propiedad>) request.getAttribute("reporteSinCitas");
    List<Usuario> listaUsuarios = (List<Usuario>) request.getAttribute("listaUsuarios");
    List<Rol> listaRoles = (List<Rol>) request.getAttribute("listaRoles");
    List<Auditoria> listaAuditoria = (List<Auditoria>) request.getAttribute("listaAuditoria");

    String tabActiva = request.getParameter("tab");
    if (tabActiva == null || tabActiva.isEmpty()) {
        tabActiva = "reportes";
    }
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm a");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administrador - Tres Muebles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">
    
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="<%= request.getContextPath() %>/panel/admin/reportes">
                <i class="bi bi-shield-lock-fill text-primary"></i> Tres Muebles - Admin
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navAdmin">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navAdmin">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link <%= "reportes".equals(tabActiva) ? "active fw-semibold" : "" %>" href="<%= request.getContextPath() %>/panel/admin/reportes?tab=reportes">
                            <i class="bi bi-bar-chart-line"></i> Reportes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= "usuarios".equals(tabActiva) ? "active fw-semibold" : "" %>" href="<%= request.getContextPath() %>/panel/admin/reportes?tab=usuarios">
                            <i class="bi bi-people"></i> Usuarios y Roles
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= "auditoria".equals(tabActiva) ? "active fw-semibold" : "" %>" href="<%= request.getContextPath() %>/panel/admin/reportes?tab=auditoria">
                            <i class="bi bi-journal-text"></i> Auditoría
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <span class="nav-link text-white-50">
                            <i class="bi bi-person-circle"></i> <%= usuario.getPerfil() != null ? usuario.getPerfil().getNombres() : usuario.getCorreo() %>
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-sm btn-outline-light ms-2" href="<%= request.getContextPath() %>/auth?action=logout">
                            <i class="bi bi-box-arrow-right"></i> Salir
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4 mb-5">
        
        <% if (request.getParameter("mensaje") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> <%= request.getParameter("mensaje") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> <%= request.getParameter("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- NAVEGACIÓN POR PESTAÑAS -->
        <ul class="nav nav-pills mb-4 border-bottom pb-2">
            <li class="nav-item">
                <a class="nav-link <%= "reportes".equals(tabActiva) ? "active" : "" %>" href="<%= request.getContextPath() %>/panel/admin/reportes?tab=reportes">
                    <i class="bi bi-graph-up"></i> Reportes Consolidados (SQL)
                </a>
            </li>
            <li class="nav-item ms-2">
                <a class="nav-link <%= "usuarios".equals(tabActiva) ? "active" : "" %>" href="<%= request.getContextPath() %>/panel/admin/reportes?tab=usuarios">
                    <i class="bi bi-person-gear"></i> Gestión de Usuarios y Roles (Historia 4)
                </a>
            </li>
            <li class="nav-item ms-2">
                <a class="nav-link <%= "auditoria".equals(tabActiva) ? "active" : "" %>" href="<%= request.getContextPath() %>/panel/admin/reportes?tab=auditoria">
                    <i class="bi bi-shield-check"></i> Auditoría de Accesos y Cambios (Historia 13)
                </a>
            </li>
        </ul>

        <% if ("reportes".equals(tabActiva)) { %>
            <!-- PESTAÑA 1: REPORTES SQL -->
            <div class="row">
                <div class="col-12 mb-4">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="bi bi-table"></i> 1. Propiedades por Ciudad y Estado (INNER JOIN + GROUP BY + HAVING)</h5>
                            <span class="badge bg-light text-primary">Consulta de Agregación</span>
                        </div>
                        <div class="card-body">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Ciudad</th>
                                        <th>Departamento</th>
                                        <th>Estado</th>
                                        <th>Cantidad de Propiedades</th>
                                        <th>Precio Promedio</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if(reporteCiudad != null && !reporteCiudad.isEmpty()) { 
                                        for(ReportePropiedadCiudad r : reporteCiudad) { %>
                                        <tr>
                                            <td class="fw-bold"><%= r.getCiudad() %></td>
                                            <td><%= r.getDepartamento() %></td>
                                            <td><span class="badge <%= "disponible".equals(r.getEstado()) ? "bg-success" : "bg-secondary" %>"><%= r.getEstado() %></span></td>
                                            <td><span class="badge bg-info text-dark fs-6"><%= r.getCantidad() %></span></td>
                                            <td>$ <%= String.format("%,.0f", r.getPrecioPromedio()) %></td>
                                        </tr>
                                    <%  } 
                                       } else { %>
                                        <tr><td colspan="5" class="text-center text-muted">No hay datos disponibles para el reporte.</td></tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="col-12">
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-warning text-dark d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="bi bi-calendar-x"></i> 2. Propiedades sin Citas Agendadas (LEFT JOIN)</h5>
                            <span class="badge bg-dark text-white">Relación Excluyente</span>
                        </div>
                        <div class="card-body">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Matrícula Inmobiliaria</th>
                                        <th>Título del Inmueble</th>
                                        <th>Precio</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if(reporteSinCitas != null && !reporteSinCitas.isEmpty()) { 
                                        for(Propiedad p : reporteSinCitas) { %>
                                        <tr>
                                            <td><code><%= p.getMatriculaInmobiliaria() %></code></td>
                                            <td class="fw-semibold"><%= p.getTitulo() %></td>
                                            <td>$ <%= String.format("%,.0f", p.getPrecio()) %></td>
                                        </tr>
                                    <%  } 
                                       } else { %>
                                        <tr><td colspan="3" class="text-center text-success py-3">¡Todas las propiedades cuentan con al menos una cita agendada!</td></tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

        <% } else if ("usuarios".equals(tabActiva)) { %>
            <!-- PESTAÑA 2: GESTIÓN DE USUARIOS Y ROLES (Historia 4) -->
            <div class="card shadow-sm border-0">
                <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-people-fill"></i> Usuarios del Sistema y Asignación de Roles</h5>
                    <span class="badge bg-secondary">Total: <%= listaUsuarios != null ? listaUsuarios.size() : 0 %></span>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Nombre Completo</th>
                                    <th>Correo Electrónico</th>
                                    <th>Documento</th>
                                    <th>Roles Asignados</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (listaUsuarios != null && !listaUsuarios.isEmpty()) {
                                    for (Usuario u : listaUsuarios) { %>
                                    <tr>
                                        <td><%= u.getIdUsuario() %></td>
                                        <td class="fw-semibold">
                                            <%= u.getPerfil() != null ? u.getPerfil().getNombres() + " " + u.getPerfil().getApellidos() : "Sin Perfil" %>
                                        </td>
                                        <td><%= u.getCorreo() %></td>
                                        <td><%= u.getPerfil() != null && u.getPerfil().getDocumento() != null ? u.getPerfil().getDocumento() : "-" %></td>
                                        <td>
                                            <% if (u.getRoles() != null) { 
                                                for (Rol r : u.getRoles()) { %>
                                                    <span class="badge bg-primary me-1">
                                                        <%= r.getNombre() %>
                                                        <% if (u.getRoles().size() > 1 && u.getIdUsuario() != usuario.getIdUsuario()) { %>
                                                            <form action="reportes" method="post" class="d-inline" onsubmit="return confirm('¿Revocar el rol <%= r.getNombre() %> a este usuario?');">
                                                                <input type="hidden" name="action" value="revocarRol">
                                                                <input type="hidden" name="idUsuario" value="<%= u.getIdUsuario() %>">
                                                                <input type="hidden" name="idRol" value="<%= r.getIdRol() %>">
                                                                <button type="submit" class="btn btn-link text-white p-0 ms-1" style="text-decoration:none;" title="Revocar rol">&times;</button>
                                                            </form>
                                                        <% } %>
                                                    </span>
                                            <%  } 
                                               } %>
                                        </td>
                                        <td>
                                            <% if ("activo".equalsIgnoreCase(u.getEstado())) { %>
                                                <span class="badge bg-success">Activo</span>
                                            <% } else { %>
                                                <span class="badge bg-secondary">Inactivo</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <!-- Botón Asignar Rol Modal -->
                                            <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#modalRol<%= u.getIdUsuario() %>">
                                                <i class="bi bi-person-plus"></i> Asignar Rol
                                            </button>

                                            <!-- Botón Activar / Inactivar -->
                                            <% if (u.getIdUsuario() != usuario.getIdUsuario()) { %>
                                                <form action="reportes" method="post" class="d-inline ms-1">
                                                    <input type="hidden" name="action" value="cambiarEstado">
                                                    <input type="hidden" name="idUsuario" value="<%= u.getIdUsuario() %>">
                                                    <% if ("activo".equalsIgnoreCase(u.getEstado())) { %>
                                                        <input type="hidden" name="estado" value="inactivo">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('¿Desactivar la cuenta de <%= u.getCorreo() %>?');">
                                                            <i class="bi bi-person-slash"></i> Inactivar
                                                        </button>
                                                    <% } else { %>
                                                        <input type="hidden" name="estado" value="activo">
                                                        <button type="submit" class="btn btn-sm btn-outline-success">
                                                            <i class="bi bi-person-check"></i> Activar
                                                        </button>
                                                    <% } %>
                                                </form>
                                            <% } %>

                                            <!-- MODAL ASIGNAR ROL -->
                                            <div class="modal fade" id="modalRol<%= u.getIdUsuario() %>" tabindex="-1">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <form action="reportes" method="post">
                                                            <input type="hidden" name="action" value="asignarRol">
                                                            <input type="hidden" name="idUsuario" value="<%= u.getIdUsuario() %>">
                                                            <div class="modal-header bg-primary text-white">
                                                                <h5 class="modal-title">Asignar Rol a <%= u.getCorreo() %></h5>
                                                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                <div class="mb-3">
                                                                    <label class="form-label fw-bold">Seleccione el Rol:</label>
                                                                    <select name="idRol" class="form-select" required>
                                                                        <% if (listaRoles != null) {
                                                                            for (Rol rol : listaRoles) { %>
                                                                                <option value="<%= rol.getIdRol() %>"><%= rol.getNombre() %></option>
                                                                        <%  } 
                                                                           } %>
                                                                    </select>
                                                                </div>
                                                                <small class="text-muted">El usuario puede tener múltiples roles (Relación N:M mediante la tabla <code>usuario_rol</code>).</small>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                                                                <button type="submit" class="btn btn-primary">Asignar Rol</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                <%  } 
                                   } else { %>
                                    <tr><td colspan="7" class="text-center text-muted">No se encontraron usuarios.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        <% } else if ("auditoria".equals(tabActiva)) { %>
            <!-- PESTAÑA 3: AUDITORÍA (Historia 13) -->
            <div class="card shadow-sm border-0">
                <div class="card-header bg-secondary text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-journal-bookmark-fill"></i> Registro de Auditoría de Operaciones</h5>
                    <span class="badge bg-light text-dark">Últimos eventos registrados</span>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped align-middle">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Fecha y Hora</th>
                                    <th>Usuario / Responsable</th>
                                    <th>Módulo</th>
                                    <th>Acción Realizada</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (listaAuditoria != null && !listaAuditoria.isEmpty()) {
                                    for (Auditoria a : listaAuditoria) { %>
                                    <tr>
                                        <td><%= a.getIdAuditoria() %></td>
                                        <td><%= a.getFechaHora() != null ? a.getFechaHora().format(dtf) : "-" %></td>
                                        <td class="fw-semibold"><%= a.getCorreoUsuario() %></td>
                                        <td><span class="badge bg-info text-dark"><%= a.getModulo() %></span></td>
                                        <td><%= a.getAccion() %></td>
                                    </tr>
                                <%  } 
                                   } else { %>
                                    <tr><td colspan="5" class="text-center text-muted py-3">No hay registros de auditoría aún.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        <% } %>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
