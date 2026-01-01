public class TERNARIO extends EXP {

    private EXP exprV;
    private EXP exprF;

    public TERNARIO (AST condicion, AST expresion1, AST expresion2){
        super(condicion, null);
        exprV = ((EXP)expresion1);
        exprF = ((EXP)expresion2);
        this.t = new TIPO(TIPO.INT);
    }

    public void ctd(){

        //como izq es la CONDICION, se imprimirán primero if(..) goto Li \n goto Lj
        if(izq!=null){
            izq.ctd();
        }

        String etiqV = ((CONDICION)izq).getEtiquetas().v();  //Li
        String etiqF = ((CONDICION)izq).getEtiquetas().f();  //Lj

        Generador.printLabel(etiqV);

        if(exprV != null){
            exprV.ctd();
        }

        String tmp = Generador.nuevaTemporal();
        Generador.asignacion(tmp, exprV.getCodigo());
        String etiqFinal = Generador.nuevaLabel();
        this.codigo = tmp;  
        Generador.printGoToLabel(etiqFinal);

        Generador.printLabel(etiqF); 
        
        if(exprF != null){
            exprF.ctd();
        }

        Generador.asignacion(tmp, exprF.getCodigo());
        this.codigo = tmp;
        Generador.printLabel(etiqFinal);

        
        
    }
    
}
