

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.*;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

/**
 *
 * @author Pablo Fazio Arrabal
 */

public class ClientUDP {
    public static void main(String[] args) throws IOException {
    	
        // DATOS DEL SERVIDOR:
    	
        //* FIJOS: coméntelos si los lee de la línea de comandos
        String serverName = "127.0.0.1"; //direccion local
        int serverPort = 54322;
    	
        //* VARIABLES: descomentelos si los lee de la línea de comandos
        //String serverName = args[0];
        //int serverPort = Integer.parseInt(args[1]);

        DatagramSocket serviceSocket = null;
        
        try {
            serviceSocket = new DatagramSocket();
        }catch(SocketException e) {
        	System.err.println("Error creando el socket: " + e.getMessage());
        }

        // INICIALIZA ENTRADA POR TECLADO
        BufferedReader stdIn = new BufferedReader( new InputStreamReader(System.in) );
        String userInput;
        System.out.println("Introduzca un texto a enviar (FINALIZAR para acabar): ");
        userInput = stdIn.readLine(); /*CADENA ALMACENADA EN userInput*/

       
        while (userInput.compareTo("FINALIZAR") != 0)
        {
        	
        	DatagramPacket datagram = null;
        	
        	try {
        		datagram = new DatagramPacket(userInput.getBytes(), userInput.getBytes().length, InetAddress.getByName(serverName), serverPort);
        	}catch(Exception e) {
        		System.err.println("Error creando el datagrama: " + e.getMessage());
        	}

         
        	try {
        		serviceSocket.send(datagram);
        	}catch(IOException e) {
        		System.err.println("Error enviando el datagrama: " +e.getMessage());
        	}

            System.out.println("STATUS: Waiting for the reply");
            
            
            byte[] array = new byte[500];
            
            DatagramPacket datagramrp = null;
            
            try {
            	datagramrp = new DatagramPacket(array, array.length);
            }catch (Exception e) {
            	System.err.println("Error creando el datagrama de recepción: " +e.getMessage());
            }
            
            try {
        		serviceSocket.receive(datagramrp);
        	}catch(IOException e) {
        		System.err.println("Error recibiendo el datagrama: " +e.getMessage());
        	}
       
            
            String line = new String(datagramrp.getData(), datagramrp.getOffset(), datagramrp.getLength(), StandardCharsets.UTF_8);

            System.out.println("echo: " + line);
            System.out.println("Introduzca un texto a enviar (FINALIZAR para acabar): ");
            userInput = stdIn.readLine();
        }

        System.out.println("STATUS: Closing client");

        serviceSocket.close();

        System.out.println("STATUS: closed");
    }
}
