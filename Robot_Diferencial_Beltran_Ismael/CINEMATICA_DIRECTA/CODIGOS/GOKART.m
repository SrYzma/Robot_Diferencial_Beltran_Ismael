%% ------------------------------------------------------------------------
% PRÁCTICA DE ROBÓTICA MÓVIL
% Alumno: Ismael Beltran Espinoza
% Descripción: Simulación de Cinemática Directa de Robot Diferencial
% Método: Lazo Abierto
% Trayectoria: Circuito de GOKART
%%-------------------------------------------------------------------------
clear;
clc;
close all;

% CÁLCULO CINEMÁTICO DEL ROBOT  
t(1) = 0;
x(1) = 0; 
y(1) = 0; 
theta(1) = 0; 

ts = 35;      
ti = 0.01;    

L = 0.18; % Distancia entre ruedas [m]
r = 0.03; % Radio de las ruedas [m]

% TRAYECTORIA SECUENCIAL
for k= 1: ts/ti
    
    if t(k) < 2.00
        % 1. Recta Principal
        dot_theta_RD = 10;
        dot_theta_RI = 10;
        
    elseif t(k) < 6.19
        % 2. Curvas 1 a 3 (Giro de 180 grados a la derecha)
        dot_theta_RD = 7.75;
        dot_theta_RI = 12.25;
        
    elseif t(k) < 7.19
        % 3. Recta corta
        dot_theta_RD = 10;
        dot_theta_RI = 10;
        
    elseif t(k) < 8.76
        % 4. Curva (Giro de 90 grados a la derecha)
        dot_theta_RD = 7.00;
        dot_theta_RI = 13.00;
        
    elseif t(k) < 9.50 
        % 5. Recta 
        dot_theta_RD = 10;
        dot_theta_RI = 10;
        
    elseif t(k) < 12.64
        % 6. Curva  (Horquilla de 180 grados a la izquierda)
        dot_theta_RD = 9.67;
        dot_theta_RI = 3.67;
        
    elseif t(k) < 14.14
        % 7. Recta 
        dot_theta_RD = 10;
        dot_theta_RI = 10;
        
    elseif t(k) < 15.71
        % 8. Curva (Giro de 90 grados a la derecha)
        dot_theta_RD = 7.00;
        dot_theta_RI = 13.00;
        
    elseif t(k) < 19.71
        % 9. Recta Trasera Larga
        dot_theta_RD = 10;
        dot_theta_RI = 10;
        
    elseif t(k) < 22.07
        % 10. Curva de 180 grados a la izquierda
        dot_theta_RD = 10.67;
        dot_theta_RI = 2.67;
        
    elseif t(k) < 23.07
        % 11. Entrada al estadio
        dot_theta_RD = 10;
        dot_theta_RI = 10;
        
    elseif t(k) < 24.64
        % 12. Curva 12 (Giro de 90 grados a la derecha)
        dot_theta_RD = 3.67;
        dot_theta_RI = 9.67;
        
    elseif t(k) < 25.14
        % 13. Recta muy corta
        dot_theta_RD = 10;
        dot_theta_RI = 10;
        
    elseif t(k) < 26.71
        % 14. Curva 13 (Giro de 90 grados a la derecha)
        dot_theta_RD = 3.67;
        dot_theta_RI = 9.67;
        
    elseif t(k) < 27.21
        % 15. Recta muy corta
        dot_theta_RD = 10;
        dot_theta_RI = 10;
        
    elseif t(k) < 30.35
        % 16. Curvas finales (Giro largo de 180 grados a meta)
        dot_theta_RD = 7.00;
        dot_theta_RI = 13.00;
        
    elseif t(k) < 34.00
        % 17. LLEGADA: Recta final a la meta
        dot_theta_RD = 10;
        dot_theta_RI = 10;
        
    else 
        % FRENO TOTAL
        dot_theta_RD = 0; 
        dot_theta_RI = 0;
    end
    
    % Cinemática Directa 
    VRD = dot_theta_RD * r;
    VRI = dot_theta_RI * r;
    u = (VRD + VRI) / 2; 
    w = (VRD - VRI) / L; 
    
    x(k+1) = x(k) + ti*( u*cos(theta(k)) );
    y(k+1) = y(k) + ti*( u*sin(theta(k)) );
    theta(k+1) = theta(k) + ti*(w) ;
    t(k+1) = t(k) + ti;
end

