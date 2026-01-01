public class RESTA extends EXP{

    /*
            Para entender el funcionamiento, leer clase SUMA
     */
    
     public RESTA(AST e1, AST e2){
        super(e1,e2);
        this.codigo = Generador.nuevaTemporal(); // ti=a-b
    }

    public void ctd(){

        if(izq != null){
            izq.ctd();
        } 
        if(der != null){
            der.ctd();

            TIPO t1 = ((EXP)izq).getTipo();
            TIPO t2 = ((EXP)der).getTipo();
            String codIzq = ((EXP)izq).getCodigo();
            String codDer = ((EXP)der).getCodigo();

            if(t1.tipo().equals("float") && t2.tipo().equals("float")){
                this.t = new TIPO(TIPO.FLOAT);
                Generador.operacionAritm(this.codigo, codIzq +" -r "+ codDer);
            } else if (t1.tipo().equals("float") && t2.tipo().equals("int")){
                this.t = new TIPO(TIPO.FLOAT);
                String tmp = Generador.nuevaTemporal();
                Generador.asignacion(tmp, "(float) "+ codDer);
                Generador.operacionAritm(this.codigo, codIzq +" -r "+tmp);
            } else if (t1.tipo().equals("int") && t2.tipo().equals("float")){
                this.t = new TIPO(TIPO.FLOAT);
                String tmp = Generador.nuevaTemporal();
                Generador.asignacion(tmp, "(float) "+ codIzq);
                Generador.operacionAritm(this.codigo, tmp +" -r "+ codDer);
            } else if (t1.tipo().equals("int") && t2.tipo().equals("int")){
                this.t = new TIPO(TIPO.INT);
                Generador.operacionAritm(this.codigo, codIzq +" - "+ codDer);
            }else if((t1.tipo().equals("char") && t2.tipo().equals("char")) || (t1.tipo().equals("char") && t2.tipo().equals("int")) || (t1.tipo().equals("int") && t2.tipo().equals("char"))){
                
                // Resta usando el valor ASCII del Char
                this.t = new TIPO(TIPO.INT);
                Generador.operacionAritm(this.codigo, codIzq +" - "+ codDer);

            }
    
        } else { // Caso del MENOSUNARIO
            this.t = ((EXP)izq).getTipo();
            Generador.operacionAritm(this.codigo, " -"+((EXP) izq).getCodigo());
        }
    }
    
}
