/*
  Estructuras de Datos
  Grado en Ingeniería Informática, del Software y de Computadores
  Tema 3. TAD Lineales
  Pablo López
*/

package referencias;

/**
 * <p>
 * En Haskell representamos las estructuras lineales mediante tipos algebraicos
 * recursivos. Por ejemplo, el tipo:
 * </p>
 * <p>
 * <pre>
 *         data Seq = Empty
 *                  | Node Int Seq
 * </pre>
 * </p>
 * <p>
 * permite construir secuencias de valores enteros como la siguiente:
 * </p>
 * <p>
 * <pre>
 *         Node 3 (Node 2 (Node 7 Empty))
 * </pre>
 * </p>
 * <p>
 * La estructura es lineal porque a cada dato {@code Node} le sucede otro dato
 * {@code Node}, excepto al último, al que le sucede {@code Empty} para señalar
 * el final de la secuencia.
 * </p>
 * <p>
 * Observa que el tipo {@code Seq} es recursivo:
 * </p>
 * <ul>
 *   <li>el caso base es {@code Empty}</li>
 *   <li>el caso recursivo es {@code Node}, que contiene una secuencia {@code Seq}
 *    como segundo argumento</li>
 * </ul>
 * <p>
 * En Java también es posible utilizar recursividad para representar estructuras
 * lineales. La idea es usar una clase recursiva {@code Node} que haga el papel
 * del constructor de datos {@code Node} de Haskell:
 * </p>
 * <p>
 * <pre>
 *         class Node {
 *             int elem;
 *             Node next;
 *         }
 * </pre>
 * </p>
 * <p>
 * La clase {@code Node} define dos atributos, uno por cada argumento del constructor
 * Haskell:
 * </p>
 * <ul>
 *     <li>{@code elem} es el entero almacenado</li>
 *     <li>{@code next} es una referencia al siguiente objeto {@code Node} de la secuencia</li>
 * </ul>
 * <p>
 * En Java no hace falta un constructor especial {@code Empty} para representar el
 * final de la secuencia: basta emplear la referencia {@code null} para indicar que
 * a un {@code Node} no le sigue ningún otro.
 * </p>
 */

public class NodosEnlazados {

    static class Node {  // semejante al constructor 'Node Int Seq' de Haskell
        int elem;        // el valor almacenado
        Node next;       // el siguiente en la secuencia (recursividad)

        public Node(int x, Node nextNode) {
            elem = x;
            next = nextNode;
        }
    }

    public static void main(String[] args) {
        /* el valor Haskell:

              Node 3 (Node 2 (Node 7 Empty))

           se puede representar en Java de la siguiente manera
           (observa que usamos 'null' en lugar de 'Empty')
         */

        Node first;
        first = new Node(3, new Node(2, new Node(7, null)));

        /* el siguiente bucle recorre la secuencia y escribe sus valores */

        Node p = first;
        while (p != null) {
            System.out.println(p.elem);
            p = p.next;
        }
    }
}
