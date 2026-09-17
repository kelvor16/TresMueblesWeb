<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión - Tres Muebles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card shadow">
                    <div class="card-body p-4">
                        <h3 class="text-center mb-4">Iniciar Sesión</h3>
                        
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
                        <% } %>
                        <% if (request.getAttribute("mensaje") != null) { %>
                            <div class="alert alert-success"><%= request.getAttribute("mensaje") %></div>
                        <% } %>

                        <form action="auth" method="post">
                            <input type="hidden" name="action" value="login">
                            
                            <div class="mb-3">
                                <label for="correo" class="form-label">Correo Electrónico</label>
                                <input type="email" class="form-control" id="correo" name="correo" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="clave" class="form-label">Contraseña</label>
                                <input type="password" class="form-control" id="clave" name="clave" required>
                            </div>
                            
                            <button type="submit" class="btn btn-primary w-100">Ingresar</button>
                        </form>
                        
                        <div class="mt-3 text-center">
                            <a href="registro.jsp">¿No tienes cuenta? Regístrate aquí</a>
                        </div>
                        <div class="mt-2 text-center">
                            <a href="index.jsp" class="text-muted">Volver al inicio</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
