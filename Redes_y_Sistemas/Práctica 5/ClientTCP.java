/**
 *
 * @author <Pablo Fazio Arrabal>
 */

import java.io.*;
import java.net.*;
import java.util.Scanner;

public class ClientTCP {

    public static void main(String[] args) throws IOException {
    	
        // DATOS DEL SERVIDOR:
        //* FIJOS: coméntelos si los lee de la línea de comandos
         String serverName = "127.0.0.1"; // direccion local
         int serverPort = 12345;
        //* VARIABLES: descoméntelos si los lee de la línea de comandos
        //String serverName = args[0];
        //int serverPort = Integer.parseInt(args[1]);

        // SOCKET
        Socket serviceSocket = null;

        // FLUJOS PARA EL ENVÍO Y RECEPCIÓN
        PrintWriter out = null;
        BufferedReader in = null;

        //* COMPLETAR: Crear socket y conectar con servidor
        
        try {
        	serviceSocket = new Socket(serverName, serverPort);
        }catch(SocketException e) {
        	System.err.println("Error creando el socket: " + e.getMessage());
        	System.exit(1);
        }

        //* COMPLETAR: Inicializar los flujos de entrada/salida del socket conectado en las variables PrintWriter  y BufferedReader

        try {
        	out = new PrintWriter(serviceSocket.getOutputStream(),true);
        }catch (IOException e) {
        	System.err.println("Error inicializando el flujo de salida: "  +e.getMessage());
        	System.exit(1);
        }
        
        try {
        	in = new BufferedReader(new InputStreamReader(serviceSocket.getInputStream()));
        }catch (IOException e) {
        	System.err.println("Error inicializando el flujo de entrada: "  +e.getMessage());
        	System.exit(1);
        }
        
        System.out.println("STATUS: Conectado al servidor.");
        
        //* COMPLETAR: Recibir mensaje de bienvenida del servidor y mostrarlo
        
        // Obtener texto por teclado
       BufferedReader stdIn = new BufferedReader(new InputStreamReader(System.in));
       String userInput;

       System.out.println("Introduzca un texto a enviar (TERMINAR para acabar)");
       userInput = stdIn.readLine();

        //* COMPLETAR: Comprobar si el usuario ha iniciado el fin de la interacciÃ³n
        while (userInput.compareTo("TERMINAR") != 0) { // bucle del servicio
            //* COMPLETAR: Enviar texto en userInput al servidor a travÃ©s del flujo de salida del socket conectado

        	out.println(userInput);
        	
            //* COMPLETAR: Recibir texto enviado por el servidor a travÃ©s del flujo de entrada del socket conectado
            String line = null;
            
            try {
            	line = in.readLine();
            }catch(IOException e) {
            	System.err.println("Error leyendo de buffer: " + e.getMessage());
        		System.exit(1);
            }
            
            System.out.println("Línea recibida: " + line);

            // Leer texto de usuario por teclado
            System.out.println("Introduzca un texto a enviar (TERMINAR para acabar)");
            userInput = stdIn.readLine();
        } // Fin del bucle de servicio en cliente

        // Salimos porque el cliente quiere terminar la interaccion, ha introducido TERMINAR
        //* COMPLETAR: Enviar END al servidor para indicar el fin deL Servicio
        
        System.out.println("STATUS: Cerrando la conexión con el servidor");
         
        out.println("END");

        //* COMPLETAR: Recibir el OK del Servidor
        
        String ok = in.readLine();
        
        System.out.println("STATUS: Cerrando ...");
      
        //* COMPLETAR Cerrar flujos y socket
        
        in.close();
        
        out.close();
        
        stdIn.close();
        
        try {
        	serviceSocket.close();
        }catch(Exception e) {
        	System.err.println("Error cerrando el socket: " + e.getMessage());
        	System.exit(1);
        
        }
        
        System.out.println("STATUS: Conexión cerrada");
    }
}
