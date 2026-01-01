public class NOT extends CONDICION{

    /*
          Un NOT es un tipo de condición, que en lugar de evaluar dos EXP, evalua una CONDICION 
     */
    public NOT(int tipoDeCondicion, AST cond) {
        super(tipoDeCondicion, cond, null);
    }

    public void ctd(){
        
        //Primero evaluamos la condición
        izq.ctd();
        
        //Obtenemos sus Li y Lj 
        String etiqIzqV = ((CONDICION)izq).getEtiquetas().v();
        String etiqIzqF = ((CONDICION)izq).getEtiquetas().f();

        //Como es un NOT, se invierten las etiquetas Li,Lj correspondientes a verdadero y falso respectivamente
        //Si por ejemplo estamos dentro de un IFELSE, se habrá impreso   if (cond) gotoLi \n goto Lj
        //al hacer izq.ctd(), pero como ahora OR tiene las etiquetas Lj Li (invertidas),
        //el IFELSE meterán en Lj se las sentencias del caso True, y en Li las del caso False
        setEtiq(new ETIQCASOS(etiqIzqF, etiqIzqV)); 
    }
    
}
