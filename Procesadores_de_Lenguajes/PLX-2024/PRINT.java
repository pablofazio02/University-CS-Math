public class PRINT extends AST{

    public PRINT(AST i, AST d){
        super(i,d);
    }

    public void ctd(){

        //Se procesa la expresión EXP a imprimir

        if(izq != null){
            izq.ctd();
        

        // Se obtiene el tipo de variable y la cadena

        TIPO tipo = ((EXP)izq).getTipo();
        String codigo = ((EXP)izq).getCodigo();


        if(tipo.tipo().equals(TIPO.CHAR)){

            // Si es tipo CHAR se imprime con printc

            Generador.printc(((EXP)izq).getCodigo());

        } else if(tipo.tipo().equals(TIPO.ARRAY)) {

            // Si es tipo ARRAY se imprime elemento a elemento

            int tam = tipo.getTam();
            String tmp = Generador.nuevaTemporal();
            if(tipo.subTipo().tipo().equals(TIPO.INT) || tipo.subTipo().tipo().equals(TIPO.FLOAT)){

                for(int i = 0; i < tam; i++){
                    Generador.asignacion(tmp, codigo+"["+i+"]");
                    Generador.print(tmp);
                }

            } else if (tipo.subTipo().tipo().equals(TIPO.CHAR)){

                for(int i = 0; i < tam; i++){
                    Generador.asignacion(tmp, codigo+"["+i+"]");
                    Generador.printc(tmp);
                }
            }
        } else if(tipo.tipo().equals(TIPO.STRING)){

            // Si es tipo String se ejecuta elemento a elemento
            
            String cont = Generador.nuevaTemporal();
            String inicio = Generador.nuevaLabel();

            ETIQCASOS et = new ETIQCASOS(Generador.nuevaLabel(), Generador.nuevaLabel());

            Generador.asignacion(cont, "0");

            Generador.printLabel(inicio);

            Generador.condicion(Generador.MENOR, cont, codigo+"_length", et);

            Generador.printLabel(et.v());
            String tmp = Generador.nuevaTemporal();
            Generador.asignacion(tmp, codigo+"["+cont+"]");
            Generador.writec(tmp);
            Generador.asignacion(cont, cont+" + 1");
            Generador.printGoToLabel(inicio);

            Generador.printLabel(et.f());
            Generador.writec("10"); // Caracter de fin de linea

        }else if(tipo.tipo().equals(TIPO.BOOLEAN)){ // Si es tipo booleano solo tendremos que imprimir por pantalla "true" o "false"

        String label0 = Generador.nuevaLabel();
        String label1 = Generador.nuevaLabel();

        if(izq instanceof CONDICION){
            ETIQCASOS trueorFalse = ((CONDICION)izq).getEtiquetas(); // Como el booleano hereda de condición podemos usar sus etiquetas
            label0 = trueorFalse.v();
            label1 = trueorFalse.f();
        }else if(izq instanceof BOOL){
            int trueorFalse = ((BOOL)izq).getTrueorFalse(); // Vemos si es true (valor 1) o false (valor 0)
            if(trueorFalse == 1){ // Si es true, imprimimos goto label0
                Generador.printGoToLabel(label0);
            }else{ // Si queremos asignar false, imprimimos goto label1
                Generador.printGoToLabel(label1);
            }
        }else if(izq instanceof CASTING){
            Generador.printIf(((EXP)izq).getCodigo() + " == 0", label1);
            Generador.printGoToLabel(label0);
        }else if(izq instanceof ASIG){
            Generador.printIf("0 < "+((ASIG)izq).getNomVar(),label0); // Imprimimos if(0 < by) goto Li
            Generador.printGoToLabel(label1); // Imprimimos Lj (Esto es para saber que asignar a bx directamente)
        }
            String fin = Generador.nuevaLabel();

            Generador.printLabel(label0); // Si la repuesta es verdadera, imprimimos "true" usando writec
            Generador.writec("116");
            Generador.writec("114");
            Generador.writec("117");
            Generador.writec("101");
            Generador.writec("10");
            Generador.printGoToLabel(fin);

            Generador.printLabel(label1); // Si la respuesta es falsa, imprimos "false" usando writec
            Generador.writec("102");
            Generador.writec("97");
            Generador.writec("108");
            Generador.writec("115");
            Generador.writec("101");
            Generador.writec("10");
            
            Generador.printLabel(fin);

        }else {

            Generador.print(codigo);

        }

    }
    }
    
}
