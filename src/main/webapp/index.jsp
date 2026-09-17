<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tres Muebles Inmobiliaria</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .hero {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover;
            height: 60vh;
            display: flex;
            align-items: center;
            color: white;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">Tres Muebles</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="index.jsp">Inicio</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="buscador">Explorar Propiedades</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">Iniciar Sesión</a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-primary ms-2" href="registro.jsp">Registrarse</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <header class="hero text-center">
        <div class="container">
            <h1 class="display-3 fw-bold">Encuentra el hogar de tus sueños</h1>
            <p class="lead mb-4">Las mejores propiedades en arriendo y venta en un solo lugar.</p>
            
            <!-- Buscador Rápido -->
            <form action="buscador" method="get" class="d-flex justify-content-center bg-white p-3 rounded shadow-sm mx-auto" style="max-width: 800px;">
                <select name="tipo" class="form-select me-2">
                    <option value="">Todos los tipos</option>
                    <option value="1">Casa</option>
                    <option value="2">Apartamento</option>
                    <option value="3">Local</option>
                </select>
                <input type="number" name="precioMax" class="form-control me-2" placeholder="Precio máximo ($)...">
                <button class="btn btn-primary px-4" type="submit">Buscar</button>
            </form>
        </div>
    </header>

    <!-- Propiedades Destacadas -->
    <section class="container my-5">
        <h2 class="text-center mb-4">Propiedades Destacadas</h2>
        <div class="row g-4">
            <!-- Card 1 -->
            <div class="col-md-4">
                <div class="card h-100 shadow-sm">
                    <img src="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60" class="card-img-top" alt="Propiedad">
                    <div class="card-body">
                        <h5 class="card-title">Hermoso Apartamento en Cabecera</h5>
                        <p class="card-text text-muted">Bucaramanga, Santander</p>
                        <h6 class="text-primary fs-4">$ 350.000.000</h6>
                    </div>
                    <div class="card-footer bg-white border-top-0">
                        <a href="buscador?action=detalle&id=1" class="btn btn-outline-primary w-100">Ver Detalles</a>
                    </div>
                </div>
            </div>
            <!-- Más cards irían aquí dinámicamente -->
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-white text-center py-4 mt-auto">
        <div class="container">
            <p>&copy; 2026 Inmobiliaria Tres Muebles. Todos los derechos reservados.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
