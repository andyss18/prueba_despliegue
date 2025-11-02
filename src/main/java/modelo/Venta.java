package modelo;

import java.sql.*;
import javax.swing.table.DefaultTableModel;

public class Venta extends Conexion {
    private int idVenta;
    private int nofactura;
    private String serie;          // 1 carácter
    private Date fechafactura;     // java.sql.Date
    private int idcliente;
    private int idempleado;
    private Timestamp fechaingreso;

    // Getters/Setters
    public int getIdVenta() { return idVenta; }
    public void setIdVenta(int idVenta) { this.idVenta = idVenta; }
    public int getNofactura() { return nofactura; }
    public void setNofactura(int nofactura) { this.nofactura = nofactura; }
    public String getSerie() { return serie; }
    public void setSerie(String serie) { this.serie = serie; }
    public Date getFechafactura() { return fechafactura; }
    public void setFechafactura(Date fechafactura) { this.fechafactura = fechafactura; }
    public int getIdcliente() { return idcliente; }
    public void setIdcliente(int idcliente) { this.idcliente = idcliente; }
    public int getIdempleado() { return idempleado; }
    public void setIdempleado(int idempleado) { this.idempleado = idempleado; }
    public Timestamp getFechaingreso() { return fechaingreso; }
    public void setFechaingreso(Timestamp fechaingreso) { this.fechaingreso = fechaingreso; }

    // ========== Crear maestro + detalles (en transacción) ==========
    public boolean crearConDetalles(
        int[] idsProducto, int[] cantidades, double[] preciosUnit // mismo length
    ){
        boolean ok = false;
        try{
            abrir_conexion();
            conexionBD.setAutoCommit(false); // comenzar transacción

            // 1) Insert maestro (ventas)
            String sqlVenta = "INSERT INTO ventas(nofactura, serie, fechafactura, idcliente, idempleado) VALUES (?,?,?,?,?);";
            PreparedStatement psVenta = conexionBD.prepareStatement(sqlVenta, Statement.RETURN_GENERATED_KEYS);
            psVenta.setInt(1, getNofactura());
            psVenta.setString(2, getSerie());
            psVenta.setDate(3, getFechafactura());
            psVenta.setInt(4, getIdcliente());
            psVenta.setInt(5, getIdempleado());
            psVenta.executeUpdate();
            ResultSet gk = psVenta.getGeneratedKeys();
            int nuevoIdVenta = 0;
            if (gk.next()) nuevoIdVenta = gk.getInt(1);
            setIdVenta(nuevoIdVenta);

            // 2) Insert detalles + 3) Actualizar existencias
            String sqlDet = "INSERT INTO ventas_detalle(idVenta, idProducto, cantidad, precio_unitario) VALUES (?,?,?,?);";
            PreparedStatement psDet = conexionBD.prepareStatement(sqlDet);

            String sqlExist = "UPDATE productos SET existencia = existencia - ? WHERE idProducto = ?;";
            PreparedStatement psExist = conexionBD.prepareStatement(sqlExist);

            for (int i=0; i<idsProducto.length; i++){
                int idProd = idsProducto[i];
                int cant = cantidades[i];
                double pu = preciosUnit[i];

                // detalle
                psDet.setInt(1, nuevoIdVenta);
                psDet.setInt(2, idProd);
                psDet.setInt(3, cant);
                psDet.setDouble(4, pu);
                psDet.addBatch();

                // existencias
                psExist.setInt(1, cant);
                psExist.setInt(2, idProd);
                psExist.addBatch();
            }
            psDet.executeBatch();
            psExist.executeBatch();

            conexionBD.commit();
            ok = true;
        }catch(SQLException e){
            try{ conexionBD.rollback(); }catch(Exception ig){}
            System.out.println("crearConDetalles Ventas: " + e.getMessage());
        }finally{
            try{ conexionBD.setAutoCommit(true); }catch(Exception ig){}
            cerrar_conexion();
        }
        return ok;
    }

    // ========== Listado simple con total ==========
    public DefaultTableModel leer(){
        DefaultTableModel t = new DefaultTableModel();
        try{
            abrir_conexion();
            String q = 
              "SELECT v.idVenta, v.nofactura, v.serie, v.fechafactura, " +
              " CONCAT(c.nombres,' ',c.apellidos) AS cliente, " +
              " CONCAT(e.nombres,' ',e.apellidos) AS empleado, " +
              " ROUND(IFNULL(SUM(d.cantidad * d.precio_unitario),0),2) AS total " +
              "FROM ventas v " +
              "INNER JOIN clientes c ON v.idcliente = c.idCliente " +
              "INNER JOIN empleados e ON v.idempleado = e.idEmpleado " +
              "LEFT JOIN ventas_detalle d ON v.idVenta = d.idVenta " +
              "GROUP BY v.idVenta, v.nofactura, v.serie, v.fechafactura, cliente, empleado " +
              "ORDER BY v.idVenta DESC;";
            ResultSet rs = conexionBD.createStatement().executeQuery(q);

            t.setColumnIdentifiers(new String[]{"ID","NoFactura","Serie","Fecha","Cliente","Empleado","Total"});
            while(rs.next()){
                t.addRow(new Object[]{
                    rs.getInt("idVenta"),
                    rs.getInt("nofactura"),
                    rs.getString("serie"),
                    rs.getDate("fechafactura"),
                    rs.getString("cliente"),
                    rs.getString("empleado"),
                    rs.getBigDecimal("total")
                });
            }
            cerrar_conexion();
        }catch(SQLException e){
            System.out.println("leer Ventas: " + e.getMessage());
        }
        return t;
    }
}
