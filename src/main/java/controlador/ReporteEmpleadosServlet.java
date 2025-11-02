/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.*;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import modelo.Conexion;

@WebServlet("/reporteEmpleados")
public class ReporteEmpleadosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=reporte_empleados.pdf");
        
        Document documento = new Document(PageSize.A4.rotate());
        try {
            OutputStream out = response.getOutputStream();
            PdfWriter.getInstance(documento, out);
            documento.open();

            // 🔷 Título
            Font tituloFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.BLACK);
            Paragraph titulo = new Paragraph("Reporte de Empleados", tituloFont);
            titulo.setAlignment(Element.ALIGN_CENTER);
            titulo.setSpacingAfter(20);
            documento.add(titulo);

            // 🔹 Encabezados
            PdfPTable tabla = new PdfPTable(7);
            tabla.setWidthPercentage(100);
            tabla.setWidths(new float[]{2, 3, 3, 4, 3, 2, 3});
            
            String[] encabezados = {"ID", "Nombres", "Apellidos", "Dirección", "Teléfono", "Género", "Puesto"};
            for (String e : encabezados) {
                PdfPCell celda = new PdfPCell(new Phrase(e, new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD, BaseColor.WHITE)));
                celda.setHorizontalAlignment(Element.ALIGN_CENTER);
                celda.setBackgroundColor(new BaseColor(50, 100, 200));
                celda.setPadding(8);
                tabla.addCell(celda);
            }

            // 🔸 Query y conexión
            Conexion cn = new Conexion();
            cn.abrir_conexion();
            String query = "SELECT e.idEmpleado, e.nombres, e.apellidos, e.direccion, e.telefono, " +
                           "IF(e.genero=1,'Masculino','Femenino') AS genero, " +
                           "p.puesto, e.fecha_inicio_labores AS fecha_ingreso " +
                           "FROM db_supermercado.empleados e " +
                           "INNER JOIN puestos p ON e.idPuesto = p.idPuesto;";
            
            ResultSet rs = cn.conexionBD.createStatement().executeQuery(query);

            Font normalFont = new Font(Font.FontFamily.HELVETICA, 10);
            
            while (rs.next()) {
                // Cambia el color del fondo según el género
                BaseColor colorFila = rs.getString("genero").equalsIgnoreCase("Masculino")
                        ? new BaseColor(210, 235, 255)   // azul claro
                        : new BaseColor(255, 220, 240);  // rosa claro

                for (int i = 1; i <= 7; i++) {
                    PdfPCell celda = new PdfPCell(new Phrase(rs.getString(i), normalFont));
                    celda.setBackgroundColor(colorFila);
                    celda.setPadding(6);
                    tabla.addCell(celda);
                }
            }

            cn.cerrar_conexion();
            documento.add(tabla);
            documento.close();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
