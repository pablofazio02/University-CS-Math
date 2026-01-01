public class CASTING extends EXP{

    public CASTING(TIPO t, AST i){
        super(i,null);
        this.t = t;
    }

    public void ctd(){

        if(izq!=null){

        izq.ctd();

        TIPO tIzq = ((EXP)izq).getTipo();
        
        String codIzq = ((EXP)izq).getCodigo();

        if(!t.tipo().equals(tIzq.tipo())){ // Si el tipo es el mismo, no se hace nada

            if(t.tipo().equals(TIPO.CHAR)){ //si estamos convirtiendo un int a char no hay que hacer casting
               this.codigo = codIzq;
            } else {
                if(tIzq.tipo().equals(TIPO.CHAR)){ //si estamos convirtiendo un char a int/float, no tenemos que hacer casting porque se almacena su ASCII
                    this.codigo = codIzq;
                }else{ // En otro caso, se hace el casting necesario
                    String tmp = Generador.nuevaTemporal();
                    this.codigo = tmp;
                    Generador.casting(this.codigo, this.t.tipo(), codIzq); 
                }
            }
        } else{
            this.codigo = codIzq;
        }   

        }
        
    }

}
