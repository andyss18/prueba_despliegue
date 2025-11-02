package modelo;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.table.DefaultTableModel;
import java.util.HashMap;

public class Puesto extends Conexion {
    private int idPuesto;
    private String puesto;

    public Puesto(){}
    public Puesto(int idPuesto, String puesto){
        this.idPuesto = idPuesto;
        this.puesto = puesto;
    }

    public int getIdPuesto() { return idPuesto; }
    public void setIdPuesto(int idPuesto) { this.idPuesto = idPuesto; }
    public String getPuesto() { return puesto; }
    public void setPuesto(String puesto) { this.puesto = puesto; }

    public HashMap<String,String> leerDrop(){
        HashMap<String,String> drop = new HashMap<>();
        try{
            abrir_conexion();
            ResultSet rs = conexionBD.createStatement()
                    .executeQuery("SELECT idPuesto, puesto FROM Puestos;");
            while(rs.next()){
                drop.put(rs.getString("idPuesto"), rs.getString("puesto"));
            }
            cerrar_conexion();
        }catch(SQLException e){ System.out.println("leerDrop Puestos: " + e.getMessage()); }
        return drop;
    }

    public DefaultTableModel leer(){
        DefaultTableModel tabla = new DefaultTableModel();
        try{
            abrir_conexion();
            ResultSet rs = conexionBD.createStatement()
                    .executeQuery("SELECT idPuesto, puesto FROM Puestos;");
            tabla.setColumnIdentifiers(new String[]{"ID","Puesto"});
            String[] fila = new String[2];
            while(rs.next()){
                fila[0] = rs.getString("idPuesto");
                fila[1] = rs.getString("puesto");
                tabla.addRow(fila);
            }
            cerrar_conexion();
        }catch(SQLException e){ System.out.println("leer Puestos: " + e.getMessage()); }
        return tabla;
    }

    public int crear(){
        int r=0;
        try{
            abrir_conexion();
            PreparedStatement ps = conexionBD.prepareStatement(
                "INSERT INTO Puestos(puesto) VALUES (?);");
            ps.setString(1, getPuesto());
            r = ps.executeUpdate();
            cerrar_conexion();
        }catch(SQLException e){ System.out.println("crear Puesto: " + e.getMessage()); }
        return r;
    }

    public int actualizar(){
        int r=0;
        try{
            abrir_conexion();
            PreparedStatement ps = conexionBD.prepareStatement(
                "UPDATE Puestos SET puesto=? WHERE idPuesto=?;");
            ps.setString(1, getPuesto());
            ps.setInt(2, getIdPuesto());
            r = ps.executeUpdate();
            cerrar_conexion();
        }catch(SQLException e){ System.out.println("actualizar Puesto: " + e.getMessage()); }
        return r;
    }

    public int borrar(){
        int r=0;
        try{
            abrir_conexion();
            PreparedStatement ps = conexionBD.prepareStatement(
                "DELETE FROM Puestos WHERE idPuesto=?;");
            ps.setInt(1, getIdPuesto());
            r = ps.executeUpdate();
            cerrar_conexion();
        }catch(SQLException e){ System.out.println("borrar Puesto: " + e.getMessage()); }
        return r;
    }
}
