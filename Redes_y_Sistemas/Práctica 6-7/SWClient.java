package es.uma.rysd.app;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;

import javax.net.ssl.HttpsURLConnection;

import com.google.gson.Gson;

import es.uma.rysd.entities.Person;
import es.uma.rysd.entities.Planet;
import es.uma.rysd.entities.ResourceCountResponse;
import es.uma.rysd.entities.SearchResponse;
import es.uma.rysd.entities.Starship;

public class SWClient {
	
	// Nombre de la aplicaci�n 
    private final String app_name = "My SW Client v0.1";
    private final int year = 2022;
    
    private final String url_api = "https://swapi.dev/api/";

    // M�todos auxiliares facilitados
    
    // Obtiene la URL del recurso id del tipo resource
	public String generateEndpoint(String resource, Integer id){
		return url_api + resource + "/" + id + "/";
	}
	
	// Dada una URL de un recurso obtiene su ID
	public Integer getIDFromURL(String url){
		String[] parts = url.split("/");

		return Integer.parseInt(parts[parts.length-1]);
	}
	
	// Consulta un recurso y devuelve cu�ntos elementos tiene
	
	/*
	 * Debemos comentar que el m�todo devuelve el n�mero m�ximo de recurso alcanzado pero,
	 * existen diferentes recursos que no tienen algunos n�meros asignados en el intervalo
	 * [1-getNumberOfResources(resource)]. Cuando ocurra esto y usemos el m�todo getX ocurrir�
	 * que al tomar en Main.java un aleatorio en este intervalo dar� lugar, a veces, a c�digos de 
	 * respuesta de la forma: 404, NOT FOUND.
	 * 
	 */
	
	public int getNumberOfResources(String resource){    
		
		String urlName = url_api + resource + "/";
		
		int number = 0;
		
		try {
			
			URL url = new URL(urlName);
		
			HttpsURLConnection connection = (HttpsURLConnection) url.openConnection();
    	
			connection.addRequestProperty("User-Agent", app_name + "-" + year);
			connection.addRequestProperty("Accept", "application/json");
    	
			connection.setRequestMethod("GET");
			
			int responseCode = connection.getResponseCode();
			
			if(responseCode/100 != 2) {
				System.err.println("Incorrect answer: " + connection.getResponseCode() + " " + connection.getResponseMessage());
				return 0;
			}
  
        Gson parser = new Gson();
        InputStream in = connection.getInputStream();
        ResourceCountResponse c = parser.fromJson(new InputStreamReader(in), ResourceCountResponse.class);
        number = c.count;
        connection.disconnect();
        
		} catch (MalformedURLException e) {
			System.err.println("Non Valid URL");
			return 0;
		}catch (IOException e) {
			System.err.println("Error: " + e.getMessage());
			return 0;
		}
		
        return number;
	}
	
	// Completaremos datos de una persona en concreto que tomamos para las preguntas en Main.java
	
	/*
	 * Person.java tambi�n tiene argumentos vac�os que podremos completar en funci�n de lo que necesitamos
	 * como son "homeplanet" o "naves" en nuestro caso. Este m�todo tomar� los par�metros de cada dato y usar�
	 * nuestros m�todos getX para incluirlo directamente como el tipo de dato y no con el formato swapi.dev/api/resource/n.
	 * 
	 */
	
	private void completePersonData(Person p) {
		
		if(p == null) {
			return;
		}
		
		if(p.homeworld != null) {
			p.homeplanet = getPlanet(p.homeworld);
		}
		
		if(p.starships != null) {
			
			p.naves = new Starship[p.starships.length];
			int i = 0;
			for(String star : p.starships) {
				p.naves[i] = getStarship(star);
				i++;
			}
			
		}
	}
	
	// Dada una url del tipo swapi.dev/api/person/n devolver� un objeto de la clase Person.java
	
	public Person getPerson(String urlname) {
		
    	Person p = null;
    	
    	// Por si acaso viene como http la pasamos a https
    	
    	urlname = urlname.replaceAll("http:", "https:");
		
    	try {
    		
    		// Creaci�n URL
			
			URL url = new URL(urlname);
			
			// Apertura conexi�n
			
			HttpsURLConnection connection = (HttpsURLConnection) url.openConnection();
			
			// A�adir propiedades
			
			connection.addRequestProperty("User-Agent", app_name + "-" + year);
			connection.addRequestProperty("Accept", "application/json");
			
			// Conexi�n por peticiones ("GET")
    	
			connection.setRequestMethod("GET");
			
			// Conocer el c�digo de la respuesta
			
			int responseCode = connection.getResponseCode();
			
			// Necesitamos un c�digo de respuesta de la forma 2XX.
			
			if(responseCode/100 != 2) {
				System.err.println("Incorrect answer: " + connection.getResponseCode() + " " + connection.getResponseMessage());
				return null;
			}
			
		// Conversi�n de formato JSON a objeto Java
			
		Gson parser = new Gson();
		p = parser.fromJson(new InputStreamReader(connection.getInputStream()), Person.class);
		
		completePersonData(p);
		
		// Cierre de conexi�n
		
		connection.disconnect();

    	} catch (MalformedURLException e) {
			System.err.println("Non Valid URL");
			return null;
		}catch (IOException e) {
			System.err.println("Error: " + e.getMessage());
			return null;
		}
		
    	return p;
	}
	
