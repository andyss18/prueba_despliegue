/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package LoginServlet;

import com.miapp.security.JwtUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

// Filtra solo las páginas protegidas
@WebFilter(urlPatterns = {"/index.jsp", "/clientes.jsp", "/compras.jsp", "/empleados.jsp",
    "/productos.jsp", "/proveedores.jsp", "/puestos.jsp", "/ventas.jsp", "/api/*"})
public class JwtAuthFilter implements Filter {

    private JwtUtil jwtUtil;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String secret = System.getenv("JWT_SECRET");
        if (secret == null || secret.isEmpty()) {
            secret = "bXlfc2VjcmV0X2RlbW9fYmFzZTY0X2tleV9fZm9yX2RlbW8="; // misma clave que LoginServlet
        }
        jwtUtil = new JwtUtil(secret);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI();

        // 🔓 Excluir rutas públicas
        if (path.endsWith("login.jsp") || path.endsWith("login") ||
            path.contains("/css/") || path.contains("/js/") || path.contains("/images/")) {
            chain.doFilter(request, response);
            return;
        }

        // 🔐 Revisar token en header Authorization
        String token = null;
        String authHeader = req.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            token = authHeader.substring(7);
        }

        // 🔐 Si no hay token en header, revisar sesión
        if (token == null) {
            token = (String) req.getSession().getAttribute("token");
        }

        // 🔹 Validar token si existe
        if (token != null) {
            try {
                jwtUtil.validateToken(token); // lanzará excepción si no es válido
                chain.doFilter(request, response); // token válido → sigue
                return;
            } catch (Exception e) {
                System.out.println("Token inválido: " + e.getMessage());
            }
        }

        // 🔹 Alternativa simple: revisar si usuario está en sesión
        if (req.getSession().getAttribute("usuario") != null) {
            chain.doFilter(request, response);
            return;
        }

        // 🚫 Sin token ni sesión válida → redirigir al login
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    @Override
    public void destroy() {}
}










