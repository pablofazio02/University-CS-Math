public class ASIG extends EXP{

    /*
            Las asignaciones son de la forma IDENT = expresion
            Luego el código (VER CLASE EXP) será el IDENT
            y solo habrá un hijo que es la expresión que se le asigna
     */
    public ASIG(String ident, AST e) {
        
        super(null,e);   

        this.codigo = ident;  //el "código" o identificador de una asignación será el nombre de la variable (Ej: a en a=5)

    }

    public String getCodigo(){
        return this.codigo;
    }


    public void ctd(){
 

        if(der!=null){

            der.ctd();   //se procesa la expresión a asignar

            //Una vez procesada, puede imprimirse IDENT = expresion
            Generador.operacionAritm(this.codigo, ((EXP)der).getCodigo());

        }

    }
    
}
