package controlador;

import java.sql.*;
import javax.swing.table.DefaultTableModel;
import modelo.Conexion;

public class compra extends Conexion {
    private int idcompra;
    private int no_orden_compra;
    private Date fecha_orden;
    private int idproveedor;
    private Timestamp fechaingreso;

    public int getIdcompra(){ return idcompra; }
    public void setIdcompra(int v){ idcompra=v; }
    public int getNo_orden_compra(){ return no_orden_compra; }
    public void setNo_orden_compra(int v){ no_orden_compra=v; }
    public Date getFecha_orden(){ return fecha_orden; }
    public void setFecha_orden(Date v){ fecha_orden=v; }
    public int getIdproveedor(){ return idproveedor; }
    public void setIdproveedor(int v){ idproveedor=v; }
    public Timestamp getFechaingreso(){ return fechaingreso; }
    public void setFechaingreso(Timestamp v){ fechaingreso=v; }

    // ===== maestro + detalle (transacción) =====
    public boolean crearConDetalles(
        int[] idProducto, int[] cantidad, double[] precio_costo_unit
    ){
        boolean ok=false;
        try{
            abrir_conexion();
            conexionBD.setAutoCommit(false);

            // 1) maestro
            String sqlM = "INSERT INTO compras(no_orden_compra, idproveedor, fecha_orden) VALUES (?,?,?);";
            PreparedStatement pm = conexionBD.prepareStatement(sqlM, Statement.RETURN_GENERATED_KEYS);
            pm.setInt(1, getNo_orden_compra());
            pm.setInt(2, getIdproveedor());
            pm.setDate(3, getFecha_orden());
            pm.executeUpdate();
            ResultSet gk = pm.getGeneratedKeys();
            int nuevoId = 0; if(gk.next()) nuevoId = gk.getInt(1);
            setIdcompra(nuevoId);

            // 2) detalle
            String sqlD = "INSERT INTO compras_detalle(idcompra, idproducto, cantidad, precio_costo_unitario) VALUES (?,?,?,?);";
            PreparedStatement pd = conexionBD.prepareStatement(sqlD);

            // 3) actualizar producto: existencia, costo y venta (venta = costo * 1.25)
            String sqlProd = "UPDATE productos SET existencia = existencia + ?, precio_costo = ?, precio_venta = ROUND(? * 1.25, 2) WHERE idProducto = ?;";
            PreparedStatement pp = conexionBD.prepareStatement(sqlProd);

            for(int i=0;i<idProducto.length;i++){
                // detalle
                pd.setInt(1, nuevoId);
                pd.setInt(2, idProducto[i]);
                pd.setInt(3, cantidad[i]);
                pd.setDouble(4, precio_costo_unit[i]);
                pd.addBatch();

                // producto
                pp.setInt(1, cantidad[i]);
                pp.setDouble(2, precio_costo_unit[i]);
                pp.setDouble(3, precio_costo_unit[i]);
                pp.setInt(4, idProducto[i]);
                pp.addBatch();
            }
            pd.executeBatch();
            pp.executeBatch();

            conexionBD.commit();
            ok=true;
        }catch(SQLException e){
            try{ conexionBD.rollback(); }catch(Exception ig){}
            System.out.println("crearConDetalles Compras: " + e.getMessage());
        }finally{
            try{ conexionBD.setAutoCommit(true);}catch(Exception ig){}
            cerrar_conexion();
        }
        return ok;
    }

    // listado simple
    public DefaultTableModel leer(){
        DefaultTableModel t = new DefaultTableModel();
        try{
            abrir_conexion();
            String q =
              "SELECT c.idcompra, c.no_orden_compra, c.fecha_orden, p.proveedor, " +
              " ROUND(IFNULL(SUM(d.cantidad * d.precio_costo_unitario),0),2) AS total " +
              "FROM compras c INNER JOIN proveedores p ON c.idproveedor=p.idProveedor " +
              "LEFT JOIN compras_detalle d ON c.idcompra=d.idcompra " +
              "GROUP BY c.idcompra, c.no_orden_compra, c.fecha_orden, p.proveedor " +
              "ORDER BY c.idcompra DESC;";
            ResultSet rs = conexionBD.createStatement().executeQuery(q);
            t.setColumnIdentifiers(new String[]{"ID","No. Orden","Fecha","Proveedor","Total"});
            while(rs.next()){
                t.addRow(new Object[]{
                    rs.getInt(1), rs.getInt(2), rs.getDate(3), rs.getString(4), rs.getBigDecimal(5)
                });
            }
            cerrar_conexion();
        }catch(SQLException e){ System.out.println("leer Compras: "+e.getMessage()); }
        return t;
    }
}
