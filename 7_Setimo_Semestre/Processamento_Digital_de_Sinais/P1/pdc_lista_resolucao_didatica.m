%% PDC List - Resolucao didatica para prova
% Tema: Equacoes de diferencas, resposta impulsiva, convolucao e eco.
% Este roteiro foi escrito para estudo: cada etapa tem teoria, calculo e grafico.
%
% Como usar:
% 1) Execute o script inteiro.
% 2) Leia os textos no Command Window e compare com os graficos.
% 3) Se quiser ouvir os audios, ative PLAY_AUDIO = true.

clear; clc; close all;

%% Configuracoes gerais (pode alterar)
% Tambem e possivel configurar por variaveis de ambiente:
% PDC_PLAY_AUDIO=1 e PDC_GRAVAR_AUDIO=1
envPlay = getenv('PDC_PLAY_AUDIO');
envRec = getenv('PDC_GRAVAR_AUDIO');

PLAY_AUDIO = true;   % troque para true se quiser ouvir os audios
GRAVAR_AUDIO = true; % troque para true para gravar quando nao houver arquivo

if ~isempty(strtrim(envPlay))
    PLAY_AUDIO = any(strcmpi(strtrim(envPlay), {'1','true','yes','sim'}));
end
if ~isempty(strtrim(envRec))
    GRAVAR_AUDIO = any(strcmpi(strtrim(envRec), {'1','true','yes','sim'}));
end

audioFile = 'audio.mp3';
duracaoSeg = 5;
FsGrav = 44100;

fprintf('\n==============================================================\n');
fprintf('PDC LIST - RESOLUCAO DIDATICA\n');
fprintf('==============================================================\n');
fprintf('Modelo LTI usado na lista:\n');
fprintf('  y[n] = x[n] + 0.6x[n-1] + 0.36x[n-2] + 0.216x[n-3]\n');
fprintf('Equacao de convolucao:\n');
fprintf('  y[n] = sum_{k=-inf}^{inf} x[k] h[n-k]\n');
fprintf('Para sinais causais e finitos:\n');
fprintf('  y[n] = sum_{k=0}^{N-1} x[k] h[n-k]\n\n');

%% ATIVIDADE 1 -----------------------------------------------------------
% Sinal de entrada e sistema FIR de ordem 3.

n = 0:7;
x = [1 2 2 1 -1 1 0 0];

% Coeficientes da equacao de diferencas (FIR):
% y[n] = b0*x[n] + b1*x[n-1] + b2*x[n-2] + b3*x[n-3]
b = [1 0.6 0.36 0.216];

% Calculo direto pela equacao de diferencas
[y1, termosY1] = fir_por_equacao_explicada(x, b);
ny1 = 0:length(y1)-1;

fprintf('ATIVIDADE 1\n');
fprintf('Sistema FIR: y[n] = sum_{m=0}^{3} b[m]x[n-m]\n');
fprintf('b = [1, 0.6, 0.36, 0.216]\n\n');

% Tabela numerica para estudo
T1 = table(ny1(:), y1(:), 'VariableNames', {'n', 'y1_n'});
disp('Tabela da saida y1[n] (Atividade 1):');
disp(T1);

% Visual completo da Atividade 1
figure('Name','Atividade 1 - visao geral','Color','w');
tl = tiledlayout(2,2,'TileSpacing','compact','Padding','compact');
title(tl,'Atividade 1: entrada, coeficientes e saida');

nexttile;
stem(n, x, 'filled', 'LineWidth', 1.2); grid on;
xlabel('n'); ylabel('x[n]');
title('Entrada x[n]');

nexttile;
stem(0:length(b)-1, b, 'filled', 'LineWidth', 1.2); grid on;
xlabel('n'); ylabel('h[n]');
title({'Resposta impulsiva do FIR', 'h[n] = [1 0.6 0.36 0.216]'});

nexttile;
stem(ny1, y1, 'filled', 'LineWidth', 1.2); grid on;
xlabel('n'); ylabel('y_1[n]');
title('Saida pela equacao de diferencas');

nexttile;
stem(n, x, 'o', 'LineWidth', 1.2); hold on;
stem(ny1, y1, 'x', 'LineWidth', 1.2);
grid on;
xlabel('n'); ylabel('Amplitude');
title('Comparacao visual: x[n] e y_1[n]');
legend('x[n]','y_1[n]','Location','best');

