/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Optional;

public class UsuarioDAO {
    
    public Optional<Usuario> validarUsuario(String username, String password) {
        Conexion cn = new Conexion();
        Optional<Usuario> usuarioOpt = Optional.empty();
        
        try {
            cn.abrir_conexion();
            String sql = "SELECT * FROM usuarios WHERE username = ? AND password = ?";
            PreparedStatement ps = cn.conexionBD.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Usuario u = new Usuario();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setPassword(rs.getString("password"));
                u.setRole(rs.getString("role")); // 👈 nuevo
                usuarioOpt = Optional.of(u);
            }
            
            rs.close();
            ps.close();
            cn.cerrar_conexion();
            
        } catch (Exception e) {
            System.out.println("Error validarUsuario: " + e.getMessage());
        }
        
        return usuarioOpt;
    }
}

