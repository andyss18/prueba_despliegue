package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import modelo.compra;

public class sr_compra extends HttpServlet {

    private int toInt(String s){ try { return Integer.parseInt(s); } catch(Exception e){ return 0; } }
    private double toDouble(String s){ try { return Double.parseDouble(s); } catch(Exception e){ return 0.0; } }
    private java.sql.Date toSqlDate(String s){ try { return java.sql.Date.valueOf(s); } catch(Exception e){ return null; } }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        compra c = new compra();
        c.setNo_orden_compra( toInt(req.getParameter("txt_no_orden")) );
        c.setIdproveedor( toInt(req.getParameter("drop_proveedor")) );
        c.setFecha_orden( toSqlDate(req.getParameter("txt_fecha")) );

        String[] idsP = req.getParameterValues("detail_idProducto");
        String[] cants = req.getParameterValues("detail_cantidad");
        String[] costos= req.getParameterValues("detail_costo");

        if (idsP==null || idsP.length==0){ resp.sendRedirect("compras.jsp"); return; }

        int n = idsP.length;
        int[] idProd = new int[n]; int[] cant = new int[n]; double[] costo = new double[n];
        for(int i=0;i<n;i++){
            idProd[i]=toInt(idsP[i]); cant[i]=toInt(cants[i]); costo[i]=toDouble(costos[i]);
        }

        c.crearConDetalles(idProd, cant, costo);
        resp.sendRedirect("compras.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendRedirect("compras.jsp");
    }
}

