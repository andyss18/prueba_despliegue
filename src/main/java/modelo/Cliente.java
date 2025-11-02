package modelo;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.table.DefaultTableModel;

public class Cliente {
    private int idCliente;
    private String nombres;
    private String apellidos;
    private String NIT;
    private Boolean genero;
    private String telefono;
    private String correo_electronico;

    // Getters y Setters
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { 
        System.out.println("Cliente.setIdCliente(" + idCliente + ")");
        this.idCliente = idCliente; 
    }
    public String getNombres() { return nombres; }
    public void setNombres(String nombres) { this.nombres = nombres; }
    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }
    public String getNIT() { return NIT; }
    public void setNIT(String NIT) { this.NIT = NIT; }
    public Boolean getGenero() { return genero; }
    public void setGenero(Boolean genero) { this.genero = genero; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    public String getCorreo_electronico() { return correo_electronico; }
    public void setCorreo_electronico(String correo_electronico) { this.correo_electronico = correo_electronico; }

    // MÉTODO LEER
    public DefaultTableModel leer(){
        DefaultTableModel tabla = new DefaultTableModel();
        Conexion conexion = new Conexion();
        try{
            conexion.abrir_conexion();
            String query = "SELECT * FROM Clientes ORDER BY idCliente;";
            ResultSet rs = conexion.conexionBD.createStatement().executeQuery(query);

            String[] cols = {"ID","Nombres","Apellidos","NIT","Género","Teléfono","Correo"};
            tabla.setColumnIdentifiers(cols);

            String[] fila = new String[cols.length];
            while(rs.next()){
                fila[0] = rs.getString("idCliente");
                fila[1] = rs.getString("nombres");
                fila[2] = rs.getString("apellidos");
                fila[3] = rs.getString("NIT");
                fila[4] = rs.getBoolean("genero") ? "M" : "F";
                fila[5] = rs.getString("telefono");
                fila[6] = rs.getString("correo_electronico");
                tabla.addRow(fila);
            }
            conexion.cerrar_conexion();
        }catch(SQLException e){
            System.out.println("leer Clientes: " + e.getMessage());
        }
        return tabla;
    }

    public void crear() {
        System.out.println("Cliente.crear() ejecutándose");
        Conexion conexion = new Conexion();
        try {
            conexion.abrir_conexion();
            String sql = "INSERT INTO Clientes (nombres, apellidos, NIT, genero, telefono, correo_electronico) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql);
            stmt.setString(1, this.nombres);
            stmt.setString(2, this.apellidos);
            stmt.setString(3, this.NIT);
            stmt.setBoolean(4, this.genero);
            stmt.setString(5, this.telefono);
            stmt.setString(6, this.correo_electronico);
            int resultado = stmt.executeUpdate();
            System.out.println("CREAR - Filas afectadas: " + resultado);
            stmt.close();
        } catch (Exception e) {
            System.out.println("Error al crear cliente: " + e.getMessage());
            e.printStackTrace();
        } finally {
            conexion.cerrar_conexion();
        }
    }

    public void actualizar() {
        System.out.println("Cliente.actualizar() ejecutándose - ID: " + this.idCliente);
        // VALIDACIÓN: No actualizar si el ID es inválido
        if (this.idCliente <= 0) {
            System.out.println("ERROR ACTUALIZAR: ID de cliente inválido: " + this.idCliente);
            return;
        }
        
        Conexion conexion = new Conexion();
        try {
            conexion.abrir_conexion();
            String sql = "UPDATE Clientes SET nombres=?, apellidos=?, NIT=?, genero=?, telefono=?, correo_electronico=? WHERE idCliente=?";
            PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql);
            stmt.setString(1, this.nombres);
            stmt.setString(2, this.apellidos);
            stmt.setString(3, this.NIT);
            stmt.setBoolean(4, this.genero);
            stmt.setString(5, this.telefono);
            stmt.setString(6, this.correo_electronico);
            stmt.setInt(7, this.idCliente);
            int filasAfectadas = stmt.executeUpdate();
            
            System.out.println("ACTUALIZAR - Filas afectadas: " + filasAfectadas);
            
            if (filasAfectadas > 0) {
                System.out.println("Cliente actualizado exitosamente. ID: " + this.idCliente);
            } else {
                System.out.println("No se encontró el cliente con ID: " + this.idCliente);
            }
            
            stmt.close();
        } catch (Exception e) {
            System.out.println("Error al actualizar cliente: " + e.getMessage());
            e.printStackTrace();
        } finally {
            conexion.cerrar_conexion();
        }
    }

    public void borrar() {
        System.out.println("Cliente.borrar() ejecutándose - ID: " + this.idCliente);
        // VALIDACIÓN CRÍTICA: No borrar si el ID es 0 o negativo
        if (this.idCliente <= 0) {
            System.out.println("ERROR BORRAR: ID de cliente inválido: " + this.idCliente);
            return;
        }
        
        Conexion conexion = new Conexion();
        try {
            conexion.abrir_conexion();
            String sql = "DELETE FROM Clientes WHERE idCliente=?";
            PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql);
            stmt.setInt(1, this.idCliente);
            int filasAfectadas = stmt.executeUpdate();
            
            System.out.println("BORRAR - Filas afectadas: " + filasAfectadas);
            
            if (filasAfectadas > 0) {
                System.out.println("Cliente borrado exitosamente. ID: " + this.idCliente);
            } else {
                System.out.println("No se encontró el cliente con ID: " + this.idCliente);
            }
            
            stmt.close();
        } catch (Exception e) {
            System.out.println("Error al borrar cliente: " + e.getMessage());
            e.printStackTrace();
        } finally {
            conexion.cerrar_conexion();
        }
    }
}