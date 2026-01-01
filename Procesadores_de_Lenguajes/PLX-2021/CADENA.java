public class CADENA extends EXP{
    
    String st;

    public CADENA(String st){
        super(null,null);
        this.codigo = Generador.nuevaTemporal(); // t0 vector aux
        this.t = new TIPO(TIPO.STRING, st.length());
        this.st = st;
    }

    public String getString(){
        return st;
    }

    public void ctd(){

        for(int i=0; i<st.length(); i++){
            Generador.asignacion(this.codigo+"["+i+"]", String.valueOf((int)st.charAt(i))); //t0[i] = String.valueof(char(i))
        }
        Generador.printLength(this.codigo, st.length());
    }
}
