
import java.util.ArrayList;
import java.util.HashMap;

public class TablaSimbolos {
    
    //Hay una lista de variables por cada profundidad de bloque
    private static ArrayList<HashMap<String,TIPO>> TablaSimbolos;
    private static int indiceBloque;

    static { //esto siempre se ejecuta al comienzo;
        TablaSimbolos = new ArrayList<HashMap<String,TIPO>>();
        TablaSimbolos.add(new HashMap<>());
        indiceBloque = 0;
    }

    /*  Si la variable no se ha declarado aún (en este bloque o en previos), 
        se inserta en el bloque actual.
        Si ya ha sido declarada, se imprime el mensaje de error.
    */
    public static void insertar(String var, TIPO tipo){
        
        if(findInCurrentBlock(var)){
            Generador.error();
        } else {
           
            TablaSimbolos.get(indiceBloque).put(var, tipo);
        }

       //showTable();

    }

    /*
        var = x
        Mira si en este o los bloques exteriores, la variable ha sido declarada
     */
    public static boolean check(String var){
        boolean declarada = false;
        int bloq = indiceBloque;
        while(!declarada && bloq>=0){
            if(TablaSimbolos.get(bloq).containsKey(var+"_"+bloq)) declarada=true;
            bloq--;
        }
        return declarada;
    }

    /*
        var = x_i
         Mira si en este o los bloques exteriores, la variable ha sido declarada
        Útil porque solo una variable puede ser declarada con este nombre
     */
    public static boolean checkSub(String var){
        boolean declarada = false;
        int bloq = indiceBloque;
        while(!declarada && bloq>=0){
            if(TablaSimbolos.get(bloq).containsKey(var)) declarada=true;
            bloq--;
        }
        return declarada;
    }

    /*
        Suponiendo que la variable está declarada, devuelve su tipo
     */
    public static TIPO getTipo(String var){
        int bloque = inWhichBloque(var);
        return TablaSimbolos.get(bloque).get(var+"_"+bloque);
    }

    /*
        Igual pero en el caso de tener un identificador var_i
     */
    
    public static TIPO getTipoSub(String var){
        int bloque = inWhichBloqueSub(var);
        return TablaSimbolos.get(bloque).get(var);
    }

    /*
        Suponiendo que la variable está declarada, devuelve el bloque en el que está
     */

    public static int inWhichBloque(String var){
        boolean declarada = false;
        int bloq = indiceBloque;
        while(!declarada && bloq>=0){
            if(TablaSimbolos.get(bloq).containsKey(var+"_"+bloq)) declarada=true;
            if(!declarada) bloq--;
        }
        return bloq;
    }

    /*
           Igual pero en el caso de tener un identificador var_i
     */
    public static int inWhichBloqueSub(String var){
        boolean declarada = false;
        int bloq = indiceBloque;
        while(!declarada && bloq>=0){
            if(TablaSimbolos.get(bloq).containsKey(var)) declarada=true;
            if(!declarada) bloq--;
        }
        return bloq;
    }

    /*
        Cuando se abren llaves (nuevo bloque), creamos una nueva lista de variables 
        asociadas a esta profundidad
     */
    public static void nuevoBloque(){
        indiceBloque++;
        TablaSimbolos.add(indiceBloque,new HashMap<>());
    }

    /*
        Cuando salimos de un bloque, borramos la lista asociada a esa profundidad
        porque al salir, podremos declarar más variables con los mismos nombres 
     */
    public static void finBloque(){
        TablaSimbolos.remove(indiceBloque);
        indiceBloque--;
    }

    public static int getIndice(){
        return indiceBloque;
    }

    public static String varBlock(String var){
        return var +"_"+indiceBloque;
    }

    public static boolean findInCurrentBlock(String var){
        return TablaSimbolos.get(indiceBloque).containsKey(var);
    }

    public static void actualizarTam(String var, TIPO t){
        
        int b = Integer.parseInt(var.split("_")[1]);
        TablaSimbolos.get(b).replace(var, t);
        
    }

    public static void showTable(){
        for(int i = 0; i < TablaSimbolos.size(); i++){
            System.out.println("Bloque "+i+": "+TablaSimbolos.get(i).toString());
        }
    }

}
