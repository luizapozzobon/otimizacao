clc;
close all;
clear all;

% Método da bisseção
% Desenho e funções no caderno, dia 06/09
% Divide a função ao meio, em partes esquerda e direita
% Comparar as metades dos dois lados. 
% O que for 'pior', a fronteira afunila (limite, a ou b, vai diminuindo).
% Até os dois pontos a e b chegarem perto -> ponto de mínimo.

% Funções multi e unimodais
y1 = @(x) -(1/((x - 0.3)^2 + 0.01) + 1/((x - 0.9)^2 + 0.04) - 6);
y2 = @(x) 2*x^2 - 5*x - 5;

% Função a ser utilizada dessa vez.
y = y1;

% Parâmetros iniciais
a_ini = -2;
b_ini = 2;

a_A = a_ini;
b_A = b_ini;

cont = 0;

while(abs(a_A - b_A)/(b_ini - a_ini) >= 1e-6)
    % 1) Achar o meio de y
    x_mid = (a_A + b_A)/2;

    % 2) Achar o meio das duas metades e comparar. Pior, puxa a ou b 
    % para aquele lado.
    x_mid_left = (a_A + x_mid)/2;
    x_mid_right  = (b_A + x_mid)/2;
    
    y_left = y(x_mid_left);
    y_right = y(x_mid_right);
    
    scatter(x_mid_left, y_left, 'r');
    hold on;
    scatter(x_mid_right, y_right, 'b');
    hold on;
    
    % Pior = valor maior
    if(y_left > y_right)
        a_A = x_mid_left;
        minimo = y_right;
        xmin = x_mid_right;
    end
    if(y_left < y_right)
        b_A = x_mid_right;
        minimo = y_left;
        xmin = x_mid_left;
    end
    if(y_left == y_right)
        b_A = x_mid_left;
        a_A = x_mid_right;
        minimo = y_left;
        xmin = x_mid_left;
    end
    
    cont = cont + 1;
end

fplot(y);

xmin
minimo
cont