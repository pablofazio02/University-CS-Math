public class VECTORELEM extends EXP{

    private String indice;
    private String nomArray;
    private int tam;
    private TIPO tipoVar;
    
    public VECTORELEM(String nombreArray, TIPO t, AST i, AST d){
        super(i, d);
        this.tam = t.getTam();
        this.tipoVar = t;
        this.t = t.subTipo();
        this.nomArray = nombreArray;
    }

    public void ctd(){

        if(der == null){
            this.codigo = Generador.nuevaTemporal(); // t0
        }

        izq.ctd();
        this.indice = ((EXP)izq).getCodigo(); // lo que hay dentro de []
        
        if(der!=null){ // Asignacion de la forma x[i] = expr
           
            der.ctd(); // Procesamos la expr
            this.codigo = nomArray + "["+indice+"]";

            String codAsig = ((EXP)der).getCodigo();
            TIPO tipoAsig = ((EXP)der).getTipo();

            /*
                Como estamos en una asignación, tenemos que ver que el tipo de la asignación 
                es del mismo tipo que los elementos del array,
                O a lo sumo, que el array sea float y le metamos un int,
                en cual caso haremos casting antes
            */

            if(tipoAsig.tipo().equals(TIPO.INT) && t.tipo().equals(TIPO.FLOAT)){
                String tmp = Generador.nuevaTemporal();
                Generador.asignacion(tmp, "(float) " + codAsig);
                codAsig = tmp;

            } else if (!tipoAsig.tipo().equals(t.tipo())){
                Generador.error();
            }

            String l1 = Generador.nuevaLabel();
            String l2 = Generador.nuevaLabel();
            Generador.condVector(indice, tam, l1, l2);

            Generador.printLabel(l1);
            Generador.printError();

            Generador.printLabel(l2);
            Generador.asignacion(codigo, codAsig); // Imprime x[i] = expr

        } else { // LLamada al elemento x[i]      
            String l1 = Generador.nuevaLabel();
            String l2 = Generador.nuevaLabel();
            Generador.condVector(indice, tam, l1, l2);

            Generador.printLabel(l1);
            Generador.printError();

            Generador.printLabel(l2);
            Generador.asignacion(codigo, nomArray + "["+indice+"]"); // imprime t0 = x[i]
        }
            
    }
}


