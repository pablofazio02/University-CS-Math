public class WHILE extends AST{

    //L0 : Etiqueta de comienzo del bucle, para poder volver a evaluar la condición en cada iteración
    public String etiqInicio;   


    /*
            WHILE se compone de una condición para entrar y del cuerpo del bucle(sentencia)
     */
    public WHILE(AST condicion, AST sentencia) {
        super(condicion,sentencia);    
    }

    public void ctd(){

        //Se crea la etiqueta de entrada al cuerpo L0
        etiqInicio = Generador.nuevaLabel();

        //Comienza el WHILE, ponemos su etiqueta L0
        Generador.printLabel(etiqInicio);

        //Se imprime la condición   if(condición) goto Li;  
        //                          goto Lj;
        if(izq!=null){
            izq.ctd();
        }

        //Obtenemos las Li y Lj
        String etiqV = ((CONDICION)izq).getEtiquetas().v();  //Li
        String etiqF = ((CONDICION)izq).getEtiquetas().f();  //Lj


        //Entramos en el caso True, Li
        Generador.printLabel(etiqV);

        //donde imprimen las sentencias del cuerpo del bucle a ejecutar
        if(der!=null){
            der.ctd();
        }

        //así como se añade un goto a L0 para poder volver a evaluar la condición y entrar de nuevo
        Generador.printGoToLabel(etiqInicio);


        //Ahora entramos en el caso False, Lj
        Generador.printLabel(etiqF);

        //Aquí no se hace nada, porque los while no tienen parte "else", sino que continuará el código fuera del while

    }
    

}
