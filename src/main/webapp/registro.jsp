<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro - Tres Muebles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    
    <div class="container mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow">
                    <div class="card-body p-4">
                        <h3 class="text-center mb-4">Crea tu cuenta</h3>
                        
                        <% if (request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
                        <% } %>

                        <form action="auth" method="post">
                            <input type="hidden" name="action" value="registro">
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="nombres" class="form-label">Nombres</label>
                                    <input type="text" class="form-control" id="nombres" name="nombres" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="apellidos" class="form-label">Apellidos</label>
                                    <input type="text" class="form-control" id="apellidos" name="apellidos" required>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="documento" class="form-label">Documento de Identidad</label>
                                <input type="text" class="form-control" id="documento" name="documento" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="correo" class="form-label">Correo Electrónico</label>
                                <input type="email" class="form-control" id="correo" name="correo" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="clave" class="form-label">Contraseña</label>
                                <input type="password" class="form-control" id="clave" name="clave" required>
                            </div>
                            
                            <button type="submit" class="btn btn-primary w-100 mt-3">Registrarse</button>
                        </form>
                        
                        <div class="mt-3 text-center">
                            <a href="login.jsp">¿Ya tienes cuenta? Inicia sesión aquí</a>
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
