public class CONDICION extends EXP{

    /*
         CONDICIÓN está compuesta por dos expresiones y una relación entre ellas, según 
         si esta relación es verdadera o no, tendrá dos caminos, Li o Lj (etiquetas)
         Por ello, lo que debemos imprimir es de esta forma:


         if(exp condicion exp) goto Li 
         goto Lj

     */


    public int tipoDeCondicion;    //identificamos si es <,>,>=,<=, etc
    public ETIQCASOS trueOrFalse;  //Etiquedas Li y Lj para los casos verdadero o falso (ETIQ en alvarosh)

    public CONDICION(int tipo, AST exp1, AST exp2){

        super(exp1,exp2);

        tipoDeCondicion = tipo;
    }

    public int getCondicion(){
        return tipoDeCondicion;
    }

    public ETIQCASOS getEtiquetas(){
        return trueOrFalse;             //tureOrFalse = (Li, Lj)
    }

    public void ctd(){

        //Se procesa la expresión primera
        if(izq != null){
            izq.ctd();
        }

        //Se procesa la expresión segunda 
        if(der!= null){
            der.ctd();
        }

        //Se generan las etiquetas Li y Lj 
        trueOrFalse = new ETIQCASOS(Generador.nuevaLabel(), Generador.nuevaLabel());

        // Se imprime
        //    if(exp condicion exp) goto Li 
        //    goto Lj
        Generador.condicion(tipoDeCondicion, ((EXP)izq).getCodigo(), ((EXP)der).getCodigo(), trueOrFalse);
    }

}
