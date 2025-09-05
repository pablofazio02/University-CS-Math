/*
  Estructuras de Datos
  Grado en Ingeniería Informática, del Software y de Computadores
  Tema 3. TAD Lineales
  Pablo López
*/

package colas;

import dataStructures.queue.LinkedQueue;
import dataStructures.queue.Queue;

public class QueueClient {
    public static void main(String[] args) {
        Queue<Integer> q = new LinkedQueue<>();

        q.enqueue(4);
        q.enqueue(7);
        q.enqueue(1);
        q.enqueue(3);

        System.out.println(q);

        while (!q.isEmpty()) {
            System.out.println(q.first());
            q.dequeue();
        }
    }
}
