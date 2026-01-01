public class EXP extends AST {

    /*
          Esta es una clase que representa a una expresión (operaciones)
          Aunque realmente se comporta como una clase abstracta ya que 
          al haber varios tipos de operaciones, cada uno tiene su propia clase (SUMA, RESTA, DIV, PROD...)
     */

    protected String codigo; //Esto servirá para identificar la expresión, por ejemplo, ti en una expresión ti = a+b


    public EXP(AST i, AST d){
        super(i,d);
    }

    public String getCodigo(){
        return this.codigo;
    }

}
