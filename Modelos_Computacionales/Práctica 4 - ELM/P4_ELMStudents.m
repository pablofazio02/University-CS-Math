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
% Estimate the hyper-parameters values
for C = [10^(-3) 10^(-2) 10^(-1) 1 10 100 1000]
    i = i+1;
    for L = [50 100 500 1000 1500 2000]
        j = j+1;
        
        %% Validación anidada
        % Implementar el ELM neuronal, calcular el rendimiento asociado a C
        % y L

        t = 2*rand(L,K) - 1;

        u = XscaledTrainVal*t';

        H = 1 ./ (1 + exp(-u));

        w = inv((eye(L)/C) + (H'*H))*H'*YTrainVal;
        
        H_val = 1 ./(1 + exp(-XscaledVal*t'));

        Yval_estimated = H_val*w;

        % Cálculo del CCR
        [~, pred] = max(Yval_estimated, [], 2);
        [~, actual] = max(YVal, [], 2);
        Performance(i,j) = sum(pred == actual) / length(actual);
        
    end
    j=0;
end

Performance;

C = [10^(-3) 10^(-2) 10^(-1) 1 10 100 1000];
L = [50 100 500 1000 1500 2000];

[maxValue, linearIndexesOfMaxes] = max(Performance(:));
[rowsOfMaxes colsOfMaxes] = find(Performance == maxValue);

Copt = C(rowsOfMaxes(1))
Lopt = L(colsOfMaxes(1))

%% Modelo ELM como conjunto completo de entrenamiento
% Calcular con el conjunto de entrenamiento el ELM neuronal y
% reportar el error cometido en test

% Diapositiva 22 - Sesión ELM

NewCol = -1*ones(size(XscaledTrain,1),1);
XscaledTrain = [XscaledTrain NewCol];

NewCol = -1*ones(size(XscaledTest,1),1);
XscaledTest = [XscaledTest NewCol];

t = 2*rand(Lopt,K+1) - 1;

u = XscaledTrain*t';
H = 1 ./ (1+exp(-u))
w = inv((eye(Lopt)/Copt) + H'*H)*H'*YTrain;

H_test = 1./(1+exp(-XscaledTest*t'));
Y_Test_estimated = H_test*w;

% Cálculo del CCR y MSE
[~, predTest] = max(Y_Test_estimated, [], 2);
[~, actualTest] = max(YTest, [], 2);

CCR = sum(predTest == actualTest) / length(actualTest)

MSE = mean((Y_Test_estimated - YTest).^2, 'all')