/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package filtros;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter({"/ADMIN/*"}) // Protege admin y la principal
public class RolFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        String role = null;

        if (session != null) {
            role = (String) session.getAttribute("role");
        }

        String path = req.getRequestURI();

        // 🔒 Si no está logueado, mandamos al login
        if (role == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=notlogged");
            return;
        }

        // 🔐 Si es admin, puede acceder a todo
        if ("ADMIN".equals(role)) {
            chain.doFilter(request, response);
            return;
        }

        // 🔐 Si es empleado, puede acceder al index pero no al admin
        if ("EMPLEADO".equals(role)) {
            if (path.contains("/ADMIN/")) {
                resp.sendRedirect(req.getContextPath() + "/index.jsp?permiso=denegado");
                return;
            } else {
                chain.doFilter(request, response);
                return;
            }
        }

        // Si llega aquí, bloqueamos
        resp.sendRedirect(req.getContextPath() + "/index.jsp?error=permiso");
    }
}