% Problema N-Torres para N 
clear all;

% Inicialización de variables
tiempos_ejecucion = zeros(1, 30); % Almacena los tiempos promedio para cada N
repeticiones = 10; % Número de repeticiones por cada N

for N = 1:30
    tiempos_individuales = zeros(1, repeticiones); % Tiempos para cada repetición
    
    for r = 1:repeticiones
        tic; % Inicia el temporizador

        % Definir la matriz de pesos
        W = zeros(N, N, N, N);

        % Inicializamos los umbrales Theta
        Theta = zeros(N, N);
        Theta(:,:) = -1; % Theta vale -1 para todas las neuronas

        for i = 1:N
            for j = 1:N
                W(i, j, 1:N, j) = -2; % Conexiones con la fila j (todas)
                W(i, j, i, 1:N) = -2; % Conexiones con la columna i (todas)
                W(i, j, i, j) = 0; % Diagonal principal (Limpias las autoconexiones)
            end
        end

        % Número de iteraciones
        epoc = 20;

        % Almacena los estados históricos del tablero en cada iteración
        Shist = zeros(N, N, epoc);

        % Estado inicial del tablero
        estado_inicial = round(rand(N, N), 0);
        Shist(:,:,1) = estado_inicial;

        % Bucle para minimizar la energía
        for e = 2:epoc
            cambio = false;
            Shist(:, :, e) = Shist(:, :, e-1); % Cargar estado previo

            % Cálculo de cada casilla del tablero
            for i = 1:N
                for j = 1:N
                    h = 0;

                    % Cálculo del potencial sináptico
                    for l = 1:N
                        for k = 1:N
                            h = h + Shist(l, k, e) * W(i, j, l, k);
                        end
                    end

                    % Regla de actualización
                    Shist(i, j, e) = int16(h >= Theta(i, j));
                    cambio = cambio || Shist(i, j, e) ~= Shist(i, j, e-1);
                end
            end

            % Verificar convergencia
            if ~cambio
                break;
            end
        end

        tiempos_individuales(r) = toc; % Almacena el tiempo de la repetición
    end

    % Calcula el tiempo promedio para este N
    tiempos_ejecucion(N) = mean(tiempos_individuales);
end

% Función para graficar los puntos (N, tiempo_ejecucion)
function graficar_tiempos(tiempos)
    N = 1:30;
    plot(N, tiempos, '-o');
    xlabel('N');
    ylabel('Tiempo de ejecución promedio (segundos)');
    title('Tiempo promedio de ejecución vs N');
    grid on;
end

% Llamada a la función para graficar los tiempos de ejecución
graficar_tiempos(tiempos_ejecucion);
