public class BLOQUE extends AST{

    /*
            Esta clase se usa cuando en el .plc aparecen bloques de código
            entre llaves { }
     */


    /*
           Como solo se trata de una serie de sentencias,
           el hijo derecho queda null
     */
    public BLOQUE(AST listaSentencias){
        super(listaSentencias,null);
    }
    

    /*
         Como solo existe el hijo izdo, solo se procesa ese
         Además, no es necesario añadir nada más pues las sentencias son 
         EXP que tienen su propio ctd() ya definido, así que solo tenemos que llamarlo
     */
    public void ctd(){
        
        izq.ctd();
        
    }
    
}
