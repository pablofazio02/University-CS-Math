
import java.io.IOException;
import java.net.*;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

/**
 *
 * @author Pablo Fazio Arrabal
 */

public class ServerUDP {
	
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
        int port = 54322; // puerto del servidor
    	
        //* VARIABLE: Si se lee de línea de comando debe descomentarse
        //int port = Integer.parseInt(args[0]); // puerto del servidor

        // SOCKET
        DatagramSocket server = null;
        
        try {
            server = new DatagramSocket(port);
        }catch(SocketException e) {
        	System.err.println("Error creando el socket: " +e.getMessage());
        }
      
        
        // Funcion PRINCIPAL del servidor
        while (true)
        {
            
        	byte[] array = new byte[500];
            
            DatagramPacket datagramrp = null;
            
            try {
            	datagramrp = new DatagramPacket(array, array.length);
            }catch (Exception e) {
            	System.err.println("Error creando el datagrama de recepción: " +e.getMessage());
            }       
            
            try {
        		server.receive(datagramrp);
        	}catch(IOException e) {
        		System.err.println("Error recibiendo el datagrama: " +e.getMessage());
        	}
            
           
            String line = new String(datagramrp.getData(),datagramrp.getOffset(), datagramrp.getLength(), StandardCharsets.UTF_8);
            
            int puerto = datagramrp.getPort();
            
            InetAddress IP = datagramrp.getAddress();
            
            System.out.println(line + " - Socket Adress: " + IP + " Port: " + puerto);
            
            // Capitalizamos la linea
            line = capitalize(line);
            
            byte[] arr = line.getBytes(StandardCharsets.UTF_8);

            DatagramPacket datagram = null;
        	
        	try {
        		datagram = new DatagramPacket(arr, arr.length, IP, puerto);
        	}catch(Exception e) {
        		System.err.println("Error creando el datagrama.");
        	}
            
        	try {
        		server.send(datagram);
        	}catch(IOException e) {
        		System.err.println("Error enviando el datagrama: " + e.getMessage());
        	}
        	

        } // Fin del bucle del servicio
    }

}
