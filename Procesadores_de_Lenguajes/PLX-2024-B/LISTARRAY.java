import java.util.*;

public class LISTARRAY extends EXP{

    /*
            Esta clase se encarga de, habiendo recibido una lista de nums(o expresiones), 
            imprimir un vector auxiliar t0[i] = exp_i
            Se llama cuando vamos a hacer x = {exp1,exp2,...},
            ya que en ASIGVECTOR posteriormente se hará x[i] = t0[i]
     */
    
    private ArrayList<AST> lista;
    private int tam;

    public LISTARRAY(ArrayList<AST> l){ // Constructor para arrays
        super(null,null);
        this.lista = l;
        this.tam = l.size();
        TIPO t1 = ((EXP)l.get(0)).getTipo(); // Tipo del primer elemento de la lista
        this.t = new TIPO(TIPO.ARRAY,t1,tam);

        this.codigo = Generador.nuevaTemporal();
    }

    public int getTam(){
        return this.tam;
    }
    
    public ArrayList<AST> getListaNums() {
        return lista;
    }

    public void ctd(){

        TablaSimbolos.insertar(this.codigo, t);

        if(lista.size() < 0){
            Generador.error();
        } else {
            this.codigo = Generador.nuevaTemporal();
            for(int i = 0; i<lista.size(); i++){
                AST e = lista.get(i);
                e.ctd();
                //t0[i] = exp_i
                Generador.asignacion(this.codigo+"["+i+"]", ((EXP)e).getCodigo());
                //se imprime t[i] = numero i de la lista
            }
        }
    }

}
