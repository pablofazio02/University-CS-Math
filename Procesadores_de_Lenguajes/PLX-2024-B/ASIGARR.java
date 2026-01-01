import java.util.ArrayList;

public class ASIGARR extends EXP{

    private TIPO tipoElems;

    public ASIGARR(String var, AST lista){
        super(lista,null);
        this.t = TablaSimbolos.getTipoSub(var);
        tipoElems = this.t.subTipo();
        this.codigo = var;
    }

    public void ctd(){
       
        izq.ctd();

        
        ArrayList<AST> listaNums = ((LISTARRAY)izq).getListaNums();  
        int tamArray = this.t.getTam(); 
        if(tamArray<listaNums.size()){
            Generador.error();
        }


        String tmp = Generador.nuevaTemporal();
        int i = 0;

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