package modelo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    public Connection conexionBD;

    // 🔗 Datos de conexión desde Railway
    private final String url = "jdbc:mysql://shinkansen.proxy.rlwy.net:59184/railway";
    private final String usuario = "root";
    private final String contraseña = "LzZyXZcsKAjzBcItdZLolgKbIoQDNSPk";

    public void abrir_conexion() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conexionBD = DriverManager.getConnection(url, usuario, contraseña);
            System.out.println("✅ Conexión exitosa a la base de datos Railway");
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("❌ Error al conectar a la base de datos: " + e.getMessage());
        }
    }

    public void cerrar_conexion() {
        try {
            if (conexionBD != null) {
                conexionBD.close();
                System.out.println("🔒 Conexión cerrada correctamente");
            }
        } catch (SQLException e) {
            System.out.println("❌ Error al cerrar conexión: " + e.getMessage());
        }
    }
}
