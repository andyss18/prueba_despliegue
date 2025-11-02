/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package LoginServlet;


import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import modelo.UsuarioDAO;
import modelo.Usuario;
import java.util.Optional;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        UsuarioDAO dao = new UsuarioDAO();
        Optional<Usuario> userOpt = dao.validarUsuario(username, password);

        if (userOpt.isPresent()) {
            Usuario user = userOpt.get();
            HttpSession session = req.getSession();
            session.setAttribute("usuario", user);
            session.setAttribute("role", user.getRole()); // 👈 nuevo
            resp.sendRedirect("index.jsp"); // Redirige a la página principal
        } else {
            resp.sendRedirect("login.jsp?error=true");
        }
    }
}

