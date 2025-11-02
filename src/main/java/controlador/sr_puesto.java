package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Puesto;

public class sr_puesto extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Puesto p = new Puesto();

        String idTxt = request.getParameter("txt_id");
        String nomTxt = request.getParameter("txt_puesto");

        int id = 0;
        try { id = Integer.parseInt(idTxt); } catch(Exception e) { id = 0; }
        p.setIdPuesto(id);
        p.setPuesto(nomTxt);

        if (request.getParameter("btn_crear") != null){
            p.crear();
        } else if (request.getParameter("btn_actualizar") != null){
            p.actualizar();
        } else if (request.getParameter("btn_borrar") != null){
            p.borrar();
        }
        response.sendRedirect("ADMIN/puestos.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("ADMIN/puestos.jsp");
    }
}
