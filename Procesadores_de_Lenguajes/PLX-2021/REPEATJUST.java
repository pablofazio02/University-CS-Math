public class REPEATJUST extends AST {

    private EXP update; 
    public String etiqInicio;

    public REPEATJUST(AST actualizacion, AST sentencia) {
        super(null,sentencia);
        update = ((EXP)actualizacion);
    }

    public void ctd(){

        String tmp0 = Generador.nuevaTemporal();
        String etiqTrue = Generador.nuevaLabel();
        String tmp1 = Generador.nuevaTemporal();
        
        if(update!=null){
            update.ctd();
        }

        Generador.asignacion(tmp1, update.getCodigo());
        Generador.asignacion(tmp0, "1");
        
        etiqInicio = Generador.nuevaLabel();

        Generador.printLabel(etiqInicio);

        

        Generador.printIf(tmp1 + " < " + tmp0 , etiqTrue);
        
        if(der!=null){
            der.ctd();
        }

        Generador.asignacion(tmp0, tmp0 + " + 1");
        
        Generador.printGoToLabel(etiqInicio);

        Generador.printLabel(etiqTrue);

    }




    
}
