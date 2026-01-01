public class DEC extends EXP{

      /*
            Una declaración es de la forma: tipo x,y=1,z ...
            Tiene al menos una variable declarada (i.e. una expresión, que puede ser cte (x) o una asignación (y=1))
            Por tanto en el siguiente constructor, la parte declaración puede ser nula cuando solo es: tipo x 
     */
    
    public DEC(AST declaracion, AST var) {
        super(declaracion,var);
        this.t = ((EXP)var).getTipo();
    }


    public void ctd(){
        
        if(izq!=null){
            izq.ctd();
        }

        if(der!=null){
            der.ctd();
        }
    }
        
}