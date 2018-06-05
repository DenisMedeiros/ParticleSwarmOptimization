// Otimização por Nuvem de Partículas (configurado para maximização)
// Autor: Denis Ricardo da Silva Medeiros

// Parâmetros do PSO
NUM_PART = 40;
NUM_GER = 40;
PAR_COG = 0.3;
PAR_SOCIAL = 0.7;
INERCIA = 0.7;
DIMENSOES = 2;
L_MIN = -500;
L_MAX = 500;

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

// Função de avaliação.
function saida = fa(xn)
    x = xn(1);
    y = xn(2);
    z=-x.*sin(sqrt(abs(x)))-y.*sin(sqrt(abs(y)));
    x = x/250;
    y = y/250;
    r = 100*(y-x.^2).^2+(1-x).^2;
    r1 = (y-x.^2).^2+(1-x).^2;
    w = r .* z;
    w2 = z - r1;
    w6 = w + w2;
    saida = -w6;
endfunction


//function saida = fa(xn)
//    x = xn(1);
//    y = xn(2);
//    //z = xn(1) .^2 + xn(2) .^ 2;
//    z = (x - 2).^2 + (y - 8).^2 + 7;
//    saida = -z;
//endfunction

//function saida = fa(xn)
//    x = xn(1);
//    y = xn(2);
//    z = x.^2 + y.^2;
//    saida = -z;
//endfunction

// Inicia a nuvem de partículas.
posicoes = L_MIN + (L_MAX-L_MIN) .* rand(NUM_PART, DIMENSOES);
velocidades = L_MIN + (L_MAX-L_MIN) .* rand(NUM_PART, DIMENSOES);
pbest = posicoes;
gbest = posicoes(1,:);

melhores = zeros(NUM_GER);
medias = zeros(NUM_GER);

// Processa as gerações.
for i=1:NUM_GER
    
    soma = 0.0;
    for j=1:NUM_PART
        avaliacao = fa(posicoes(j,:));
        soma = soma + avaliacao;
        // Encontra o personal best da partícula.
        if avaliacao > fa(pbest(j,:)) then
            pbest(j,:) = posicoes(j,:);
        end
        // Verifica se ele também é global best da população.
        if avaliacao > fa(gbest(1,:)) then
            gbest(1,:) = posicoes(j,:);
        end
    end
    
    melhores(i) = fa(gbest(1,:));
    medias(i) = soma/NUM_PART;
    
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
            
// Plota a melhoria da respostas.
clf();
plot([1:NUM_GER]', melhores, '*-');
plot([1:NUM_GER]', medias, 'go-');
legend(['Melhor aptidão'; 'Média das aptidoẽs']);
xlabel("Gerações");
ylabel("Aptidão");
title("Convergência da resposta");        
            
            
