public class BOOL extends EXP {

    private int trueorFalse;

    public BOOL(int tof) {
        super(null,null);
        this.trueorFalse = tof; // indica si es true (valor 1) o false (valor 0)
        this.t = new TIPO(TIPO.BOOLEAN); // BOOL es un subtipo booleano
        this.codigo = String.valueOf(trueorFalse);
    }

    public int getTrueorFalse(){
        return trueorFalse;
    }
    
}