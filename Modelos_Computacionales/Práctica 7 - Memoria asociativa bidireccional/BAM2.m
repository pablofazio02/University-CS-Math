%% BAM Asociando Texto con Dibujo

clear all;

% Cargar las matrices de patrones y textos de los datasets del enunciado
barco = load('barco.mat');
coche = load('coche.mat');
textoBarco = load('textoBarco.mat');
textoCoche = load('textoCoche.mat');

% Reshape y almacenamiento de los patrones y textos en las matrices X e Y
% Necesitamos convertirlo en vectores para poder calcular la matriz de
% pesos (W) mediante la regla de Hebb

X(1,:) = reshape(barco.barco, 1, size(barco.barco,1)*size(barco.barco,2));
X(2,:) = reshape(coche.coche, 1, size(coche.coche,1)*size(coche.coche,2));
Y(1,:) = reshape(textoBarco.textoBarco, 1, size(textoBarco.textoBarco,1)*size(textoBarco.textoBarco,2));
Y(2,:) = reshape(textoCoche.textoCoche, 1, size(textoCoche.textoCoche,1)*size(textoCoche.textoCoche,2));

% matrizBipolarGausiano=imnoise(X(1,:),'gaussian',0,0)*2-1; % Si no hay
% ruido obviamente la red se estabiliza bien

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
% sinit = matrizBipolarGausiano; % No nos dice por cual empezar, luego elegimos SInit = X(1,:)
sinit = X(1,:); % Dibujo barco
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
        subplot(3,1,1) 
        imshow(reshape(S(:,1), size(barco.barco,1), size(barco.barco,2)))
        subplot(3,1,2)
        imshow(reshape(S(:,epoc), size(barco.barco,1), size(barco.barco,2)))
        subplot(3,1,3)
        imshow(reshape(S2(:,epoc), size(textoBarco.textoBarco,1), size(textoBarco.textoBarco,2)))
        return
    end
end
