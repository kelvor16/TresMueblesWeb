<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tresmuebles.model.Propiedad" %>
<%@ page import="com.tresmuebles.model.Caracteristica" %>
<%@ page import="com.tresmuebles.model.ImagenPropiedad" %>
<%@ page import="com.tresmuebles.model.Usuario" %>
<%
    Propiedad p = (Propiedad) request.getAttribute("propiedad");
    if (p == null) {
        response.sendRedirect("buscador");
        return;
    }
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    boolean esCliente = (usuario != null && usuario.hasRol("Cliente"));
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%= p.getTitulo() %> - Tres Muebles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="<%= request.getContextPath() %>/index.jsp">Tres Muebles</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ms-auto">
                    <% if(usuario != null) { %>
                        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/panel/perfil">Mi Perfil</a></li>
                    <% } else { %>
                        <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/login.jsp">Iniciar Sesión</a></li>
                    <% } %>
                    <li class="nav-item"><a class="nav-link" href="buscador">Volver al Buscador</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4 mb-5">
        <% if (request.getParameter("mensaje") != null) { %>
            <div class="alert alert-success alert-dismissible fade show"><%= request.getParameter("mensaje") %><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show"><%= request.getParameter("error") %><button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        <% } %>

        <div class="row">
            <!-- Galería -->
            <div class="col-md-8">
                <div id="carouselPropiedad" class="carousel slide shadow-sm rounded overflow-hidden" data-bs-ride="carousel">
                    <div class="carousel-inner">
                         <% boolean isFirst = true;
                            if (p.getImagenes() != null && !p.getImagenes().isEmpty()) {
                                for (ImagenPropiedad img : p.getImagenes()) { 
                                    String urlImg = img.getUrlImagen();
                                    String srcImg = (urlImg != null && (urlImg.startsWith("http://") || urlImg.startsWith("https://"))) ? urlImg : request.getContextPath() + "/" + urlImg + "?v=2";
                         %>
                                 <div class="carousel-item <%= isFirst ? "active" : "" %>">
                                     <img src="<%= srcImg %>" class="d-block w-100" alt="Propiedad" style="height: 500px; object-fit: cover;">
                                 </div>
                         <%      isFirst = false;
                                }
                            } else { %>
                               <div class="carousel-item active">
                                    <img src="https://via.placeholder.com/800x500?text=Sin+Imagen" class="d-block w-100" alt="Sin imagen">
                               </div>
                        <% } %>
                    </div>
                    <% if (p.getImagenes() != null && p.getImagenes().size() > 1) { %>
                    <button class="carousel-control-prev" type="button" data-bs-target="#carouselPropiedad" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#carouselPropiedad" data-bs-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    </button>
                    <% } %>
                </div>
                
                <div class="card mt-4 shadow-sm border-0">
                    <div class="card-body">
                        <h4 class="card-title">Descripción</h4>
                        <p class="card-text text-secondary" style="white-space: pre-line;"><%= p.getDescripcion() %></p>
                    </div>
                </div>
            </div>
            
            <!-- Ficha Técnica -->
            <div class="col-md-4">
                <div class="card shadow-sm border-0 mb-4 sticky-top" style="top: 20px;">
                    <div class="card-body">
                        <span class="badge bg-primary mb-2"><%= p.getTipo().getNombre() %></span>
                        <span class="badge bg-secondary mb-2"><%= p.getCiudad().getNombre() %>, <%= p.getCiudad().getDepartamento() %></span>
                        <h2 class="card-title"><%= p.getTitulo() %></h2>
                        <h3 class="text-success fw-bold mb-4">$ <%= String.format("%,.0f", p.getPrecio()) %></h3>
                        
                        <ul class="list-group list-group-flush mb-4">
                            <li class="list-group-item d-flex justify-content-between align-items-center">Área <span><strong><%= p.getArea() %> m²</strong></span></li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">Habitaciones <span><strong><%= p.getHabitaciones() %></strong></span></li>
                            <li class="list-group-item d-flex justify-content-between align-items-center">Baños <span><strong><%= p.getBanos() %></strong></span></li>
                        </ul>
                        
                        <!-- Operaciones del Cliente -->
                        <div class="d-grid gap-3">
                            <% if(esCliente) { %>
                                <!-- Form Favorito -->
                                <form action="operacion" method="post">
                                    <input type="hidden" name="action" value="favorito">
                                    <input type="hidden" name="idPropiedad" value="<%= p.getIdPropiedad() %>">
                                    <button type="submit" class="btn btn-outline-danger w-100">♥ Marcar Favorito</button>
                                </form>

                                <!-- Form Cita -->
                                <form action="operacion" method="post" class="p-3 border rounded bg-light">
                                    <h6>Agendar Cita</h6>
                                    <input type="hidden" name="action" value="agendar">
                                    <input type="hidden" name="idPropiedad" value="<%= p.getIdPropiedad() %>">
                                    <input type="datetime-local" name="fechaHora" class="form-control mb-2" required>
                                    <button type="submit" class="btn btn-primary w-100">Confirmar Cita</button>
                                </form>

                                <!-- Form Solicitud -->
                                <form action="operacion" method="post" class="p-3 border rounded bg-light">
                                    <h6>Radicar Solicitud</h6>
                                    <input type="hidden" name="action" value="radicar">
                                    <input type="hidden" name="idPropiedad" value="<%= p.getIdPropiedad() %>">
                                     <select name="tipo" class="form-select mb-2" required>
                                         <option value="compra">Compra</option>
                                         <option value="arriendo">Arriendo</option>
                                     </select>
                                    <input type="url" name="documentoUrl" class="form-control mb-2" placeholder="URL Documento PDF" required>
                                    <button type="submit" class="btn btn-success w-100">Enviar Solicitud</button>
                                </form>

                            <% } else { %>
                                <div class="alert alert-info text-center">
                                    Inicia sesión como cliente para agendar citas, guardar favoritos o enviar solicitudes.
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
