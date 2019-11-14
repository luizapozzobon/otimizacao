classdef Linear
    properties
        output_size
        input_size
        weights
        bias
        output
        activation
    end
    methods
        function obj = Linear(input_size, neurons, activation)
            % Inicializa��o da camada linear (totalmente conectada)
            obj.input_size = input_size; % Quantia de neuronios de entrada
            obj.output_size = neurons; % Quantia de neuronios de sa�da
            obj.activation = activation; % Fun��o de ativa��o
            for n=1:neurons
                % Pesos definidos pelo tamanho de entrada da camada
                for w=1:input_size
                    obj.weights(w, n) = rand()/10; % Pesos baixos s�o melhores para a converg�ncia
                end
                % Bias para esse neur�nio
                obj.bias(n) = 1;
            end
        end
    end
end