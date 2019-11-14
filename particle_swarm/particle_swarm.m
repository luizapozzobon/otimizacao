clc;
clear all;
close all;

% Particle Swarm Optimization

% ===== Função
f = @(x1, x2)100*(x2 - x1^2)^2 + (1 - x1)^2;
x_interval = [-3 3];
%fmin = 0;
%x1_min = 1;
%x2_min = 1;

%f = @(x1, x2) sin(x1+x2) + (x1-x2)^2 - 1.5*x1 + 2.5*x2 + 1;
%x_interval = [-10 10];

num_variables = 2; % número de variáveis da função

xA = [x_interval(1):0.1:x_interval(2)];
xB = [x_interval(1):0.1:x_interval(2)];
[X1, X2] = meshgrid(xA, xB);
F = 100*(X2 - X1.^2).^2 + (1 - X1).^2;
%F = sin(X1 + X2) + (X1 - X2).^2 - 1.5*X1 + 2.5*X2 + 1


% ==== Parâmetros
rng(42); % random seed
lambda1 = 2.0;
lambda2 = 2.0;
w       = 0.5;

% ==== Mudar número de partículas, se desejado
num_particles = 10;
% ================

figure(1);

% === Geração dos pontos e plotagem
x = zeros(2, num_variables, num_particles);
% Particulas aleatórias dentro do intervalo definido
for i=1:num_particles
    % Cada coluna é uma partícula
    % linha 1 = valor atual
    % linha 2 = proximo valor
    for var=1:num_variables
        x(1, var, i) = x_interval(1) + rand() * x_interval(2)*2; 
    end
    
    % Plot dos pontos
    z(i) = f(x(1, 1, i), x(1, 2, i));
    scatter3(x(1, 1, i), x(1, 2, i), z(i));
    hold on;
    title('As n partículas iniciais');
end

% Plot da curva
surf(X1, X2, F);
shading interp;

% === Vetor de velocidades
% cada coluna = uma variável
% 1ª linha = velocidade atual
% 2ª linha = próxima velocidade
% v(:, :, particle) = [v_var1_1  v_var2_1]
                  % = [v_var1_2  v_var2_2]
v = zeros(2, num_variables, num_particles);

% ==== X cognitivos
% n linhas = n variaveis
xlbest = zeros(num_variables, num_particles);

% ==== X social
xgbest = zeros(num_variables, 1); 
xgbest(:, 1) = 1e30;

iter = 0;
gbest_count = 0;
while(gbest_count < 1000)
    for p=1:num_particles
        for var=1:num_variables
            v(2, var, p) = ((w * v(1, var, p) + lambda1 * rand() * (xlbest(var, p) - x(1, var, p)) + lambda2 * rand() * (xgbest(var, 1) - x(1, var, p)) ));
            x(2, var, p) = x(1, var, p) + v(2, var, p);
            
            % Limitar valores dos x para os limites [-3, 3]
            if x(2, var, p) > x_interval(2)
                x(2, var, p) = x_interval(2);
            end
            if x(2, var, p) < x_interval(1)
                x(2, var, p) = x_interval(1);
            end
        end
        
        % Atualizar cognitivo
        new_z = f(x(2, 1, p), x(2, 2, p));
        if new_z < z(i)
            xlbest(:, p) = x(2, :, p);
        end
        
        % Atualizar social
        if new_z < f(xgbest(1), xgbest(2))
            xgbest(:) = x(2, :, p);
        else
            % Atualização critério de parada
            gbest_count = gbest_count + 1;
        end

        % Atualização de v e x de cada particula
        v(1, :, p)  = v(2, :, p);
        x(1, :, p)  = x(2, :, p);
    end
    iter = iter + 1;
end

% Print do melhor ponto e número de iterações
iter
xgbest
zbest = f(xgbest(1), xgbest(2))

% Plot do melhor ponto
figure(2)
scatter3(xgbest(1), xgbest(2), zbest);
hold on;

% Plot da curva
surf(X1, X2, F);
title('Melhor ponto encontrado')
shading interp;