%% GRÁFICA 3D ESTÁTICA
z = zeros(1, length(t)); % Eje Z al ras del suelo

figure('Name', 'Trayectoria 3D estática', 'NumberTitle', 'off');
plot3(x, y, z, 'b', 'LineWidth', 5); % Línea azul gruesa
hold on;

% Punto de partida (Círculo verde)
plot3(x(1), y(1), z(1), 'go', 'MarkerSize', 12, 'LineWidth', 3, 'MarkerFaceColor', 'g');

% Punto final (Cuadrado rojo)
plot3(x(end), y(end), z(end), 'rs', 'MarkerSize', 12, 'LineWidth', 3, 'MarkerFaceColor', 'r');

% Etiquetas y formato
xlabel("POSICION EN X [m]");
ylabel("POSICION EN Y [m]");
zlabel("Z [m]");
title("Circuito de GOKART");
grid on;
axis equal;

% Darle el formato de fondo negro con letras blancas
set(gca, 'FontSize', 15, 'Color', 'k', 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w', 'GridColor', 'w');
set(gcf, 'Color', 'k');
view(-45, 30); % Ajusta el ángulo de la cámara para que se vea en 3D




%% ANIMACIÓN DEL ROBOT Y EXPORTACIÓN A GIF
figure('Name', 'Animación: Circuito de GOKART', 'NumberTitle', 'off', 'WindowState', 'maximized');
clf; hold on; grid on; axis equal;

xlabel("POSICION EN X [m]"); ylabel("POSICION EN Y [m]");
title("Circuito de GOKART");
set(gca, 'FontSize', 12, 'Color', [0.15 0.15 0.15], 'XColor', 'w', 'YColor', 'w', 'GridColor', 'w');
set(gcf, 'Color', [0.2 0.2 0.2]);

% Límites dinámicos de la gráfica para ver todo el mapa
xlim([min(x)-1, max(x)+1])
ylim([min(y)-1, max(y)+1])

% Línea de rastro 
plot(x, y, 'w--', 'LineWidth', 1.5);
plot(x(1), y(1), 'go', 'MarkerFaceColor', 'g', 'MarkerSize', 12);
plot(x(end), y(end), 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 12);

% Proporciones del carrito
L_robot = 0.25; W_robot = 0.16; 
robot_shape = [ L_robot/2, W_robot/2; L_robot/2, -W_robot/2; -L_robot/2, -W_robot/2; -L_robot/2, W_robot/2 ]';
wheel_shape = [ -0.06, 0.02; 0.06, 0.02; 0.06, -0.02; -0.06, -0.02 ]';
pos_wheel_L = [0; L/2];
pos_wheel_R = [0; -L/2];

h_trayectoria = plot(nan, nan, 'b', 'LineWidth', 3);
h_chasis = []; h_ruedaL = []; h_ruedaR = []; h_frente = [];

nombre_archivo = 'trayectoria_libre.gif'; 

for k = 1:20:length(t) 
    
    set(h_trayectoria, 'XData', x(1:k), 'YData', y(1:k));
    delete(h_chasis); delete(h_ruedaL); delete(h_ruedaR); delete(h_frente);
    
    R_mat = [cos(theta(k)) -sin(theta(k)); sin(theta(k)) cos(theta(k))];
    p = [x(k); y(k)];
    
    robot_global = R_mat*robot_shape + p;
    wheel_L_global = R_mat*(wheel_shape + pos_wheel_L) + p;
    wheel_R_global = R_mat*(wheel_shape + pos_wheel_R) + p;
    frente = R_mat*[L_robot/2 + 0.1; 0] + p;
    
    % CHASIS 
    h_chasis = fill(robot_global(1,:), robot_global(2,:), [1 0 0]); 
    % LLANTAS 
    h_ruedaL = fill(wheel_L_global(1,:), wheel_L_global(2,:), [0 0 0]);
    h_ruedaR = fill(wheel_R_global(1,:), wheel_R_global(2,:), [0 0 0]);
    
    h_frente = plot([p(1), frente(1)], [p(2), frente(2)], 'y-', 'LineWidth', 2);
    
    drawnow limitrate; 
 
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im, 256);
    
    if k == 1
        imwrite(imind, cm, nombre_archivo, 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
    else
        imwrite(imind, cm, nombre_archivo, 'gif', 'WriteMode', 'append', 'DelayTime', 0.1);
    end
end