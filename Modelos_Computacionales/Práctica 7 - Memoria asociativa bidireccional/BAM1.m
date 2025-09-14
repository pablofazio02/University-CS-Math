%% EJEMPLO BAM - DIAPOSITIVAS

clear all;

% Definimos los patrones a memorizar y sus salidas
X(1, :) =  [1 1 1 -1 1 -1 -1 1 -1];
X(2, :) =  [1 -1 -1 1 -1 -1 1 1 1];
Y(1, :) =  [1 -1 -1];
Y(2, :) =  [-1 -1 1];

% Inicialización de la matriz de pesos (W) usando la regla de Hebb
W = X' * Y;

% Número máximo de iteraciones de la dinámica de computación
epocMax = 21;

% Definir momentos históricos de X
S = zeros(size(X,2), epocMax); % size(X,2) = K

% Definir momentos históricos de Y
S2 = zeros(size(Y,2), epocMax); % size(Y,2) = J

% Necesitamos dos momentos ya que es una estructura heteroasociativa

% Inicialización del estado de la red en la primera época
sinit = [-1 -1 -1 -1 -1 -1 1 -1 -1]; % No nos dice por cual empezar, luego elegimos SInit = X(2,:) (nos debe salir de salida Y(2,:))
s2init = sign(sinit * W); % ya que W = X'*Y
S(:,1) = sinit;
S2(:,1) = s2init;

for epoc = 2:1:epocMax
    % Actualización del estado de la red en ambas direcciones
    S(:, epoc) = sign(W*S2(:, epoc-1));
    S2(:, epoc) = sign(S(:, epoc)' * W);
    
    % ¿Cuándo habrá convergencia?
    if (sum(S(:, epoc) == S(:, epoc-1)) == size(X, 2)) && (sum(S2(:, epoc) == S2(:, epoc-1)) == size(Y, 2)) % Cuando el estado no cambie en cualquier caso
        
        % Si la red converge, se muestra el resultado y se termina el bucle
        epoc
        disp("S(:, epoc) = ");
        disp(S(:, epoc));
        disp("S2(:, epoc) = ");
        disp(S2(:, epoc));
        return
    end
end