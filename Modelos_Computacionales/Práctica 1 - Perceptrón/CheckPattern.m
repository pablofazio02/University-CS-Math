function correct = CheckPattern(Data,W)
% Inicializamos a True una variable booleana que controlará si nos hemos
% equivocado en alguna clasificación.
    correct = true;
    % Nos desplazamos por toda la base de datos
    for i = 1:1:size(Data,1)
        [~, Output, Target] = ValoresIOT(Data, W, i);
        % Comparamos el valor esperado con el que generamos.
        if(Target ~= Output)
            % Si hay algun ejemplo que está mal clasificado, devolvemos
            % False.
            correct = false;
            break;
        end
    end
end
