<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tresmuebles.model.Usuario" %>
<%@ page import="com.tresmuebles.model.Solicitud" %>
<%@ page import="com.tresmuebles.model.DocumentoSolicitud" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null || (!usuario.hasRol("Inmobiliaria") && !usuario.hasRol("Administrador"))) {
        response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
        return;
    }
    List<Solicitud> solicitudes = (List<Solicitud>) request.getAttribute("solicitudes");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bandeja de Solicitudes - Agente</title>
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
                        <a class="nav-link" href="<%= request.getContextPath() %>/panel/agente/citas">
                            <i class="bi bi-calendar-check"></i> Citas Recibidas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active fw-semibold" href="<%= request.getContextPath() %>/panel/agente/solicitudes">
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
            <h2><i class="bi bi-file-earmark-text text-success"></i> Solicitudes y Documentación Radicada</h2>
            <span class="badge bg-secondary fs-6">Total: <%= solicitudes != null ? solicitudes.size() : 0 %></span>
        </div>
        
        <% if (request.getParameter("mensaje") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> <%= request.getParameter("mensaje") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Propiedad</th>
                                <th>Cliente</th>
                                <th>Tipo</th>
                                <th>Documento Adjunto</th>
                                <th>Estado Actual</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (solicitudes != null && !solicitudes.isEmpty()) { 
                                for (Solicitud s : solicitudes) { %>
                                <tr>
                                    <td class="fw-semibold text-primary"><%= s.getPropiedad().getTitulo() %></td>
                                    <td><%= s.getCliente().getCorreo() %></td>
                                    <td>
                                        <span class="badge bg-secondary text-uppercase"><%= s.getTipo() %></span>
                                    </td>
                                    <td>
                                        <% if (s.getDocumentos() != null && !s.getDocumentos().isEmpty()) { 
                                            for (DocumentoSolicitud doc : s.getDocumentos()) { %>
                                                <a href="<%= doc.getUrlDocumento() %>" target="_blank" class="btn btn-sm btn-outline-danger" title="Ver / Descargar documento">
                                                    <i class="bi bi-file-earmark-pdf-fill"></i> <%= doc.getNombreDocumento() != null ? doc.getNombreDocumento() : "Ver PDF" %>
                                                </a>
                                        <%  } 
                                           } else { %>
                                            <span class="text-muted small"><i class="bi bi-dash-circle"></i> Sin adjunto</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if("pendiente".equalsIgnoreCase(s.getEstado())) { %>
                                            <span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split"></i> Pendiente</span>
                                        <% } else if("aprobada".equalsIgnoreCase(s.getEstado())) { %>
                                            <span class="badge bg-success"><i class="bi bi-check-circle"></i> Aprobada</span>
                                        <% } else { %>
                                            <span class="badge bg-danger"><i class="bi bi-x-circle"></i> Rechazada</span>
                                        <% } %>
                                    </td>
                                    <td class="text-center">
                                        <% if("pendiente".equalsIgnoreCase(s.getEstado())) { %>
                                            <form action="<%= request.getContextPath() %>/operacion" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="estadoSolicitud">
                                                <input type="hidden" name="id" value="<%= s.getIdSolicitud() %>">
                                                <input type="hidden" name="estado" value="aprobada">
                                                <button type="submit" class="btn btn-sm btn-success" title="Aprobar trámite">
                                                    <i class="bi bi-check-lg"></i> Aprobar
                                                </button>
                                            </form>
                                            <form action="<%= request.getContextPath() %>/operacion" method="post" class="d-inline ms-1">
                                                <input type="hidden" name="action" value="estadoSolicitud">
                                                <input type="hidden" name="id" value="<%= s.getIdSolicitud() %>">
                                                <input type="hidden" name="estado" value="rechazada">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Rechazar trámite">
                                                    <i class="bi bi-x-lg"></i> Rechazar
                                                </button>
                                            </form>
                                        <% } else { %>
                                            <span class="text-muted small">Sin acciones pendientes</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <%  } 
                               } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">
                                        <i class="bi bi-folder2-open fs-1 d-block mb-2"></i>
                                        No hay solicitudes radicadas para tus propiedades.
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
