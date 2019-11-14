clc;
clear all;
close all;

% Particle Swarm Optimization
% --- Luiza Pozzobon
% ----- Algoritmos de Otimização 2019/2

% ================= PARÂMETROS MODIFICÁVEIS PELO USUÁRIO
% === Número de partículas, restrição on/off e sensibilidade do critério de parada
num_particles = 10;
with_restriction = 1; % 0 = off, 1 = on
gbest_count_max = 1000; % critério de parada -> quantas vezes gbest permaneceu o mesmo
funcao = "Mishra"
    % opções: Rosenbrock, Mishra
    % constraints: rosenbrock = circulo de diametro 2
    %              mishra = uma função genérica
% ================
% =======================================

% ===== Função
if funcao == "Rosenbrock"
    % Rosenbrock
    f = @(x) (1-x(1))^2 + 100*(x(2) - x(1)^2)^2;
    % Disk constrain
    f_restriction = @(x) x(1)^2 + x(2)^2;
    restriction_value = 2;
    x_interval = [-1.5 1.5];
    y_interval = [-1.5 1.5];
    num_variables = 2; % número de variáveis da função

    % Para plotagem
    xA = [x_interval(1):0.1:x_interval(2)];
    xB = [y_interval(1):0.1:y_interval(2)];
    [X1, X2] = meshgrid(xA, xB);
    F = (1-X1).^2 + 100*(X2 - X1.^2).^2;
    F_restriction = X1.^2 + X2.^2;
    % essa restrição não desenhei da melhor forma possível, ficou um quadradão
end
if funcao == "Mishra"
    f = @(x)sin(x(2))*exp( ( 1-cos(x(1)) )^2) + cos(x(1))*exp( (1-sin(x(2)))^2 ) + (x(1)-x(2))^2;
    f_restriction = @(x)(x(1) + 5)^2 + (x(2) + 5)^2;
    restriction_value = 24; % é 25, mas botei 24 pois no if tá <=
    x_interval = [-10 0];
    y_interval = [-6.5 0];
    num_variables = 2;
    
    xA = [x_interval(1):0.1:x_interval(2)];
    xB = [y_interval(1):0.1:y_interval(2)];
    [X1, X2] = meshgrid(xA, xB);
    F = sin(X2).*exp( (1-cos(X1)) ).^2 + cos(X1).*exp( (1-sin(X2)).^2 ) + (X1 - X2).^2;
    F_restriction = (X1 + 5).^2 + (X2 + 5).^2;
end

% ==== Parâmetros
rng(42); % random seed
lambda1 = 2.0;
lambda2 = 2.0;
w       = 0.5;

figure(1);

% === Geração dos pontos e plotagem
x = zeros(2, num_variables, num_particles);
% Particulas aleatórias dentro do intervalo definido
for i=1:num_particles
    % Cada coluna é uma partícula
    % linha 1 = valor atual
    % linha 2 = proximo valor
    for var=1:num_variables
        % intervalos em x ou y dependendo da iteração
        if var == 1
            interval = x_interval;
        end
        if var == 2
            interval = y_interval;
        end
        x(1, var, i) = interval(1) + rand() * (abs(interval(1)) + abs(interval(2)));
    end
    % Plot dos pontos
    z(i) = f(x(1, :, i));
    scatter3(x(1, 1, i), x(1, 2, i), z(i), '+', 'LineWidth', 2);
    hold on;
    title('As n partículas iniciais');
end

% Plot da curva
surf(X1, X2, F);
shading interp;
if with_restriction == 1
    display('Com restrições')
    hold on;
    surf(X1, X2, F_restriction);
else
    display('Sem restrições')
end
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

iter = 0;
gbest_count = 0;
while(gbest_count < gbest_count_max)
    for p=1:num_particles
        for var=1:num_variables
            v(2, var, p) = ((w * v(1, var, p) + lambda1 * rand() * (xlbest(var, p) - x(1, var, p)) + lambda2 * rand() * (xgbest(var, 1) - x(1, var, p)) ));
            x(2, var, p) = x(1, var, p) + v(2, var, p);
            
            % Limitar valores dos x para os limites
            if var == 1
                interval = x_interval;
            end
            if var == 2
                interval = y_interval;
            end
            if x(2, var, p) > interval(2)
                x(2, var, p) = interval(2);
            end
            if x(2, var, p) < interval(1)
                x(2, var, p) = interval(1);
            end
        end
        
        % Atualizar cognitivo
        new_z = f(x(2, :, p));
        if new_z < z(i)
            xlbest(:, p) = x(2, :, p);
        end

        if with_restriction == 1
            x(2, :, p);
            z_restriction = f_restriction(x(2, :, p));
            % Atualizar social contando com restrição
            if new_z < f(xgbest) && z_restriction <= restriction_value
                xgbest(:) = x(2, :, p);
            else
                % Atualização critério de parada
                gbest_count = gbest_count + 1;
            end
            if iter == 0 % só para não ficar travado no número alto
                if new_z < f(xgbest)
                    xgbest(:) = x(2, :, p);
                else
                    % Atualização critério de parada
                    gbest_count = gbest_count + 1;
                end
            end
        else
            % Atualizar social sem contar com restrição
            if new_z < f(xgbest) || iter == 0
                xgbest(:) = x(2, :, p);
            else
                % Atualização critério de parada
                gbest_count = gbest_count + 1;
            end
        end
        
        if new_z < f(xgbest) && z_restriction <= 2
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
    gbest_iter(iter) = f(xgbest);
end

% Print do melhor ponto e número de iterações
iter
xgbest
zbest = f(xgbest)

% Plot do melhor ponto
figure(2)
scatter3(xgbest(1), xgbest(2), zbest, '+', 'LineWidth', 2);
hold on;

% Plot da curva
surf(X1, X2, F);
title('Melhor ponto encontrado')
shading interp;
if with_restriction == 1
    hold on;
    surf(X1, X2, F_restriction);
end

% Plot do melhor valor ( f(xgbest) ) em cada iteração
figure(3)
plot(gbest_iter);
title('Gbest nas iterações')