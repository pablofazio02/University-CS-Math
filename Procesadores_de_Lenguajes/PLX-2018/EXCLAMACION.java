public class EXCLAMACION extends EXP{   

    private String nomCaracter;

    public EXCLAMACION(AST caracter){
        super(caracter, null);
        this.t = new TIPO(TIPO.CHAR);
    }

    public void ctd(){

        if(izq!=null){
            izq.ctd();
        }

        nomCaracter = ((EXP)izq).codigo;

        String etiqInicio = Generador.nuevaLabel();
        String tmp = Generador.nuevaTemporal();

        Generador.asignacion(tmp, nomCaracter);

        Generador.printIf(nomCaracter + " < 97", etiqInicio);
        Generador.printIf("122 < " + nomCaracter, etiqInicio);
        Generador.asignacion(tmp, nomCaracter + " - 32");

        Generador.printLabel(etiqInicio);

        this.codigo = tmp;

    }


}
