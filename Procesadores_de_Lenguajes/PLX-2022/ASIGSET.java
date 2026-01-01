import java.util.ArrayList;

public class ASIGSET extends EXP{

    /*
        A esta clase llama únicamente cuando tenemos x un array y 
        hacemos x = {a,b,c...}
        Se utilizar para asignar a x[i] cada elemento de la lista (ya construida) en VECTORAUXILIAR 
        y comprobar que los tipos están bien

     */

    private TIPO tipoElems;

    public ASIGSET(String var, AST lista){
        super(lista,null);
        this.t = TablaSimbolos.getTipoSub(var);
        tipoElems = this.t.subTipo(); // El tipo del que son cada elemento es el subtipo del set
        this.codigo = var;
    }

    public void ctd(){
       
        izq.ctd(); // se imprime vector auxiliar

        // Sacamos el tamaño del array y comprobamos que coincide con la lista dada
        ArrayList<AST> listaNums = ((LISTARRAY)izq).getListaNums();  

        String tmp = Generador.nuevaTemporal();
        int i = 0;

        /*
             Para ir metiendo los elementos del vector t0 en el vector x, 
             se utilizar una auxiliar (t1) a la que se hará t1 = t0[i]
             y luego x[i] = t1
         */

        for(AST e : listaNums){

            if(!((EXP)e).getTipo().tipo().equals(tipoElems.tipo())){
                Generador.error();
            }

                Generador.asignacion(tmp, ((LISTARRAY)izq).getCodigo()+"["+i+"]");
                Generador.asignacion(this.codigo+"["+i+"]", tmp);
                i++;
        }
    

    }

}