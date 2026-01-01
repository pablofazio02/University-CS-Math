import java.util.ArrayList;

public class FORALLINT extends CONDICION{ //¡Es una condición!

    private ArrayList<AST> listaForall;

    public FORALLINT(ArrayList<AST> listaForall, AST taut) {
        super(0, null, taut);
        this.listaForall = listaForall;
        this.t = new TIPO(TIPO.BOOLEAN);
    }

    public void ctd(){
        
        for(AST var : listaForall){ // Para cada entero de la lista forall x from 1 to 10, forall y from 2 to 5...
        
            String nomVar = ((EXP)var).getCodigo();
            String step = ((DECFORALLINT)var).getStep();
            String inicio = ((DECFORALLINT)var).getInicio();
            String fin = ((DECFORALLINT)var).getFin();

            Generador.asignacion(nomVar, inicio);

            String labelInicio = Generador.nuevaLabel();
            Generador.printLabel(labelInicio); 
            String labelTrue = Generador.nuevaLabel();

            Generador.printIf(fin + " < "+ nomVar, labelTrue); // Comprobación de tamaño, si esto se cumple he acabado con éxito y la condición es verdadera

            der.ctd(); // Ejecuto la expresion que queremos ver que es tautologia para el valor actual

            ETIQCASOS trueorFalse = ((CONDICION)der).getEtiquetas();
            String etiqV = trueorFalse.v();
            String etiqF = trueorFalse.f();

            Generador.printLabel(etiqV); 
            Generador.operacionAritm(nomVar, nomVar + " + " + step); // si se cumple, modifico la variable con el step dado y se ejecuta todo de nuevo desde comprobación de tamaño
            Generador.printGoToLabel(labelInicio);

            this.trueOrFalse = new ETIQCASOS(labelTrue, etiqF);

        }

    }
    
}
