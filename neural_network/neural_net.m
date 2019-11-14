clc; clear all; close all;

% Neural Networks
% Luiza Pozzobon

%% Quantia de neuronios
% Entre #in e #out
% Menos neurônios que 2x #in
% 2/3(#in e #out)

%% 

f = @(x) 3*x(1) + x(2);
% Criação do Dataset
for i=1:100
    input1 = 0 + rand() * 10; % Se for usar relu, não é bom usar dataset com dados negativos
    input2 = 0 + rand() * 10; % pois relu só deixa valores de pesos positivos
    inputs(i, :) = [input1, input2];
    targets(i) = f(inputs(i, :));
end

%% Criação do modelo
% Camadas lineares (totalmente conectadas) = Linear(input, output, ativação)
% com pesos aleatórios entre 0 e 1 e bias sempre de valor 1.
% Se não quiser ativação, digitar 0 ao invés do 'relu'

% Sigmoid ainda não está funcionando
%model = Model([Linear(2, 3, 'sigmoid'), Linear(3, 2, 'sigmoid'), Linear(2, 1, 'sigmoid')]);

%model = Model([Linear(2, 3, 'relu'), Linear(3, 2, 'relu'), Linear(2, 1, 'relu')]);
model = Model([Linear(2, 3, 0), Linear(3, 2, 0), Linear(2, 1, 0)]); % sem ativação

%% Hiperparâmetros
max_epochs = 500;
batch_size = 10;
lr = 0.000002;

% Contadores
batch_count = 0;
epochs = 0;

% Se for usar como critério o valor da loss
%epoch_loss = 20000;
%desired_loss = 1; % precisão

%while epoch_loss > desired_loss
for epochs=1:max_epochs
    epochs
    % Início de uma época
    for batch=1:length(targets)/batch_size
        cost = 0;
        for batch_sample=1:batch_size
            % Amostra (index global) dessa iteração no batch
            sample = (batch * batch_size + batch_sample) - batch_size;
            % Forward prop
            [pred, layers] = model.forward(inputs(sample, :));
            % Atualização dos layers na forward prop (outputs)
            model.layers = layers;
            % Salvando o resultado obtido
            preds(sample) = pred;
            
            % Cálculo do erro
            error = loss(targets(sample), pred);
            cost = cost + error;
        end
        
        mean_loss = cost/batch_size; % Erro médio nesse batch
        batches_loss(batch) = mean_loss; % Registro dos erros dos batches de uma época
        
        % Atualizando os pesos
        for batch_sample=1:batch_size
            sample = (batch * batch_size + batch_sample) - batch_size;

            % Backpropagation
            layers = model.backprop(inputs(sample, :), preds(sample), targets(sample), lr);
            model.layers = layers; % atualizando os layers
        end
        batch_count = batch_count + 1;
    end
    epoch_loss(epochs+1) = mean(batches_loss); % Loss de uma época (conjunto de n batches) -> critério de parada
    %epochs = epochs + 1
end
preds(1:10)
targets(1:10)
display('Batches treinados: ')
display(batch_count)
display('Épocas de treino')
display(epochs)
display('Erro médio da última época: ')
display(epoch_loss(end))

figure(1)
plot(epoch_loss, 'r')
title('Erro x Épocas');

figure(2)
scatter(inputs(:, 1), preds, 'r')
title('Em verde os pontos (1) da função original e vermelho a gerada pela rede');
hold on;
scatter(inputs(:, 1), targets, 'g')