clear;
clc;
close all;

%load DatosAND
%load DatosLS5
%load DatosLS10
%load DatosLS50
%load DatosOR
load DatosXOR

LR=0.02;
Limites=[-1.5, 2.5, -1.5, 2.5];
MaxEpoc=30;

% Inicializo un vector de pesos W = [0,0,0]'  
W = zeros(3,1);

ECM = zeros(MaxEpoc-1,1); % El bucle empieza en 1, luego hace maxEpoc-1 iteraciones como mucho

Epoc=1;

while ~CheckPattern(Data,W) && Epoc<MaxEpoc
   errorTotal = 0;
     for i=1:size(Data,1)
        [Input,Output,Target]=ValoresIOT(Data,W,i);
        
       % Cuando estamos estimando los parametros por un algoritmo por
       % descenso de gradiente, es crucial que el error que optimizamos
       % (ECM) sea justo el valor que comparemos con la salida esperada.
       % Estamos representando JUSTO el error real en cada iteración.

        errorTotal = errorTotal + (Output - Target)^2;
       
        GrapDatos(Data,Limites);
        GrapPatron(Input,Output,Limites);
        GrapNeuron(W,Limites);hold off;
        drawnow
%         pause;

        if Signo(Output) ~= Target
            W=UpdateNet(W,LR,Output,Target,Input);
        end

        
        GrapDatos(Data,Limites);
        GrapPatron(Input,Output,Limites)
        GrapNeuron(W,Limites);hold off;
        drawnow
%         pause;
     
     end
    % ECM = error cuadrático acumulado / número muestras
    ECM(Epoc,1) = errorTotal / size(Data,1);
    Epoc=Epoc+1;
end

ECM

plot(ECM);
title('Valores ECM (XOR)');
xlabel('Epocs');
ylabel('Error Cuadratico Medio');
grid(on);


% NOTA: el ECM debería ser decreciente en cada epoch. Con dataAND y learning rate LR=0.5, 
% no ocurre eso. Para ello, debería bajar el LR. El ECM se mantiene
% constante cuando no se encuentra solución.
	