% Mostra detalhamento dos primeiros instantes
fprintf('Primeiros instantes detalhados (expansao da soma):\n');
for ii = 1:min(6, numel(termosY1))
    fprintf('  n=%d -> %s = %.6f\n', ii-1, termosY1{ii}, y1(ii));
end
fprintf('\n');

%% ATIVIDADE 2 -----------------------------------------------------------
% Confirmacao por soma de respostas impulsivas (convolucao).

h = b;
y2 = convolucao_soma_impulsos(x, h);
ny2 = 0:length(y2)-1;

erroMax = max(abs(y1(:) - y2(:)));

fprintf('ATIVIDADE 2\n');
fprintf('Convolucao por soma de impulsos: y2[n] = x[n] * h[n]\n');
fprintf('Erro maximo entre Ativ.1 e Ativ.2: %.12f\n\n', erroMax);

figure('Name','Atividade 2 - comparacao','Color','w');
stem(ny1, y1, 'o', 'LineWidth', 1.2); hold on;
stem(ny2, y2, 'x', 'LineWidth', 1.2);
grid on;
xlabel('n'); ylabel('Amplitude');
title('Atividade 2: y_1[n] (equacao) x y_2[n] (convolucao)');
legend('y_1[n]','y_2[n]','Location','best');

% Visualizacao didatica da soma de impulsos
plot_convolucao_passo_a_passo(x, h, 4);

%% ATIVIDADE 3 -----------------------------------------------------------
% Efeito de eco por resposta impulsiva finita:
% h_eco[n] = sum_{k=0}^{K} a^k delta[n-kD]
% onde K = numero de ecos, a = atenuacao, D = atraso em amostras.

fprintf('ATIVIDADE 3\n');

if isfile(audioFile)
    [xAudio, Fs] = audioread(audioFile);
    fprintf('Audio carregado de arquivo: %s\n', audioFile);
elseif GRAVAR_AUDIO
    fprintf('Arquivo nao encontrado. Gravando %d s...\n', duracaoSeg);
    recObj = audiorecorder(FsGrav, 16, 1);
    recordblocking(recObj, duracaoSeg);
    xAudio = getaudiodata(recObj);
    Fs = FsGrav;
    fprintf('Gravacao finalizada.\n');
else
    % Sinal de teste para estudo (evita depender de microfone)
    Fs = FsGrav;
    tTest = (0:1/Fs:duracaoSeg-1/Fs).';
    xAudio = 0.65*sin(2*pi*220*tTest) + 0.25*sin(2*pi*330*tTest) + 0.10*sin(2*pi*440*tTest);
    fprintf('Arquivo nao encontrado e GRAVAR_AUDIO=false.\n');
    fprintf('Usando sinal sintetico de teste (%d s).\n', duracaoSeg);
end

% Se vier estereo, converte para mono
if size(xAudio, 2) == 2
    xAudio = mean(xAudio, 2);
end

xAudio = normaliza_sinal(xAudio(:));

numEcos = 5;
Aeco = 0.6;
atrasoSeg = 0.4;
D = round(atrasoSeg * Fs);

ganhosEco = Aeco.^(0:numEcos);
hEco = zeros(D*numEcos + 1, 1);
hEco(1 + (0:numEcos)*D) = ganhosEco;

% Aplicacao eficiente da soma de impulsos (equivalente a convolucao com hEco,
% mas explorando que hEco e esparso)
yEco = aplica_eco_por_soma_impulsos(xAudio, ganhosEco, D);
yEco = normaliza_sinal(yEco);

fprintf('Eco finito: K=%d, a=%.3f, D=%d amostras (%.3f s)\n\n', ...
    numEcos, Aeco, D, D/Fs);

% Graficos da Atividade 3
figure('Name','Atividade 3 - resposta impulsiva do eco','Color','w');
stem((0:length(hEco)-1)/Fs, hEco, '.', 'LineWidth', 1.0); grid on;
xlabel('Tempo (s)'); ylabel('h_{eco}[n]');
title('h_{eco}[n] = sum_{k=0}^{K} a^k delta[n-kD]');

% Comparacao temporal (janela inicial para ver o deslocamento)
tOriginal = (0:length(xAudio)-1)/Fs;
tEco = (0:length(yEco)-1)/Fs;
janela = min(length(tOriginal), round(1.8*Fs));

figure('Name','Atividade 3 - sinais no tempo','Color','w');
tl = tiledlayout(3,1,'TileSpacing','compact','Padding','compact');
title(tl,'Atividade 3: audio original e audio com eco');

