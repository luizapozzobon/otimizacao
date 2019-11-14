clc;
clear all;
close all;

% Dijkstra
% matriz w nxn de pesos entre os pontos
% matriz não é simétrica (wij != wji), as vezes pode ir para um ponto, mas não voltar
% wii = 0, wij = infinito quando não há conexão direta entre os pontos

% ==============================
% ============= Definição dos parâmetros
% === Pontos
s = 1;
a = 2;
b = 3;
c = 4;
d = 5;
t = 6;
% lista dos pontos em string, nas posições correspondentes definidas acima
points_list = ["S", "A", "B", "C", "D", "T"];

% ============== Início e Destino
starting_point = s;
destination = t;
% ==============

% === Número de pontos
n = t; 

% === Matriz de pesos
w = zeros(n, n);
w(s, a) = 15;
w(s, d) = 9;
w(a, b) = 35;
w(a, c) = 3;
w(b, a) = 16;
w(b, c) = 6;
w(b, t) = 21;
w(c, d) = 2;
w(c, t) = 7;
w(d, a) = 4;
w(d, c) = 2;
w(t, b) = 5;
for i=1:n
    for j=1:n
        if (w(i, j) == 0) && (i ~= j)
            w(i, j) = 1.e1000;
        end
    end
end

% === Vetor auxiliar de rótulos temporários
temp_rot = zeros(1, n);
for i=1:n
    temp_rot(i) = 1e10000;
end

% === Vetor de ordem de rótulos permanentes
% Primeira linha = qual ponto recebeu naquela iteração
perm_rot = zeros(1, n);
perm_rot(1) = starting_point; % primeiro permanente é o s

% === Matrix auxiliar de valor de rótulos obtidos
% Primeira linha = de qual ponto estamos falando, de s a t
% segunda linha = para qual ponto de referencia teve aquele valor?
% terceira linha = valor
min_values = zeros(3, n);
for i=1:n
    min_values(1, i) = i;
    min_values(2, i) = 1e1000;
    min_values(3, i) = 1e1000;
end
min_values(2, starting_point) = starting_point;
min_values(3, starting_point) = 0;

% Inicialização do primeiro rótulo permanente (do ponto s), vi = 0
vi = 0;
% Ponto que recebeu último rótulo permanente
last_perm = starting_point;

cont = 1; % contador de iterações

% Lista auxiliar com valores ainda temporários
temp_list = [s, a, b, c, d, t];
temp_list(temp_list == starting_point) = []; % remover ponto de início

% == Início da iteração
while(last_perm ~= destination && cont < 10)
    % ponto de rotulo permanente anterior = i = last_perm
    % vertice atual = j
    for j=1:size(temp_list, 2)
        points_list(temp_list(j))
        % atualizar rótulos de pontos presentes na temp_list
        % necessária para guardarmos o último valor para tal ponto
        temp_rot(temp_list(j)) = min(temp_rot(temp_list(j)), vi + w(last_perm, temp_list(j)));
        
        % vetor auxiliar para obtermos o
        % rótulo permanente dessa iteração
        % linha 1 = qual ponto
        % linha 2 = qual seu valor
        temp_rot_comp(1, j) = temp_list(j);
        temp_rot_comp(2, j) = temp_rot(temp_list(j));
        
        % Salvar valores mínimos obtidos em matriz auxiliar
        % coluna = ponto j nessa iteração -> nunca alterada
        % linha 2 = ponto de último valor permanente, i,  nessa iteração
        % linha 3 = valor do peso de i->j
        if temp_rot(temp_list(j)) < min_values(3, temp_list(j))
            points_list(temp_list(j))
            min_values(2, temp_list(j)) = last_perm;
            min_values(3, temp_list(j)) = w(last_perm, temp_list(j));
        end
    end
    
    % ====== Decisão do ponto de rótulo permanente
    % Rótulo permanente = menor rótulo temporário dessa iteração
    [M, I] = min(temp_rot_comp(2, :));
    if size(M) > 1 % caso de empate, escolher qualquer um (nesse caso o 1o)
        vi = M(1);
        last_perm = temp_rot_comp(1, I(1));
    else
        vi = M;
        last_perm = temp_rot_comp(1, I);
    end
    
    % ======= Atualização das listas de rótulos permanentes e temporários

    % adicionar ponto permanente na lista de permanentes
    perm_rot(1 + cont) = last_perm;
    
    % deletar ponto permanente da lista de pontos temporarios
    temp_list(temp_list == last_perm) = []; 
    
    % atualização do contador de iterações
    cont = cont + 1;
end

% Qual o menor caminho a percorrer para ir da origem até o destino?
cont = 2;
path_sum = 0;
current_point = destination;
path(cont-1) = points_list(current_point);
min_values
while(current_point ~= starting_point)
    % Pegar ponto, em string, a partir do valor armazenado na 2a linha de
    % min_values para o current_point (início é no destino, caminho inverso).
    % Lembrando que as linhas do min values correspondem a:
    % [current_point, ponto de menor distancia até current_point, valor da distancia]
    path(cont) = points_list(min_values(2, current_point));
    
    % Somar valores do caminho
    path_sum = path_sum + min_values(3, current_point);
    
    % mudança do ponto atual
    
    current_point = min_values(2, current_point);
    cont = cont + 1;
end
path = flip(path)
path_sum