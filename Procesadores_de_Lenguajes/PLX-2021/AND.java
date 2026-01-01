public class AND extends CONDICION{

    /*
          Un AND es un tipo de condición, que en lugar de evaluar dos EXP, evalua dos CONDICIONES 
     */
    public AND(int tipoDeCondicion, AST cond1, AST cond2) {
        super(tipoDeCondicion, cond1, cond2);
    }

    public void ctd(){
        
        //Primero se evalúa la 1ª cond
        izq.ctd();
        
        //Se obtienen los Li y Lj de la 1ª condición
        String etiqIzqV = ((CONDICION)izq).getEtiquetas().v();
        String etiqIzqF = ((CONDICION)izq).getEtiquetas().f();

        //En el caso de que se cumpla la 1ª cond, se evaluará la siguiente condición
        Generador.printLabel(etiqIzqV);

        //Se evalúa la 2ª cond
        der.ctd();
        
        //Se obtienen los Li y Lj de la 2ª condición
        String etiqDerV = ((CONDICION)der).getEtiquetas().v();
        String etiqDerF = ((CONDICION)der).getEtiquetas().f();

        //----------------------------------------------------------

        //En el caso False de la 1ª cond, se hace un goto al caso False de la segunda cond
        //Porque autómaticamente si la primera falla, todo falla al ser un AND
        Generador.printLabel(etiqIzqF);
        Generador.printGoToLabel(etiqDerF);

        //Finalmente, el caso True de AND es el caso True de la 2º cond (solo se llega si la 1ª cond es True tmb)
        //Y el caso False de AND es el caso Fales de la 2º cond (si la 1ª es False, se ha hecho un goto a esta)
        this.trueOrFalse = new ETIQCASOS(etiqDerV, etiqDerF); 
        
    }
    
}
