public class BOOLEANO extends CONDICION{ // Un booleano extiende realmente de CONDICION

    String nombreVar;

    public BOOLEANO(String nomBool) {
        super(0,null,null);
        this.nombreVar =  nomBool;
        this.codigo = nomBool;
    }

    public void ctd(){

         // Se generan las etiquetas Li (verdad) y Lj (falso)
         trueOrFalse = new ETIQCASOS(Generador.nuevaLabel(), Generador.nuevaLabel());

         // Se imprime
         //    if(1 == nomVar) goto Li 
         //    goto Lj

         Generador.printIf("1 == "+ nombreVar, trueOrFalse.v());
         Generador.printGoToLabel(trueOrFalse.f());
    }
    
}
