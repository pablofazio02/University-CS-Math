public class ETIQCASOS {

    /*
            Esta clase se usa como auxiliar en CONDICIÓN, cuando es necesario tomar dos caminos distintos según la evaluación.
            En concreto, aquí se almacenan las etiquetas Li y Lj creadas en una condición (LEER CLASE CONDCIÓN)
     */
    
    public String v;
    public String f;

    public ETIQCASOS(String etiqV, String etiqF){  
        v = etiqV;
        f = etiqF;
    }

    public void setV(String etiqV){
        v = etiqV;
    }

    public void setF(String etiqF){
        f = etiqF;
    }

    public String v(){
        return this.v;
    }

    public String f(){
        return this.f;
    }
}
