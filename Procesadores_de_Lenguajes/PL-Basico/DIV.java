public class DIV extends EXP{

    /*
            Para entender el funcionamiento, leer clase SUMA
     */

    public DIV(AST e1, AST e2) {
        
        super(e1,e2);

        this.codigo = Generador.nuevaTemporal();  //el "código" o identificador de una DIVISION será un ti pues cuando sumamos dos números, se genera una temporal ti = a/b

    }

    public void ctd(){

        if(izq!=null){
            izq.ctd();
        }        

        if(der!=null){
            der.ctd();
        }

        Generador.operacionAritm(this.codigo, ((EXP)izq).getCodigo() + " / " + ((EXP)der).getCodigo());   //ti = a/b
    }
    
}
