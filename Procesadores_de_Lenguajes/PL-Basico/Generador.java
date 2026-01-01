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
    public final static int NOT = 10;


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
        System.out.println("\t print " + expr +";");
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
        System.out.println("\t goto "+ label + ";");
    }



    /*
            Imprime una asignación (ti = expresion;) tras haber operado 
     */
    public static void operacionAritm (String result, String expresion) {
        System.out.println("\t " + result + " = " + expresion + ";");
    }


    /*
            Imprime una asignación (ti = expresion;) tras haber declarado una variable
     */
    public static void asignacion (String ident, String expresion){
        System.out.println("\t " +  ident + "=" + expresion + ";");
    }


    /*
            Imprime la estructura de una condición 

                    if(exp1 relación exp2) goto Li;
                    goto Lj;

     */
    public static void condicion (int tipoDeCondicion, String exp1, String exp2, ETIQCASOS trueOfFalse){
        
        switch (tipoDeCondicion) {

            case IGUALDAD: 
                System.out.println("\t if(" + exp1 + " == " + exp2 + ") goto " + trueOfFalse.v() + ";") ;
                System.out.println("\t goto " +  trueOfFalse.f() + ";");
                break;


            case NOTIGUALDAD: 
                System.out.println("\t if(" + exp1 + " == " + exp2 + ") goto " + trueOfFalse.f() + ";") ;
                System.out.println("\t goto " +  trueOfFalse.v() + ";");
                break;

            case MAYOR: 
                System.out.println("\t if(" + exp2 + " < " + exp1 + ") goto " + trueOfFalse.v() + ";") ;
                System.out.println("\t goto " +  trueOfFalse.f() + ";");
                break;

            case MAYOROIGUAL: 
                System.out.println("\t if(" + exp1 + " < " + exp2 + ") goto " + trueOfFalse.f() + ";") ;
                System.out.println("\t goto " +  trueOfFalse.v() + ";");
                break;     


            case MENOR: 
                System.out.println("\t if(" + exp1 + " < " + exp2 + ") goto " + trueOfFalse.v() + ";") ;
                System.out.println("\t goto " +  trueOfFalse.f() + ";");
                break; 
                
                
            case MENOROIGUAL: 
                System.out.println("\t if(" + exp2 + " < " + exp1 + ") goto " + trueOfFalse.f() + ";") ;
                System.out.println("\t goto " +  trueOfFalse.v() + ";");
                break;  


            default:
                break;
        }
    }

    public static void error(){
        System.out.println("error;");
        System.out.println("halt;");
        System.exit(1);
    }
   
}