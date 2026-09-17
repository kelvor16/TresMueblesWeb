<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.tresmuebles.model.Usuario" %>
<%@ page import="com.tresmuebles.model.Cita" %>
<%@ page import="com.tresmuebles.model.Favorito" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.tresmuebles.model.Solicitud" %>
<%@ page import="com.tresmuebles.model.DocumentoSolicitud" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null || !usuario.hasRol("Cliente")) {
        response.sendRedirect(request.getContextPath() + "/acceso-denegado.jsp");
        return;
    }
    List<Cita> citas = (List<Cita>) request.getAttribute("citas");
    List<Favorito> favoritos = (List<Favorito>) request.getAttribute("favoritos");
    List<Solicitud> solicitudes = (List<Solicitud>) request.getAttribute("solicitudes");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy hh:mm a");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel de Cliente - Tres Muebles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    
    <nav class="navbar navbar-expand-lg navbar-dark bg-info">
        <div class="container">
            <a class="navbar-brand" href="#">Tres Muebles - Cliente</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="#">Mi Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/panel/perfil">Mi Perfil</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/buscador">Buscador</a>
                    </li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="<%= request.getContextPath() %>/auth?action=logout">Cerrar Sesión</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <% if (request.getParameter("mensaje") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <%= request.getParameter("mensaje") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <%= request.getParameter("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        <h2 class="mb-4">Hola, <%= (usuario.getPerfil() != null && usuario.getPerfil().getNombres() != null && !usuario.getPerfil().getNombres().isEmpty()) ? usuario.getPerfil().getNombres() : usuario.getCorreo() %></h2>
        
        <div class="row">
            <!-- Citas Agendadas -->
            <div class="col-md-6 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-header bg-white">
                        <h4 class="mb-0">Mis Citas</h4>
                    </div>
                    <div class="card-body">
                        <% if(citas != null && !citas.isEmpty()) { %>
                            <ul class="list-group list-group-flush">
                                <% for(Cita c : citas) { 
                                    String titEsc = c.getPropiedad().getTitulo().replace("'", "\\'");
                                %>
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <div>
                                            <strong><%= c.getPropiedad().getTitulo() %></strong><br>
                                            <small class="text-muted"><%= c.getFechaHora().format(formatter) %></small>
                                        </div>
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="badge bg-primary"><%= c.getEstado() %></span>
                                            <% if(!"cancelada".equalsIgnoreCase(c.getEstado())) { %>
                                                <button type="button" class="btn btn-sm btn-outline-primary" title="Reprogramar Cita" onclick="abrirModalEditar(<%= c.getIdCita() %>, '<%= titEsc %>')">✎</button>
                                                <button type="button" class="btn btn-sm btn-outline-danger" title="Cancelar Cita" onclick="abrirModalCancelar(<%= c.getIdCita() %>, '<%= titEsc %>')">✕</button>
                                            <% } %>
                                        </div>
                                    </li>
                                <% } %>
                            </ul>
                        <% } else { %>
                            <p class="text-muted">No tienes citas agendadas.</p>
                        <% } %>
                    </div>
                </div>
            </div>
            
            <!-- Favoritos -->
            <div class="col-md-6 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-header bg-white">
                        <h4 class="mb-0">Mis Propiedades Favoritas</h4>
                    </div>
                    <div class="card-body">
                        <% if(favoritos != null && !favoritos.isEmpty()) { %>
                            <div class="list-group">
                                <% for(Favorito f : favoritos) { %>
                                    <div class="list-group-item d-flex justify-content-between align-items-center">
                                        <a href="<%= request.getContextPath() %>/buscador?action=detalle&id=<%= f.getPropiedad().getIdPropiedad() %>" class="text-decoration-none flex-grow-1 text-dark">
                                            <h6 class="mb-1"><%= f.getPropiedad().getTitulo() %></h6>
                                            <small class="text-success fw-bold">$ <%= String.format("%,.0f", f.getPropiedad().getPrecio()) %></small>
                                        </a>
                                        <form action="<%= request.getContextPath() %>/operacion" method="post" class="m-0 p-0 ms-2">
                                            <input type="hidden" name="action" value="quitarFavorito">
                                            <input type="hidden" name="idPropiedad" value="<%= f.getPropiedad().getIdPropiedad() %>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger" title="Quitar de Favoritos">♥ Quit</button>
                                        </form>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <p class="text-muted">No tienes propiedades en favoritos.</p>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Solicitudes Radicadas -->
            <div class="col-md-12 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-header bg-white">
                        <h4 class="mb-0">Mis Solicitudes Radicadas</h4>
                    </div>
                    <div class="card-body">
                        <% if(solicitudes != null && !solicitudes.isEmpty()) { %>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Propiedad</th>
                                            <th>Trámite</th>
                                            <th>Estado</th>
                                            <th>Fecha</th>
                                            <th>Documento</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for(Solicitud s : solicitudes) { %>
                                            <tr>
                                                <td><strong><%= s.getPropiedad().getTitulo() %></strong></td>
                                                <td><span class="badge bg-secondary text-uppercase"><%= s.getTipo() %></span></td>
                                                <td>
                                                    <% if("aprobada".equalsIgnoreCase(s.getEstado())) { %>
                                                        <span class="badge bg-success">Aprobada</span>
                                                    <% } else if("rechazada".equalsIgnoreCase(s.getEstado())) { %>
                                                        <span class="badge bg-danger">Rechazada</span>
                                                    <% } else { %>
                                                        <span class="badge bg-warning text-dark">Pendiente</span>
                                                    <% } %>
                                                </td>
                                                <td><%= s.getFechaRadicacion() != null ? s.getFechaRadicacion().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "" %></td>
                                                <td>
                                                    <% if (s.getDocumentos() != null && !s.getDocumentos().isEmpty()) { 
                                                        DocumentoSolicitud doc = s.getDocumentos().get(0);
                                                    %>
                                                        <a href="<%= doc.getUrlDocumento() %>" target="_blank" class="btn btn-sm btn-outline-primary" title="Descargar <%= doc.getNombreDocumento() %>">Descargar PDF</a>
                                                    <% } else { %>
                                                        <span class="text-muted small">Sin adjunto</span>
                                                    <% } %>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } else { %>
                            <p class="text-muted">No has radicado ninguna solicitud de compra o arriendo.</p>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Editar Cita -->
    <div class="modal fade" id="modalEditarCita" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow">
                <form action="<%= request.getContextPath() %>/operacion" method="post">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">Reprogramar Cita</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Selecciona una nueva fecha y hora para tu visita a <strong id="editarTituloPropiedad"></strong>.</p>
                        <input type="hidden" name="action" value="editarCita">
                        <input type="hidden" name="idCita" id="editarIdCita">
                        <input type="datetime-local" class="form-control" name="fechaHora" required>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Volver</button>
                        <button type="submit" class="btn btn-primary">Confirmar Nueva Fecha</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Cancelar Cita -->
    <div class="modal fade" id="modalCancelarCita" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content border-0 shadow">
                <form action="<%= request.getContextPath() %>/operacion" method="post">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">¿Cancelar Cita?</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center py-4">
                        <h4 class="mb-3">¿Estás completamente seguro?</h4>
                        <p class="text-muted mb-0">Vas a cancelar tu cita para visitar <strong id="cancelarTituloPropiedad"></strong>.</p>
                        <input type="hidden" name="action" value="cancelarCita">
                        <input type="hidden" name="idCita" id="cancelarIdCita">
                    </div>
                    <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-success px-4" data-bs-dismiss="modal">Mejor No</button>
                        <button type="submit" class="btn btn-danger px-4">Sí, Cancelar Cita</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function abrirModalEditar(idCita, titulo) {
            document.getElementById('editarIdCita').value = idCita;
            document.getElementById('editarTituloPropiedad').innerText = titulo;
            new bootstrap.Modal(document.getElementById('modalEditarCita')).show();
        }
        function abrirModalCancelar(idCita, titulo) {
            document.getElementById('cancelarIdCita').value = idCita;
            document.getElementById('cancelarTituloPropiedad').innerText = titulo;
            new bootstrap.Modal(document.getElementById('modalCancelarCita')).show();
        }
    </script>
</body>
</html>
