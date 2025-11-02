/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controlador;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import modelo.Conexion;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

@WebServlet("/ReporteExistenciasPDF")
public class ReporteExistenciasPDF extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "inline; filename=Reporte_Existencias.pdf");

        Conexion cn = new Conexion();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String query = "SELECT p.idproducto AS id, p.producto, m.marca, p.existencia " +
                       "FROM db_supermercado.productos p " +
                       "INNER JOIN marcas m ON p.idMarca = m.idmarca " +
                       "ORDER BY p.existencia DESC;";

        Document documento = new Document(PageSize.A4.rotate()); // horizontal para mejor tabla

        try {
            OutputStream out = response.getOutputStream();
            PdfWriter.getInstance(documento, out);
            documento.open();

            // 📘 Título
            Font tituloFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
            Paragraph titulo = new Paragraph("Reporte de Existencias por Producto\n\n", tituloFont);
            titulo.setAlignment(Element.ALIGN_CENTER);
            documento.add(titulo);

            // 🧱 Tabla con 4 columnas
            PdfPTable tabla = new PdfPTable(4);
            tabla.setWidthPercentage(100);
            tabla.setWidths(new float[]{10, 40, 30, 20});

            // Encabezados
            Font headerFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.WHITE);
            BaseColor headerBg = new BaseColor(60, 60, 60);
            String[] headers = {"ID", "Producto", "Marca", "Existencia"};

            for (String h : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(h, headerFont));
                cell.setBackgroundColor(headerBg);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                tabla.addCell(cell);
            }

            // Datos
            cn.abrir_conexion();
            con = cn.conexionBD;
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            Font cellFont = new Font(Font.FontFamily.HELVETICA, 11);

            while (rs.next()) {
                int existencia = rs.getInt("existencia");
                BaseColor bgColor;

                // 🔴 Azul Verde según existencia
                if (existencia < 10) {
                    bgColor = new BaseColor(255, 150, 150); // rojo claro
                } else if (existencia <= 25) {
                    bgColor = new BaseColor(150, 180, 255); // azul claro
                } else {
                    bgColor = new BaseColor(150, 255, 150); // verde claro
                }

                tabla.addCell(String.valueOf(rs.getInt("id")));
                tabla.addCell(rs.getString("producto"));
                tabla.addCell(rs.getString("marca"));

                PdfPCell existenciaCell = new PdfPCell(new Phrase(String.valueOf(existencia), cellFont));
                existenciaCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                existenciaCell.setBackgroundColor(bgColor);
                tabla.addCell(existenciaCell);
            }

            documento.add(tabla);
            documento.close();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            cn.cerrar_conexion();
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
