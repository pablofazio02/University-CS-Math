% Problema N-Torres para N = 3
clear all;

% Inicialización de variable N = 3
N = 3;

% Definir la matriz de pesos. Son 4 variables ya que las dos primeras te dicen posición en tablero y
% las dos segundas con quién está conectada.

W = zeros (N, N, N, N);

% Para cada celda, inicializamos el umbral que tiene.

Theta = zeros (N,N);
Theta(:,:) = -1; % Theta vale -1 para todas las neuronas

for i = 1:1:N
    for j = 1:1:N
        W(i, j, 1:N, j) = -2; % Conexiones con la fila j (todas)
        W(i, j, i, 1:N) = -2; % Conexiones con la columna i (todas)
        W(i, j, i, j) = 0; % Diagonal principal (Limpias las autoconexiones)
    end
end


% Número de iteraciones que corre la dinámica de computación.
epoc = 20;

% Almacena los estados históricos del tablero en cada iteración.
% Esto sirve para poder ir comparando y ver como va variando el tablero

Shist = zeros(N, N, epoc);

% Estado inicial del tablero (enunciado)

estado_inicial = [0 1 1; 1 1 0; 0 1 0];
Shist(:,:,1) = estado_inicial;
E_actual = 0;

% Bucle para minimizar la energía
for e = 2:1:epoc
    cambio = false;
    E_antiguo = E_actual;
    Shist(:, :, e) = Shist(:, :, e-1); % cargo como punto inicial de esa iteración el estado del tablero del punto anterior

    % Cálculo de cada casilla del tablero
    for i = 1:1:N
        for j = 1:1:N

            h = 0;
            % Cálculo del potencial sináptico (conexiones de una casilla
            % concreta)

            % Conexiones
            for l = 1:1:N
                for k = 1:1:N
                    % h += estado de esa neurona * peso dado de esa neurona
                    % conectado con la neurona (l,k) [Potencial sináptico]
                    h = h + Shist(l, k, e) * W(i, j, l, k);
                end
            end

            % Almacena el potencial sináptico de la neurona que se está actualizando en cada momento
            H(i, j) = h;

            % Regla de actualización
            Shist(i, j, e) = int16(h >= Theta(i, j));
            % int16 te lo convierte en el formato matemático de MATLAB

            cambio = cambio || Shist(i,j,e) ~= Shist(i,j,e-1);
        end
    end

    % ¿Qué sentencia pondrías en Matlab para calcular el diferencial de energía que se produce después de actualizar una neurona?
    % Se calcula la energía de la neurona en el estado actual y en el estado anterior y se resta una de la otra.
    % E(i) = -1/2 * Sum_i Sum_j (Wij * si *sj) - Sum (si)

    E_actual = (-1/2)*sum(sum(W(i,j,:,:)*Shist(i,j,e)*Shist(j,i,e))) - sum(sum(Shist(:,:,e)));
    delta_E = E_actual - E_antiguo

    % Verificar si hay cambio en el histórico
    % Si no hay cambio, significa que converge a un optimo local

    if ~cambio
        % Imprimir el tablero una vez obtengo solución
        Shist(:,:,e)
        e
        return;
    end

end