	// Dada una url del tipo swapi.dev/api/planet/n devolver� un objeto de la clase Planet.java

	public Planet getPlanet(String urlname) {
		
    	Planet p = null;
    	
    	// Por si acaso viene como http la pasamos a https
    	
    	urlname = urlname.replaceAll("http:", "https:");
    	
    	try {
			
			URL url = new URL(urlname);
			
			HttpsURLConnection connection = (HttpsURLConnection) url.openConnection();
			
			connection.addRequestProperty("User-Agent", app_name + "-" + year);
			connection.addRequestProperty("Accept", "application/json");
    	
			connection.setRequestMethod("GET");
			
			int responseCode = connection.getResponseCode();
			
			// Necesitamos un c�digo de respuesta de la forma 2XX.
			
			if(responseCode/100 != 2) { 
				System.err.println("Incorrect answer: " + connection.getResponseCode() + " " + connection.getResponseMessage());
				return null;
			}
			
		Gson parser = new Gson();
		p = parser.fromJson(new InputStreamReader(connection.getInputStream()), Planet.class);
		
		connection.disconnect();
		
    	} catch (MalformedURLException e) {
			System.err.println("Non Valid URL");
			return null;
		}catch (IOException e) {
			System.err.println("Error: " + e.getMessage());
			return null;
		}
    	
        return p;
	}
	
	// Dado un nombre se devolver� un objeto Person.java con dicho nombre como par�metro

	public Person search(String name) {
		
    	Person p = null;
    	
    	try {
    		
    		// Creaci�n nueva URL para b�squeda por nombre de persona
    		
    		String urlName = url_api + "/people/?search=" + URLEncoder.encode(name, "utf-8");
    	
    		URL url = new URL(urlName);
			
			HttpsURLConnection connection = (HttpsURLConnection) url.openConnection();
			
			connection.addRequestProperty("User-Agent", app_name + "-" + year);
			connection.addRequestProperty("Accept", "application/json");
    	
			connection.setRequestMethod("GET");
			
			int responseCode = connection.getResponseCode();
			
			// Necesitamos un c�digo de respuesta de la forma 2XX.
			
			if(responseCode/100 != 2) {
				System.err.println("Incorrect answer: " + connection.getResponseCode() + " " + connection.getResponseMessage());
				return null;
			}
	    	
			Gson parser = new Gson();
			
			SearchResponse r = parser.fromJson(new InputStreamReader(connection.getInputStream()), SearchResponse.class);
			
        	p = r.results[0];
        	
        	completePersonData(p);
        	
        	connection.disconnect();
    	
    	}catch(Exception e) {
    		System.err.println("Error: " + e.getMessage());
    	}
    	
        return p;
    }
	
	// Dada una url del tipo swapi.dev/api/starship/n devolver� un objeto de la clase Starship.java
	
	public Starship getStarship(String urlname) {
		
		Starship p = null;
		
		// Por si acaso viene como http la pasamos a https
    	
    	urlname = urlname.replaceAll("http:", "https:");
    	
    	try {
			
			URL url = new URL(urlname);
			
			HttpsURLConnection connection = (HttpsURLConnection) url.openConnection();
			
			connection.addRequestProperty("User-Agent", app_name + "-" + year);
			connection.addRequestProperty("Accept", "application/json");
    	
			connection.setRequestMethod("GET");
			
			int responseCode = connection.getResponseCode();
			
			// Necesitamos un c�digo de respuesta de la forma 2XX.
			
			if(responseCode/100 != 2) {
				System.err.println("Incorrect answer: " + connection.getResponseCode() + " " + connection.getResponseMessage());
				return null;
			}
			
		Gson parser = new Gson();
		p = parser.fromJson(new InputStreamReader(connection.getInputStream()), Starship.class);
		
		connection.disconnect();
		
    	} catch (MalformedURLException e) {
			System.err.println("Non Valid URL");
			return null;
		}catch (IOException e) {
			System.err.println("Error: " + e.getMessage());
			return null;
		}
    	
        return p;
	}

}
