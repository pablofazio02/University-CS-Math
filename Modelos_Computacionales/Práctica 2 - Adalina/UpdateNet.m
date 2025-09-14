% No varía con UpdateNet.m del Perceptron Simple

function WN = UpdateNet(W,LR,Output,Target,Input)

% Input tiene dimensión K y diffW debe tener dimensión K+1 (en la ultima posiicion tiene el sesgo)
% para ello debemos formar un nuevo vector con una última componente -1.

diffW = LR*(Target - Output)*[Input, -1]; % Linea 9 - Flujo algoritmico
WN = W + diffW';  % Linea 10 - Flujo algoritmico

end

