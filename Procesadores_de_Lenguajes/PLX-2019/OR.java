public class OR extends CONDICION{

    /*
          Un or es un tipo de condición, que en lugar de evaluar dos EXP, evalua dos CONDICIONES 
     */
    public OR(int tipoDeCondicion, AST cond1, AST cond2) {
        super(tipoDeCondicion, cond1, cond2);
    }

    public void ctd(){

        //Primero se evalúa la 1ª cond        
        izq.ctd();
        
        //Se obtienen los Li y Lj de la 1ª condición        
        String etiqIzqV = ((CONDICION)izq).getEtiquetas().v();
        String etiqIzqF = ((CONDICION)izq).getEtiquetas().f();

        //En el caso False de la 1ª cond, se evaluará la 2ª para ver si es verdadera esa 
        //Es un OR, así que la segunda se evalúa aunque falle la primera
        Generador.printLabel(etiqIzqF);

        //Se evalúa la 2ª cond
        der.ctd();

        //Se obtienen los Li y Lj de la 2ª condición
        String etiqDerV = ((CONDICION)der).getEtiquetas().v();
        String etiqDerF = ((CONDICION)der).getEtiquetas().f();

        //En el caso True de la 1ª cond, se envía al caso True de la 2ª
        //Porque autómaticamente si la primera es True, todo es True al ser un OR
        Generador.printLabel(etiqIzqV);
        Generador.printGoToLabel(etiqDerV);

        //Finalmente, el caso True de OR es el caso True de la 2ª cond (si la 1ª es True, se hace un goto a esta) 
        //Y el caso False de OR es el caso False de la 2ª cond, porque solo se llega ahí si la 1ª es False tmb)
        setEtiq(new ETIQCASOS(etiqDerV, etiqDerF)); 
        
    }
    
}
