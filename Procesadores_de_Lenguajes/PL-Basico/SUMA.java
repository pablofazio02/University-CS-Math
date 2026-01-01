public class SUMA extends EXP{

    /*
            En la suma, intervienen dos expresiones (e1 y e2) a procesar
            que serán los hijos izdo y derecho
     */
    public SUMA(AST e1, AST e2) {
        
        super(e1,e2);

        this.codigo = Generador.nuevaTemporal();  
        //el "código" o identificador de una suma será un ti 
        //pues cuando sumamos dos números, se genera una temporal
        // ti = a+b


    }

    public void ctd(){

        // se procesan ambas expresiones participantes en la suma
        if(izq!=null){
            izq.ctd();
        }        

        if(der!=null){
            der.ctd();
        }

        //Una vez procesados, ya puede imprimirse ti = t1 + t2
        //donde t1 es la temporal asignada a la expresión 1 (igual con t2)
        //(aunque tmb puede tratarse de CONSTANTE enteras, porque estas tmb son tipo EXP)
        Generador.operacionAritm(this.codigo, ((EXP)izq).getCodigo() + " + " + ((EXP)der).getCodigo());
    }
    
}
