/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.miapp.security;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import io.jsonwebtoken.Claims;

@WebServlet("/protected") // URL que quieres proteger
public class ProtectedServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // El filtro ya puso estos atributos si el token es válido
        String username = (String) req.getAttribute("username");
        Claims claims = (Claims) req.getAttribute("claims");

        resp.setContentType("application/json");
        resp.getWriter().write("{\"msg\":\"Hola " + username + "\", \"role\":\"" + claims.get("role") + "\"}");
    }
}
