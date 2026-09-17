package com.tresmuebles.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {
    
    // Configuración local por defecto
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/inmobiliaria_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "";
    
    private static ConexionDB instancia;
    
    private ConexionDB() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    public static ConexionDB getInstancia() {
        if (instancia == null) {
            instancia = new ConexionDB();
        }
        return instancia;
    }
    
    public Connection getConexion() throws SQLException {
        // En Clever Cloud, al vincular el add-on de MySQL, estas variables se configuran automáticamente:
        String host = System.getenv("MYSQL_ADDON_HOST");
        String port = System.getenv("MYSQL_ADDON_PORT");
        String db = System.getenv("MYSQL_ADDON_DB");
        String user = System.getenv("MYSQL_ADDON_USER");
        String password = System.getenv("MYSQL_ADDON_PASSWORD");
        
        if (host != null && !host.trim().isEmpty()) {
            String cloudUrl = "jdbc:mysql://" + host + ":" + port + "/" + db + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            return DriverManager.getConnection(cloudUrl, user, password);
        }
        
        // Entorno local por defecto
        return DriverManager.getConnection(DEFAULT_URL, DEFAULT_USER, DEFAULT_PASSWORD);
    }
}
