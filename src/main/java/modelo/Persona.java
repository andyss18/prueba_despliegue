package modelo;

public class Persona extends Conexion {
    protected String nombres;
    protected String apellidos;
    protected String direccion;
    protected String telefono;
    protected String DPI;              // VARCHAR(15)
    protected Boolean genero;          // BIT -> usamos Boolean
    protected java.sql.Date fecha_nacimiento;

    public Persona(){}

    public Persona(String nombres, String apellidos, String direccion, String telefono,
                   String DPI, Boolean genero, java.sql.Date fecha_nacimiento) {
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.direccion = direccion;
        this.telefono = telefono;
        this.DPI = DPI;
        this.genero = genero;
        this.fecha_nacimiento = fecha_nacimiento;
    }

    // Getters/Setters
    public String getNombres() { return nombres; }
    public void setNombres(String nombres) { this.nombres = nombres; }
    public String getApellidos() { return apellidos; }
    public void setApellidos(String apellidos) { this.apellidos = apellidos; }
    public String getDireccion() { return direccion; }
    public void setDireccion(String direccion) { this.direccion = direccion; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    public String getDPI() { return DPI; }
    public void setDPI(String DPI) { this.DPI = DPI; }
    public Boolean getGenero() { return genero; }
    public void setGenero(Boolean genero) { this.genero = genero; }
    public java.sql.Date getFecha_nacimiento() { return fecha_nacimiento; }
    public void setFecha_nacimiento(java.sql.Date fecha_nacimiento) { this.fecha_nacimiento = fecha_nacimiento; }
}
