package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Proveedor;

public class sr_proveedor extends HttpServlet {

    private int toInt(String s){
        try { return Integer.parseInt(s); } catch(Exception e){ return 0; }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Proveedor p = new Proveedor();

        // ID
        p.setIdProveedore(toInt(request.getParameter("txt_id")));

        // Datos del proveedor
        p.setProveedor(request.getParameter("txt_proveedor"));
        p.setNit(request.getParameter("txt_nit"));
        p.setDireccion(request.getParameter("txt_direccion"));
        p.setTelefono(request.getParameter("txt_telefono"));

        if (request.getParameter("btn_crear") != null){
            p.crear();
        } else if (request.getParameter("btn_actualizar") != null){
            p.actualizar();
        } else if (request.getParameter("btn_borrar") != null){
            p.borrar();
        }

        response.sendRedirect("ADMIN/proveedores.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("ADMIN/proveedores.jsp");
    }
}