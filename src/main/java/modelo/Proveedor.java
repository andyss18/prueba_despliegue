package modelo;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.table.DefaultTableModel;

public class Proveedor {
    private int idProveedore;
    private String proveedor;
    private String nit;
    private String direccion;
    private String telefono;

    // Getters y Setters
    public int getIdProveedore() { return idProveedore; }
    public void setIdProveedore(int idProveedore) { this.idProveedore = idProveedore; }
    public String getProveedor() { return proveedor; }
    public void setProveedor(String proveedor) { this.proveedor = proveedor; }
    public String getNit() { return nit; }
    public void setNit(String nit) { this.nit = nit; }
    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }

    // MÉTODO LEER - IGUAL QUE TU AMIGO
    public DefaultTableModel leer(){
        DefaultTableModel tabla = new DefaultTableModel();
        Conexion conexion = new Conexion();
        try{
            conexion.abrir_conexion();
            String query = "SELECT * FROM Proveedores ORDER BY idProveedor;";
            ResultSet rs = conexion.conexionBD.createStatement().executeQuery(query);

            String[] cols = {"ID","Proveedor","NIT","Dirección","Teléfono"};
            tabla.setColumnIdentifiers(cols);

            String[] fila = new String[cols.length];
            while(rs.next()){
                fila[0] = rs.getString("idProveedor");
                fila[1] = rs.getString("proveedor");
                fila[2] = rs.getString("nit");
                fila[3] = rs.getString("direccion");
                fila[4] = rs.getString("telefono");
                tabla.addRow(fila);
            }
            conexion.cerrar_conexion();
        }catch(SQLException e){
            System.out.println("leer Proveedores: " + e.getMessage());
        }
        return tabla;
    }

    public void crear() {
        Conexion conexion = new Conexion();
        try {
            conexion.abrir_conexion();
            
            // Validación NIT
            if(!this.nit.matches("[0-9]+")) {
                System.out.println("Error: NIT solo números");
                return;
            }
            
            String sql = "INSERT INTO Proveedores (proveedor, nit, direccion, telefono) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql);
            stmt.setString(1, this.proveedor);
            stmt.setString(2, this.nit);
            stmt.setString(3, this.direccion);
            stmt.setString(4, this.telefono);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            conexion.cerrar_conexion();
        }
    }

    public void actualizar() {
        Conexion conexion = new Conexion();
        try {
            conexion.abrir_conexion();
            String sql = "UPDATE Proveedores SET proveedor=?, nit=?, direccion=?, telefono=? WHERE idProveedor=?";
            PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql);
            stmt.setString(1, this.proveedor);
            stmt.setString(2, this.nit);
            stmt.setString(3, this.direccion);
            stmt.setString(4, this.telefono);
            stmt.setInt(5, this.idProveedore);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            conexion.cerrar_conexion();
        }
    }

    public void borrar() {
        Conexion conexion = new Conexion();
        try {
            conexion.abrir_conexion();
            String sql = "DELETE FROM Proveedores WHERE idProveedor=?";
            PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql);
            stmt.setInt(1, this.idProveedore);
            stmt.executeUpdate();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            conexion.cerrar_conexion();
        }
    }
}