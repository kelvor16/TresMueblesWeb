<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tresmuebles.model.Usuario" %>
<%@ page import="com.tresmuebles.model.Cita" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null || (!usuario.hasRol("Inmobiliaria") && !usuario.hasRol("Administrador"))) {
        response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
        return;
    }
    List<Cita> citas = (List<Cita>) request.getAttribute("citas");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm a");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Citas Agendadas - Panel de Agente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <!-- NAVBAR UNIFICADO DEL AGENTE -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-success shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="<%= request.getContextPath() %>/panel/agente/propiedades?action=listar">
                <i class="bi bi-buildings"></i> Tres Muebles - Agente
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navAgente">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navAgente">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/panel/agente/propiedades?action=listar">
                            <i class="bi bi-house-door"></i> Mis Propiedades
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active fw-semibold" href="<%= request.getContextPath() %>/panel/agente/citas">
                            <i class="bi bi-calendar-check"></i> Citas Recibidas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/panel/agente/solicitudes">
                            <i class="bi bi-file-earmark-text"></i> Solicitudes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/panel/perfil">
                            <i class="bi bi-person"></i> Mi Perfil
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="bi bi-calendar2-check text-success"></i> Agenda de Citas para Mis Propiedades</h2>
            <span class="badge bg-secondary fs-6">Total: <%= citas != null ? citas.size() : 0 %></span>
        </div>
        
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

        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Inmueble</th>
                                <th>Fecha y Hora</th>
                                <th>Cliente</th>
                                <th>Teléfono</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (citas != null && !citas.isEmpty()) { 
                                for (Cita c : citas) { %>
                                <tr>
                                    <td class="fw-semibold text-primary">
                                        <%= c.getPropiedad() != null ? c.getPropiedad().getTitulo() : "-" %>
                                    </td>
                                    <td>
                                        <strong><%= c.getFechaHora() != null ? c.getFechaHora().format(dtf) : "-" %></strong>
                                    </td>
                                    <td>
                                        <% if (c.getCliente() != null && c.getCliente().getPerfil() != null && !c.getCliente().getPerfil().getNombres().isEmpty()) { %>
                                            <%= c.getCliente().getPerfil().getNombres() %> <%= c.getCliente().getPerfil().getApellidos() %><br>
                                        <% } %>
                                        <small class="text-muted"><%= c.getCliente() != null ? c.getCliente().getCorreo() : "-" %></small>
                                    </td>
                                    <td>
                                        <%= c.getCliente() != null && c.getCliente().getPerfil() != null && !c.getCliente().getPerfil().getTelefono().isEmpty() ? c.getCliente().getPerfil().getTelefono() : "<span class='text-muted'>No registrado</span>" %>
                                    </td>
                                    <td>
                                        <% if ("programada".equalsIgnoreCase(c.getEstado())) { %>
                                            <span class="badge bg-warning text-dark"><i class="bi bi-clock"></i> Programada</span>
                                        <% } else if ("realizada".equalsIgnoreCase(c.getEstado())) { %>
                                            <span class="badge bg-success"><i class="bi bi-check-all"></i> Realizada</span>
                                        <% } else { %>
                                            <span class="badge bg-danger"><i class="bi bi-x-circle"></i> Cancelada</span>
                                        <% } %>
                                    </td>
                                    <td class="text-center">
                                        <% if ("programada".equalsIgnoreCase(c.getEstado())) { %>
                                            <form action="citas" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="cambiarEstado">
                                                <input type="hidden" name="idCita" value="<%= c.getIdCita() %>">
                                                <input type="hidden" name="estado" value="realizada">
                                                <button type="submit" class="btn btn-sm btn-success" title="Marcar como realizada">
                                                    <i class="bi bi-check-lg"></i> Realizada
                                                </button>
                                            </form>
                                            <form action="citas" method="post" class="d-inline ms-1" onsubmit="return confirm('¿Está seguro de cancelar esta cita?');">
                                                <input type="hidden" name="action" value="cambiarEstado">
                                                <input type="hidden" name="idCita" value="<%= c.getIdCita() %>">
                                                <input type="hidden" name="estado" value="cancelada">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Cancelar cita">
                                                    <i class="bi bi-x-lg"></i> Cancelar
                                                </button>
                                            </form>
                                        <% } else { %>
                                            <span class="text-muted small">Sin acciones</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <%  } 
                               } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">
                                        <i class="bi bi-calendar-x fs-1 d-block mb-2"></i>
                                        Aún no hay citas agendadas para las propiedades que gestionas.
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
