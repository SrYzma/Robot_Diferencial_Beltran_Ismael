clear;
clc;
close all;

%% PARAMETROS DEL ROBOT

L = 0.18;
r = 0.03;

thetaDot_max = 20;   % rad/s

ts = 20;
ti = 0.01;
t = 0:ti:ts;

%% META

xd = 5;
yd = 5;

%% GANANCIAS

k_rho = 0.3;
k_theta = 4;

tolerancia = 0.03;

%% CASO 1: SIN SATURACION

x1(1)=0;
y1(1)=0;
theta1(1)=0;

rho1=zeros(size(t));
etheta1=zeros(size(t));
u1=zeros(size(t));
w1=zeros(size(t));

thetaD1=zeros(size(t));
thetaI1=zeros(size(t));

for k=1:length(t)-1

    ex = xd - x1(k);
    ey = yd - y1(k);

    rho1(k)=sqrt(ex^2+ey^2);

    theta_d = atan2(ey,ex);

    etheta1(k)=atan2( ...
        sin(theta_d-theta1(k)), ...
        cos(theta_d-theta1(k)));

    u1(k)=k_rho*rho1(k);
    w1(k)=k_theta*etheta1(k);

    if rho1(k)<tolerancia
        u1(k)=0;
        w1(k)=0;
    end

    vD = u1(k) + (L/2)*w1(k);
    vI = u1(k) - (L/2)*w1(k);

    thetaD1(k)=vD/r;
    thetaI1(k)=vI/r;

    x1(k+1)=x1(k)+ti*u1(k)*cos(theta1(k));
    y1(k+1)=y1(k)+ti*u1(k)*sin(theta1(k));
    theta1(k+1)=theta1(k)+ti*w1(k);

end

%% CASO 2: CON SATURACION PROPORCIONAL

x2(1)=0;
y2(1)=0;
theta2(1)=0;

rho2=zeros(size(t));
etheta2=zeros(size(t));
u2=zeros(size(t));
w2=zeros(size(t));

thetaD2=zeros(size(t));
thetaI2=zeros(size(t));

for k=1:length(t)-1

    ex = xd - x2(k);
    ey = yd - y2(k);

    rho2(k)=sqrt(ex^2+ey^2);

    theta_d = atan2(ey,ex);

    etheta2(k)=atan2( ...
        sin(theta_d-theta2(k)), ...
        cos(theta_d-theta2(k)));

    u_des = k_rho*rho2(k);
    w_des = k_theta*etheta2(k);

    if rho2(k)<tolerancia
        u_des = 0;
        w_des = 0;
    end

    vD = u_des + (L/2)*w_des;
    vI = u_des - (L/2)*w_des;

    thetaD = vD/r;
    thetaI = vI/r;

    %% SATURACION PROPORCIONAL

    vmax = max(abs([thetaD thetaI]));

    if vmax > thetaDot_max

        factor = thetaDot_max/vmax;

        thetaD = thetaD*factor;
        thetaI = thetaI*factor;

    end

    thetaD2(k)=thetaD;
    thetaI2(k)=thetaI;

    vD = thetaD*r;
    vI = thetaI*r;

    u2(k)=(vD+vI)/2;
    w2(k)=(vD-vI)/L;

    x2(k+1)=x2(k)+ti*u2(k)*cos(theta2(k));
    y2(k+1)=y2(k)+ti*u2(k)*sin(theta2(k));
    theta2(k+1)=theta2(k)+ti*w2(k);

end

%% COMPARACION DE TRAYECTORIAS

figure

h1 = plot(x1,y1,'b','LineWidth',3);
hold on

h2 = plot(x2,y2,'r--','LineWidth',3);

h3 = plot(0,0,...
    'go',...
    'MarkerFaceColor','g',...
    'MarkerSize',10);

h4 = plot(xd,yd,...
    'p',...
    'Color',[1 1 0],...
    'MarkerFaceColor',[1 1 0],...
    'MarkerSize',18);

grid on
axis equal

xlabel('X [m]')
ylabel('Y [m]')

legend([h1 h2 h3 h4],...
    {'Sin saturacion',...
    'Con saturacion',...
    'Inicio',...
    'Meta'},...
    'Location','best');

title('Comparacion de trayectorias')

%% ERROR DE POSICION

figure

plot(t,rho1,'b','LineWidth',3)
hold on

plot(t,rho2,'r--','LineWidth',3)

grid on

xlabel('Tiempo [s]')
ylabel('Error [m]')

legend('Sin saturacion', ...
       'Con saturacion')

title('Error de posicion')

%% ERROR ANGULAR

figure

plot(t,etheta1,'b','LineWidth',3)
hold on

plot(t,etheta2,'r--','LineWidth',3)

grid on

xlabel('Tiempo [s]')
ylabel('Error angular [rad]')

legend('Sin saturacion', ...
       'Con saturacion')

title('Error angular')

%% U Y W

figure

subplot(2,1,1)

plot(t,u1,'b','LineWidth',2)
hold on
plot(t,u2,'r--','LineWidth',2)

grid on
ylabel('u [m/s]')
title('Velocidad lineal')

subplot(2,1,2)

plot(t,w1,'b','LineWidth',2)
hold on
plot(t,w2,'r--','LineWidth',2)

grid on
ylabel('w [rad/s]')
xlabel('Tiempo [s]')
title('Velocidad angular')

%% VELOCIDADES DE RUEDAS

figure

subplot(2,1,1)

plot(t,thetaD1,'b','LineWidth',2)
hold on

plot(t,thetaD2,'r--','LineWidth',2)

grid on

ylabel('\theta_D [rad/s]')

legend('Sin sat','Con sat')

title('Rueda derecha')

subplot(2,1,2)

