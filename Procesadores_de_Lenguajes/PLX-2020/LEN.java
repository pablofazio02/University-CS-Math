public class LEN extends EXP{
    
    public LEN(String var, TIPO t){
        super(null,null);
        
        if(t.tipo().equals(TIPO.ARRAY) || t.tipo().equals(TIPO.STRING)){
            this.t = new TIPO(TIPO.INT);
            this.codigo = var+"_length";   
        } else {
            Generador.error();
        }
        
    }

}
