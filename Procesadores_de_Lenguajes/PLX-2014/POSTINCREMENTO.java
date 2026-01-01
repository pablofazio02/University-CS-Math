public class POSTINCREMENTO extends EXP{

    private String var;

    public POSTINCREMENTO (String nombre, TIPO t){
        super(null, null);
        var = nombre;
        this.t = t;
    }

    public void ctd(){

        String tmp = Generador.nuevaTemporal();

        Generador.asignacion(tmp, var);

        Generador.asignacion(var, var + " + 1");

        this.codigo = tmp;

    }
    
}
