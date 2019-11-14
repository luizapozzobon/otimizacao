function[genotypes] = crossing(genotypes, pop_to_keep, num_bits, num_pop, num_variables)
    % Listas de indexes dos cromossomos 1 e 2 para crossing
    for var=1:num_variables
        crs1 = randi([1, num_pop], num_pop/2, 1);
        crs2 = randi([1, num_pop], num_pop/2, 1);

        for i=1:num_pop/2
            % Index aleatório de corte no range [2:num_bits-1] do genótipo
            cross_bit = randi([2, num_bits-1]);

            % Geração dos cromossomos filhos
            cr1_crossed = [genotypes(crs1(i), 1:cross_bit, var) genotypes(crs2(i), cross_bit+1:num_bits, var)];
            cr2_crossed = [genotypes(crs2(i), 1:cross_bit, var) genotypes(crs1(i), cross_bit+1:num_bits, var)];

            % Troca do pai pelo filho
            % nunca altera os x melhores da população
            if crs1(i) > pop_to_keep
                % Comparação dos indexes. 
                % Genotypes está ordenado em ordem decrescente.
                genotypes(crs1(i), :, var) = cr1_crossed;
            end
            if crs2(i) > pop_to_keep
                genotypes(crs2(i), :, var) = cr2_crossed;
            end
        end
    end
    %cross_bit = randi([1+1, num_bits-1]);
    %crossed = [cr1(1:cross_bit) cr2(cross_bit+1:num_bits)];
end