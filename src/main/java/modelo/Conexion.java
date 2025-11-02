package modelo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {
    public Connection conexionBD;
    private final String puerto = "3306";
    private final String bd = "db_supermercado";
    private final String url = "jdbc:mysql://localhost:" + puerto + "/" + bd + "?useSSL=false&serverTimezone=UTC";
    private final String usuario = "root";
    private final String password = "andy@19jajaj"; // tu clave

    public void abrir_conexion(){
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            conexionBD = DriverManager.getConnection(url, usuario, password);
        }catch(Exception ex){
            System.out.println("Error abrir_conexion: " + ex.getMessage());
        }   
    }
    public void cerrar_conexion(){
        try{
            if (conexionBD != null) conexionBD.close();
        }catch(SQLException ex){
            System.out.println("Error cerrar_conexion: " + ex.getMessage());
        }
    }
}
