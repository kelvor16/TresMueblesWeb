<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.tresmuebles.model.Ciudad" %>
<%@ page import="com.tresmuebles.model.TipoPropiedad" %>
<%@ page import="com.tresmuebles.model.Propiedad" %>
<%@ page import="com.tresmuebles.model.Usuario" %>
<%
    List<Ciudad> ciudades = (List<Ciudad>) request.getAttribute("ciudades");
    List<TipoPropiedad> tipos = (List<TipoPropiedad>) request.getAttribute("tipos");
    List<Propiedad> propiedades = (List<Propiedad>) request.getAttribute("propiedades");
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Buscador de Propiedades - Tres Muebles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .property-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important;
            transition: all 0.3s ease;
        }
    </style>
</head>
<body class="bg-light">
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="<%= request.getContextPath() %>/index.jsp">Tres Muebles</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <% if(usuario != null) { 
                        String dashUrl = request.getContextPath() + "/panel/cliente/dashboard";
                        if (usuario.hasRol("Administrador")) dashUrl = request.getContextPath() + "/panel/admin/reportes";
                        else if (usuario.hasRol("Inmobiliaria")) dashUrl = request.getContextPath() + "/panel/agente/propiedades?action=listar";
                    %>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= dashUrl %>">Mi Dashboard (<%= (usuario.getPerfil() != null && usuario.getPerfil().getNombres() != null && !usuario.getPerfil().getNombres().isEmpty()) ? usuario.getPerfil().getNombres() : usuario.getCorreo() %>)</a>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link" href="<%= request.getContextPath() %>/login.jsp">Iniciar Sesión</a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Panel de Filtros -->
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <form action="buscador" method="get" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label text-muted small text-uppercase fw-bold">Ciudad</label>
                        <select name="ciudad" class="form-select">
                            <option value="">Todas las ciudades</option>
                            <% if (ciudades != null) { 
                                for(Ciudad c : ciudades) { %>
                                <option value="<%= c.getIdCiudad() %>" <%= request.getParameter("ciudad") != null && request.getParameter("ciudad").equals(String.valueOf(c.getIdCiudad())) ? "selected" : "" %>><%= c.getNombre() %></option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label text-muted small text-uppercase fw-bold">Tipo de Inmueble</label>
                        <select name="tipo" class="form-select">
                            <option value="">Todos los tipos</option>
                            <% if (tipos != null) { 
                                for(TipoPropiedad t : tipos) { %>
                                <option value="<%= t.getIdTipo() %>" <%= request.getParameter("tipo") != null && request.getParameter("tipo").equals(String.valueOf(t.getIdTipo())) ? "selected" : "" %>><%= t.getNombre() %></option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label text-muted small text-uppercase fw-bold">Precio Mínimo</label>
                        <input type="number" name="precioMin" class="form-control" value="<%= request.getParameter("precioMin") != null ? request.getParameter("precioMin") : "" %>">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label text-muted small text-uppercase fw-bold">Precio Máximo</label>
                        <input type="number" name="precioMax" class="form-control" value="<%= request.getParameter("precioMax") != null ? request.getParameter("precioMax") : "" %>">
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">Filtrar</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Resultados -->
        <h3 class="mb-4">Resultados de tu búsqueda</h3>
        <div class="row g-4">
            <% if (propiedades != null && !propiedades.isEmpty()) { 
                for (Propiedad p : propiedades) { %>
                <div class="col-md-4">
                    <div class="card h-100 border-0 shadow-sm property-card">
                        <% 
                            String imgPrinc = p.getImagenPrincipalUrl();
                            String srcPrinc = (imgPrinc != null && (imgPrinc.startsWith("http://") || imgPrinc.startsWith("https://"))) ? imgPrinc : request.getContextPath() + "/" + imgPrinc + "?v=2";
                        %>
                        <img src="<%= srcPrinc %>" class="card-img-top" alt="Imagen" style="height: 200px; object-fit: cover;">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="badge bg-primary rounded-pill"><%= p.getTipo().getNombre() %></span>
                                <span class="text-muted small"><i class="bi bi-geo-alt"></i> <%= p.getCiudad().getNombre() %></span>
                            </div>
                            <h5 class="card-title text-truncate"><%= p.getTitulo() %></h5>
                            <h4 class="text-success fw-bold mb-3">$ <%= String.format("%,.0f", p.getPrecio()) %></h4>
                            
                            <div class="d-flex justify-content-between text-muted small mb-3">
                                <span>Hab: <%= p.getHabitaciones() %></span>
                                <span>Baños: <%= p.getBanos() %></span>
                                <span>Área: <%= p.getArea() %> m²</span>
                            </div>
                        </div>
                        <div class="card-footer bg-white border-top-0 pt-0">
                            <a href="buscador?action=detalle&id=<%= p.getIdPropiedad() %>" class="btn btn-outline-primary w-100">Ver Detalles</a>
                        </div>
                    </div>
                </div>
            <%  } 
               } else { %>
                <div class="col-12 text-center py-5">
                    <h4 class="text-muted">No se encontraron propiedades con esos filtros.</h4>
                    <p>Intenta buscando en otra ciudad o ajustando el precio.</p>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
