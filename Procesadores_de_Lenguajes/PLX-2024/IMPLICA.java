public class IMPLICA extends CONDICION{ // Es una condición equivalente a !exp1 || exp2

    public IMPLICA(AST exp1, AST exp2) {
        super(0, exp1, exp2);
    }
    
    public void ctd(){

        if(izq instanceof BOOL && der instanceof BOOL){ // si es de la forma false --> true

        String label0 = Generador.nuevaLabel();
        String label1 = Generador.nuevaLabel();
        String label2 = Generador.nuevaLabel();
        String label3 = Generador.nuevaLabel();
        this.trueOrFalse = new ETIQCASOS(label1, label3); // Esto lo hago porque todo lo que sale por label1 es true y todo lo que sale por label3 es false

            // Guardamos el valor 0 o 1 en el código de izquierda y derecha
            izq.ctd();
            der.ctd();

            // Miro primero si expr2 = true o expr2 = false, si es true he acabado
            if(((EXP)der).getCodigo().equals("0")){
                Generador.printGoToLabel(label0);                
            }else{
                Generador.printGoToLabel(label1);
            }
            
            Generador.printLabel(label0);
            
            // Si expr2 = false, llego aquí y miro si expr1 = true o expr1 = false, si es false también lo he conseguido
            if(((EXP)izq).getCodigo().equals("1")){
                Generador.printGoToLabel(label3);                
            }else{
                Generador.printGoToLabel(label2);
            }

            Generador.printLabel(label2);
            Generador.printGoToLabel(label1);  

        }else if(izq instanceof BOOL && der instanceof CONDICION){ // Si es de la forma true/false --> (3==1)

            String label0 = Generador.nuevaLabel();
            String label1 = Generador.nuevaLabel();

            // Guardamos el valor 0 o 1 en el código de izquierda
            izq.ctd();

            // Miro primero si expr1 = true o expr1 = false, si es false he acabado
            if(((EXP)izq).getCodigo().equals("0")){
                Generador.printGoToLabel(label1);                
            }else{
                Generador.printGoToLabel(label0);
            }
            
            Generador.printLabel(label0);
            der.ctd();

            ETIQCASOS etiqDer = ((CONDICION)der).getEtiquetas(); // Como hereda de condición uso etiquetas 
            String label2 = etiqDer.v();
            String label3 = etiqDer.f(); // Si es falsa la condición de la derecha la hemos cagado

            Generador.printLabel(label2);
            Generador.printGoToLabel(label1);  

            this.trueOrFalse = new ETIQCASOS(label1, label3); // Esto lo hago porque todo lo que sale por label1 es true y todo lo que sale por label3 es false

        }else if(der instanceof BOOL && izq instanceof CONDICION){ // Si es de la forma (3==1) --> true/false

            izq.ctd();

            ETIQCASOS etiqIzq = ((CONDICION)izq).getEtiquetas(); // Como hereda de condición uso etiquetas 
            String label0 = etiqIzq.v();
            String label1 = etiqIzq.f(); // Si es falsa la condición de la derecha la hemos cagado

            Generador.printLabel(label0);

            String label2 = Generador.nuevaLabel();
            String label3 = Generador.nuevaLabel();

            // Guardamos el valor 0 o 1 en el código de derecha
            der.ctd();

            // Miro después si expr1 = true o expr1 = false, si es true he acabado
            if(((EXP)der).getCodigo().equals("1")){
                Generador.printGoToLabel(label2);                
            }else{
                Generador.printGoToLabel(label3);
            }

            Generador.printLabel(label2);
            Generador.printGoToLabel(label1);  

            this.trueOrFalse = new ETIQCASOS(label1, label3); 
        
        }else{ // si es de cualquier otra forma como 1<2 --> a<c

            izq.ctd(); // Ejecuto la expresion
            
            ETIQCASOS etiqIzq = ((CONDICION)izq).getEtiquetas(); // Como hereda de condición uso etiquetas 
            String label0 = etiqIzq.v; // Si es verdadera la expresión de la izquierda continuo a ver la expresión de la derecha
            String label1 = etiqIzq.f;

            Generador.printLabel(label0);

            der.ctd(); // Ejecuto la expresión

            ETIQCASOS etiqDer = ((CONDICION)der).getEtiquetas(); // Como hereda de condición uso etiquetas 
            String label2 = etiqDer.v();
            String label3 = etiqDer.f(); // Si es falsa la condición de la derecha la hemos cagado

            Generador.printLabel(label2);
            Generador.printGoToLabel(label1);

            this.trueOrFalse = new ETIQCASOS(label1, label3); // Esto lo hago porque todo lo que sale por label1 es true y todo lo que sale por label3 es false


        }
    }
    
}