nexttile;
plot(tOriginal, xAudio, 'LineWidth', 1.0); grid on;
xlabel('Tempo (s)'); ylabel('Amp.');
title('Audio original x[n]');

nexttile;
plot(tEco, yEco, 'LineWidth', 1.0); grid on;
xlabel('Tempo (s)'); ylabel('Amp.');
title('Audio com eco finito y_{eco}[n]');

nexttile;
plot(tOriginal(1:janela), xAudio(1:janela), 'LineWidth', 1.0); hold on;
plot(tEco(1:janela), yEco(1:janela), 'LineWidth', 1.0);
grid on;
xlabel('Tempo (s)'); ylabel('Amp.');
title('Zoom inicial para visualizar repeticoes (eco)');
legend('x[n]','y_{eco}[n]','Location','best');

% Espectro em magnitude (dB) para visual
[fX, magX] = espectro_db(xAudio, Fs);
[fY, magY] = espectro_db(yEco, Fs);

figure('Name','Atividade 3 - espectro','Color','w');
plot(fX, magX, 'LineWidth', 1.0); hold on;
plot(fY, magY, 'LineWidth', 1.0);
grid on;
xlabel('Frequencia (Hz)'); ylabel('Magnitude (dB)');
title('Comparacao de espectros (original x eco)');
legend('Original','Com eco','Location','best');

if PLAY_AUDIO
    fprintf('Reproduzindo audio original...\n');
    sound(xAudio, Fs);
    pause(length(xAudio)/Fs + 0.4);

    fprintf('Reproduzindo audio com eco finito...\n');
    sound(yEco, Fs);
    pause(length(yEco)/Fs + 0.4);
end

%% ATIVIDADE 4 -----------------------------------------------------------
% Eco recursivo:
% y[n] = x[n] + A y[n-D]
%
% Resposta impulsiva teorica:
% h_rec[n] = sum_{k=0}^{inf} A^k delta[n-kD],  para |A| < 1.
% Ou seja, e um eco infinito (IIR).

fprintf('ATIVIDADE 4\n');
Arec = 0.6;
Drec = D;

% Coloca cauda para ouvir/ver repeticoes apos o final do sinal
cauda = zeros(Drec*6, 1);
xPad = [xAudio; cauda];

yRec = eco_recursivo(xPad, Arec, Drec);
yRec = normaliza_sinal(yRec);

% Aproximacao do eco recursivo por soma finita de impulsos.
% Escolhemos K para que |A|^K < 1e-4.
Kaprox = ceil(log(1e-4) / log(abs(Arec)));
ganhosAprox = Arec.^(0:Kaprox);
yAprox = aplica_eco_por_soma_impulsos(xPad, ganhosAprox, Drec);
yAprox = yAprox(1:length(yRec));
yAprox = normaliza_sinal(yAprox);

erroRecAprox = max(abs(yRec - yAprox));

fprintf('Eco recursivo: A=%.3f, D=%d amostras (%.3f s)\n', Arec, Drec, Drec/Fs);
fprintf('Aproximacao por soma finita com K=%d -> erro maximo = %.6e\n\n', ...
    Kaprox, erroRecAprox);

% Resposta impulsiva truncada para visualizacao
hRecPlot = zeros(Drec*Kaprox + 1, 1);
hRecPlot(1 + (0:Kaprox)*Drec) = ganhosAprox;

figure('Name','Atividade 4 - resposta impulsiva recursiva (truncada)','Color','w');
stem((0:length(hRecPlot)-1)/Fs, hRecPlot, '.', 'LineWidth', 1.0); grid on;
xlabel('Tempo (s)'); ylabel('h_{rec}[n]');
title('Aproximacao de h_{rec}[n] = sum_{k=0}^{inf} A^k delta[n-kD]');

tRec = (0:length(yRec)-1)/Fs;
janelaRec = min(length(tRec), round(2.4*Fs));

figure('Name','Atividade 4 - comparacao temporal','Color','w');
plot(tRec(1:janelaRec), yRec(1:janelaRec), 'LineWidth', 1.0); hold on;
plot(tRec(1:janelaRec), yAprox(1:janelaRec), '--', 'LineWidth', 1.0);
grid on;
xlabel('Tempo (s)'); ylabel('Amp.');
title('y_{rec}[n] (recursivo) x aproximacao por soma de impulsos');
legend('Recursivo','Soma finita de impulsos','Location','best');

