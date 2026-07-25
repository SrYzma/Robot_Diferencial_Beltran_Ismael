clear;
clc;
close all;

%% PARAMETROS DEL ROBOT
L = 0.22;      % Distancia entre ruedas [m]
r = 0.07;      % Radio de rueda [m]

%% TRAYECTORIA DESEADA
R = 1.0;       % Radio deseado [m]
w = 0.3;       % Velocidad angular deseada [rad/s]

u = R*w;       % Velocidad lineal [m/s]

%% CINEMATICA INVERSA
dot_theta_D = (u + (L/2)*w)/r;
dot_theta_I = (u - (L/2)*w)/r;

fprintf('u = %.3f m/s\n',u);
fprintf('w = %.3f rad/s\n',w);
fprintf('theta_D = %.3f rad/s\n',dot_theta_D);
fprintf('theta_I = %.3f rad/s\n',dot_theta_I);

%% VECTOR DE TIEMPO
ti = 0.01;
ts = 21;                % Aproximadamente una vuelta completa

t = 0:ti:ts;

%% TRAYECTORIA DESEADA
x_d = R*cos(w*t);
y_d = R*sin(w*t);

%% CINEMATICA DIRECTA (VERIFICACION)
x(1) = R;
y(1) = 0;
theta(1) = pi/2;

for k = 1:length(t)-1

    VRD = dot_theta_D*r;
    VRI = dot_theta_I*r;

    u_robot = (VRD + VRI)/2;
    w_robot = (VRD - VRI)/L;

    x(k+1) = x(k) + ti*u_robot*cos(theta(k));
    y(k+1) = y(k) + ti*u_robot*sin(theta(k));
    theta(k+1) = theta(k) + ti*w_robot;

end

%% TRAYECTORIA DESEADA
figure
plot(x_d,y_d,'r','LineWidth',3)
grid on
axis equal
title('Trayectoria Deseada')
xlabel('X [m]')
ylabel('Y [m]')
saveas(gcf,'trayectoria_deseada.png')

%% TRAYECTORIA OBTENIDA
figure
plot(x,y,'b','LineWidth',3)
grid on
axis equal
title('Trayectoria Obtenida')
xlabel('X [m]')
ylabel('Y [m]')
saveas(gcf,'trayectoria_obtenida.png')

%% COMPARACION
figure
plot(x_d,y_d,'r--','LineWidth',3)
hold on
plot(x,y,'b','LineWidth',2)
grid on
axis equal
legend('Deseada','Obtenida')
title('Comparacion de Trayectorias')
xlabel('X [m]')
ylabel('Y [m]')
saveas(gcf,'comparacion_trayectorias.png')

%% VELOCIDAD LINEAL
figure
plot(t,u*ones(size(t)),'LineWidth',2)
grid on
title('Velocidad Lineal')
xlabel('Tiempo [s]')
ylabel('u [m/s]')
saveas(gcf,'velocidad_lineal.png')

%% VELOCIDAD ANGULAR
figure
plot(t,w*ones(size(t)),'LineWidth',2)
grid on
title('Velocidad Angular')
xlabel('Tiempo [s]')
ylabel('\omega [rad/s]')
saveas(gcf,'velocidad_angular.png')

%% VELOCIDADES DE RUEDAS
figure
plot(t,dot_theta_D*ones(size(t)),'b','LineWidth',2)
hold on
plot(t,dot_theta_I*ones(size(t)),'r','LineWidth',2)
grid on
legend('\theta_D','\theta_I')
title('Velocidades de las ruedas')
xlabel('Tiempo [s]')
ylabel('rad/s')
saveas(gcf,'velocidades_ruedas.png')

%% ERROR DE TRAYECTORIA
error = sqrt((x_d-x).^2 + (y_d-y).^2);

fprintf('\nError minimo = %.6f m\n',min(error));
fprintf('Error maximo = %.6f m\n',max(error));
%% ==========================================
%% ANIMACION DEL ROBOT
%% ==========================================

figure('Name','Cinematica Inversa','NumberTitle','off');
hold on;
grid on;
axis equal;

xlabel('X [m]');
ylabel('Y [m]');
title('Robot recorriendo trayectoria circular')

xlim([min(x)-0.5 max(x)+0.5]);
ylim([min(y)-0.5 max(y)+0.5]);

% Trayectoria completa
plot(x,y,'w--','LineWidth',1);

% Punto inicial
plot(x(1),y(1),'go','MarkerFaceColor','g');

% Punto final
plot(x(end),y(end),'ro','MarkerFaceColor','r');

set(gca,'Color',[0.15 0.15 0.15], ...
    'XColor','w', ...
    'YColor','w', ...
    'GridColor','w');

set(gcf,'Color',[0.2 0.2 0.2]);

%% Modelo del robot

L_robot = 0.25;
W_robot = 0.16;

% Chasis
robot_shape = [ L_robot/2,  W_robot/2;
                L_robot/2, -W_robot/2;
               -L_robot/2, -W_robot/2;
               -L_robot/2,  W_robot/2 ]';

% Llantas
wheel_shape = [ -0.06, 0.02;
                 0.06, 0.02;
                 0.06,-0.02;
                -0.06,-0.02 ]';

% Posición de llantas respecto al centro
pos_wheel_L = [0; L/2];
pos_wheel_R = [0; -L/2];

h_trayectoria = plot(nan,nan,'b','LineWidth',3);

h_robot = [];
h_ruedaL = [];
h_ruedaR = [];
h_frente = [];

nombre_archivo = 'cinematica_inversa.gif';

%% Animación

for k = 1:10:length(x)

    set(h_trayectoria,...
        'XData',x(1:k),...
        'YData',y(1:k));

    if k > 1
        delete(h_robot);
        delete(h_ruedaL);
        delete(h_ruedaR);
        delete(h_frente);
    end

    % Matriz de rotación
    Rmat = [cos(theta(k)) -sin(theta(k));
            sin(theta(k))  cos(theta(k))];

    % Posición actual
    p = [x(k); y(k)];

    % Chasis
    robot_global = Rmat*robot_shape + p;

    % Llantas
    wheel_L_global = Rmat*(wheel_shape + pos_wheel_L) + p;
    wheel_R_global = Rmat*(wheel_shape + pos_wheel_R) + p;

    % Frente
    frente = Rmat*[L_robot/2 + 0.1;0] + p;

    % Chasis rojo
    h_robot = fill(robot_global(1,:),...
                   robot_global(2,:),...
                   [1 0 0],...
                   'EdgeColor','w');

    % Llanta izquierda negra
    h_ruedaL = fill(wheel_L_global(1,:),...
                    wheel_L_global(2,:),...
                    [0 0 0]);

    % Llanta derecha negra
    h_ruedaR = fill(wheel_R_global(1,:),...
                    wheel_R_global(2,:),...
                    [0 0 0]);

    % Frente amarillo
    h_frente = plot([p(1) frente(1)],...
                    [p(2) frente(2)],...
                    'y','LineWidth',2);

    drawnow limitrate

    %% Guardar GIF

    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);

    if k == 1

        imwrite(imind,cm,nombre_archivo,...
            'gif',...
            'Loopcount',inf,...
            'DelayTime',0.05);

    else

        imwrite(imind,cm,nombre_archivo,...
            'gif',...
            'WriteMode','append',...
            'DelayTime',0.05);

    end

end