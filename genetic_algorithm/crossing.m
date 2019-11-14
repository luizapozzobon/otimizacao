function[genotypes] = crossing(genotypes, pop_to_keep, num_bits, num_pop, num_variables)
    % Listas de indexes dos cromossomos 1 e 2 para crossing
    for var=1:num_variables
        crs1 = randi([1, num_pop], num_pop/2, 1);
        crs2 = randi([1, num_pop], num_pop/2, 1);

        for i=1:num_pop/2
            % Index aleat�rio de corte no range [2:num_bits-1] do gen�tipo
            cross_bit = randi([2, num_bits-1]);

            % Gera��o dos cromossomos filhos
            cr1_crossed = [genotypes(crs1(i), 1:cross_bit, var) genotypes(crs2(i), cross_bit+1:num_bits, var)];
            cr2_crossed = [genotypes(crs2(i), 1:cross_bit, var) genotypes(crs1(i), cross_bit+1:num_bits, var)];

            % Troca do pai pelo filho
            % nunca altera os x melhores da popula��o
            if crs1(i) > pop_to_keep
                % Compara��o dos indexes. 
                % Genotypes est� ordenado em ordem decrescente.
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