if PLAY_AUDIO
    fprintf('Reproduzindo audio com eco recursivo...\n');
    sound(yRec, Fs);
    pause(length(yRec)/Fs + 0.4);
end

fprintf('Resumo final:\n');
fprintf('1) Ativ.1 e Ativ.2 sao equivalentes (convolucao = equacao de diferencas FIR).\n');
fprintf('2) Ativ.3 gera eco finito com K+1 repeticoes.\n');
fprintf('3) Ativ.4 gera eco infinito (IIR) para |A|<1, aproximavel por soma finita.\n');
fprintf('==============================================================\n\n');

%% Funcoes locais --------------------------------------------------------
function [y, termos] = fir_por_equacao_explicada(x, b)
% Implementa y[n] = sum_{m=0}^{M-1} b[m]x[n-m], com x fora do suporte = 0.

x = x(:).';
M = length(b);
N = length(x);
y = zeros(1, N + M - 1);
termos = cell(1, N + M - 1);

for n = 1:(N + M - 1)
    acc = 0;
    partes = strings(1, M);

    for m = 1:M
        idx = n - (m - 1);
        if idx >= 1 && idx <= N
            termo = b(m) * x(idx);
            acc = acc + termo;
            partes(m) = sprintf('%.3f*x[%d]', b(m), idx-1);
        else
            partes(m) = sprintf('%.3f*0', b(m));
        end
    end

    y(n) = acc;
    termos{n} = strjoin(partes, ' + ');
end
end

function y = convolucao_soma_impulsos(x, h)
% Convolucao direta por soma das respostas impulsivas.

x = x(:).';
h = h(:).';
Nx = length(x);
Nh = length(h);
y = zeros(1, Nx + Nh - 1);

for i = 1:Nx
    y(i:i+Nh-1) = y(i:i+Nh-1) + x(i) * h;
end
end

function plot_convolucao_passo_a_passo(x, h, nTermos)
% Visual didatico: mostra termos x[k]h[n-k] e soma acumulada.

x = x(:).';
h = h(:).';
Nx = length(x);
Nh = length(h);
Ny = Nx + Nh - 1;

nTermos = min(nTermos, Nx);
acumulado = zeros(1, Ny);

figure('Name','Convolucao passo a passo','Color','w');
tl = tiledlayout(nTermos+1, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
title(tl, 'Soma de impulsos: y[n] = sum_k x[k]h[n-k]');

for k = 1:nTermos
    termo = zeros(1, Ny);
    termo(k:k+Nh-1) = x(k) * h;
    acumulado = acumulado + termo;

    nexttile;
    stem(0:Ny-1, termo, 'filled', 'LineWidth', 1.0); grid on;
    ylabel(sprintf('k=%d', k-1));
    title(sprintf('Termo: x[%d]h[n-%d], x[%d]=%.3f', k-1, k-1, k-1, x(k)));
end

nexttile;
stem(0:Ny-1, acumulado, 'filled', 'LineWidth', 1.1); grid on;
xlabel('n'); ylabel('Soma');
title(sprintf('Soma parcial com %d termos', nTermos));
end

function y = aplica_eco_por_soma_impulsos(x, ganhos, D)
% Aplica y[n] = sum_{k=0}^{K} ganhos[k] * x[n-kD].
% E exatamente a convolucao quando h[n] = sum ganhos[k]delta[n-kD].

x = x(:);
ganhos = ganhos(:);
N = length(x);
K = length(ganhos);

y = zeros(N + (K-1)*D, 1);
for k = 0:(K-1)
    idx = (1:N) + k*D;
    y(idx) = y(idx) + ganhos(k+1) * x;
end
end

function y = eco_recursivo(x, A, D)
% Implementa y[n] = x[n] + A*y[n-D], causal.

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

function x = normaliza_sinal(x)
% Evita clipping mantendo o pico em 1.

maxVal = max(abs(x));
if maxVal > 0
    x = x / maxVal;
end
end

function [f, magDb] = espectro_db(x, Fs)
% Espectro unilateral em dB para comparacao visual.

x = x(:);
N = length(x);
Nfft = 2^nextpow2(N);
X = fft(x, Nfft);
X = X(1:Nfft/2+1);

mag = abs(X);
mag = mag / max(mag + eps);
magDb = 20*log10(mag + 1e-12);
f = (0:Nfft/2)' * (Fs/Nfft);
end
