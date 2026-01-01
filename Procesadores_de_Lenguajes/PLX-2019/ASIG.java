public class ASIG extends EXP{

    /*
            Las asignaciones son de la forma IDENT = expresion
            Luego el código (VER CLASE EXP) será el IDENT
            y solo habrá un hijo que es la expresión que se le asigna
     */

     private String nomVar;

    public ASIG(String id, AST d){
        super(d, null);
        this.codigo = id;
        nomVar = id;

        /*
            Vamos a inicializarlo así, porque cuando declaramos una variable, 
            hacemos ((exp)var).getCodigo() para introducirlo en tablaSimbolos.
            Sin embargo, cuando e sea procesada, imaginemos que tiene 
            código t0, haremos this.codigo=((exp)izq).getcodigo() (devuelve el t0 de e=izq)
            para que, si se hace una doble asignación, se compute bien (leer abajo)

        */    
    }

    public void setTipo(TIPO t){
        this.t=t;
    }

    public TIPO getTipo(){
        return this.t;
    }

    public String getCodigo(){
        return this.codigo;
    }

    public String getNomVar(){
        return nomVar;
    }

    public void ctd(){
 
        if(izq!=null){ 

            izq.ctd(); // Se procesa la expresión a asignar
            this.codigo = ((EXP)izq).getCodigo();

             //El "código" o identificador de una asignación será el código de la expresión
             // (leer por qué aquí:)

            /*
                 Si tenemos una asignación x=exp con exp de código t0,
                 i.e. x=t0 en el ctd
                 Si luego hacemos y=x=exp, no se hace y=x, sino y=t0  
                 
                 Por eso, cuando esta expresión, que es una asignación sea 
                 llamada, tendremos que devolverel t0 en vez del x 

             */

            String codIzq = ((EXP)izq).getCodigo();

            if(TablaSimbolos.checkSub(nomVar)){ // Miramos si ha sido declarada ya la variable
                TIPO tipoVar = TablaSimbolos.getTipoSub(nomVar);
                TIPO tipoIzq = ((EXP)izq).getTipo();

                if(tipoVar.tipo().equals(tipoIzq.tipo())){

                    
                    if(tipoVar.tipo().equals(TIPO.ARRAY)){
                        TIPO subtipoVar = tipoVar.subTipo();
                        TIPO subtipoIzq = tipoIzq.subTipo();
                        int tamVar = tipoVar.getTam();
                        int tamIzq = tipoIzq.getTam();

                        // Cuando asociamos arrays, mirar que coinciden los subtipos y que el 1º sea mayor o igual de tamaño que el 2º
                        if(subtipoVar.tipo().equals(subtipoIzq.tipo()) && tamVar >= tamIzq){

                            /* si tenemos a=b, no podemos hacer 
                                   Generador.asignacion(nomVar, codExp);, es decir, a=b,
                                   sino t0=a[i]; b[i]=t0 */
                            String tmp = Generador.nuevaTemporal();
                            for(int i = 0; i<tamIzq; i++){
                                Generador.asignacion(tmp, codIzq + "["+i+"]");
                                Generador.asignacion(nomVar+"["+i+"]", tmp);
                            }

                        }else{
                            Generador.error();
                        }

                    }else if (tipoVar.tipo().equals(TIPO.STRING)){

                        Generador.printLength(nomVar, 0);

                        String i = Generador.nuevaTemporal();
                        Generador.asignacion(i, "0");

                        String inicio = Generador.nuevaLabel();

                        ETIQCASOS e = new ETIQCASOS(Generador.nuevaLabel(),Generador.nuevaLabel());
                        
                        Generador.printLabel(inicio);

                        Generador.condicion(Generador.MENOR, i, codIzq+"_length", e);
                        
                        Generador.printLabel(e.v());
                        String aux = Generador.nuevaTemporal();
                        Generador.asignacion(aux, codIzq+"["+i+"]");

                        String e1 = Generador.nuevaLabel();
                        String e2 = Generador.nuevaLabel();
                        
                        Generador.printLabel(e1);
                        Generador.asignacion(nomVar+"["+nomVar+"_length]", aux);
                        Generador.asignacion(nomVar+"_length", nomVar+"_length + 1");
                        
                        Generador.printLabel(e2);
                        Generador.asignacion(i, i+" + 1");
                        Generador.printGoToLabel(inicio);

                        Generador.printLabel(e.f());   

    
                    }else{ // Mismo tipo pero no array, string o booleano
                        Generador.asignacion(nomVar, codIzq);
                        this.t = ((EXP)izq).getTipo();
                    }

                }else if(tipoVar.tipo().equals(TIPO.FLOAT) && tipoIzq.tipo().equals(TIPO.INT)){
                    Generador.asignacion(nomVar, "(float)" + codIzq);
                }else if(tipoVar.tipo().equals(TIPO.STRING) && tipoIzq.tipo().equals(TIPO.CHAR)){
                    
                    Generador.asignacion(nomVar+"[0]", codIzq);
                    Generador.printLength(nomVar, 1);

                }else{
                    Generador.error();
                }

            }else{ // Necesitamos declarar la variable
                Generador.asignacion(nomVar, codIzq);
                this.t = ((EXP)izq).getTipo();
            }
        }

    }
    
}
