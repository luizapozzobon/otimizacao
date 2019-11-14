clc;
clear all;
close all;

% Artificial Bee Colony - Algoritmo para MAXIMIZA��O
% --- Luiza Pozzobon
% ----- Algoritmos de Otimiza��o 2019/2

% ================= PAR�METROS MODIFIC�VEIS PELO USU�RIO
% === N�mero de abelhas e sensibilidade do crit�rio de parada
num_particles = 10;
best_count_max = 100; % crit�rio de parada -> quantas vezes zbest permaneceu o mesmo
funcao = "Mishra"
    % op��es: Rosenbrock, Mishra invertidas
    % Rosenbrock � quase inteira um ponto de sela
% ================
% =======================================

% ===== Fun��o
if funcao == "Rosenbrock"
    % Rosenbrock
    f = @(x) -((1-x(1))^2 + 100*(x(2) - x(1)^2)^2);
    x_interval = [-1.5 1.5];
    y_interval = [-1.5 1.5];
    num_variables = 2; % n�mero de vari�veis da fun��o

    % Para plotagem
    xA = [x_interval(1):0.1:x_interval(2)];
    xB = [y_interval(1):0.1:y_interval(2)];
    [X1, X2] = meshgrid(xA, xB);
    F = -((1-X1).^2 + 100*(X2 - X1.^2).^2);
end
if funcao == "Mishra"
    f = @(x) -(sin(x(2))*exp( ( 1-cos(x(1)) )^2) + cos(x(1))*exp( (1-sin(x(2)))^2 ) + (x(1)-x(2))^2);
    x_interval = [-10 0];
    y_interval = [-6.5 0];
    num_variables = 2;
    
    xA = [x_interval(1):0.1:x_interval(2)];
    xB = [y_interval(1):0.1:y_interval(2)];
    [X1, X2] = meshgrid(xA, xB);
    F = -(sin(X2).*exp( (1-cos(X1)) ).^2 + cos(X1).*exp( (1-sin(X2)).^2 ) + (X1 - X2).^2);
end

% ==== Par�metros
rng(42); % random seed

figure(1);
% === Gera��o dos pontos e plotagem
x = zeros(2, num_variables, num_particles);
% Particulas aleat�rias dentro do intervalo definido
for i=1:num_particles
    % Cada coluna � uma part�cula
    % linha 1 = valor atual
    % linha 2 = proximo valor
    for var=1:num_variables
        % intervalos em x ou y dependendo da itera��o
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
    title('As n part�culas iniciais');
end

% Plot da curva
surf(X1, X2, F);
shading interp;

iter = 0;
best_count = 0;
previous_xbest = 10000;
while(best_count < best_count_max)
    
    for p=1:num_particles
        for t=1:3
            % Busca de melhor valor proximo de cada ponto
            % Acha um vizinho
            neighbor = floor(num_particles*rand) + 1;
            % N�mero aleat�rio de -1 a 1
            rand_var = -1 + rand() * 2;
            % Ponto candidato * rand_var
            candidate = x(1, :, p) + (x(1, :, neighbor) - x(1, :, p))* rand_var;
            
            % Limites
            if candidate(1) < x_interval(1)
                candidate(1) = x_interval(1);
            elseif candidate(1) > x_interval(2)
                candidate(1) = x_interval(2);
            end
            if candidate(2) < y_interval(1)
                candidate(2) = y_interval(1);
            elseif candidate(2) > y_interval(2)
                candidate(2) = y_interval(2);
            end
            
            % C�lculo dos z's para o candidato e o ponto sorteado antes
            z_candidate = f(candidate);
            z_probable = f(x(1, :, p));
            if z_candidate > z_probable
                x(1, :, p) = candidate;
            end
        end
        % Atualiza��o do z para cada ponto
        new_z(p) = f(x(1, :, p));
    end
    
    % Probabilidades
    for p=1:num_particles
        fitness(p) = new_z(p)/sum(new_z);
    end
    
    % Atualiza��o dos poss�veis novos valores das abelhas (linha 2 dos arrays)
    % Exploradora e demais baseadas na fitness
    for p=1:num_particles
        if p == 1
            % exploradora
            for var=1:num_variables
                % intervalos em x ou y dependendo da itera��o
                if var == 1
                    interval = x_interval;
                end
                if var == 2
                    interval = y_interval;
                end
                x(1, var, p) = interval(1) + rand() * (abs(interval(1)) + abs(interval(2)));
            end
            new_z(p) = f(x(1, :, p));
        end
        % Resto das abelhas que tem posi��o definida pela fitness calculada
        % antes
        r = rand;
        
        % Vetor de soma cumulativa das probabilidades
        C = cumsum(fitness);

        % Prob a ser seguida, a maior poss�vel dentre as fitness no alcance
        % definido pela soma cumulativa
        best_point = find(r <= C, 1, 'first'); 

        % Atualiza��o do ponto na dire��o do best_point
        x(2, :, p) = x(1, :, p) + (x(1, :, p) - x(1, :, best_point)) * rand;
        
        % Limites
        if x(2, 1, p) < x_interval(1)
            x(2, 1, p) = x_interval(1);
        elseif x(2, 1, p) > x_interval(2)
            x(2, 1, p) = x_interval(2);
        end
        if x(2, 2, p) < y_interval(1)
            x(2, 2, p) = y_interval(1);
        elseif x(2, 2, p) > y_interval(2)
            x(2, 2, p) = y_interval(2);
        end

        z_candidate = f(x(2, :, p));
        z_previous = f(x(1, :, p));
        if z_candidate > z_previous
            x(1, :, p) = x(2, :, p);
        end
        % Atualizando os valores de z
        new_z(p) = f(x(1, :, p))
    end
    [M, I] = max(new_z)
    xbest = x(1, :, I);
    if xbest == previous_xbest
        best_count = best_count + 1;
    end
    zbest = M;
    best_history(iter+1) = zbest;
    iter = iter + 1;
    previous_xbest = xbest;
end

% Print do melhor ponto e n�mero de itera��es
iter
xbest
zbest

% Plot do melhor ponto
figure(2)
scatter3(xbest(1), xbest(2), f(xbest), '+', 'LineWidth', 2);
hold on;

% Plot da curva
surf(X1, X2, F);
title('Melhor ponto encontrado')
shading interp;

figure(3)
plot(best_history);