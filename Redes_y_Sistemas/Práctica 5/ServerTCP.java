import java.io.*;
import java.net.*;
import java.util.Scanner;

class ServerTCP {
	
    public static String capitalize(String s){
        String words[] = s.split("\\s");
        String res = "";
        for(String w: words){
            if(!res.isEmpty()){
                res += " ";
            }
            res += w.substring(0,1).toUpperCase() + w.substring(1);
        }
        return res;
    }

    public static void main(String[] args)
    {
        // DATOS DEL SERVIDOR
        //* FIJO: Si se lee de línea de comando debe comentarse
        int port = 12345; // puerto del servidor
        //* VARIABLE: Si se lee de línea de comando debe descomentarse
        // int port = Integer.parseInt(args[0]);

        // SOCKETS
        ServerSocket server = null; // Pasivo (recepción de peticiones)
        Socket client = null;       // Activo (atención al cliente)

        // FLUJOS PARA EL ENVÍO Y RECEPCIÓN
        BufferedReader in = null;
        PrintWriter out = null;
        

        //* COMPLETAR: Crear e inicializar el socket del servidor (socket pasivo)
        
        try {
        	server = new ServerSocket(port,	1);
        }catch(IOException e) {
        	System.err.println("Error creando el socket servidor: " + e.getMessage());
        	System.exit(1);
        	
        }
        
       

        while (true) // Bucle de recepción de conexiones entrantes
        {
            //* COMPLETAR: Esperar conexiones entrantes
        	System.out.println("STATUS: Esperando clientes...");
        	 
        	try {
        		client = server.accept();
        	}catch(IOException e) {
        		System.err.println("Error aceptando conexión: " + e.getMessage());
        	}
        	
        	SocketAddress clientAddress = client.getRemoteSocketAddress();

            //* COMPLETAR: Una vez aceptada una conexion, inicializar flujos de entrada/salida del socket conectado
        	
        	 try {
             	out = new PrintWriter(client.getOutputStream(),true);
             }catch (IOException e) {
             	System.err.println("Error inicializando el flujo de salida: "  + e.getMessage());
             	System.exit(1);
             }
        	
        	try {
        		in = new BufferedReader(new InputStreamReader(client.getInputStream()));
        	}catch(IOException e) {
        		System.err.println("Error inicializando el flujo de entrada: " + e.getMessage());
        		System.exit(1);
        	}
        	
        	System.out.println("STATUS: Cliente " + clientAddress + " conectado.");
        	

           boolean salir = false;
           while(!salir) // Inicio bucle del servicio de un cliente
           {
                //* COMPLETAR: Recibir texto en line enviado por el cliente a través del flujo de entrada del socket conectado
                String line = null;
                
                try {
                	line = in.readLine();
                }catch(IOException e) {
                	System.err.println("Error leyendo de buffer: " + e.getMessage());
            		System.exit(1);
                }
                
                System.out.println("STATUS: Línea recibida: " + line);

                //* COMPLETAR: Comprueba si es fin de conexion - SUSTITUIR POR LA CADENA DE FIN enunciado
                
                if (line.compareTo("END") != 0){
                	
                    line = capitalize(line);

                    //* COMPLETAR: Enviar texto al cliente a traves del flujo de salida del socket conectado
                    
                    out.println(line);
                    
                    System.out.println("STATUS: Línea enviada: " + line);
                    
                } else { 
                    salir = true;
                    out.println("OK");
                }
                
            } // fin del servicio
           
           System.out.println("STATUS: Cerrando conexión con " + clientAddress);

            //* COMPLETAR: Cerrar flujos y socket
                
                try {
					in.close();
					out.close();
					client.close();
				} catch (IOException e) {
					System.err.println("Error cerrando la conexión: " + e.getMessage());
					System.exit(1);
				}
                
                
              System.out.println("STATUS: Conexión cerrada");
           
        } // fin del bucle
    } // fin del metodo
}
