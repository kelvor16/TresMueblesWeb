<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.tresmuebles.util.ConexionDB" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Diagnóstico de Base de Datos - Tres Muebles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light p-4">
    <div class="container" style="max-width: 700px;">
        <div class="card shadow-sm p-4">
            <h3 class="mb-3">Diagnóstico de Conexión a Base de Datos</h3>
            
            <table class="table table-bordered table-sm mb-4">
                <thead class="table-dark">
                    <tr><th>Variable de Entorno</th><th>Valor Detectado</th></tr>
                </thead>
                <tbody>
                    <tr><td>MYSQL_ADDON_HOST</td><td><%= System.getenv("MYSQL_ADDON_HOST") != null ? System.getenv("MYSQL_ADDON_HOST") : "<span class='text-danger'>NO DETECTADA (Falta vincular add-on)</span>" %></td></tr>
                    <tr><td>MYSQL_ADDON_PORT</td><td><%= System.getenv("MYSQL_ADDON_PORT") != null ? System.getenv("MYSQL_ADDON_PORT") : "-" %></td></tr>
                    <tr><td>MYSQL_ADDON_DB</td><td><%= System.getenv("MYSQL_ADDON_DB") != null ? System.getenv("MYSQL_ADDON_DB") : "-" %></td></tr>
                    <tr><td>MYSQL_ADDON_USER</td><td><%= System.getenv("MYSQL_ADDON_USER") != null ? System.getenv("MYSQL_ADDON_USER") : "-" %></td></tr>
                </tbody>
            </table>

            <h5 class="mb-2">Prueba de Conexión en Vivo:</h5>
            <%
                try {
                    Connection con = ConexionDB.getInstancia().getConexion();
                    if (con != null && !con.isClosed()) {
                        Statement st = con.createStatement();
                        ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM usuario");
                        int count = 0;
                        if (rs.next()) count = rs.getInt(1);
            %>
                        <div class="alert alert-success">
                            <strong>¡CONEXIÓN EXITOSA!</strong><br>
                            Se conectó a la base de datos correctamente.<br>
                            Usuarios registrados encontrados en la base de datos: <strong><%= count %></strong>
                        </div>
            <%
                        con.close();
                    }
                } catch (Exception e) {
            %>
                    <div class="alert alert-danger">
                        <strong>FALLÓ LA CONEXIÓN:</strong><br>
                        <code><%= e.getClass().getName() %>: <%= e.getMessage() %></code>
                    </div>
            <%
                }
            %>
            <div class="mt-3">
                <a href="index.jsp" class="btn btn-outline-primary">Volver al Inicio</a>
            </div>
        </div>
    </div>
</body>
</html>
