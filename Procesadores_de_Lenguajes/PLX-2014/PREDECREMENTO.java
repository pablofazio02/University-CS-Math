public class PREDECREMENTO extends EXP{

    public PREDECREMENTO (String nombre, TIPO t){
        super(null, null);
        this.codigo = nombre;
        this.t = t;
    }

    public void ctd(){
        Generador.asignacion(this.codigo, this.codigo + " - 1");
    }
    
}
