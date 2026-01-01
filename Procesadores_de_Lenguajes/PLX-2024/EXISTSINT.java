import java.util.ArrayList;

public class EXISTSINT extends CONDICION{ //¡Es una condición!

    private ArrayList<AST> listaExists;

    public EXISTSINT(ArrayList<AST> listaExists, AST taut) {
        super(0, null, taut);
        this.listaExists = listaExists;
        this.t = new TIPO(TIPO.BOOLEAN);
    }

    public void ctd(){
        
        for(AST var : listaExists){ // Para cada entero de la lista exists x from 1 to 10, exists y from 2 to 5...
        
            String nomVar = ((EXP)var).getCodigo();
            String step = ((DECFORALLINT)var).getStep();
            String inicio = ((DECFORALLINT)var).getInicio();
            String fin = ((DECFORALLINT)var).getFin();

            Generador.asignacion(nomVar, inicio);

            String labelInicio = Generador.nuevaLabel();
            Generador.printLabel(labelInicio); 
            String labelTrue = Generador.nuevaLabel();

            Generador.printIf(fin + " < "+ nomVar, labelTrue);

            der.ctd(); 

            ETIQCASOS trueorFalse = ((CONDICION)der).getEtiquetas();
            String etiqV = trueorFalse.v();
            String etiqF = trueorFalse.f();

            Generador.printLabel(etiqF); 
            Generador.operacionAritm(nomVar, nomVar + " + " + step); // si se cumple, modifico la variable con el step dado y se ejecuta todo de nuevo desde comprobación de tamaño
            Generador.printGoToLabel(labelInicio);

            this.trueOrFalse = new ETIQCASOS(etiqV, labelTrue);

        }

    }
    
}
