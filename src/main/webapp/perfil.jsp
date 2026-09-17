<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tresmuebles.model.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mi Perfil - Tres Muebles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="#">Tres Muebles</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="<%= request.getContextPath() %>/auth?action=logout">Cerrar Sesión</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Mi Perfil</h4>
                    </div>
                    <div class="card-body p-4">
                        <% if (request.getAttribute("mensaje") != null) { %>
                            <div class="alert alert-success"><%= request.getAttribute("mensaje") %></div>
                        <% } %>
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
                        <% } %>
                        
                        <form action="perfil" method="post">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Nombres</label>
                                    <input type="text" class="form-control" name="nombres" value="<%= usuario.getPerfil().getNombres() != null ? usuario.getPerfil().getNombres() : "" %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Apellidos</label>
                                    <input type="text" class="form-control" name="apellidos" value="<%= usuario.getPerfil().getApellidos() != null ? usuario.getPerfil().getApellidos() : "" %>" required>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Documento de Identidad</label>
                                    <input type="text" class="form-control" name="documento" value="<%= usuario.getPerfil().getDocumento() != null ? usuario.getPerfil().getDocumento() : "" %>" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Teléfono</label>
                                    <input type="text" class="form-control" name="telefono" value="<%= usuario.getPerfil().getTelefono() != null ? usuario.getPerfil().getTelefono() : "" %>">
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label">Dirección</label>
                                <input type="text" class="form-control" name="direccion" value="<%= usuario.getPerfil().getDireccion() != null ? usuario.getPerfil().getDireccion() : "" %>">
                            </div>
                            
                            <div class="d-flex justify-content-between">
                                <a href="javascript:history.back()" class="btn btn-outline-secondary">Volver</a>
                                <button type="submit" class="btn btn-primary px-5">Guardar Cambios</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
</body>
</html>
