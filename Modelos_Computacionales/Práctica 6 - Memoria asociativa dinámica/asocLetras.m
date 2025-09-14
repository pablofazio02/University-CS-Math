% Ejercicio 3 - Asociador No Lineal Simple II

clear all;
clc;

d(:,:,1) = [1 1 -1 -1 -1 1 1; 
            1 1 -1 1 -1 1 1;
            1 1 -1 1 -1 1 1;
            1 1 -1 1 -1 1 1;
            1 -1 -1 -1 -1 -1 1;
            1 -1 1 1 1 -1 1;
            1 -1 1 1 1 -1 1;
            1 -1 1 1 1 -1 1;
            -1 -1 1 1 1 -1 -1;];

d(:,:,2) = [1 -1 -1 -1 -1 -1 1; 
            1 -1 1 1 1 1 -1;
            1 -1 1 1 1 1 -1;
            1 -1 1 1 1 1 -1;
            1 -1 -1 -1 -1 -1 1;
            1 -1 1 1 1 1 -1;
            1 -1 1 1 1 1 -1;
            1 -1 1 1 1 1 -1;
            1 -1 -1 -1 -1 -1 1;];

d(:,:,3) = [1 -1 -1 -1 -1 -1 -1; 
            -1 1 1 1 1 1 1;
            -1 1 1 1 1 1 1;
            -1 1 1 1 1 1 1;
            -1 1 1 1 1 1 1;
            -1 1 1 1 1 1 1;
            -1 1 1 1 1 1 1;
            -1 1 1 1 1 1 1;
            1 -1 -1 -1 -1 -1 -1;];

d(:,:,4) = [1 -1 -1 -1 -1 -1 1; 
            1 -1 1 1 1 1 -1;
            1 -1 1 1 1 1 -1;
            1 -1 1 1 1 1 -1;
            1 -1 1 1 1 1 -1;
            1 -1 1 1 1 1 -1;
            1 -1 1 1 1 1 -1;
            1 -1 1 1 1 1 -1;
            1 -1 -1 -1 -1 -1 1;];

d(:,:,5) = [-1 -1 -1 -1 -1 -1 -1; 
            -1 1 1 1 1 1 1;
            -1 1 1 1 1 1 1;
            -1 1 1 1 1 1 1;
            -1 -1 -1 -1 -1 -1 1;
            -1 1 1 1 1 1 1;
            -1 1 1 1 1 1 1;
            -1 1 1 1 1 1 1;
            -1 -1 -1 -1 -1 -1 -1;];

% Las letras están en formato matricial, pero internamente vamos a trabajar
% por vectores

% Número máximo de iteraciones del algoritmo
epoc = 21;

% Las letras tienen 9 filas y 7 columnas
w = zeros(9*7, 9*7);

% No podemos trabajar con la regla de Hebb en matrices, por eso vamos a ir
% pasando esta matriz a vector
dVect = zeros(5, 9*7);

% Calcular la matriz de pesos sumando los productos externos de los
% patrones y luego multiplicandolo por 1/K

for i = 1:5
    dVect(i, :) = reshape(d(:,:,i), 1, 9*7); % Permite pasar de matrices a vectores
    w = w + dVect(i, :)' * dVect(i, :); % regla de Hebb - parte del sumatorio
end

w = (1/size(w,1)) * w; % regla de Hebb - parte de 1/K
w = w - diag(diag(w)); % quita autoconexiones


% Bucle para probar cada patrón como entrada
for k = 1:5
    S = zeros(size(w,1), epoc);
    S(:, 1) = dVect(k, :);

    disp("Modelo inicial para el patrón " + char('A' + k - 1))
    disp(reshape(S(:, 1), 9, 7))
    
    % Bucle de iteraciones
    for t = 2:epoc
        cambio = false;
        S(:, t) = S(:, t-1);
        
        % Actualización de la red
        for i = 1:size(S, 2)
            h = sum(S(:, t)' .* w(i, :), 'all');
            S(i, t) = (h > 0) * 2 - 1;
            cambio = cambio || S(i, t) ~= S(i, t-1);
        end
        
        % Comprobar si la red se ha estabilizado
        if ~cambio
            disp("Modelo final para el patrón " + char('A' + k - 1))
            disp(reshape(S(:, t), 9, 7))
            break
        end
    end
end