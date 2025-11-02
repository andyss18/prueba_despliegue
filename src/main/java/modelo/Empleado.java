package modelo;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.table.DefaultTableModel;

public class Empleado extends Persona {
    private int idEmpleado;
    private int idPuesto;
    private java.sql.Date fecha_inicio_labores;
    private java.sql.Timestamp fechaingreso; // lo trae la BD por default

    public Empleado(){}

    // Getters/Setters
    public int getIdEmpleado() { return idEmpleado; }
    public void setIdEmpleado(int idEmpleado) { this.idEmpleado = idEmpleado; }

    public int getIdPuesto() { return idPuesto; }
    public void setIdPuesto(int idPuesto) { this.idPuesto = idPuesto; }

    public java.sql.Date getFecha_inicio_labores() { return fecha_inicio_labores; }
    public void setFecha_inicio_labores(java.sql.Date fecha_inicio_labores) { this.fecha_inicio_labores = fecha_inicio_labores; }

    public java.sql.Timestamp getFechaingreso() { return fechaingreso; }
    public void setFechaingreso(java.sql.Timestamp fechaingreso) { this.fechaingreso = fechaingreso; }

    // Listado con JOIN para mostrar nombre del puesto
    public DefaultTableModel leer(){
    DefaultTableModel tabla = new DefaultTableModel();
    try{
        abrir_conexion();
        String query =
            "SELECT e.idEmpleado, e.nombres, e.apellidos, e.direccion, e.telefono, e.DPI, " +
            "       e.genero, e.fecha_nacimiento, p.puesto AS nombre_puesto, " +
            "       e.idPuesto, e.fecha_inicio_labores, e.fechaingreso " +
            "FROM Empleados e INNER JOIN Puestos p ON e.idPuesto = p.idPuesto " +
            "ORDER BY e.idEmpleado;";
        ResultSet rs = conexionBD.createStatement().executeQuery(query);

        String[] cols = {"ID","Nombres","Apellidos","Dirección","Teléfono","DPI",
                         "Género","Fecha Nac.","Puesto","idPuesto","Inicio","Ingreso"};
        tabla.setColumnIdentifiers(cols);

        while (rs.next()){
            int idEmpleado      = rs.getInt("idEmpleado");
            String nombres      = rs.getString("nombres");
            String apellidos    = rs.getString("apellidos");
            String direccion    = rs.getString("direccion");
            String telefono     = rs.getString("telefono");
            String dpi          = rs.getString("DPI");

            // genero BIT -> texto
            int genInt = rs.getInt("genero");
            String generoTxt = rs.wasNull() ? "" : (genInt == 1 ? "Masculino" : "Femenino");

            java.sql.Date fechaNac   = rs.getDate("fecha_nacimiento");
            String puestoNombre      = rs.getString("nombre_puesto");
            int idPuesto             = rs.getInt("idPuesto");
            java.sql.Date fechaInicio= rs.getDate("fecha_inicio_labores");

            // 👇 Solo fecha (yyyy-MM-dd) SIN hora
            java.sql.Date fechaIngresoSoloFecha = rs.getDate("fechaingreso");

            tabla.addRow(new Object[]{
                idEmpleado, nombres, apellidos, direccion, telefono, dpi,
                generoTxt, fechaNac, puestoNombre, idPuesto, fechaInicio, fechaIngresoSoloFecha
            });
        }
        cerrar_conexion();
    }catch (java.sql.SQLException e){
        System.out.println("leer Empleados: " + e.getMessage());
    }
    return tabla;
}

    public int crear(){
        int r=0;
        try{
            abrir_conexion();
            String sql = "INSERT INTO Empleados(nombres,apellidos,direccion,telefono,DPI,genero,fecha_nacimiento,idPuesto,fecha_inicio_labores) " +
                         "VALUES (?,?,?,?,?,?,?,?,?);";
            PreparedStatement ps = conexionBD.prepareStatement(sql);
            ps.setString(1, getNombres());
            ps.setString(2, getApellidos());
            ps.setString(3, getDireccion());
            ps.setString(4, getTelefono());
            ps.setString(5, getDPI());
            // genero BIT
            if (getGenero()==null) ps.setNull(6, java.sql.Types.BIT); else ps.setBoolean(6, getGenero());
            ps.setDate(7, getFecha_nacimiento()); // puede ser null
            ps.setInt(8, getIdPuesto());
            ps.setDate(9, getFecha_inicio_labores()); // puede ser null
            r = ps.executeUpdate();
            cerrar_conexion();
        }catch(SQLException e){
            System.out.println("crear Empleado: " + e.getMessage());
        }
        return r;
    }

    public int actualizar(){
        int r=0;
        try{
            abrir_conexion();
            String sql = "UPDATE Empleados SET nombres=?, apellidos=?, direccion=?, telefono=?, DPI=?, genero=?, " +
                         "fecha_nacimiento=?, idPuesto=?, fecha_inicio_labores=? WHERE idEmpleado=?;";
            PreparedStatement ps = conexionBD.prepareStatement(sql);
            ps.setString(1, getNombres());
            ps.setString(2, getApellidos());
            ps.setString(3, getDireccion());
            ps.setString(4, getTelefono());
            ps.setString(5, getDPI());
            if (getGenero()==null) ps.setNull(6, java.sql.Types.BIT); else ps.setBoolean(6, getGenero());
            ps.setDate(7, getFecha_nacimiento());
            ps.setInt(8, getIdPuesto());
            ps.setDate(9, getFecha_inicio_labores());
            ps.setInt(10, getIdEmpleado());
            r = ps.executeUpdate();
            cerrar_conexion();
        }catch(SQLException e){
            System.out.println("actualizar Empleado: " + e.getMessage());
        }
        return r;
    }

    public int borrar(){
        int r=0;
        try{
            abrir_conexion();
            PreparedStatement ps = conexionBD.prepareStatement("DELETE FROM Empleados WHERE idEmpleado=?;");
            ps.setInt(1, getIdEmpleado());
            r = ps.executeUpdate();
            cerrar_conexion();
        }catch(SQLException e){
            System.out.println("borrar Empleado: " + e.getMessage());
        }
        return r;
    }
}
