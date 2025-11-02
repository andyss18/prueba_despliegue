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

@WebServlet("/reporteVentas")
public class ReporteVentasServlet extends HttpServlet {


@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "inline; filename=reporte_ventas.pdf");

    Document documento = new Document(PageSize.A4.rotate());
    try {
        OutputStream out = response.getOutputStream();
        PdfWriter.getInstance(documento, out);
        documento.open();

        // 🔷 Título
        Font tituloFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.BLACK);
        Paragraph titulo = new Paragraph("Reporte de Ventas", tituloFont);
        titulo.setAlignment(Element.ALIGN_CENTER);
        titulo.setSpacingAfter(20);
        documento.add(titulo);

        // 🔹 Encabezados
        PdfPTable tabla = new PdfPTable(9);
        tabla.setWidthPercentage(100);
        tabla.setWidths(new float[]{2, 3, 3, 4, 4, 3, 2, 3, 3});

        String[] encabezados = {"ID Venta", "Factura", "Fecha Venta", "Cliente", "Empleado", "Producto", "Cantidad", "Precio Unitario", "Subtotal"};
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
        String query = "SELECT " +
                "v.idVenta, " +
                "v.nofactura AS factura, " +
                "v.fechafactura AS fecha_venta, " +
                "CONCAT(c.nombres, ' ', c.apellidos) AS Cliente, " +
                "CONCAT(e.nombres, ' ', e.apellidos) AS Empleado, " +
                "p.producto, " +
                "vd.cantidad, " +
                "vd.precio_unitario, " +
                "(vd.cantidad * vd.precio_unitario) AS subtotal " +
                "FROM db_supermercado.ventas v " +
                "INNER JOIN clientes c ON v.idcliente = c.idCliente " +
                "INNER JOIN empleados e ON v.idempleado = e.idEmpleado " +
                "INNER JOIN ventas_detalle vd ON v.idVenta = vd.idventa_detalle " +
                "INNER JOIN productos p ON vd.idProducto = p.idProducto;";

        ResultSet rs = cn.conexionBD.createStatement().executeQuery(query);

        Font normalFont = new Font(Font.FontFamily.HELVETICA, 10);

        while (rs.next()) {
            // Color alternado de filas para mejor lectura
            BaseColor colorFila = rs.getRow() % 2 == 0
                    ? new BaseColor(230, 245, 255)  // azul claro
                    : new BaseColor(255, 255, 255); // blanco

            for (int i = 1; i <= 9; i++) {
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
