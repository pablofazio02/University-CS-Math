public class DOWHILE extends AST{

    //L0 : Etiqueta de comienzo del bucle, para volver a ejecutar el cuerpo tras haber evaluado la condición a True
    public String etiqInicio;

     /*
            WHILE se compone de una sentencia (que la 1ª vez siempre se ejecuta) que compone el cuerpo del bucle
            y de una condición que se evalúa para poder volver a entrar
     */
    public DOWHILE(AST sentencia, AST condicion) {
        super(sentencia,condicion);    
    }

    public void ctd(){

        //Se crea la etiqueta de entrada al cuerpo L0
        etiqInicio = Generador.nuevaLabel();

        //Comienza el DOWHILE, ponemos su etiqueta L0
        Generador.printLabel(etiqInicio);

        //En un DOWHILE siempre se ejecutan las sentencias antes de probar la condición:
        if(izq!=null){
            izq.ctd();  
        }

        //Ahora es cuando entra en juego la condición, para ver si se entra de nuevo al bucle o se abandona
        //Se imprime la condición   if(condición) goto Li;  
        //                          goto Lj;
        if(der!=null){
            der.ctd();  
        }

        //Todo lo anterior era el cuerpo del DOWHILE, ahora vamos a ver qué se hace en cada caso, V o F 
        
        //Primero almacenamos las etiquetas de ambos casos
        String etiqV = ((CONDICION)der).getEtiquetas().v();  //Li
        String etiqF = ((CONDICION)der).getEtiquetas().f();  //Lj


        //Entramos en el caso True,
        Generador.printLabel(etiqV);
        //Ahí lo que se hace es volver a entrar en el while
        Generador.printGoToLabel(etiqInicio);


        //Ahora entramos en el caso False
        Generador.printLabel(etiqF);
        //Aquí no se hace nada, porque los while no tienen parte "else", sino que continuará el código fuera del while

    }
    




}
