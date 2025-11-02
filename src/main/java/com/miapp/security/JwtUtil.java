/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.miapp.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;

import java.security.Key;
import java.util.Date;
import java.util.Base64;
import java.util.Map;

public class JwtUtil {
    private static final long EXPIRATION_MS = 1000 * 60 * 60; // 1 hora
    private final Key key;

    // Espera la clave en base64
    public JwtUtil(String base64Secret) {
        byte[] secretBytes = Base64.getDecoder().decode(base64Secret);
        this.key = Keys.hmacShaKeyFor(secretBytes);
    }

    public String generateToken(String username, Map<String, Object> claims){
        long now = System.currentTimeMillis();
        JwtBuilder b = Jwts.builder()
            .setClaims(claims)
            .setSubject(username)
            .setIssuedAt(new Date(now))
            .setExpiration(new Date(now + EXPIRATION_MS))
            .signWith(key, SignatureAlgorithm.HS256);
        return b.compact();
    }

    public Jws<Claims> validateToken(String token) throws JwtException {
        return Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token);
    }

    public boolean isTokenExpired(Jws<Claims> jws) {
        Date exp = jws.getBody().getExpiration();
        return exp.before(new Date());
    }
}
