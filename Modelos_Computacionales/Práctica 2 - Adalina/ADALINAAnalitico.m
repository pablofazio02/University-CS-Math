clear all;
clc;
close all;

%load DatosAND
%load DatosLS5
%load DatosLS10
%load DatosLS50
%load DatosOR
load DatosXOR

%FLUJO ALGORÍTMICO - Diapositiva 24 

% Tomamos todas las filas y columnas menos la última columna
X = Data(: , 1:end-1);

% Tomamos la última columna del dataset (clase real)
Y = Data(:,end);

% Número de atributos (columnas - 1)
K = size(Data,2) - 1; 
% Número de patrones de la base de datos (filas)
N = size(Data, 1);

% Extendemos la matriz de entradas con un vector
% en la última columna con 1s (para los sesgos) - Flujo algoritmico -
% Linea 1
Xext = [X, -ones(N,1)];

% N*(K+1) = 4 3
% size(Xext)

% Calcumaos la W - Flujo algorítmico Linea 2
w1 = inv(Xext'*Xext)*Xext'*Y;

% w2 = pinv(Xext)*Y; 
% inv(Xext'*Xext)*Xext' es la pseudoinversa de Monpenrose
% de Xext, luego podemos definirlo en MATLAB como pinv(Xext)

% size(w)

% Y_Gorro = Predicted (X*w)
Y_Predicted = Xext * w1;

% Los valores en continuo los pasamos a discreto. La función Sigmo también
% está definida para vectores.
Label = Signo(Y_Predicted);

% Label == Y devuelve un vector de booleanos (1 y 0s) si coinciden por cada
% componente entre los vectores o no.

% CCR = Correct Clasification Rate // Ratio de patrones bien clasificados
% Cuantas coordenadas en el vector tienen la Y con nuestra predicción y divimos entre el total
ccr = (sum(Label == Y))/N

% Que minimice el ECM no significa que sea cero, por mucho que el CCR sea
% 100, nos sale ECM = 0.25 (Caso AND)

ECM = ((norm(Y - Y_Predicted, 2))^2)/N