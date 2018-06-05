// Otimização por Nuvem de Partículas (configurado para maximização)
// Autor: Denis Ricardo da Silva Medeiros

// Parâmetros do PSO
NUM_PART = 50;
NUM_GER = 50;
PAR_COG = 0.8;
PAR_SOCIAL = 0.2;
INERCIA = 0.9;
DIMENSOES = 2;
L_MIN = -10;
L_MAX = 10;

function plotar()
    [x, y] = meshgrid(-500:5:500,-500:5:500);
    z = -x.*sin(sqrt(abs(x)))-y.*sin(sqrt(abs(y)));
    x = x/250;
    y = y/250;
    // r: Rosenbrock's function
    r = 100*(y-x.^2).^2+(1-x).^2;
    r1 = (y-x.^2).^2+(1-x).^2;

    w = r .* z;
    w2 = z - r1;
    w6 = w + w2;
    x = x * 250;
    y = y * 250;
    figure;
    surf(x, y, w6);
endfunction

//// Função de avaliação.
//function saida = fa(xn)
//    x = xn(1);
//    y = xn(2);
//    z=-x.*sin(sqrt(abs(x)))-y.*sin(sqrt(abs(y)));
//    x = x/250;
//    y = y/250;
//    r = 100*(y-x.^2).^2+(1-x).^2;
//    r1 = (y-x.^2).^2+(1-x).^2;
//    w = r .* z;
//    w2 = z - r1;
//    w6 = w + w2;
//    saida = -w6;
//endfunction


//function saida = fa(xn)
//    x = xn(1);
//    y = xn(2);
//    //z = xn(1) .^2 + xn(2) .^ 2;
//    z = (x - 2).^2 + (y - 8).^2 + 7;
//    saida = -z;
//endfunction

function saida = fa(xn)
    x = xn(1);
    y = xn(2);
    z = x.^2 + y.^2;
    saida = -z;
endfunction

// Inicia a nuvem de partículas.
posicoes = L_MIN + (L_MAX-L_MIN) .* rand(NUM_PART, DIMENSOES);
velocidades = L_MIN + (L_MAX-L_MIN) .* rand(NUM_PART, DIMENSOES);
pbest = posicoes;
gbest = posicoes(1,:);

// Processa as gerações.
for i=1:NUM_GER
    
    for j=1:NUM_PART
        avaliacao = fa(posicoes(j,:));
        // Encontra o personal best da partícula.
        if avaliacao > pbest(j) then
            pbest(j,:) = posicoes(j,:);
        end
        // Verifica se ele também é global best da população.
        if avaliacao > gbest then
            gbest(1,:) = posicoes(j,:);
        end
    end
    
    for j=1:NUM_PART
        for d=1:DIMENSOES
            // Atualiza as velocidades.
            velocidades(j, d) = INERCIA*velocidades(j, d) + rand(1).*PAR_COG.*(pbest(j, d) - posicoes(j, d)) + rand(1).*PAR_SOCIAL.*(gbest(1,d)-posicoes(j, d));
            // Atualiza as posições.
            posicoes(j,d) = posicoes(j,d) + velocidades(j,d);
            if posicoes(j,d) < L_MIN then
                posicoes(j,d) = L_MIN;
            elseif  posicoes(j,d) > L_MAX then
                posicoes(j,d) = L_MAX;   
            end
        end
    end
    
    // Atualiza as posições.
end


// Mostrando a resposta.
disp(posicoes);
disp(gbest);
