% Ejercicio 2 - Asociador No Lineal Simple

clear all;

% Patrón que queremos memorizar
s = [-1 -1 1 1 1];

% Número máximo de iteraciones del algoritmo
epoc = 21;

% Matriz de pesos (mediante la regla de Hebb) con N = 1 y K = size(s,2)
w = (1/size(s, 2)) * s' * s;

% Resta a w la diagonal de esa misma matriz, el segundo diag es para
% convertir en matriz el vector diagonal (para que wii = 0 y no haya autoconexiones)
w = w - diag(diag(w));

S = zeros(size(s,2), epoc);
% Estado inicial de la red para el apartado b)
S(:,1) = [1 1 -1 -1 1];

% Corremos la dinámica de la computación
for t = 2:1:epoc

    cambio = false;
    S(:,t) = S(:,t-1);

    for i = 1:1:size(s,2)
        % Calcular la entrada neta para cada neurona
        h = sum(S(:,t)'.*w(i,:), "all");
        % Pasamos de un formato binario a bipolar
        S(i, t) = (h > 0) * 2 - 1;
        cambio = cambio || S(i, t) ~= S(i, t-1);
    end

    if ~cambio
        disp("Estado estabilizado = ");
        disp(S(:, t-1));
        return
    end
end