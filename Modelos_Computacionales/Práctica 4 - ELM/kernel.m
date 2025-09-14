function [Ker] = kernel(u, v, sigma)
    % Calcula el valor de kernel gaussiana para u y v
    % K(i, j) = exp(-sigma * ||u - v||^2)
    Ker = exp(-sigma * sum((u - v).^2));
end