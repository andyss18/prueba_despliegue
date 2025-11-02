package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Empleado;

public class sr_empleado extends HttpServlet {

    private java.sql.Date toSqlDate(String s){
        try { return (s==null || s.isEmpty()) ? null : java.sql.Date.valueOf(s); }
        catch(Exception e){ return null; }
    }

    private Boolean toBool10(String s){
        if (s==null) return null;
        if (s.equals("1")) return true;
        if (s.equals("0")) return false;
        return null;
    }

    private int toInt(String s){
        try { return Integer.parseInt(s); } catch(Exception e){ return 0; }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Empleado e = new Empleado();

        // ID y FK
        e.setIdEmpleado( toInt(request.getParameter("txt_id")) );
        e.setIdPuesto( toInt(request.getParameter("drop_puesto")) );

        // Persona (heredado)
        e.setNombres( request.getParameter("txt_nombres") );
        e.setApellidos( request.getParameter("txt_apellidos") );
        e.setDireccion( request.getParameter("txt_direccion") );
        e.setTelefono( request.getParameter("txt_telefono") );
        e.setDPI( request.getParameter("txt_dpi") );
        e.setGenero( toBool10(request.getParameter("drop_genero")) );
        e.setFecha_nacimiento( toSqlDate(request.getParameter("txt_fecha_nac")) );

        // Empleado propios
        e.setFecha_inicio_labores( toSqlDate(request.getParameter("txt_fecha_inicio")) );

        if (request.getParameter("btn_crear") != null){
            e.crear();
        } else if (request.getParameter("btn_actualizar") != null){
            e.actualizar();
        } else if (request.getParameter("btn_borrar") != null){
            e.borrar();
        }

        response.sendRedirect("ADMIN/empleados.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("ADMIN/empleados.jsp");
    }
}
