public class ELVIS extends EXP {

    public ELVIS (AST expresion1, AST expresion2){
        super(expresion1, expresion2);
        this.t = new TIPO(TIPO.INT);
    }

    public void ctd(){

        if(izq!=null){
            izq.ctd();
        }

        String etiq0 = Generador.nuevaLabel();
        String tmp = Generador.nuevaTemporal();
        Generador.asignacion(tmp, ((EXP)izq).getCodigo());

        Generador.printIf(((EXP)izq).getCodigo() + " != 0", etiq0);
        if(der!=null){
            der.ctd();
        }
        Generador.asignacion(tmp, ((EXP)der).getCodigo());

        Generador.printLabel(etiq0);   
        this.codigo = tmp;   
        
    }
    
}
