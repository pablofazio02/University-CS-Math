public class VOID extends AST{

    public String nomFuncion;

    public VOID (String nombreFuncion, AST declaracion, AST sentencia){    
        super(declaracion,sentencia);
        nomFuncion = nombreFuncion;
    }

    public void ctd(){

        if(izq!=null){
            izq.ctd();
        }

        Generador.funcion(nomFuncion);

        if(der!=null){
            der.ctd();
        }

        Generador.end(nomFuncion);

    }
    
}
