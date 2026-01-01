public class FORDOWNTO extends AST {

    private EXP asig;
    private EXP update; 
    private EXP valorFinal;
    private String id;

    public FORDOWNTO(String i, AST asignacion, AST valorfinal, AST actualizacion, AST sentencia) {
        super(null,sentencia);
        asig = new ASIG(TablaSimbolos.varBlock(i), asignacion);
        update = ((EXP)actualizacion);
        valorFinal = ((EXP)valorfinal);
        id = TablaSimbolos.varBlock(i);
    }

    public void ctd(){

        if(asig!=null){
            asig.ctd();
        }

        if(valorFinal!= null){
            valorFinal.ctd();
        }
        
        String etiqInicio = Generador.nuevaLabel();

        Generador.printLabel(etiqInicio);

        String nuevaEtiq = Generador.nuevaLabel();

        ETIQCASOS trueorFalse = new ETIQCASOS(Generador.nuevaLabel(), Generador.nuevaLabel());

        Generador.condicion(Generador.MENOR, id, valorFinal.getCodigo(), trueorFalse);

        Generador.printLabel(nuevaEtiq);

        if(update!= null){
            update.ctd();
        }

        Generador.asignacion(id , id + " - " + update.getCodigo());
        Generador.printGoToLabel(etiqInicio);

        Generador.printLabel(trueorFalse.f());

        if(der != null){
            der.ctd();
        }
    
        Generador.printGoToLabel(nuevaEtiq);

        Generador.printLabel(trueorFalse.v());

    }

}