function [z_sorted, sorted_genotypes, sorted_fenotypes] = evaluate(genotypes, fenotypes, func, num_pop)
    
    for i=1:num_pop
        z(i) = func(fenotypes(i, :));
    end
    
    %% Ordenação em ordem decrescente
    [z_sorted, z_order] = sort(z, 'descend');
    sorted_genotypes = genotypes(z_order, :, :);
    sorted_fenotypes = fenotypes(z_order, :);
end