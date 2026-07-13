% Pedro Mariano dos Santos
clear;
clc;
close all;

%% Atividade 1
% a) Sinal x[n] conforme o grafico (n = 0...7)
n = 0:7;
x = [1 2 2 1 -1 1 0 0];

figure('Name','Atividade 1');
stem(n, x, 'o', 'LineWidth', 1.2); grid on;
xlabel('n'); ylabel('x[n]');
title('Sinal x[n]');

% b) Sistema dado por:
% y[n] = x[n] + 0.6x[n-1] + 0.36x[n-2] + 0.216x[n-3]
b = [1 0.6 0.36 0.216];
y1 = filtro_fir_por_equacao(x, b);
ny1 = 0:length(y1)-1;

% c) Plot de x[n] e y[n] na mesma figura
figure('Name','Atividade 1 - x[n] e y[n]');
stem(n, x, 'o', 'LineWidth', 1.2); hold on;
stem(ny1, y1, 'x', 'LineWidth', 1.2);
grid on;
xlabel('n'); ylabel('Amplitude');
title('Comparacao de x[n] e y[n]');
legend('x[n]', 'y[n]', 'Location', 'best');

%% Atividade 2
% a) Resposta impulsiva do sistema da Atividade 1
h = b;
nh = 0:length(h)-1;

figure('Name','Atividade 2a - h[n]');
stem(nh, h, 'filled', 'LineWidth', 1.2); grid on;
xlabel('n'); ylabel('h[n]');
title('Resposta impulsiva h[n]');

% b) Saida por soma das respostas aos impulsos (convolucao manual)
y2 = convolucao_por_soma_de_impulsos(x, h);
ny2 = 0:length(y2)-1;

% c) Plot de y[n] e comparacao com a Atividade 1
figure('Name','Atividade 2c - comparacao y1 e y2');
stem(ny1, y1, 'o', 'LineWidth', 1.2); hold on;
stem(ny2, y2, 'x', 'LineWidth', 1.2);
grid on;
xlabel('n'); ylabel('Amplitude');
title('Saida por equacao de diferencas vs soma de respostas impulsivas');
legend('y1[n] (Ativ. 1)', 'y2[n] (Ativ. 2)', 'Location', 'best');

erro_max = max(abs(y1(:) - y2(:)));
fprintf('Atividade 2: erro maximo |y1 - y2| = %.12f\n', erro_max);

%% Atividade 3
% a) Obter audio:
% - se existir arquivo em audioFile, usa audioread
% - senao grava 5 s via microfone
audioFile = 'audio.mp3';
duracaoSeg = 5;
FsGrav = 44100;

if isfile(audioFile)
    [xAudio, Fs] = audioread(audioFile);
    fprintf('Audio lido de arquivo: %s\n', audioFile);
else
    fprintf('Arquivo %s nao encontrado. Gravando %d s...\n', audioFile, duracaoSeg);
    recObj = audiorecorder(FsGrav, 16, 1);
    recordblocking(recObj, duracaoSeg);
    xAudio = getaudiodata(recObj);
    Fs = FsGrav;
    fprintf('Gravacao finalizada.\n');
end

% Se vier estereo, converte para mono
if size(xAudio, 2) == 2
    xAudio = mean(xAudio, 2);
end

% Normaliza para evitar clipping no processamento/reproducao
if max(abs(xAudio)) > 0
    xAudio = xAudio / max(abs(xAudio));
end

% b) Criar h[n] para 5 ecos com atenuacao 0.6 e atraso 0.4 s
numEcos = 5;
Aeco = 0.6;
atrasoSeg = 0.4;
D = round(atrasoSeg * Fs);  % atraso em amostras

hEco = zeros(D * numEcos + 1, 1);
for k = 0:numEcos
    hEco(1 + k * D) = Aeco^k;
end

figure('Name','Atividade 3b - hEco[n]');
stem(0:length(hEco)-1, hEco, '.'); grid on;
xlabel('n'); ylabel('hEco[n]');
title('Resposta impulsiva do efeito de eco (5 ecos)');

% c) Aplicar no audio usando algoritmo da Atividade 2 (convolucao por impulsos)
yEco = convolucao_por_soma_de_impulsos(xAudio(:).', hEco(:).');
yEco = yEco(:);
if max(abs(yEco)) > 0
    yEco = yEco / max(abs(yEco));
end

fprintf('Reproduzindo audio original...\n');
sound(xAudio, Fs);
pause(length(xAudio)/Fs + 0.5);

fprintf('Reproduzindo audio com eco (Atividade 3)...\n');
sound(yEco, Fs);
pause(length(yEco)/Fs + 0.5);

%% Atividade 4
% Sistema recursivo: y[n] = x[n] + A * y[n - D]
% Para eco parecido com a Atividade 3:
% A = 0.6 e D = round(0.4*Fs)
A = 0.6;
Drec = D;

% Adiciona cauda para ouvir repeticoes apos o fim do audio original
cauda = zeros(Drec * 5, 1);
xPad = [xAudio; cauda];

yRec = eco_recursivo(xPad, A, Drec);
if max(abs(yRec)) > 0
    yRec = yRec / max(abs(yRec));
end

fprintf('Reproduzindo audio com eco recursivo (Atividade 4)...\n');
sound(yRec, Fs);
pause(length(yRec)/Fs + 0.5);

fprintf('\nResumo:\n');
fprintf('- Ativ. 2 confirmou y1 = y2 (erro maximo numerico pequeno).\n');
fprintf('- Ativ. 4: efeito de eco semelhante com A = %.2f e D = %d amostras (~%.3f s).\n', ...
    A, Drec, Drec/Fs);

%% Funcoes locais
function y = filtro_fir_por_equacao(x, b)
% Calcula y[n] = sum_k b(k+1)*x[n-k], com x fora do intervalo igual a 0.
x = x(:).';
M = length(b);
N = length(x);
y = zeros(1, N + M - 1);

for n = 1:(N + M - 1)
    acc = 0;
    for k = 1:M
        idx = n - (k - 1);
        if idx >= 1 && idx <= N
            acc = acc + b(k) * x(idx);
        end
    end
    y(n) = acc;
end
end

function y = convolucao_por_soma_de_impulsos(x, h)
% Implementa y = x * h pela soma das respostas de cada impulso de x.
x = x(:).';
h = h(:).';
Nx = length(x);
Nh = length(h);
y = zeros(1, Nx + Nh - 1);

for i = 1:Nx
    y(i:i+Nh-1) = y(i:i+Nh-1) + x(i) * h;
end
end

function y = eco_recursivo(x, A, D)
% Implementa y[n] = x[n] + A*y[n-D] (causal, com y[n<0] = 0).
x = x(:);
N = length(x);
y = zeros(N,1);

for n = 1:N
    y(n) = x(n);
    if n - D > 0
        y(n) = y(n) + A * y(n - D);
    end
end
end
