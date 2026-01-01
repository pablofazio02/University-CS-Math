public class CASTING extends EXP{

    public CASTING(TIPO t, AST i){
        super(i,null);
        this.t = t;
    }

    public void ctd(){

        if(izq!=null){

        izq.ctd();

        TIPO tIzq = ((EXP)izq).getTipo();
        
        String codIzq = ((EXP)izq).getCodigo();

        if(!t.tipo().equals(tIzq.tipo())){ // Si el tipo es el mismo, no se hace nada

            if(t.tipo().equals(TIPO.CHAR)){  

                if(tIzq.tipo().equals(TIPO.INT)){ //si estamos convirtiendo un int a char no hay que hacer casting
                    this.codigo = codIzq;
                }else if (tIzq.tipo().equals(TIPO.BOOLEAN)){
                    Generador.error();
                }
               
            }else if(t.tipo().equals(TIPO.BOOLEAN)){ // Si estamos convirtiendo int/float a boolean es posible hacerlo comparando, si es igual a 0 es falso y si no es verdadero (lo hago en ASIG!)

                if(tIzq.tipo().equals(TIPO.INT) || tIzq.tipo().equals(TIPO.FLOAT)){
                    this.codigo = codIzq;
                }else{
                    Generador.error();
                }

            } else {
                if(tIzq.tipo().equals(TIPO.CHAR)){ //si estamos convirtiendo un char a int/float, no tenemos que hacer casting porque se almacena su ASCII
                    this.codigo = codIzq;

                }else if(tIzq.tipo().equals(TIPO.BOOLEAN)){

                    if(t.tipo().equals(TIPO.INT)){ // Se puede convertir boolean a int, mirando sus etiquetas

                        if(izq instanceof CONDICION){
                            String tmp = Generador.nuevaTemporal();
                            ETIQCASOS trueorFalse = ((CONDICION)izq).getEtiquetas();
                            Generador.printLabel(trueorFalse.v());
                            Generador.asignacion(tmp, "1");
                            Generador.printLabel(trueorFalse.f());
                            this.codigo = tmp;
                        }else if (izq instanceof CASTING){

                            ETIQCASOS trueorFalse = new ETIQCASOS(Generador.nuevaLabel(), Generador.nuevaLabel());
                            Generador.printIf(((EXP)izq).getCodigo() + " == 0", trueorFalse.f());
                            Generador.printGoToLabel(trueorFalse.v());

                            String tmp = Generador.nuevaTemporal();
                            Generador.printLabel(trueorFalse.v());
                            Generador.asignacion(tmp, "1");
                            Generador.printLabel(trueorFalse.f());
                            this.codigo = tmp;

                        }else if (izq instanceof BOOL){
                            String label0 = Generador.nuevaLabel();
                            String label1 = Generador.nuevaLabel();
                            int trueorFalse = ((BOOL)izq).getTrueorFalse(); // Vemos si es true (valor 1) o false (valor 0)

                            if(trueorFalse == 1){ // Si es true, imprimimos goto label0
                                Generador.printGoToLabel(label0);
                            }else{ // Si queremos asignar false, imprimimos goto label1
                                Generador.printGoToLabel(label1);
                            }

                            String tmp = Generador.nuevaTemporal();
                            Generador.printLabel(label0);
                            Generador.asignacion(tmp, "1");
                            Generador.printLabel(label1);
                            this.codigo = tmp;
                        }

                       
                    }else{
                        Generador.error();
                    }

                }else{ // En otro caso, se hace el casting necesario
                    String tmp = Generador.nuevaTemporal();
                    this.codigo = tmp;
                    Generador.casting(this.codigo, this.t.tipo(), codIzq); 
                }
            }
        } else {
            this.codigo = codIzq;
        }   

        }
        
    }

}
