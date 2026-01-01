
public class DECFORALLINT extends EXP{ // Creamos una clase que guarde todos los datos de una sentencia Forall int / Exists int

    private String step;
    private String inicio;
    private String fin;

    // Guardamos el entero de inicio, el entero de fin, el paso de actualización y el nombre de la variable

    public DECFORALLINT(String variable, String numero1, String numero2, String step) {
        super(null, null);
        this.inicio = numero1;
        this.fin = numero2;
        this.codigo = variable;
        this.step = step;
    }

    public String getStep(){
        return step;
    }

    public String getInicio(){
        return inicio;
    }
    
    public String getFin(){
        return fin;
    }
}
