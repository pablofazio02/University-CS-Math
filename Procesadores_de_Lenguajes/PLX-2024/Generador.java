public class Generador {

    /*
        Clase que contiene los métodos necesarios para hacer 
        los println que componen el .ctd
        Estos métodos serán llamados desde el método ctd() de las clases que heredan de AST.java
    */
    
    public static int temporal = 0;
    public static int label = 0;

    public final static int IGUALDAD = 1;
     public final static int NOTIGUALDAD = 2;
    public final static int MAYOR = 3;
    public final static int MAYOROIGUAL = 4;   
    public final static int MENOR = 5;
    public final static int MENOROIGUAL = 6;
    public final static int AND = 7;
    public final static int OR = 8;
    public final static int NOT = 9;


    /*
     * Devuelve t0,t1,t2...
     */
    public static String nuevaTemporal(){
        String t = "t"+temporal;
        temporal++;
        return t;
    }

    /*
     * Devuelve L0,L1,L2...
     */
    public static String nuevaLabel(){
        String L = "L"+label;
        label++;
        return L;
    }    

    /*
     *  Es un print normal print(expresion)
     */
    public static void print(String expr){
        System.out.println("\tprint " + expr +";");
    }

    /*
     *  Es un printc para caracteres
     */

    public static void printc(String exp){
        System.out.println("\tprintc " + exp + ";");
    }

    /*
        Imprime writec String
     */
    public static void writec(String exp){
        System.out.println("\twritec " + exp + ";");
    }

    /*
           Imprime Li:
     */
    public static void printLabel(String label){
        System.out.println(label + ":");
    }

    /*
            Imprime goto Li;
     */
    public static void printGoToLabel(String label){
        System.out.println("\tgoto "+ label + ";");
    }


    /*
            Imprime una asignación (ti = expresion;) tras haber operado 
     */
    public static void operacionAritm (String result, String expresion) {
        System.out.println("\t" + result + " = " + expresion + ";");
    }


    /*
            Imprime una asignación (ti = expresion;) tras haber declarado una variable
     */
    public static void asignacion (String ident, String expresion){
        System.out.println("\t" +  ident + " = " + expresion + ";");
    }

    /* 
            Imprime un casting realizado sobre una variable 
    */

    public static void casting(String x, String t, String y){
        System.out.println("\t"+x+" = ("+t+") "+y+";");
        
    }

    /* 
            Imprime la longitud de la cadena
     */

    public static void printLength(String n, int tam){
        System.out.println("\t"+n+"_length = " + tam + ";");
    }

     /*
            Imprime if(condicion) goto label;
     */

    public static void printIf(String cond, String label){
        System.out.println("\tif ("+cond+") goto "+label+";");
    }

    /*
            Uso de la estructura de una condición en tipo array o string
            Si length de un array es tam = 10 y quremos acceder a la pos indice, imprime
            if (indice < 0) goto L0;
            if (10 < indice) goto L0;
            if (10 == indice) goto L0;
            goto L1;
            
            donde L0 llevará a un error (EN VECTORELEM)
            y L1 llevará a proporcionar x[indice]
     */

    public static void condVector(String x, int tam, String v, String w){
        System.out.println("\tif ("+x+" < "+0+") goto "+v+";");
        System.out.println("\tif ("+tam+" < "+x+") goto "+v+";");
        System.out.println("\tif ("+tam+" == "+x+") goto "+v+";");
        printGoToLabel(w);
    }

    /*
            Imprime la estructura de una condición 

                    if(exp1 relación exp2) goto Li;
                    goto Lj;

     */
    public static void condicion (int tipoDeCondicion, String exp1, String exp2, ETIQCASOS trueOrFalse){
        
        switch (tipoDeCondicion) {

            case IGUALDAD: 
                System.out.println("\tif (" + exp1 + " == " + exp2 + ") goto " + trueOrFalse.v() + ";") ;
                System.out.println("\tgoto " +  trueOrFalse.f() + ";");
                break;


            case NOTIGUALDAD: 
                System.out.println("\tif (" + exp1 + " == " + exp2 + ") goto " + trueOrFalse.f() + ";") ;
                System.out.println("\tgoto " +  trueOrFalse.v() + ";");
                break;

            case MAYOR: 
                System.out.println("\tif (" + exp2 + " < " + exp1 + ") goto " + trueOrFalse.v() + ";") ;
                System.out.println("\tgoto " +  trueOrFalse.f() + ";");
                break;

            case MAYOROIGUAL: 
                System.out.println("\tif (" + exp1 + " < " + exp2 + ") goto " + trueOrFalse.f() + ";") ;
                System.out.println("\tgoto " +  trueOrFalse.v() + ";");
                break;     


            case MENOR: 
                System.out.println("\tif (" + exp1 + " < " + exp2 + ") goto " + trueOrFalse.v() + ";") ;
                System.out.println("\tgoto " +  trueOrFalse.f() + ";");
                break; 
                
                
            case MENOROIGUAL: 
                System.out.println("\tif (" + exp2 + " < " + exp1 + ") goto " + trueOrFalse.f() + ";") ;
                System.out.println("\tgoto " +  trueOrFalse.v() + ";");
                break;

            default:
                break;
        }
    }

    public static void error(){
        System.out.println("\terror;");
        System.out.println("\thalt;");
        System.exit(1);
    }

    public static void printError(){
        System.out.println("\terror;");
        System.out.println("\thalt;");
    }
   
}