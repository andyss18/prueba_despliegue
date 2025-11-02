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

@WebServlet("/reporteCompras")
public class ReporteComprasServlet extends HttpServlet {


@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "inline; filename=reporte_compras.pdf");

    Document documento = new Document(PageSize.A4.rotate());
    try {
        OutputStream out = response.getOutputStream();
        PdfWriter.getInstance(documento, out);
        documento.open();

        // 🔷 Título
        Font tituloFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.BLACK);
        Paragraph titulo = new Paragraph("Reporte de Compras", tituloFont);
        titulo.setAlignment(Element.ALIGN_CENTER);
        titulo.setSpacingAfter(20);
        documento.add(titulo);

        // 🔹 Encabezados
        PdfPTable tabla = new PdfPTable(8);
        tabla.setWidthPercentage(100);
        tabla.setWidths(new float[]{2, 3, 3, 4, 4, 2, 3, 3});

        String[] encabezados = {"ID Compra", "Orden Compra", "Fecha Compra", "Proveedor", "Producto", "Cantidad", "Precio Unitario", "Subtotal"};
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
                "c.idcompra, " +
                "c.no_orden_compra AS orden_compra, " +
                "c.fecha_orden AS fecha_compra, " +
                "pr.proveedor, " +
                "p.producto, " +
                "cd.cantidad, " +
                "cd.precio_costo_unitario, " +
                "(cd.cantidad * cd.precio_costo_unitario) AS subtotal " +
                "FROM compras c " +
                "INNER JOIN compras_detalle cd ON c.idcompra = cd.idcompra " +
                "INNER JOIN proveedores pr ON c.idproveedor = pr.idProveedor " +
                "INNER JOIN productos p ON cd.idproducto = p.idProducto " +
                "ORDER BY c.idcompra ASC;";

        ResultSet rs = cn.conexionBD.createStatement().executeQuery(query);

        Font normalFont = new Font(Font.FontFamily.HELVETICA, 10);

        int fila = 0;
        while (rs.next()) {
            // Alterna color de filas
            BaseColor colorFila = fila % 2 == 0
                    ? new BaseColor(230, 245, 255)  // azul claro
                    : new BaseColor(255, 255, 255); // blanco

            for (int i = 1; i <= 8; i++) {
                PdfPCell celda = new PdfPCell(new Phrase(rs.getString(i), normalFont));
                celda.setBackgroundColor(colorFila);
                celda.setPadding(6);
                tabla.addCell(celda);
            }
            fila++;
        }

        cn.cerrar_conexion();
        documento.add(tabla);
        documento.close();

    } catch (Exception e) {
        e.printStackTrace();
    }
}


}
