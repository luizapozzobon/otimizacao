clc;
close all;
clear all;

% GOLDEN SEARCH
% Igual ao método da bisseção, mas ao invés de diminuir ao meio, utiliza-se
% o alpha1 e alpha2, que representam o número áureo da sequência de
% fibonacci.

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

% Relações do número áureo
alpha1 = (3 - sqrt(5))/2;
alpha2 = 1 - alpha1;

cont = 0;

while(abs(a_A - b_A)/(b_ini - a_ini) >= 1e-6)
   
    golden_number = alpha2/alpha1; % não é usado kk, mas é o nº áureo de fibonacci

    % 1) Achar o meio das duas metades e comparar. Pior, puxa a ou b 
    % para aquele lado.
    x_mid_left = a_A + alpha1 * (b_A - a_A);
    x_mid_right  = a_A + alpha2 * (b_A - a_A);
    
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
    
    cont = cont+1;
end

fplot(y);

xmin
minimo
cont