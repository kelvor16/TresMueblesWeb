<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String error = request.getParameter("error");
    boolean sinSesion = "no_sesion".equals(error);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso Denegado - Tres Muebles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card-denegado {
            max-width: 540px;
            width: 100%;
            border-radius: 1rem;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
        }
        .icon-box {
            width: 80px;
            height: 80px;
            margin: 0 auto 1.5rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #fee2e2;
            color: #dc2626;
            font-size: 2.5rem;
        }
    </style>
</head>
<body>
    <div class="container p-3">
        <div class="card card-denegado mx-auto p-4 p-md-5 text-center bg-white">
            <div class="icon-box">
                <i class="bi bi-shield-lock-fill"></i>
            </div>
            
            <h1 class="h3 fw-bold text-dark mb-2">Acceso Denegado (403)</h1>
            
            <% if (sinSesion) { %>
                <p class="text-muted mb-4">
                    Para ingresar a este panel privado debes <strong>iniciar sesión</strong> con una cuenta autorizada o <strong>registrarte</strong> en el sistema si aún no eres usuario.
                </p>
                <div class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                    <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-primary px-4 py-2">
                        <i class="bi bi-box-arrow-in-right me-1"></i> Iniciar Sesión
                    </a>
                    <a href="<%= request.getContextPath() %>/registro.jsp" class="btn btn-outline-success px-4 py-2">
                        <i class="bi bi-person-plus-fill me-1"></i> Registrarse
                    </a>
                </div>
            <% } else { %>
                <p class="text-muted mb-4">
                    Has iniciado sesión, pero tu cuenta no cuenta con los permisos requeridos para acceder a esta ruta o panel administrativo.
                </p>
                <div class="d-grid gap-2 d-sm-flex justify-content-sm-center">
                    <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary px-4 py-2">
                        <i class="bi bi-house-door-fill me-1"></i> Ir al Inicio
                    </a>
                    <a href="<%= request.getContextPath() %>/auth?action=logout" class="btn btn-outline-danger px-4 py-2">
                        <i class="bi bi-box-arrow-right me-1"></i> Cambiar de Cuenta
                    </a>
                </div>
            <% } %>

            <div class="mt-4 pt-3 border-top">
                <a href="<%= request.getContextPath() %>/index.jsp" class="text-decoration-none text-secondary small">
                    <i class="bi bi-arrow-left me-1"></i> Volver a la página principal de Tres Muebles
                </a>
            </div>
        </div>
    </div>
</body>
</html>
