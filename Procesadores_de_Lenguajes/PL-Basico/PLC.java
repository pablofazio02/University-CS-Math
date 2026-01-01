import java.io.*;

public class PLC{

        public static PrintStream out;

        public static void main(String args[]){

            try{

                Reader in = new InputStreamReader(System.in);
                out = System.out;
                if(args.length > 0){ 
                    in = new FileReader(args[0]);
                }
                if(args.length > 1){
                    out = new PrintStream(new FileOutputStream(args[1]));
                }
                System.setOut(out);
                System.setErr(out);
                
                parser p = new parser(new Yylex(in));

                Object result = p.parse().value;

            } catch (Exception e){
                e.printStackTrace();
            }
        }

}