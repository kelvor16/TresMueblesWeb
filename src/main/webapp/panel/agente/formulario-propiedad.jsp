<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tresmuebles.model.Usuario" %>
<%@ page import="com.tresmuebles.model.Ciudad" %>
<%@ page import="com.tresmuebles.model.TipoPropiedad" %>
<%@ page import="com.tresmuebles.model.Caracteristica" %>
<%@ page import="com.tresmuebles.model.Propiedad" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null || (!usuario.hasRol("Inmobiliaria") && !usuario.hasRol("Administrador"))) {
        response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
        return;
    }
    List<Ciudad> ciudades = (List<Ciudad>) request.getAttribute("ciudades");
    List<TipoPropiedad> tipos = (List<TipoPropiedad>) request.getAttribute("tipos");
    List<Caracteristica> caracteristicas = (List<Caracteristica>) request.getAttribute("caracteristicas");
    Propiedad propiedad = (Propiedad) request.getAttribute("propiedad");
    boolean esEdicion = (propiedad != null);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= esEdicion ? "Editar Propiedad" : "Nueva Propiedad" %> - Tres Muebles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">
    
    <div class="container mt-4 mb-5">
        <a href="propiedades?action=listar" class="btn btn-outline-secondary mb-3">
            <i class="bi bi-arrow-left"></i> Volver a Mis Propiedades
        </a>
        
        <div class="card shadow-sm border-0">
            <div class="card-header bg-success text-white py-3">
                <h4 class="mb-0"><i class="bi bi-house-gear"></i> <%= esEdicion ? "Editar Propiedad (" + propiedad.getMatriculaInmobiliaria() + ")" : "Registrar Nueva Propiedad" %></h4>
            </div>
            <div class="card-body p-4">
                <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i> <%= request.getParameter("error") %></div>
                <% } %>
                
                <form action="propiedades" method="post">
                    <input type="hidden" name="action" value="<%= esEdicion ? "actualizar" : "guardar" %>">
                    <% if (esEdicion) { %>
                        <input type="hidden" name="idPropiedad" value="<%= propiedad.getIdPropiedad() %>">
                    <% } %>
                    
                    <h5 class="border-bottom pb-2 mb-3 text-secondary">Datos Generales</h5>
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Matrícula Inmobiliaria (Única)</label>
                            <input type="text" class="form-control" name="matricula" value="<%= esEdicion ? propiedad.getMatriculaInmobiliaria() : "" %>" required>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label fw-semibold">Título del anuncio</label>
                            <input type="text" class="form-control" name="titulo" value="<%= esEdicion ? propiedad.getTitulo() : "" %>" required>
                        </div>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Tipo de Inmueble</label>
                            <select name="tipo" class="form-select" required>
                                <% if (tipos != null) {
                                    for(TipoPropiedad t : tipos) { 
                                        boolean sel = esEdicion && propiedad.getTipo() != null && propiedad.getTipo().getIdTipo() == t.getIdTipo();
                                %>
                                    <option value="<%= t.getIdTipo() %>" <%= sel ? "selected" : "" %>><%= t.getNombre() %></option>
                                <%  } 
                                   } %>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Ciudad</label>
                            <select name="ciudad" class="form-select" required>
                                <% if (ciudades != null) {
                                    for(Ciudad c : ciudades) { 
                                        boolean sel = esEdicion && propiedad.getCiudad() != null && propiedad.getCiudad().getIdCiudad() == c.getIdCiudad();
                                %>
                                    <option value="<%= c.getIdCiudad() %>" <%= sel ? "selected" : "" %>><%= c.getNombre() %> (<%= c.getDepartamento() %>)</option>
                                <%  } 
                                   } %>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Precio ($)</label>
                            <input type="number" step="0.01" class="form-control" name="precio" value="<%= esEdicion ? String.format(java.util.Locale.US, "%.0f", propiedad.getPrecio()) : "" %>" required>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Área (m²)</label>
                            <input type="number" step="0.01" class="form-control" name="area" value="<%= esEdicion ? propiedad.getArea() : "" %>" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Habitaciones</label>
                            <input type="number" class="form-control" name="habitaciones" value="<%= esEdicion ? propiedad.getHabitaciones() : "0" %>" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Baños</label>
                            <input type="number" class="form-control" name="banos" value="<%= esEdicion ? propiedad.getBanos() : "0" %>" required>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label fw-semibold">Descripción Detallada</label>
                        <textarea class="form-control" name="descripcion" rows="4"><%= esEdicion && propiedad.getDescripcion() != null ? propiedad.getDescripcion() : "" %></textarea>
                    </div>

                    <% if (!esEdicion) { %>
                        <h5 class="border-bottom pb-2 mb-3 text-secondary">Características</h5>
                        <div class="row mb-4">
                            <% if (caracteristicas != null) {
                                for(Caracteristica c : caracteristicas) { %>
                            <div class="col-md-3 mb-2">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="caracteristicas" value="<%= c.getIdCaracteristica() %>" id="c_<%= c.getIdCaracteristica() %>">
                                    <label class="form-check-label" for="c_<%= c.getIdCaracteristica() %>">
                                        <%= c.getNombre() %>
                                    </label>
                                </div>
                            </div>
                            <%  } 
                               } %>
                        </div>

                        <h5 class="border-bottom pb-2 mb-3 text-secondary">Imágenes (URLs o rutas en img/)</h5>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Imagen Principal (URL / Ruta)</label>
                            <input type="text" class="form-control mb-2" name="imagenesUrl" placeholder="ej. img/prop1_1.jpg o https://..." required>
                            <label class="form-label fw-semibold">Imagen Adicional 1 (Opcional)</label>
                            <input type="text" class="form-control mb-2" name="imagenesUrl" placeholder="ej. img/prop1_2.jpg">
                            <label class="form-label fw-semibold">Imagen Adicional 2 (Opcional)</label>
                            <input type="text" class="form-control mb-2" name="imagenesUrl" placeholder="ej. img/prop1_3.jpg">
                        </div>
                    <% } %>

                    <div class="d-grid mt-4">
                        <button type="submit" class="btn btn-success btn-lg">
                            <i class="bi <%= esEdicion ? "bi-check-circle" : "bi-cloud-upload" %>"></i> <%= esEdicion ? "Guardar Cambios" : "Publicar Propiedad" %>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
