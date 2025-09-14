filepath = "./portfolio1.txt";

% Read data from file
fileID = fopen(filepath, 'r');
N = str2double(fgetl(fileID)); % Number of assets

% Initialize arrays to store asset information
meanReturns = zeros(N, 1);
stdDeviations = zeros(N, 1);
correlationMatrix = zeros(N, N);

% Read mean returns and standard deviations for each asset
for i = 1:N
    assetData = str2double(strsplit(strtrim(fgetl(fileID)), ' '));
    meanReturns(i) = assetData(1);
    stdDeviations(i) = assetData(2);
end

% Read correlations between assets
while ~feof(fileID)
    line = strtrim(fgetl(fileID));
    if isempty(line)
        continue;
    end
    data = str2double(strsplit(line, ' '));
    i = data(1);
    j = data(2);
    correlation = data(3);
    correlationMatrix(i, j) = correlation;
    correlationMatrix(j, i) = correlation; % Correlation matrix is symmetric
end

fclose(fileID);

% - meanReturns: vector of mean returns for each asset
% - stdDeviations: vector of standard deviations for each asset
% - correlationMatrix: matrix of correlations between assets

% Calculamos matriz de covarianzas a partir de correlacion y desviaciones tipicas
cov = zeros(N, N);
for i = 1:1:N
    for j = 1:1:N
        cov(i, j) = correlationMatrix(i, j) * stdDeviations(i) * stdDeviations(j);
    end
end

% Parametros
T = 1000;               % Limite de optimización de portfolios generados
R = 50;                 % Limite de epocas para la red de Hopfield
dlambda = 0.1;          % Incremento de la aversion al riesgo
K = 6;                  % Assets a seleccionar
M = 100;                % Hiperparametro del modelo: numero de portfolios iniciales
eta = 0.1;              % Tasa de aprendizaje

epsilon = ones(N);     % Porcentaje minimo en la seleccion de un asset
delta = ones(N);       % Porcentaje maximo en la seleccion de un asset

% Asumiremos que epsilon y delta son iguales para todos los assets
epsilon = 0.01 .* epsilon;
delta = 1 .* delta;

% Conjunto de portfolios optimos
% La estructura de H es la siguiente:  H = [portfolio | valor portfolio] :: M x (N+1)
H = zeros(M, N+1);

for lambda = 0:dlambda:1

    % Construimos matriz de pesos y vector de sesgo de la red de Hopfield
    W = -2 * lambda .* sqrt(cov);
    b = (1-lambda) .* meanReturns;

    % Inicializamos aleatoriamente el conjunto de portfolios con K assets
    P = zeros(M, N);
    for i = 1:1:M
        assetsIndexes = datasample(1:N, K, 'Replace', false);
        for j = 1:1:K
            P(i, assetsIndexes(j)) = epsilon(assetsIndexes(j)) + (delta(assetsIndexes(j))-epsilon(assetsIndexes(j)))*rand();
        end
        % Normalizamos el portfolio
        % P(i) = normalize(P(i)); % TODO : Definir normalize
        
    end
    
    % Evaluamos portfolios y los guardamos en H
    Peval = zeros(M, 1);
    for i = 1:1:M
        for j = 1:1:N
            for k = 1:1:N
                Peval(i) = Peval(i) + lambda * P(i,j) * sqrt(cov(j,k)) * P(i,k) ;
            end
            Peval(i) = Peval(i) + (lambda-1) * (P(i,j) * meanReturns(j));
        end
    end

    H = [P Peval];

    for t = 1:1:T
    
        % Escogemos aleatoriamente un portfolio del conjunto
        PcanIndex = randi(M);
        Pcan = P(PcanIndex);
        
        % Tomamos los indices de 3*K/2 assets
        S = int16(3*K/2);
        Sindexes = datasample(1:N, S, 'Replace', false);

        for k = S:-1:K+1
            % Optimizamos con red de Hopfield
            X = zeros(N, R);
            X(:, 1) = Pcan;
            for e = 2:1:R
                X(:,e) = X(:,e-1);
                for i = 1:1:N
                    h = 0;
                    for j = 1:1:N
                      h = h + X(j,e) * W(i,j);
                    end
                    X(i, e) = X(i, e) + eta * Logistic(h - b(i)); % TODO : pasar todos los parametros a Logistic
                end
            end
            Popt = X(:, R)

            % Podamos peor neurona
            [Popt, Sindexes] = prune(Popt, Sindexes);  % TODO : Definir prune

            % Normalizamos el portfolio
            % Popt = normalize(Popt); % TODO : Definir normalize
        end
        % Optimizamos con red de Hopfield
        Popt = optimize(Pcan); % TODO : Definir optimize
        % Normalizamos el portfolio
        Popt = normalize(Pcan); % TODO : Definir optimize
        % Evaluamos portfolio
        Popt = (Pcan); % TODO : Definir optimize
        % Reemplazamos maximo portfolio
        % TODO
    end
end
