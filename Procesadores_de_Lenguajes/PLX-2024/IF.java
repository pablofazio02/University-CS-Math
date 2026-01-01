public class IF extends AST{

    public String etiqFinal;

    /*
        (LEER CLASE CONDICIÓN)
        Una vez ya tenemos las etiquetas Li y Lj correspondientes a los casos verdadero y falso 
        de la evaluación de una condición, la clase IF imprimirá el código correspondiente al 
        caso verdadero (el caso falso queda vacío porque no es un IFELSE)

     */


    public IF (AST condicion, AST sentencia){    //sentencia es lo que se ejecuta en el caso True
        super(condicion,sentencia);
    }

    public String getEtiqFinal(){
        return etiqFinal;
    }


    public void ctd(){

        //como izq es la CONDICION, se imprimirán primero if(..) goto Li \n goto Lj
        if(izq!=null){
            izq.ctd();
        }

        String etiqV, etiqF;

        if( izq instanceof CONDICION){
             etiqV = ((CONDICION)izq).getEtiquetas().v();  //Li
             etiqF = ((CONDICION)izq).getEtiquetas().f();  //Lj
        }else{
            ETIQCASOS trueOrFalse = new ETIQCASOS(Generador.nuevaLabel(), Generador.nuevaLabel());
            Generador.printIf("0 < "+((ASIG)izq).getNomVar(),trueOrFalse.v());
            Generador.printGoToLabel(trueOrFalse.f());
            etiqV = trueOrFalse.v();
            etiqF = trueOrFalse.f();
        }


        //Ahora, antes de imprimir la sentencias, imprimimos la etiqueta del caso True  ("Li: ")
        Generador.printLabel(etiqV);


                // esto es solo porque al final del caso True, necesitamos un goto a una etiqueta 
                // que marque cómo sigue el programa dps del IF (NO SE IPRIME AÚN)
                etiqFinal = Generador.nuevaLabel();  


        //como der es la sentencia a ejecutar, se imprime ahora, dentro de la etiqueta Li  (al ser tipo EXP, ya se imprime en su propio ctd() automáticamente)
        if(der!=null){
            der.ctd();
        }

        //Una vez impresa la sentencia, se imprime el goto a la continuación del programa
        Generador.printGoToLabel(etiqFinal);

        //se imprime la etiqueta del caso False ("Lj: ")
        Generador.printLabel(etiqF); 
        //Como no es un IFELSE, no se ponen sentencias a ejecutar detrás de esta etiqueta, es solo Lj: 

    
        //Finalmente, imprimimos la etiqueta que da lugar a la continuación del código
        //Generador.printLabel(etiqFinal);
        //esto lo comentamos porque ahora se hace al final del IFELSE, que no es más que un IF, al que a continuación de etiqueta Lj, se le añaden sentencias
    }
    
}
