public class PRINT extends AST{

    public PRINT(AST i, AST d){
        super(i,d); // El hijo derecho quedará a null
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

             /*
                    Si es un array, se toma una temporal que va tomando el valor de cada elem t1 = x[i]
                    y se hace print(t1) cada vez
                 */

            int tam = tipo.getTam();
            String tmp = Generador.nuevaTemporal();
            if(tipo.subTipo().tipo().equals(TIPO.INT) || tipo.subTipo().tipo().equals(TIPO.FLOAT)){

                for(int i = 0; i < tam; i++){
                    Generador.asignacion(tmp, codigo+"["+i+"]"); //t1 = x[i]
                    Generador.print(tmp); // print t1
                }

            } else if (tipo.subTipo().tipo().equals(TIPO.CHAR)){

                for(int i = 0; i < tam; i++){
                    Generador.asignacion(tmp, codigo+"["+i+"]"); //t1 = x[i]
                    Generador.printc(tmp); // printc t1
                }
            }
        } else if(tipo.tipo().equals(TIPO.STRING)){

            /* para print("abc"), tenemos:
                        $t0[0] = 97;
                        $t0[1] = 98;
                        $t0[2] = 99;
                        $$t0_length = 3;
                        $t1 = 0;
                        L0:
                        if ($t1 < $$t0_length) goto L1;
                        goto L2;
                        L1:
                        $t2 = $t0[$t1];
                        writec $t2;
                        $t1 = $t1 + 1;
                        goto L0;
                        L2:
                        writec 10;
            */
            
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
        }else {

            Generador.print(codigo);

        }

    }
    }
    
}
