% Ejercicio 1 - Asociador Lineal

% Vamos a hacer dos veces el ejercicio, una vez dándole la propiedad de
% ortonormalidad a los vectores de entrada y sin ella

%% CONDICIÓN DE ORTONORMALIDAD
clear all;

disp("Con condición de ortonormalidad");

% Definir matrices aleatorias para los patrones de entrada (X) y salida (Y)
% Cuatro patrones y dimensión 2/5

X = rand(4, 5);
Y = rand(4, 2);

% Aplicamos la transformación para que sean ortonormales
% Si hay más dimensiones que patrones 
X = orth(X.')';
% Si hay más patrones que dimensiones

% Regla de Hebb
W = X' * Y;

% Debemos comprobar que coinciden estas matrices:
disp("Valores reales = ");
disp(Y); 
disp("Valores estimados = ");
disp(X*W);

%% SIN CONDICIÓN DE ORTONORMALIDAD
clear all;

disp("Sin condición de ortonormalidad");

% Definir matrices aleatorias para los patrones de entrada (X) y salida (Y)
% Cuatro patrones y dimensión 2 ó 5

X = rand(4, 5);
Y = rand(4, 2);

% Aquí no aplicaremos la transformación para que sean ortonormales

W = X' * Y;

% Ahora las matrices NO coinciden
disp("Valores reales = ");
disp(Y); 
disp("Valores estimados = ");
disp(X*W);

 


