package controlador;

import modelo.Producto;
import modelo.Marca;
import modelo.Conexion;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/sr_producto")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class sr_producto extends HttpServlet {
    
    private Conexion conexion;
    
    @Override
    public void init() throws ServletException {
        conexion = new Conexion();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if (action == null) {
                showMainPage(request, response);
            } else {
                switch (action) {
                    case "mostrar":
                        listProductos(request, response);
                        break;
                    case "agregar":
                        showNewForm(request, response);
                        break;
                    case "actualizar":
                        showEditForm(request, response);
                        break;
                    case "eliminar":
                        deleteProducto(request, response);
                        break;
                    case "obtenerParaCompra":
                        obtenerProductosParaCompra(request, response);
                        break;
                    default:
                        showMainPage(request, response);
                        break;
                }
            }
        } catch (SQLException ex) {
            request.setAttribute("error", "Error de base de datos: " + ex.getMessage());
            try {
                listProductos(request, response);
            } catch (SQLException e) {
                throw new ServletException(e);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("insert".equals(action)) {
                insertProducto(request, response);
            } else if ("update".equals(action)) {
                updateProducto(request, response);
            } else {
                showMainPage(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    
    private void obtenerProductosParaCompra(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        List<String[]> productos = getProductosParaCompra();
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < productos.size(); i++) {
            String[] p = productos.get(i);
            if (i > 0) json.append(",");
            json.append("{\"id\":").append(p[0])
                .append(",\"nom\":\"").append(p[1].replace("\"", "\\\""))
                .append("\",\"costo\":").append(p[2])
                .append(",\"exist\":").append(p[3])
                .append("}");
        }
        json.append("]");
        
        response.getWriter().write(json.toString());
    }
    
    private List<String[]> getProductosParaCompra() throws SQLException {
        List<String[]> productos = new ArrayList<>();
        String sql = "SELECT idProducto, producto, precio_costo, existencia FROM productos ORDER BY producto";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                String[] producto = {
                    rs.getString("idProducto"),
                    rs.getString("producto"),
                    rs.getString("precio_costo"),
                    rs.getString("existencia")
                };
                productos.add(producto);
            }
        } finally {
            conexion.cerrar_conexion();
        }
        return productos;
    }
    
    private void showMainPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Marca> marcas = getMarcas();
        request.setAttribute("marcas", marcas);
        RequestDispatcher dispatcher = request.getRequestDispatcher("productos.jsp");
        dispatcher.forward(request, response);
    }
    
    private void listProductos(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Producto> listaProductos = new ArrayList<>();
        String sql = "SELECT p.*, m.marca FROM productos p INNER JOIN marcas m ON p.idMarca = m.idmarca ORDER BY p.idProducto";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Producto producto = new Producto();
                producto.setIdProducto(rs.getInt("idProducto"));
                producto.setProducto(rs.getString("producto"));
                producto.setIdMarca(rs.getInt("idMarca"));
                producto.setDescripcion(rs.getString("Descripcion"));
                producto.setImagen(rs.getString("Imagen"));
                producto.setPrecioCosto(rs.getBigDecimal("precio_costo"));
                producto.setPrecioVenta(rs.getBigDecimal("precio_venta"));
                producto.setExistencia(rs.getInt("existencia"));
                producto.setFechaIngreso(rs.getTimestamp("fecha_ingreso"));
                producto.setNombreMarca(rs.getString("marca"));
                listaProductos.add(producto);
            }
        } finally {
            conexion.cerrar_conexion();
        }
        
        List<Marca> marcas = getMarcas();
        request.setAttribute("marcas", marcas);
        request.setAttribute("listaProductos", listaProductos);
        request.setAttribute("mostrarTabla", true);
        RequestDispatcher dispatcher = request.getRequestDispatcher("productos.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        List<Marca> marcas = getMarcas();
        request.setAttribute("marcas", marcas);
        request.setAttribute("mostrarFormulario", true);
        RequestDispatcher dispatcher = request.getRequestDispatcher("productos.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Producto producto = getProductoById(id);
        List<Marca> marcas = getMarcas();
        
        request.setAttribute("marcas", marcas);
        request.setAttribute("producto", producto);
        request.setAttribute("mostrarFormulario", true);
        request.setAttribute("esEdicion", true);
        RequestDispatcher dispatcher = request.getRequestDispatcher("productos.jsp");
        dispatcher.forward(request, response);
    }
    
    private void insertProducto(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String errores = validarProducto(request);
        if (!errores.isEmpty()) {
            request.setAttribute("error", errores);
            showNewForm(request, response);
            return;
        }
        
        Producto producto = obtenerProductoDeRequest(request, false);
        String imagenName = procesarImagen(request);
        
        String sql = "INSERT INTO productos (producto, idMarca, Descripcion, Imagen, precio_costo, precio_venta, existencia, fecha_ingreso) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql)) {
            
            stmt.setString(1, producto.getProducto());
            stmt.setInt(2, producto.getIdMarca());
            stmt.setString(3, producto.getDescripcion());
            stmt.setString(4, imagenName);
            stmt.setBigDecimal(5, producto.getPrecioCosto());
            stmt.setBigDecimal(6, producto.getPrecioVenta());
            stmt.setInt(7, producto.getExistencia());
            stmt.executeUpdate();
        } finally {
            conexion.cerrar_conexion();
        }
        
        response.sendRedirect("sr_producto?action=mostrar");
    }
    
    private void updateProducto(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        String errores = validarProducto(request);
        if (!errores.isEmpty()) {
            request.setAttribute("error", errores);
            showEditForm(request, response);
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        Producto producto = obtenerProductoDeRequest(request, true);
        String imagenName = procesarImagen(request);
        
        String sql = "UPDATE productos SET producto=?, idMarca=?, Descripcion=?, precio_costo=?, precio_venta=?, existencia=?";
        if (imagenName != null) {
            sql += ", Imagen=?";
        }
        sql += " WHERE idProducto=?";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql)) {
            
            int paramIndex = 1;
            stmt.setString(paramIndex++, producto.getProducto());
            stmt.setInt(paramIndex++, producto.getIdMarca());
            stmt.setString(paramIndex++, producto.getDescripcion());
            stmt.setBigDecimal(paramIndex++, producto.getPrecioCosto());
            stmt.setBigDecimal(paramIndex++, producto.getPrecioVenta());
            stmt.setInt(paramIndex++, producto.getExistencia());
            
            if (imagenName != null) {
                stmt.setString(paramIndex++, imagenName);
            }
            
            stmt.setInt(paramIndex, id);
            stmt.executeUpdate();
        } finally {
            conexion.cerrar_conexion();
        }
        
        response.sendRedirect("sr_producto?action=mostrar");
    }
    
    private void deleteProducto(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        // Verificar si el producto tiene registros relacionados
        if (tieneComprasRelacionadas(id)) {
            request.setAttribute("error", "No se puede eliminar el producto porque está siendo usado en compras.");
            listProductos(request, response);
            return;
        }
        
        String sql = "DELETE FROM productos WHERE idProducto = ?";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } finally {
            conexion.cerrar_conexion();
        }
        
        response.sendRedirect("sr_producto?action=mostrar");
    }
    
    private boolean tieneComprasRelacionadas(int idProducto) throws SQLException {
        String sql = "SELECT COUNT(*) FROM compras_detalle WHERE idproducto = ?";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql)) {
            stmt.setInt(1, idProducto);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } finally {
            conexion.cerrar_conexion();
        }
        return false;
    }
    
    private List<Marca> getMarcas() throws SQLException {
        List<Marca> marcas = new ArrayList<>();
        String sql = "SELECT idmarca, marca FROM marcas ORDER BY marca";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Marca marca = new Marca(rs.getInt("idmarca"), rs.getString("marca"));
                marcas.add(marca);
            }
        } finally {
            conexion.cerrar_conexion();
        }
        return marcas;
    }
    
    private Producto getProductoById(int id) throws SQLException {
        Producto producto = null;
        String sql = "SELECT * FROM productos WHERE idProducto = ?";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    producto = new Producto();
                    producto.setIdProducto(rs.getInt("idProducto"));
                    producto.setProducto(rs.getString("producto"));
                    producto.setIdMarca(rs.getInt("idMarca"));
                    producto.setDescripcion(rs.getString("Descripcion"));
                    producto.setImagen(rs.getString("Imagen"));
                    producto.setPrecioCosto(rs.getBigDecimal("precio_costo"));
                    producto.setPrecioVenta(rs.getBigDecimal("precio_venta"));
                    producto.setExistencia(rs.getInt("existencia"));
                    producto.setFechaIngreso(rs.getTimestamp("fecha_ingreso"));
                }
            }
        } finally {
            conexion.cerrar_conexion();
        }
        return producto;
    }
    
    private String validarProducto(HttpServletRequest request) {
        StringBuilder errores = new StringBuilder();
        
        String producto = request.getParameter("producto");
        String idMarca = request.getParameter("idMarca");
        String precioCosto = request.getParameter("precio_costo");
        String precioVenta = request.getParameter("precio_venta");
        String existencia = request.getParameter("existencia");
        
        if (producto == null || producto.trim().isEmpty()) {
            errores.append("El nombre del producto es obligatorio.<br>");
        }
        
        if (idMarca == null || idMarca.trim().isEmpty()) {
            errores.append("Debe seleccionar una marca.<br>");
        }
        
        try {
            BigDecimal costo = new BigDecimal(precioCosto);
            if (costo.compareTo(BigDecimal.ZERO) < 0) {
                errores.append("El precio costo no puede ser negativo.<br>");
            }
        } catch (Exception e) {
            errores.append("El precio costo debe ser un número válido.<br>");
        }
        
        try {
            BigDecimal venta = new BigDecimal(precioVenta);
            if (venta.compareTo(BigDecimal.ZERO) < 0) {
                errores.append("El precio venta no puede ser negativo.<br>");
            }
        } catch (Exception e) {
            errores.append("El precio venta debe ser un número válido.<br>");
        }
        
        try {
            int exist = Integer.parseInt(existencia);
            if (exist < 0) {
                errores.append("La existencia no puede ser negativa.<br>");
            }
        } catch (Exception e) {
            errores.append("La existencia debe ser un número entero válido.<br>");
        }
        
        return errores.toString();
    }
    
    private Producto obtenerProductoDeRequest(HttpServletRequest request, boolean isUpdate) {
        Producto producto = new Producto();
        
        if (isUpdate) {
            producto.setIdProducto(Integer.parseInt(request.getParameter("id")));
        }
        
        producto.setProducto(request.getParameter("producto"));
        producto.setIdMarca(Integer.parseInt(request.getParameter("idMarca")));
        producto.setDescripcion(request.getParameter("descripcion"));
        producto.setPrecioCosto(new BigDecimal(request.getParameter("precio_costo")));
        producto.setPrecioVenta(new BigDecimal(request.getParameter("precio_venta")));
        producto.setExistencia(Integer.parseInt(request.getParameter("existencia")));
        
        return producto;
    }
    
    private String procesarImagen(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("imagen");
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String fileName = getFileName(filePart);

        if (!isValidImageType(fileName)) {
            throw new ServletException("Tipo de archivo no permitido. Solo se permiten imágenes JPG, PNG, GIF.");
        }

        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

        // Carpeta 1: src/main/webapp/uploads
        String projectUploadPath = System.getProperty("user.dir")
                + File.separator + "src"
                + File.separator + "main"
                + File.separator + "webapp"
                + File.separator + "uploads";

        // Carpeta 2: target/.../uploads (temporal)
        String targetUploadPath = request.getServletContext().getRealPath("")
                + File.separator + "uploads";

        // Creamos las carpetas si no existen
        new File(projectUploadPath).mkdirs();
        new File(targetUploadPath).mkdirs();

        // Guardamos en las dos carpetas
        try (InputStream fileContent = filePart.getInputStream()) {
            // 1️⃣ Guardar en src/main/webapp/uploads
            try (FileOutputStream out = new FileOutputStream(projectUploadPath + File.separator + uniqueFileName)) {
                int read;
                final byte[] bytes = new byte[1024];
                while ((read = fileContent.read(bytes)) != -1) {
                    out.write(bytes, 0, read);
                }
            }

            // Reiniciamos el stream para la segunda copia
            filePart.getInputStream().close(); // cerramos
            InputStream fileContent2 = filePart.getInputStream(); // volvemos a abrir

            // 2️⃣ Guardar en target/.../uploads
            try (FileOutputStream out2 = new FileOutputStream(targetUploadPath + File.separator + uniqueFileName)) {
                int read;
                final byte[] bytes = new byte[1024];
                while ((read = fileContent2.read(bytes)) != -1) {
                    out2.write(bytes, 0, read);
                }
            }
        }

        // Retornamos la ruta relativa para el JSP
        return "uploads/" + uniqueFileName;
    }
    
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
    
    private boolean isValidImageType(String fileName) {
        if (fileName == null || fileName.isEmpty()) return false;
        
        String[] allowedExtensions = {".jpg", ".jpeg", ".png", ".gif"};
        String lowerCaseFileName = fileName.toLowerCase();
        
        for (String ext : allowedExtensions) {
            if (lowerCaseFileName.endsWith(ext)) {
                return true;
            }
        }
        return false;
    }
}