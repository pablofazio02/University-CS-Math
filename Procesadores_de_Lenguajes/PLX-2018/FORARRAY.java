public class FORARRAY extends AST {

    private String nomArray;
    private String elem;

    public FORARRAY(String elemento, String array, AST sentencia) {
        super(null,sentencia);
        nomArray = array;
        elem = elemento;
    }

    public void ctd(){

        String tmp = Generador.nuevaTemporal();
        Generador.asignacion(tmp, "0");

        String etiqInicio = Generador.nuevaLabel();
        String etiqFinal = Generador.nuevaLabel();

        Generador.printLabel(etiqInicio);

        Generador.printIf(nomArray+"_length == " + tmp, etiqFinal);

        Generador.asignacion(elem, nomArray + "[" + tmp + "]");

        Generador.asignacion(tmp, tmp + "+ 1");

        if(der!=null){
            der.ctd();
        }

        Generador.printGoToLabel(etiqInicio);
  
        Generador.printLabel(etiqFinal);

    }
    
}