plot(t,thetaI1,'b','LineWidth',2)
hold on

plot(t,thetaI2,'r--','LineWidth',2)

grid on

ylabel('\theta_I [rad/s]')
xlabel('Tiempo [s]')

legend({'Sin sat','Con sat'},'Location','best')

title('Rueda izquierda')
%% RESULTADOS

fprintf('\n===== SIN SATURACION =====\n');
fprintf('Error final = %.4f m\n',rho1(end));
fprintf('Theta D max = %.2f rad/s\n',max(abs(thetaD1)));
fprintf('Theta I max = %.2f rad/s\n',max(abs(thetaI1)));

fprintf('\n===== CON SATURACION =====\n');
fprintf('Error final = %.4f m\n',rho2(end));
fprintf('Theta D max = %.2f rad/s\n',max(abs(thetaD2)));
fprintf('Theta I max = %.2f rad/s\n',max(abs(thetaI2)));

%% INDICADORES PARA TABLA 8.2
% Tiempo de llegada
idx1 = find(rho1 < tolerancia,1);
idx2 = find(rho2 < tolerancia,1);

if isempty(idx1)
    tiempo1 = NaN;
else
    tiempo1 = t(idx1);
end

if isempty(idx2)
    tiempo2 = NaN;
else
    tiempo2 = t(idx2);
end

% Distancia recorrida
dist1 = sum(sqrt(diff(x1).^2 + diff(y1).^2));
dist2 = sum(sqrt(diff(x2).^2 + diff(y2).^2));

fprintf('\n===== TABLA 8.2 =====\n');

fprintf('\nSIN SATURACION\n');
fprintf('Error final        = %.4f m\n',rho1(end));
fprintf('Tiempo de llegada  = %.2f s\n',tiempo1);
fprintf('Theta D maxima     = %.2f rad/s\n',max(abs(thetaD1)));
fprintf('Theta I maxima     = %.2f rad/s\n',max(abs(thetaI1)));
fprintf('Distancia recorrida= %.2f m\n',dist1);

fprintf('\nCON SATURACION\n');
fprintf('Error final        = %.4f m\n',rho2(end));
fprintf('Tiempo de llegada  = %.2f s\n',tiempo2);
fprintf('Theta D maxima     = %.2f rad/s\n',max(abs(thetaD2)));
fprintf('Theta I maxima     = %.2f rad/s\n',max(abs(thetaI2)));
fprintf('Distancia recorrida= %.2f m\n',dist2);

%% ANIMACION DEL CONTROL CINEMATICO

figure('Name','Control Cinematico','NumberTitle','off');
clf;
hold on;
grid on;
axis equal;

xlabel('Posicion X [m]');
ylabel('Posicion Y [m]');
title('Control Cinematico con Saturacion');

xlim([min(x2)-1 max(x2)+1]);
ylim([min(y2)-1 max(y2)+1]);

% Trayectoria de referencia
plot(x2,y2,'w--','LineWidth',1.5);

% Inicio
plot(x2(1),y2(1), ...
    'go', ...
    'MarkerFaceColor','g', ...
    'MarkerSize',12);

% Meta
plot(xd,yd, ...
    'rp', ...
    'MarkerFaceColor','r', ...
    'MarkerSize',15);

set(gca,...
    'FontSize',12,...
    'Color',[0.15 0.15 0.15],...
    'XColor','w',...
    'YColor','w',...
    'GridColor','w');

set(gcf,'Color',[0.2 0.2 0.2]);

%% Robot

L_robot = 0.25;
W_robot = 0.16;

robot_shape = [ L_robot/2,  W_robot/2;
                L_robot/2, -W_robot/2;
               -L_robot/2, -W_robot/2;
               -L_robot/2,  W_robot/2 ]';

wheel_shape = [ -0.06, 0.02;
                 0.06, 0.02;
                 0.06,-0.02;
                -0.06,-0.02 ]';

pos_wheel_L = [0; L/2];
pos_wheel_R = [0;-L/2];

h_trayectoria = plot(nan,nan,'b','LineWidth',3);

h_robot  = [];
h_ruedaL = [];
h_ruedaR = [];
h_frente = [];

nombre_archivo = 'control_cinematico.gif';

%% Animacion

for k = 1:10:length(x2)

    set(h_trayectoria,...
        'XData',x2(1:k),...
        'YData',y2(1:k));

    if k > 1

        if isgraphics(h_robot)
            delete(h_robot);
        end

        if isgraphics(h_ruedaL)
            delete(h_ruedaL);
        end

        if isgraphics(h_ruedaR)
            delete(h_ruedaR);
        end

        if isgraphics(h_frente)
            delete(h_frente);
        end

    end

    Rmat = [cos(theta2(k)) -sin(theta2(k));
            sin(theta2(k))  cos(theta2(k))];

    p = [x2(k); y2(k)];

    robot_global = Rmat*robot_shape + p;

    wheel_L_global = Rmat*(wheel_shape + pos_wheel_L) + p;
    wheel_R_global = Rmat*(wheel_shape + pos_wheel_R) + p;

    frente = Rmat*[L_robot/2 + 0.1;0] + p;

    % Chasis
    h_robot = fill(robot_global(1,:),...
                   robot_global(2,:),...
                   [1 0 0],...
                   'EdgeColor','w');

    % Llanta izquierda
    h_ruedaL = fill(wheel_L_global(1,:),...
                    wheel_L_global(2,:),...
                    [0 0 0]);

    % Llanta derecha
    h_ruedaR = fill(wheel_R_global(1,:),...
                    wheel_R_global(2,:),...
                    [0 0 0]);

    % Frente
    h_frente = plot([p(1) frente(1)],...
                    [p(2) frente(2)],...
                    'y',...
                    'LineWidth',2);

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