public class CONSTANTE extends EXP{   

    /*
            Se crea un nodo que no tiene hijos (hoja), que contiene cierto valor e indicamos su tipo
     */

    public CONSTANTE(String valor, TIPO t){
        super(null, null);
        codigo = valor;
        this.t = t;
    }

    public CONSTANTE(String valor){    //este constructor se una en las declaraciones
        super(null, null);
        codigo = valor;  
    }

    public TIPO getTipo(){
        return this.t;
    }

}
