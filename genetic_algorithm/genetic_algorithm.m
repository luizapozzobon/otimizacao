clc;
close all;
clear all;

%===============  Algoritmos Genéticos
%% ---- Parâmetros
num_bits = 5;
num_pop  = 20;
best_count_limit = 120; % Critério de parada = melhor valor igual por x iterações

mutation_rate   = 0.1; % 5% de taxa de mutação
bits_to_mutate  = 1; % bits que são alterados na mutação
pop_to_keep     = 1; % quantia dos melhores indivíduos que serão mantidos para a próxima geração

% f = @(x) x^2 - x;
% x_min = [0];
% x_max = [31];
% num_variables = 1;

f = @(x) 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;
x_min = [-3 -3]; % Na ordem das variáveis, x min
x_max = [3 3];  % Na ordem das variáveis, x max
num_variables = 2;

%% ---- Gerar população aleatória
genotypes = randi([0, 1], [num_pop, num_bits, num_variables]);

%% Evolução
best_count = 0;
last_z = 0;
iter_count = 0;
while best_count < best_count_limit
    %% Cruzamento
    genotypes = crossing(genotypes, pop_to_keep, num_bits, num_pop, num_variables);

    %% Mutação
    genotypes = mutation(genotypes, pop_to_keep, mutation_rate, bits_to_mutate, num_bits, num_pop, num_variables);
    
    %% Selection
    [z, genotypes, fenotypes] = selection(genotypes, pop_to_keep, f, x_min, x_max, num_bits, num_pop, num_variables);
    
    % Listas ordenadas do melhor para o pior
    % Então o melhor valor é sempre o primeiro
    best_fenotype = fenotypes(1, :);
    best_genotype = genotypes(1, :, :);
    best_z = z(1);
    
    if best_z == last_z
        best_count = best_count + 1;
    else
        best_count = 0;
    end
    last_z = best_z;
    iter_count = iter_count + 1;
end
iter_count
best_genotype
best_fenotype
best_z