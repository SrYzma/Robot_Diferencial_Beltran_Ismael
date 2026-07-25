clear; clc; close all;

L = 0.18; r = 0.03; ts = 5; ti = 0.01; t = 0:ti:ts;

% Matrices de los 8 casos [w_D, w_I]
casos = [
    10,  10;  % Caso 1
    -10, -10;  % Caso 2
    12,   6;  % Caso 3
    6,  12;  % Caso 4
    10, -10;  % Caso 5
    10,   0;  % Caso 6
    10,   8;  % Caso 7
    10,   2   % Caso 8
    ];

fprintf('--- RESULTADOS PARA LA TABLA ---\n');
for i = 1:8
    x = zeros(1, length(t)); y = zeros(1, length(t)); theta = zeros(1, length(t));

    wD = casos(i, 1); wI = casos(i, 2);

    VRD = wD * r; VRI = wI * r;
    u = (VRD + VRI) / 2;
    w = (VRD - VRI) / L;

    for k = 1:length(t)-1
        x(k+1) = x(k) + ti*( u*cos(theta(k)) );
        y(k+1) = y(k) + ti*( u*sin(theta(k)) );
        theta(k+1) = theta(k) + ti*(w) ;
    end

    % Imprimir resultados 
    fprintf('Caso %d: u=%.2f | w=%.2f | x(end)=%.2f | y(end)=%.2f | theta(end)=%.2f\n', ...
        i, u, w, x(end), y(end), theta(end));

    % Generar Gráfica
    figure('Name', sprintf('Caso %d', i));
    plot3(x, y, zeros(1,length(t)), 'b', 'LineWidth', 4); hold on;
    plot3(x(1), y(1), 0, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
    plot3(x(end), y(end), 0, 'rs', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    xlabel('X [m]'); ylabel('Y [m]'); zlabel('Z [m]');
    title(sprintf('Caso %d: wD=%.1f, wI=%.1f', i, wD, wI));
    grid on; axis equal;
end