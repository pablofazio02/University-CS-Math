public class AST {

    /*
            Esta es la clase principal que instancia cada nodo del árbol
            Funciona como clase abstracta porque el resto de .java heredan de ella 
     */
    

    protected AST izq;
    protected AST der;

    public AST(AST i, AST d){
        izq = i;
        der = d;
    }

    public AST getIzq(){
        return izq;
    }

    public AST getDer(){
        return der;
    }

    /*
            Procesa el cambio a ctd (dentro se llamarán a las clases de Generador.java)
     */
    public void ctd(){
        if(izq != null){
            izq.ctd();
        }
        if(der != null){
            der.ctd();
        }
    }

}
