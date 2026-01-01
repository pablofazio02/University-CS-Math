public class FOR extends AST {

    private EXP asig;
    private EXP update; 
    public String etiqInicio;

    public FOR(AST asignacion, AST condicion, AST actualizacion, AST sentencia) {
        super(condicion,sentencia);
        asig = ((EXP)asignacion);
        update = ((EXP)actualizacion);
    }

    public void ctd(){

        //En primer lugar se imprime la inicialización de la i del bucle
        if(asig!=null){
            asig.ctd();
        }
        

        //Los for siempre tienen una etiqueta para poder volver (bucle)
        etiqInicio = Generador.nuevaLabel();
        //Comienza el dowhile, ponemos su etiqueta
        Generador.printLabel(etiqInicio);

        //Lo primero es la condición para poder entrar en el bucle de la forma
        //   if(condición) goto Li;  
        //   goto Lj;
        if(izq!=null){
            izq.ctd();
        }

        String etiqV = ((CONDICION)izq).getEtiquetas().v();  //Li
        String etiqF = ((CONDICION)izq).getEtiquetas().f();  //Lj


        //Vamos a ver qué ocurre en cada caso

        //----------------------------------

        //Entramos en el caso True
        Generador.printLabel(etiqV);

        //Se actualiza la variable del bucle
        if(update!=null){
            update.ctd();
        }

        //Y se genera una nueva label donde ejeuctar las sentencias de dentro del FOR
        String dentroFor = Generador.nuevaLabel();
        Generador.printGoToLabel(dentroFor);

        //--------------------------------------

        //Ahora ya entramos a ejecutar dichas sentencias
        Generador.printLabel(dentroFor);

        if(der!=null){
            der.ctd();
        }

        //Y se envía al inicio del bucle para comprobar si de nuevo se cumple la condición
        Generador.printGoToLabel(etiqInicio);

        //-----------------------------------------

        //Finalmente, entramos en el caso False
        Generador.printLabel(etiqF);
        //Aquí no se hace nada adicional, se ha salido del bucle y el código continuará fuera del for

    }




    
}
