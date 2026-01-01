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

            izq.ctd();
            this.codigo = ((EXP)izq).getCodigo();
            String codIzq = ((EXP)izq).getCodigo();

            if(TablaSimbolos.checkSub(nomVar)){
                TIPO tipoVar = TablaSimbolos.getTipoSub(nomVar);
                TIPO tipoIzq = ((EXP)izq).getTipo();

                if(tipoVar.tipo().equals(tipoIzq.tipo())){

                    if(tipoVar.tipo().equals(TIPO.ARRAY)){
                        TIPO subtipoVar = tipoVar.subTipo();
                        TIPO subtipoIzq = tipoIzq.subTipo();
                        int tamVar = tipoVar.getTam();
                        int tamIzq = tipoIzq.getTam();

                        if(subtipoVar.tipo().equals(subtipoIzq.tipo()) && tamVar >= tamIzq){

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

                    }else if(tipoVar.tipo().equals(TIPO.BOOLEAN)){ // Si hay una asignación entre booleanos

                        if(izq instanceof BOOL){ // Veamos si es de la forma b = true / false

                            String label0 = Generador.nuevaLabel();
                            String label1 = Generador.nuevaLabel();
                            String fin = Generador.nuevaLabel();
                            int trueorFalse = ((BOOL)izq).getTrueorFalse(); // Vemos si es true (valor 1) o false (valor 0)

                            if(trueorFalse == 1){ // Si es true, imprimimos goto label0
                                Generador.printGoToLabel(label0);
                            }else{ // Si queremos asignar false, imprimimos goto label1
                                Generador.printGoToLabel(label1);
                            }

                            Generador.printLabel(label0);
                            Generador.asignacion(nomVar, "1");
                            Generador.printGoToLabel(fin);

                            Generador.printLabel(label1);
                            Generador.asignacion(nomVar, "0");
                            
                            Generador.printLabel(fin);

                            this.t = ((EXP)izq).getTipo();

                        }else if (izq instanceof CONDICION){ // Veamos si es de la forma b = (3<2) && (2!=1)

                            ETIQCASOS trueorFalse = ((CONDICION)izq).getEtiquetas(); // Como es una condicion sacamos las etiquetas directamente y hacemos lo mismo
                            String fin = Generador.nuevaLabel();

                            Generador.printLabel(trueorFalse.v());
                            Generador.asignacion(nomVar, "1");
                            Generador.printGoToLabel(fin);

                            Generador.printLabel(trueorFalse.f());
                            Generador.asignacion(nomVar, "0");

                            Generador.printLabel(fin);

                            this.t = ((EXP)izq).getTipo();

                        }else if(izq instanceof ASIG){ // Veamos si es de la forma bx = by = x == 0;
                            
                            ETIQCASOS trueorFalse = new ETIQCASOS(Generador.nuevaLabel(), Generador.nuevaLabel());
                            String fin = Generador.nuevaLabel();

                            Generador.printIf("0 < "+((ASIG)izq).getNomVar(),trueorFalse.v()); // Imprimimos if(0 < by) goto Li
                            Generador.printGoToLabel(trueorFalse.f()); // Imprimimos Lj (Esto es para saber que asignar a bx directamente)

                            Generador.printLabel(trueorFalse.v());
                            Generador.asignacion(nomVar, "1");
                            Generador.printGoToLabel(fin);

                            Generador.printLabel(trueorFalse.f());
                            Generador.asignacion(nomVar, "0");

                            Generador.printLabel(fin);

                            this.t = ((ASIG)izq).getTipo();

                        }else if(izq instanceof CASTING){ // Si es de la forma x = (boolean) 2

                            ETIQCASOS trueorFalse = new ETIQCASOS(Generador.nuevaLabel(), Generador.nuevaLabel());
                            String fin = Generador.nuevaLabel();

                            Generador.printIf(((EXP)izq).getCodigo() + " == 0", trueorFalse.f());
                            Generador.printGoToLabel(trueorFalse.v());

                            Generador.printLabel(trueorFalse.v());
                            Generador.asignacion(nomVar, "1");
                            Generador.printGoToLabel(fin);

                            Generador.printLabel(trueorFalse.f());
                            Generador.asignacion(nomVar, "0");

                            Generador.printLabel(fin);
                        }

                    }else{
                        Generador.asignacion(nomVar, codIzq);
                        this.t = ((EXP)izq).getTipo();
                    }

                }else if(tipoVar.tipo().equals(TIPO.FLOAT) && tipoIzq.tipo().equals(TIPO.INT)){
                    Generador.asignacion(nomVar, "(float)" + codIzq);
                }else{
                    Generador.error();
                }

            }else{
                Generador.asignacion(nomVar, codIzq);
                this.t = ((EXP)izq).getTipo();
            }
        }

    }
    
}
