public class EJECUTARFUNC extends AST{

    public String nomFuncion;

    public EJECUTARFUNC (String nombreFuncion, AST expresion){    
        super(expresion,null);
        nomFuncion = nombreFuncion;
    }

    public void ctd(){

        if(izq!=null){
            izq.ctd();
        }

        Generador.call(nomFuncion);

    }
    
}