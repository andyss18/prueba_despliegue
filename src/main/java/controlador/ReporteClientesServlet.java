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

@WebServlet("/reporteClientes")
public class ReporteClientesServlet extends HttpServlet {


@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "inline; filename=reporte_clientes.pdf");

    Document documento = new Document(PageSize.A4.rotate());
    try {
        OutputStream out = response.getOutputStream();
        PdfWriter.getInstance(documento, out);
        documento.open();

        // 🔷 Título
        Font tituloFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.BLACK);
        Paragraph titulo = new Paragraph("Reporte de Clientes", tituloFont);
        titulo.setAlignment(Element.ALIGN_CENTER);
        titulo.setSpacingAfter(20);
        documento.add(titulo);

        // 🔹 Encabezados
        PdfPTable tabla = new PdfPTable(6);
        tabla.setWidthPercentage(100);
        tabla.setWidths(new float[]{2, 4, 3, 2, 3, 4});

        String[] encabezados = {"ID", "Cliente", "NIT", "Género", "Teléfono", "Correo electrónico"};
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
        String query = "SELECT c.idCliente AS Id, " +
                       "CONCAT(c.nombres, ' ', c.apellidos) AS Cliente, " +
                       "c.nit, " +
                       "IF(c.genero=1,'Masculino','Femenino') AS Genero, " +
                       "c.telefono, " +
                       "c.correo_electronico " +
                       "FROM db_supermercado.clientes c;";

        ResultSet rs = cn.conexionBD.createStatement().executeQuery(query);

        Font normalFont = new Font(Font.FontFamily.HELVETICA, 10);

        while (rs.next()) {
            // Color de fila según género
            BaseColor colorFila = rs.getString("Genero").equalsIgnoreCase("Masculino")
                    ? new BaseColor(210, 235, 255)   // azul claro
                    : new BaseColor(255, 220, 240);  // rosa claro

            for (int i = 1; i <= 6; i++) {
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
