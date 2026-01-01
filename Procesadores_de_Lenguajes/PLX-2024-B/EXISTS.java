import java.util.ArrayList;

public class EXISTS extends CONDICION{ // ¡Es una condición!

    private ArrayList<AST> listaExists; 

    public EXISTS(ArrayList<AST> listaExists, AST verdad) {
        super(0, null, verdad);
        this.listaExists = listaExists;
        this.t = new TIPO(TIPO.BOOLEAN);
    }

    public void ctd(){
        
        for(AST var : listaExists){ // Para cada variable en la lista de exists p, exists q...
        
            String nomVar = ((EXP)var).getCodigo();

            Generador.asignacion(nomVar, "0");

            String labelInicio = Generador.nuevaLabel();
            Generador.printLabel(labelInicio); 
            String labelTrue = Generador.nuevaLabel();

            der.ctd(); 

            ETIQCASOS trueorFalse = ((CONDICION)der).getEtiquetas();
            String etiqV = trueorFalse.v();
            String etiqF = trueorFalse.f();

            Generador.printLabel(etiqF);

            Generador.printIf("1 == "+ nomVar, labelTrue);
            Generador.asignacion(nomVar, "1");
            Generador.printGoToLabel(labelInicio); // Si no se cumple para var = 0, veamos si lo hace para var = 1

            this.trueOrFalse = new ETIQCASOS(etiqV, labelTrue);
        }

    }
    
}
