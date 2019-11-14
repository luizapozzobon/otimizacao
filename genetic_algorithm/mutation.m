function [genotypes] = mutation(genotypes, pop_to_keep, mutation_rate, bits_to_mutate, num_bits, num_pop, num_variables)
    for var=1:num_variables    
        for p=1:num_pop
            if p > pop_to_keep
                % N�mero aleat�rio de 0 a 1
                random = rand();
                % Se for menor ou igual � taxa de muta��o, ocorre a muta��o
                if random <= mutation_rate
                   % Pegamos quais indexes ser�o mutacionados do gen�tipo do indiv�duo
                   bit_indexes = randi([1, num_bits], bits_to_mutate, 1);

                   % Ent�o, trocamos os bits especificos
                   for b=1:bits_to_mutate
                       curr_bit = genotypes(p, bit_indexes(b), var);
                       if curr_bit == 1
                           new_bit = 0;
                       else 
                           new_bit = 1;
                       end
                       % Troca do valor do bit
                       genotypes(p, bit_indexes(b), var) = new_bit;
                   end
                end
            end
        end
    end
end