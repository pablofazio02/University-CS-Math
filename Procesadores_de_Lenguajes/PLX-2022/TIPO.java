public class TIPO {
    
    public static final String INT = "int";
    public static final String FLOAT = "float";
    public static final String DOUBLE = "double";
    public static final String CHAR = "char";
    public static final String ARRAY = "array";
    public static final String STRING = "string";
    public static final String SET = "set";
    

    private String tipo;
     /*
        Esto se usa, por ejemplo, si tipo=array, subtipo podrá ser int si es un array de integers o de caracteres
        El tamaño es para los strings o los array.
     */
    private TIPO subtipo;
    private int tam;

    public TIPO(String tipo){ // Contructor Tipo Simple
        this.tipo = tipo;
    }

    public TIPO(String tipo, int tam){ // Constructor String
        this.tipo = tipo;
        this.tam = tam;
    }

    public TIPO(String tipo, TIPO subtipo, int tam){ // Constructor Array
        this.tipo = tipo;
        this.subtipo = subtipo;
        this.tam = tam;
    }

    public TIPO(String tipo, TIPO subtipo){ // Constructor Set
        this.tipo = tipo;
        this.subtipo = subtipo;
    }

    public boolean equalsTIPO(TIPO t){
        if(this.tipo.equals(t.tipo)){
            return true;
        }
        return false;
    }

    public boolean equalsSubTipo(TIPO t){
        if(this.subtipo.tipo.equals(t.subTipo().tipo())){
            return true;
        } 
        return false;
    }

    public String tipo(){
        return this.tipo;
    }

    public TIPO subTipo(){
        return this.subtipo;
    }

    public int getTam(){
        return this.tam;
    }

    public String toString(){
        String res;
         /*
              Si hay subtipo, devuelve tipo[subtipo] TAM:tam
              Si es un String, devuelve tipo TAM:tam
              Si no hay subtipo ni es String, tipo
         */
        if(this.subtipo != null){
             res = this.tipo+"["+this.subtipo.tipo+"] TAM: "+this.tam;
        } else if (this.tipo.equals(TIPO.STRING)){
            res = this.tipo+" TAM: "+this.tam;
        } else {
            res = this.tipo;
        }
        return res;
    }

    public void setTam(int inc){
        this.tam += inc;
    }

}
