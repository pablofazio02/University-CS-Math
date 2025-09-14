function [Input,Output,Target] = ValoresIOT(Data,W,i) 
% Para coger la entrada, hay que tomar la fila i y todas las columnas menos
% la última que es la variable dependiente (etiqueta de clase).
    Input = Data(i, 1:end-1);
% Aquí tomamos el valor objetivo que es simplemente la última columna de la
% fila i.
    Target = Data(i, end);
% Para el cálculo de la salida, calculamos la multiplicación 
% de los pesos con las entradas menos la del sesgo. (Iual que el perceptrón pero NO HAY FUNCIÓN SIGNO)
    Output = Input*W(1:end-1) - W(end); % W(end) = teta // Linea 7 - Flujo algorítmico
end