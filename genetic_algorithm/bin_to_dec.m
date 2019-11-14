function [fenotypes] = bin_to_dec(genotypes, x_min, x_max, num_bits, num_pop)

    % Matriz vazia de chars [num_pop, num_bits]
    str_bin = repmat(' ', num_pop, num_bits);
    
    % Conversão da população de bits para string de bits
    % Em seguida, conversão para decimal e cálculo do fenótipo.
    for i=1:num_pop
        for bit=1:num_bits
            str_bin(i, bit) = string(genotypes(i, bit));
        end
        dec_from_bin = bin2dec(str_bin(i, :));
        fenotypes(i) = x_min + ((x_max - x_min) * dec_from_bin)/(2^num_bits - 1);
    end
end