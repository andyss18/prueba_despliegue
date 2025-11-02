package controlador;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelo.Cliente;

public class sr_cliente extends HttpServlet {

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

        // DEBUG: Mostrar todos los parámetros recibidos
        System.out.println("=== DEBUG SR_CLIENTE ===");
        System.out.println("txt_id: " + request.getParameter("txt_id"));
        System.out.println("txt_nombres: " + request.getParameter("txt_nombres"));
        System.out.println("btn_crear: " + request.getParameter("btn_crear"));
        System.out.println("btn_actualizar: " + request.getParameter("btn_actualizar"));
        System.out.println("btn_borrar: " + request.getParameter("btn_borrar"));

        Cliente c = new Cliente();

        // ID - con más debug
        int idRecibido = toInt(request.getParameter("txt_id"));
        System.out.println("ID convertido: " + idRecibido);
        c.setIdCliente(idRecibido);

        // Datos del cliente
        c.setNombres(request.getParameter("txt_nombres"));
        c.setApellidos(request.getParameter("txt_apellidos"));
        c.setNIT(request.getParameter("txt_nit"));
        c.setGenero(toBool10(request.getParameter("drop_genero")));
        c.setTelefono(request.getParameter("txt_telefono"));
        c.setCorreo_electronico(request.getParameter("txt_correo"));

        String mensaje = "";
        String accion = "";
        
        if (request.getParameter("btn_crear") != null){
            accion = "CREAR";
            System.out.println("Ejecutando CREAR cliente");
            c.crear();
            mensaje = "?mensaje=Cliente creado exitosamente";
        } else if (request.getParameter("btn_actualizar") != null){
            accion = "ACTUALIZAR";
            System.out.println("Ejecutando ACTUALIZAR cliente, ID: " + c.getIdCliente());
            if (c.getIdCliente() > 0) {
                c.actualizar();
                mensaje = "?mensaje=Cliente actualizado exitosamente";
            } else {
                mensaje = "?error=Seleccione un cliente para actualizar";
                System.out.println("ERROR: ID inválido para actualizar");
            }
        } else if (request.getParameter("btn_borrar") != null){
            accion = "BORRAR";
            System.out.println("Ejecutando BORRAR cliente, ID: " + c.getIdCliente());
            if (c.getIdCliente() > 0) {
                c.borrar();
                mensaje = "?mensaje=Cliente borrado exitosamente";
            } else {
                mensaje = "?error=Seleccione un cliente para borrar";
                System.out.println("ERROR: ID inválido para borrar");
            }
        }

        System.out.println("Acción ejecutada: " + accion);
        System.out.println("Redirect a: clientes.jsp" + mensaje);
        System.out.println("=== FIN DEBUG ===");

        response.sendRedirect("clientes.jsp" + mensaje);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("clientes.jsp");
    }
}