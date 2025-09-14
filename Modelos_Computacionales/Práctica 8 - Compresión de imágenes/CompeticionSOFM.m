
% Muestras son los píxeles de los que vamos a calcular su centroide (3
% filas y tantas columnas como píxeles que haya en la imagen)

function Ganadoras=CompeticionSOFM(Model, Muestras)
    [~,numMuestras] = size(Muestras);

    % Daremos la neurona ganadora de forma que relacionemos el pixel con su
    % clúster, inicializamos el vector
    Ganadoras = zeros(numMuestras, 1);

    % Para saber el número de neuronas (J) en las redes de Kohonen
    %hay que calcular el número de filas y columnas de los grid de Kohonen
    numColsMapa = Model.NumColsMapa;
    numFilasMapa = Model.NumFilasMapa;
    numNeuronas = numColsMapa*numFilasMapa;
    
    

    for i=1:numMuestras

        MiMuestra = Muestras(:,i);
        Potenciales = zeros(1, numNeuronas);

        for j = 1:numNeuronas
           % Extraemos los pesos (medias) de la neurona j
           wj = Model.Medias(:, j);
           % Calculamos el producto escalar <wj, MiMuestra>
           producto_escalar = dot(wj, MiMuestra);
           % Calculamos la norma al cuadrado de wj (es decir, <wj, wj>)
           norma_wj_cuadrado = dot(wj, wj);
           % Calculamos el potencial hj(xn)
           Potenciales(j) = producto_escalar - 0.5 * norma_wj_cuadrado;
        end
        
        [~, NdxGanadora] = max(Potenciales); % Devuelve [minimo (dist entre neurona ganadora y pixel), indice del minimo en el vector] -> nos quedamos con lo segundo
        Ganadoras(i) = NdxGanadora;
    end
end