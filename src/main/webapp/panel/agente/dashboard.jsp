<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tresmuebles.model.Usuario" %>
<%@ page import="com.tresmuebles.model.Propiedad" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null || (!usuario.hasRol("Inmobiliaria") && !usuario.hasRol("Administrador"))) {
        response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
        return;
    }
    List<Propiedad> propiedades = (List<Propiedad>) request.getAttribute("propiedades");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Agente - Mis Propiedades</title>
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
                        <a class="nav-link active fw-semibold" href="<%= request.getContextPath() %>/panel/agente/propiedades?action=listar">
                            <i class="bi bi-house-door"></i> Mis Propiedades
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/panel/agente/citas">
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
            <h2><i class="bi bi-houses text-success"></i> Mis Propiedades Publicadas</h2>
            <a href="<%= request.getContextPath() %>/panel/agente/propiedades?action=nueva" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> Registrar Nueva Propiedad
            </a>
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
                                <th>Matrícula</th>
                                <th>Título</th>
                                <th>Ciudad</th>
                                <th>Precio</th>
                                <th>Estado</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (propiedades != null && !propiedades.isEmpty()) { 
                                for (Propiedad p : propiedades) { %>
                                <tr>
                                    <td><code><%= p.getMatriculaInmobiliaria() %></code></td>
                                    <td class="fw-semibold text-primary"><%= p.getTitulo() %></td>
                                    <td><%= p.getCiudad() != null ? p.getCiudad().getNombre() : "-" %></td>
                                    <td>$ <%= String.format("%,.0f", p.getPrecio()) %></td>
                                    <td>
                                        <span class="badge <%= "disponible".equals(p.getEstadoPublicacion()) ? "bg-success" : "bg-secondary" %>">
                                            <%= p.getEstadoPublicacion().toUpperCase() %>
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <!-- Botón Editar -->
                                        <a href="propiedades?action=editar&id=<%= p.getIdPropiedad() %>" class="btn btn-sm btn-outline-primary me-1" title="Editar propiedad">
                                            <i class="bi bi-pencil-square"></i> Editar
                                        </a>

                                        <!-- Botón Baja Lógica / Activar -->
                                        <% if ("disponible".equals(p.getEstadoPublicacion())) { %>
                                            <a href="propiedades?action=cambiarEstado&id=<%= p.getIdPropiedad() %>&estado=inactiva" class="btn btn-sm btn-outline-danger" title="Dar de baja lógica" onclick="return confirm('¿Dar de baja esta propiedad?');">
                                                <i class="bi bi-slash-circle"></i> Dar de Baja
                                            </a>
                                        <% } else { %>
                                            <a href="propiedades?action=cambiarEstado&id=<%= p.getIdPropiedad() %>&estado=disponible" class="btn btn-sm btn-outline-success" title="Reactivar publicación">
                                                <i class="bi bi-check-circle"></i> Activar
                                            </a>
                                        <% } %>
                                    </td>
                                </tr>
                            <%  } 
                               } else { %>
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">
                                        <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                        No has publicado ninguna propiedad aún.
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
