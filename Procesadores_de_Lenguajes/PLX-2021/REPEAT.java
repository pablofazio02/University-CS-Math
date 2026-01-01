public class REPEAT extends AST {

    private EXP update; 
    public String etiqInicio;

    public REPEAT(AST actualizacion, AST sentencia) {
        super(null,sentencia);
        update = ((EXP)actualizacion);
    }

    public void ctd(){

        String tmp = Generador.nuevaTemporal();
        String etiqTrue = Generador.nuevaLabel();

        Generador.asignacion(tmp, "1");
        
        etiqInicio = Generador.nuevaLabel();

        Generador.printLabel(etiqInicio);

        if(update!=null){
            update.ctd();
        }

        Generador.printIf(update.getCodigo() + " < " + tmp , etiqTrue);
        
        if(der!=null){
            der.ctd();
        }
        
        Generador.asignacion(tmp, tmp + " + 1");
        Generador.printGoToLabel(etiqInicio);

        Generador.printLabel(etiqTrue);

    }




    
}
