package modelo;

public class Marca {
    private int idmarca;
    private String marca;
    
    public Marca() {}
    
    public Marca(int idmarca, String marca) {
        this.idmarca = idmarca;
        this.marca = marca;
    }
    
    public int getIdmarca() { return idmarca; }
    public void setIdmarca(int idmarca) { this.idmarca = idmarca; }
    
    public String getMarca() { return marca; }
    public void setMarca(String marca) { this.marca = marca; }
}