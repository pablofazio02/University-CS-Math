import prLibreria.LibreriaOfertaFlex;
import prLibreria.OfertaAutor;



public class PruebaLibreriaOfertaFlex {

	public static void main(String[] args) {
		
		String[] libros = new String [2];
		libros [0]="George Orwell";
		libros [1]="Isaac Asimov";
		
		OfertaAutor a = new OfertaAutor(20, libros);
		
		LibreriaOfertaFlex novedad = new LibreriaOfertaFlex(a);
		
		novedad.addLibro("george orwell", "1984", 8.20);
		novedad.addLibro("Philip K. Dick", "¿Sueñan los androides con ovejas eléctricas?", 3.50);
		novedad.addLibro("Isaac Asimov", "Fundación e Imperio", 9.40);
		novedad.addLibro("Ray Bradbury", "Fahrenheit 451", 7.40);
		novedad.addLibro("Aldous Huxley", "Un Mundo Feliz", 6.50);
		novedad.addLibro("Isaac Asimov", "La Fundación", 7.30);
		novedad.addLibro("William Gibson", "Neuromante", 8.30);
		novedad.addLibro("Isaac Asimov", "Segunda Fundación", 8.10);
		novedad.addLibro("Isaac Newton", "arithmetica universalis", 7.50);
		novedad.addLibro("George Orwell", "1984", 6.20);
		novedad.addLibro("Isaac Newton", "Arithmetica Universalis", 10.50);
		
		System.out.println (novedad);
		
		novedad.remLibro("George Orwell", "1984");
		novedad.remLibro("Aldous Huxley", "Un Mundo Feliz");
		novedad.remLibro("Isaac Newton", "Arithmetica Universalis");
		novedad.remLibro("James Gosling", "The Java Language Specification");
		
		System.out.println (novedad);
		
		System.out.println("PrecioFinal(George Orwell, 1984):"+novedad.getPrecioFinal("George Orwell", "1984"));
		System.out.println("PrecioFinal(Philip K. Dick, ¿Sueñan los androides con ovejas eléctricas?):"+novedad.getPrecioFinal("Philip K. Dick", "¿Sueñan los androides con ovejas eléctricas?"));
		System.out.println("PrecioFinal(isaac asimov, fundación e imperio):"+novedad.getPrecioFinal("isaac asimov", "fundación e imperio"));
		System.out.println("PrecioFinal(Ray Bradbury, Fahrenheit 451):"+novedad.getPrecioFinal("Ray Bradbury", "Fahrenheit 451"));
		System.out.println("PrecioFinal(Aldous Huxley, Un Mundo Feliz):"+novedad.getPrecioFinal("Aldous Huxley", "Un Mundo Feliz"));
		System.out.println("PrecioFinal(Isaac Asimov, La Fundación):"+novedad.getPrecioFinal("Isaac Asimov", "La Fundación"));
		System.out.println("PrecioFinal(william gibson, neuromante):"+novedad.getPrecioFinal("william gibson", "neuromante"));
		System.out.println("PrecioFinal(Isaac Asimov, Segunda Fundación):"+novedad.getPrecioFinal("Isaac Asimov", "Segunda Fundación"));
		System.out.println("PrecioFinal(Isaac Newton, Arithmetica Universalis):"+novedad.getPrecioFinal("Isaac Newton", "Arithmetica Universalis"));
		
		
	}

}
