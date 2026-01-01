public class VECTOR extends EXP{
    
    public VECTOR(String i, TIPO t){
        super(null,null);
        this.codigo = i;
        this.t = t;
    }

    public void ctd(){
        Generador.asignacion(this.codigo+"_length", String.valueOf(t.getTam()));
    }

}
