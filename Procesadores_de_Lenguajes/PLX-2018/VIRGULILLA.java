public class VIRGULILLA extends EXP{   

    private String nomCaracter;

    public VIRGULILLA(AST caracter){
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
        String label1 = Generador.nuevaLabel();

        Generador.asignacion(tmp, nomCaracter);

        Generador.printIf(nomCaracter + " < 65", etiqInicio);
        Generador.printIf("122 < " + nomCaracter, etiqInicio);
        Generador.printIf("96 < " + nomCaracter, label1);
        Generador.printIf("90 < " + nomCaracter, etiqInicio);

        Generador.asignacion(tmp, nomCaracter + " + 32");
        Generador.printGoToLabel(etiqInicio);
        Generador.printLabel(label1);
        Generador.asignacion(tmp, nomCaracter + " - 32");
        Generador.printLabel(etiqInicio);

        this.codigo = tmp;

    }


}
