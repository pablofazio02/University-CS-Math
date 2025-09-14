clear all;

D = load('handwriting.mat');
X = D.X;

[N, K] = size(X);
J = 10;

Y = zeros(N,J);

% Generate the Y Label (no tenemos la etiqueta de clase pero sí sabemos que
% van de 0 a 9 y que están ordenados cada 500 filas)
for i =1:10
    Y(1+(500*(i-1)):i*500,i) =1;
end

% Scale the data (te cargas los valores perdidos)
Xscaled = (X-min(X))./(max(X)-min(X));

% Remove the NaN elements
Xscaled = Xscaled(:,any(~isnan(Xscaled)));

% Compute again the number of total elements and attributes
[N, K] = size(Xscaled);

CVHO = cvpartition(N,'HoldOut',0.25);
% Genera indices para decirte que datos van a training y que datos van a test

XscaledTrain = Xscaled(CVHO.training(1),:);
XscaledTest = Xscaled(CVHO.test(1),:);
YTrain = Y(CVHO.training(1),:);
YTest = Y(CVHO.test(1),:);

% Create the validation set
[NTrain, K] = size(XscaledTrain);
CVHOV = cvpartition(NTrain,'HoldOut',0.25);
% Parto de nuevo para los hiperparámetros

% Generate the validation sets
XscaledTrainVal = XscaledTrain(CVHOV.training(1),:); % Fase de estimación de hiperparametros
XscaledVal = XscaledTrain(CVHOV.test(1),:); % Darle un valor de error asociado a ese hiperparametro
YTrainVal = YTrain(CVHOV.training(1),:);
YVal = YTrain(CVHOV.test(1),:);

% Performance Matrix
Performance = zeros(7,6);
i = 0;
j = 0;
sigma = 1;

for C = [10^(-3) 10^(-2) 10^(-1) 1 10 100 1000]
    i = i+1;
    for L = [50 100 500 1000 1500 2000]
        j = j+1;

        %% Construcción de la matriz del kernel

        Ker = zeros(L,L);

        for n = 1:L
            for k = 1:L
                Ker(n,k) = kernel(XscaledTrainVal(n,:), XscaledTrainVal(k,:), sigma);
            end
        end

        %% Inicialización de parámetros

        P = zeros(L+1,L+1);
        P_total = zeros(L+1,L+1,J);
        A = zeros(J,L+1);

        for j = 1:J

            Nj = sum(YTrainVal(:,j) == 1);

            %% Kj  = (K'(x), aquellos x con y = j) y tiene size Nj x L
            Kj = zeros(Nj, L);
            cont = 1;
            for n = 1:L
                if YTrainVal(n,j) == 1
                    Kj(cont,:) = Ker(n,:);
                    cont = cont + 1;
                end
            end

            Pj = [[Nj , -sum(Kj)] ; [-sum(Kj)', Kj'*Kj]];
            P_total(:, : ,j) = Pj;
            P = P + Pj;
        end

        for j = 1:J
            A(j,:) = eig(P, eye(L+1)*C + P_total(:,:,j));
        end

    end
    j=0;
end

Performance