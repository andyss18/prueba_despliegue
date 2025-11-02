package controlador;

import modelo.Marca;
import modelo.Conexion;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/sr_marca")
public class sr_marca extends HttpServlet {
    
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
                        listMarcas(request, response);
                        break;
                    case "agregar":
                        showNewForm(request, response);
                        break;
                    case "actualizar":
                        showEditForm(request, response);
                        break;
                    case "eliminar":
                        deleteMarca(request, response);
                        break;
                    default:
                        showMainPage(request, response);
                        break;
                }
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if ("insert".equals(action)) {
                insertMarca(request, response);
            } else if ("update".equals(action)) {
                updateMarca(request, response);
            } else {
                showMainPage(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    
    private void showMainPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("ADMIN/marcas.jsp");
        dispatcher.forward(request, response);
    }
    
    private void listMarcas(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Marca> listaMarcas = new ArrayList<>();
        String sql = "SELECT * FROM marcas ORDER BY idmarca";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Marca marca = new Marca(rs.getInt("idmarca"), rs.getString("marca"));
                listaMarcas.add(marca);
            }
        } finally {
            conexion.cerrar_conexion();
        }
        
        request.setAttribute("listaMarcas", listaMarcas);
        request.setAttribute("mostrarTabla", true);
        RequestDispatcher dispatcher = request.getRequestDispatcher("ADMIN/marcas.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("mostrarFormulario", true);
        RequestDispatcher dispatcher = request.getRequestDispatcher("ADMIN/marcas.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Marca marca = getMarcaById(id);
        
        request.setAttribute("marca", marca);
        request.setAttribute("mostrarFormulario", true);
        request.setAttribute("esEdicion", true);
        RequestDispatcher dispatcher = request.getRequestDispatcher("ADMIN/marcas.jsp");
        dispatcher.forward(request, response);
    }
    
    private void insertMarca(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String nombreMarca = request.getParameter("marca");
        
        if (nombreMarca == null || nombreMarca.trim().isEmpty()) {
            response.sendRedirect("sr_marca?error=Nombre de marca requerido");
            return;
        }
        
        String sql = "INSERT INTO marcas (marca) VALUES (?)";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql)) {
            stmt.setString(1, nombreMarca.trim());
            stmt.executeUpdate();
        } finally {
            conexion.cerrar_conexion();
        }
        
        response.sendRedirect("sr_marca?action=mostrar");
    }
    
    private void updateMarca(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String nombreMarca = request.getParameter("marca");
        
        if (nombreMarca == null || nombreMarca.trim().isEmpty()) {
            response.sendRedirect("sr_marca?error=Nombre de marca requerido");
            return;
        }
        
        String sql = "UPDATE marcas SET marca = ? WHERE idmarca = ?";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql)) {
            stmt.setString(1, nombreMarca.trim());
            stmt.setInt(2, id);
            stmt.executeUpdate();
        } finally {
            conexion.cerrar_conexion();
        }
        
        response.sendRedirect("sr_marca?action=mostrar");
    }
    
    private void deleteMarca(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        // Verificar si hay productos asociados
        String sqlCheck = "SELECT COUNT(*) as total FROM productos WHERE idMarca = ?";
        int totalProductos = 0;
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sqlCheck)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    totalProductos = rs.getInt("total");
                }
            }
        } finally {
            conexion.cerrar_conexion();
        }
        
        if (totalProductos > 0) {
            // Hay productos asociados - mostrar mensaje de error
            String mensajeError = "No se puede eliminar la marca porque tiene " + totalProductos + 
                                " producto(s) asociado(s). " +
                                "Primero debe eliminar los productos relacionados en la tabla de Productos.";
            
            request.setAttribute("error", mensajeError);
            listMarcas(request, response);
        } else {
            // No hay productos - eliminar la marca
            String sql = "DELETE FROM marcas WHERE idmarca = ?";
            
            conexion.abrir_conexion();
            
            try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql)) {
                stmt.setInt(1, id);
                stmt.executeUpdate();
            } finally {
                conexion.cerrar_conexion();
            }
            response.sendRedirect("sr_marca?action=mostrar");
        }
    }
    
    private Marca getMarcaById(int id) throws SQLException {
        Marca marca = null;
        String sql = "SELECT * FROM marcas WHERE idmarca = ?";
        
        conexion.abrir_conexion();
        
        try (PreparedStatement stmt = conexion.conexionBD.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    marca = new Marca(rs.getInt("idmarca"), rs.getString("marca"));
                }
            }
        } finally {
            conexion.cerrar_conexion();
        }
        return marca;
    }
}