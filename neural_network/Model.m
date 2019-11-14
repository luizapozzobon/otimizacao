classdef Model
    properties
        layers
    end
    methods
        function obj = Model(layers)
            obj.layers = layers;
        end
        
        function [pred, layers] = forward(obj, input)
            % Passagem forward da rede neural
            % Itera por todas as camadas definidas na cria��o da classe Model
            for l=1:length(obj.layers)
                % output = Weights*input + bias
                pred = (input * obj.layers(l).weights) + obj.layers(l).bias;
                
                % Fun��o de ativa��o na sa�da da camada linear, se houver
                if obj.layers(l).activation ~= 0
                    pred = activation(pred, obj.layers(l).activation);
                end
                
                obj.layers(l).output = pred';
                input = pred; % Sa�da de uma camada � entrada da pr�xima
            end
            layers = obj.layers;
        end
       
        function [layers] = backprop(obj, input, pred, target, lr)
            % m = training samples
            m = 1;
            
            % �ltima camada
            dZ_curr = pred - target; % 'erro' entre uma camada e outra
            dW = obj.layers(end).output * dZ_curr; % Gradiente dos pesos
            db = sum(obj.layers(end).bias, 2); % Gradiente do bias
            
            % Atualiza��o dos pesos e bias da �ltima camada
            % w' = w - learning_rate * dW
            % b' = b - learning_rate * db
            obj.layers(end).weights = obj.layers(end).weights - lr * dW;
            obj.layers(end).bias = obj.layers(end).bias - lr * db;
            
            % C�lculo do gradiente e atualiza��o dos pesos e bias
            % Come�ando na �ltima camada escondida
            for i=length(obj.layers)-1:-1:2
                % Gradientes dos pesos e bias para hidden layers
                dW = (1/m) * obj.layers(i - 1).output .* dZ_curr;
                db = (1/m) * sum(dZ_curr, 2)';
                % dA_prev = obj.layers(i).weights .* dZ_curr;

                dZ_curr = obj.layers(i).weights .* dZ_curr; % Novo 'erro' entre uma camada e outra
                %dZ_curr = (obj.layers(i).weights' .* dZ_curr) * (1 - (obj.layers(i-1).output).^2);
                
                % Atualiza��o dos pesos e bias das camadas escondidas
                obj.layers(i).weights = obj.layers(i).weights - lr * dW;
                obj.layers(i).bias = obj.layers(i).bias - lr * db;
            end
            
            % Atualiza��es para o primeiro layer
            dW = (1/m) * input .* dZ_curr;
            db = (1/m) * sum(dZ_curr, 2)';
            obj.layers(1).weights = obj.layers(1).weights - lr * dW';
            obj.layers(1).bias = obj.layers(1).bias - lr * db;
            
            layers = obj.layers;
        end
    end
end