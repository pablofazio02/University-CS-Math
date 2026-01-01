public class DOBLEIMPLICA extends CONDICION{ // Es una condición equivalente a (exp1-->exp2) && (exp2-->exp1)

    public DOBLEIMPLICA(AST exp1, AST exp2) {
        super(0, exp1, exp2);
    }
    
    public void ctd(){

        if(izq instanceof BOOL && der instanceof BOOL){ // si es de la forma false <--> true

            String label0 = Generador.nuevaLabel();
            String label1 = Generador.nuevaLabel();
            String label2 = Generador.nuevaLabel();
            String label3 = Generador.nuevaLabel();
            String label4 = Generador.nuevaLabel();
            String label5 = Generador.nuevaLabel();
            String tmp = Generador.nuevaTemporal();
            this.trueOrFalse = new ETIQCASOS(label4, label5); // Esto lo hago porque todo lo que sale por label4 es true y todo lo que sale por label5 es false

            // Guardamos el valor 0 o 1 en el código de izquierda y derecha
            izq.ctd();
            der.ctd();

            // Miro primero si expr1 = true o expr1 = false
            if(((EXP)izq).getCodigo().equals("1")){
                Generador.printGoToLabel(label0);                
            }else{
                Generador.printGoToLabel(label1);
            }
            
            Generador.printLabel(label0);

            Generador.asignacion(tmp, "1");

            Generador.printLabel(label1);
            
            // Miro si expr2 = true o expr2 = false
            if(((EXP)der).getCodigo().equals("0")){
                Generador.printGoToLabel(label3);                
            }else{
                Generador.printGoToLabel(label2);
            }

            Generador.printLabel(label2);

            Generador.printIf(tmp + " == 1", label4);
            Generador.printGoToLabel(label5);  

            Generador.printLabel(label3);

            Generador.printIf(tmp + " == 1", label5);
            Generador.printGoToLabel(label4);  

        }else if(izq instanceof BOOL && der instanceof CONDICION){ // Si es de la forma true/false <--> (3==1)

            String label0 = Generador.nuevaLabel();
            String label1 = Generador.nuevaLabel();
            String tmp = Generador.nuevaTemporal();

             // Guardamos el valor 0 o 1 en el código de izquierda
             izq.ctd();

             // Miro primero si expr1 = true o expr1 = false
            if(((EXP)izq).getCodigo().equals("1")){
                Generador.printGoToLabel(label0);                
            }else{
                Generador.printGoToLabel(label1);
            }
            
            Generador.printLabel(label0);

            Generador.asignacion(tmp, "1");

            Generador.printLabel(label1);

            der.ctd(); // Ejecuto la expresión

            ETIQCASOS etiqDer = ((CONDICION)der).getEtiquetas(); // Como hereda de condición uso etiquetas 
            String label2 = etiqDer.v();
            String label3 = etiqDer.f();

            Generador.printLabel(label2);

            String label4 = Generador.nuevaLabel();
            String label5 = Generador.nuevaLabel();

            Generador.printIf(tmp + " == 1", label4);
            Generador.printGoToLabel(label5); 

            Generador.printLabel(label3);

            Generador.printIf(tmp + " == 1", label5);
            Generador.printGoToLabel(label4); 

            this.trueOrFalse = new ETIQCASOS(label4, label5);


        }else if(der instanceof BOOL && izq instanceof CONDICION){ // Si es de la forma (3==1) <--> true/false

            String tmp = Generador.nuevaTemporal();

            izq.ctd(); // Ejecuto la expresion
            
            ETIQCASOS etiqIzq = ((CONDICION)izq).getEtiquetas(); // Como hereda de condición uso etiquetas 
            String label0 = etiqIzq.v(); 
            String label1 = etiqIzq.f();

            Generador.printLabel(label0);
            Generador.asignacion(tmp, "1");

            Generador.printLabel(label1);

            der.ctd();

            String label2 = Generador.nuevaLabel();
            String label3 = Generador.nuevaLabel();
            String label4 = Generador.nuevaLabel();
            String label5 = Generador.nuevaLabel();

             // Miro si expr2 = true o expr2 = false
             if(((EXP)der).getCodigo().equals("0")){
                Generador.printGoToLabel(label3);                
            }else{
                Generador.printGoToLabel(label2);
            }

            Generador.printLabel(label2);

            Generador.printIf(tmp + " == 1", label4);
            Generador.printGoToLabel(label5);  

            Generador.printLabel(label3);

            Generador.printIf(tmp + " == 1", label5);
            Generador.printGoToLabel(label4);  

            this.trueOrFalse = new ETIQCASOS(label4, label5);
             

        }else{ // si es de cualquier otra forma como (1<3) <--> b ó 1<2 <-->a<c

            String tmp = Generador.nuevaTemporal();

            izq.ctd(); // Ejecuto la expresion
            
            ETIQCASOS etiqIzq = ((CONDICION)izq).getEtiquetas(); // Como hereda de condición uso etiquetas 
            String label0 = etiqIzq.v(); 
            String label1 = etiqIzq.f();

            Generador.printLabel(label0);
            Generador.asignacion(tmp, "1");

            Generador.printLabel(label1);

            der.ctd(); // Ejecuto la expresión

            ETIQCASOS etiqDer = ((CONDICION)der).getEtiquetas(); // Como hereda de condición uso etiquetas 
            String label2 = etiqDer.v();
            String label3 = etiqDer.f();

            Generador.printLabel(label2);

            String label4 = Generador.nuevaLabel();
            String label5 = Generador.nuevaLabel();

            Generador.printIf(tmp + " == 1", label4);
            Generador.printGoToLabel(label5); 

            Generador.printLabel(label3);

            Generador.printIf(tmp + " == 1", label5);
            Generador.printGoToLabel(label4); 

            this.trueOrFalse = new ETIQCASOS(label4, label5);


        }
    }
    
}
