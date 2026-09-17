<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.File" %>
<%@ page import="com.tresmuebles.util.ConexionDB" %>
<!DOCTYPE html>
<html>
<head><title>Test Imagenes</title></head>
<body>
    <h1>Diagnóstico de Imágenes</h1>
    <p>Context Path: <b><%= request.getContextPath() %></b></p>
    <p>Ruta real en servidor: <b><%= application.getRealPath("/") %></b></p>
    
    <table border="1" cellpadding="5">
        <tr>
            <th>ID Propiedad</th>
            <th>URL Imagen (BD)</th>
            <th>Es Principal?</th>
            <th>Archivo Existe en Disco?</th>
            <th>Ruta Física Buscada</th>
        </tr>
        <%
            try (Connection con = ConexionDB.getInstancia().getConexion();
                 PreparedStatement ps = con.prepareStatement("SELECT * FROM imagen_propiedad ORDER BY id_propiedad, id_imagen");
                 ResultSet rs = ps.executeQuery()) {
                
                while (rs.next()) {
                    int idPropiedad = rs.getInt("id_propiedad");
                    String urlImagen = rs.getString("url_imagen");
                    boolean esPrincipal = rs.getBoolean("es_principal");
                    
                    String realPath = application.getRealPath("/") + urlImagen;
                    File f = new File(realPath);
                    boolean exists = f.exists();
                    
                    out.println("<tr>");
                    out.println("<td>" + idPropiedad + "</td>");
                    out.println("<td>" + urlImagen + "</td>");
                    out.println("<td>" + esPrincipal + "</td>");
                    out.println("<td style='color:" + (exists ? "green" : "red") + "'>" + (exists ? "SI" : "NO") + "</td>");
                    out.println("<td>" + realPath + "</td>");
                    out.println("</tr>");
                }
            } catch(Exception e) {
                out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</body>
</html>
