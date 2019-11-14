function [z, sorted_genotypes, sorted_fenotypes] = selection(genotypes, pop_to_keep, func, x_min, x_max, num_bits, num_pop, num_variables)

    %% Fenótipos e resultados na função
    % Calculo do fenótipo para cara variável
    for var=1:num_variables
        fenotypes(:, var) = bin_to_dec(genotypes(:, :, var), x_min(var), x_max(var), num_bits, num_pop);
    end
    [z, sorted_genotypes, sorted_fenotypes] = evaluate(genotypes, fenotypes, func, num_pop);
    
    %% Seleção
    cumulative_sum = cumsum(z);
    cumulative_sum = cumulative_sum/sum(z); % normalizado
    
    for var=1:num_variables
        for i=1:num_pop
            % Prob a ser seguida, a maior possível dentre as fitness no alcance
            % definido pela soma cumulativa
            if i > pop_to_keep
                r = rand(); % probabilidade [0, 1]
                idx = find(r <= cumulative_sum, 1, 'first');
                new_genotypes(i, :, var) = sorted_genotypes(idx, :, var);
            else
                new_genotypes(i, :, var) = sorted_genotypes(i, :, var);
            end
        end
        new_fenotypes(:, var) = bin_to_dec(new_genotypes(:, :, var), x_min(var), x_max(var), num_bits, num_pop);
    end
    [z, sorted_genotypes, sorted_fenotypes] = evaluate(new_genotypes, new_fenotypes, func, num_pop);
end