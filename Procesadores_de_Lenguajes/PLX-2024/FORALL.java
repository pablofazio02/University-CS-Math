import java.util.ArrayList;

public class FORALL extends CONDICION{ // ¡Es una condición!

    private ArrayList<AST> listaForall; 

    public FORALL(ArrayList<AST> listaForall, AST taut) {
        super(0, null, taut);
        this.listaForall = listaForall;
        this.t = new TIPO(TIPO.BOOLEAN);
    }

    public void ctd(){
        
        for(AST var : listaForall){ // Para cada variable en la lista de forall p, forall q...
        
            String nomVar = ((EXP)var).getCodigo();

            Generador.asignacion(nomVar, "0");

            String labelInicio = Generador.nuevaLabel();
            Generador.printLabel(labelInicio); 
            String labelTrue = Generador.nuevaLabel();

            der.ctd(); // Ejecutamos la expresión que queremos ver si es tautología 

            ETIQCASOS trueorFalse = ((CONDICION)der).getEtiquetas();
            String etiqV = trueorFalse.v();
            String etiqF = trueorFalse.f();

            Generador.printLabel(etiqV);

            this.trueOrFalse = new ETIQCASOS(labelTrue, etiqF); // se genera el par de etiquetas labelTrue (creada aquí cuando cumple que es taut) y etiqF (falsa)

            Generador.printIf("1 == "+ nomVar, labelTrue);
            Generador.asignacion(nomVar, "1");
            Generador.printGoToLabel(labelInicio); // Si no se cumple para var = 0, veamos si lo hace para var = 1
        }

    }
    
}
