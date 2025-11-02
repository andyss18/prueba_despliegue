
# Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
# Click nbfs://nbhost/SystemFileSystem/Templates/Other/Dockerfile to edit this template

# Imagen base: Tomcat 11 con Java 17
FROM tomcat:11-jdk17

# Limpia la carpeta webapps por si hay apps por defecto
RUN rm -rf /usr/local/tomcat/webapps/*

# Copia tu WAR al contenedor y lo renombra como ROOT.war
COPY target/Proyecto_final-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Expone el puerto que Render usará
EXPOSE 8080

# Inicia Tomcat
CMD ["catalina.sh", "run"]
