public class IFELSE extends AST{

    /*  (LEER CLASE IF)
        IFELSE  funciona igual que el IF, solo que el caso False no se deja vacío,
        sino que hay una sentencia a imprimir. Por ello el hijo izdo va a ser un 
        IF completo, y el derecho la sentencia del caso False.

        Cuando en .cup creamos un IF, en realidad estamos creando un IFELSE con el hijo derecho vacío
     */
   

    public IFELSE (AST parteIF, AST sentenciasElse){

        super(parteIF,sentenciasElse);
        //parteIF es objeto de la clase IF
    }



    public void ctd(){

        //En primer lugar se ejecuta todo lo relacionado con el IF y las condiciones
        //Se queda hasta imprimir la etiqueta Lj: (que la deja vacía porque era un IF)        
        izq.ctd();


        //Ahora entran en juego las nuevas sentencias del ELSE, que solo se imprimen si no son nulas (caso IF simple)
        if(der!=null){
            der.ctd();
        }

        
        //Finalmente, imprimimos la etiqueta que da lugar a la continuación del código
        Generador.printLabel(((IF)izq).getEtiqFinal()); 
        //Antes de estar implementado el IFELSE, esta última línea se ejecutaba en el IF, pero como ahora 
        //cabía la posibilidad de añadir sentencias tras el Lj, se hace aquí tras ellas
    }
    
}
