public class PRINT extends AST{


     /*
           Como solo se trata de imprimir una expresión,
           el hijo derecho queda null
     */
    public PRINT(AST expr) {     
        super(expr, null);
    }


    public void ctd(){

        //Se procesa la expresión EXP a imprimir
        if(izq != null){
            izq.ctd();
        }

        //no hacemos nada en el derecho porque PRINT(exp,null) 

        
        Generador.print(((EXP)izq).getCodigo());

    }
    
}
