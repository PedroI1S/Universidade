%% Laboratorio 6 - Filtros Digitais
% Disciplina: Processamento Digital de Sinais - PD46CP
% Professor:  Lucas Bernardo Zilch
% Aluno:      Pedro Mariano

clear; close all; clc;

%% Atividade 1 - Leitura do sinal de audio (~30 s)
% usa o primeiro .mp3 da pasta (ou 'audio.mp3'); funciona com qualquer mp3
audioFile = 'audio.mp3';
if ~isfile(audioFile)
    listaMp3 = dir('*.mp3');
    if isempty(listaMp3)
        error('Nenhum arquivo .mp3 encontrado na pasta atual.');
    end
    audioFile = listaMp3(1).name;
end

[xAudio, FA] = audioread(audioFile);
if size(xAudio, 2) > 1
    xAudio = mean(xAudio, 2);   % estereo -> mono
end
xAudio = xAudio(:);

duracaoSeg = 30;
maxSamples = min(length(xAudio), round(duracaoSeg * FA));
xAudio = xAudio(1:maxSamples);
fprintf('=== Atividade 1 ===\n');
fprintf('Arquivo: "%s" | Fs = %d Hz | %.1f s | %d amostras (mono).\n', ...
    audioFile, FA, length(xAudio)/FA, length(xAudio));

%% Atividade 2 - Passa-baixas (ordem 10): retangular vs Hamming
fc = 500;             % corte do passa-baixas (Hz)
wc = 2*pi*fc/FA;
Ordem0 = 10;
NFFT2 = 8192;

b_rect = fir1(Ordem0, wc/pi, rectwin(Ordem0+1));   % janela retangular
b_hamm = fir1(Ordem0, wc/pi);                       % janela de Hamming

[f2, Hdb_rect] = respFreqDB(b_rect, NFFT2, FA);
[~,  Hdb_hamm] = respFreqDB(b_hamm, NFFT2, FA);
metade2 = 1:floor(NFFT2/2);

figure('Name','Atividade 2 - Passa-baixas ordem 10 (Retangular x Hamming)');
plot(f2(metade2), Hdb_rect(metade2), 'r', 'LineWidth', 1.2); hold on;
plot(f2(metade2), Hdb_hamm(metade2), 'b', 'LineWidth', 1.2); grid on;
xlabel('Frequencia (Hz)'); ylabel('Magnitude (dB)');
title(sprintf('Passa-baixas fc = %d Hz, ordem %d', fc, Ordem0));
legend('Janela retangular', 'Janela de Hamming', 'Location', 'northeast');
xlim([0 5000]); ylim([-100 5]);

fprintf('\n=== Atividade 2 ===\n');
fprintf('Retangular: transicao abrupta, lobulos altos (~ -21 dB).\n');
fprintf('Hamming: lobulos bem menores (~ -53 dB), transicao mais suave.\n');

%% Atividade 3 - Aumenta a ordem (Hamming) ate >= 80 dB acima de 1000 Hz
fstop = 1000;
attMin = 80;
NFFT3 = 65536;
ordemMax = 8000;

Ordem = Ordem0;
piorGanho = 0;
while Ordem <= ordemMax
    bL = fir1(Ordem, wc/pi);
    [f3, Hdb] = respFreqDB(bL, NFFT3, FA);
    banda = (f3 > fstop) & (f3 <= FA/2);
    piorGanho = max(Hdb(banda));
    if piorGanho <= -attMin
        break;
    end
    Ordem = Ordem + 2;   % ordem par (necessaria p/ o passa-altas)
end
if piorGanho > -attMin
    warning('Nao atingiu %d dB ate a ordem %d (pior ganho = %.1f dB).', attMin, ordemMax, piorGanho);
end

figure('Name','Atividade 3 - Passa-baixas Hamming (>= 80 dB acima de 1000 Hz)');
plot(f3(1:floor(NFFT3/2)), Hdb(1:floor(NFFT3/2)), 'b', 'LineWidth', 1.0); hold on;
yline(-attMin, '--k', sprintf('-%d dB', attMin));
xline(fstop, '--r', sprintf('%d Hz', fstop)); grid on;
xlabel('Frequencia (Hz)'); ylabel('Magnitude (dB)');
title(sprintf('Passa-baixas Hamming - ordem %d', Ordem));
xlim([0 5000]); ylim([-140 5]);

fprintf('\n=== Atividade 3 ===\n');
fprintf('Ordem necessaria: %d (pior ganho em f > %d Hz = %.1f dB).\n', Ordem, fstop, piorGanho);
fprintf('Hamming satura ~ -53 dB perto da transicao, entao 80 dB exige ordem altissima\n');
fprintf('e o resultado e marginal. Blackman (~460) ou Kaiser (~230) seriam robustos.\n');

%% Atividade 4 - Aplica o passa-baixas no audio -> GRAVES
graves = conv(xAudio, bL);
fprintf('\n=== Atividade 4 === Passa-baixas (fc = %d Hz) -> GRAVES.\n', fc);

%% Atividade 5 - Passa-altas em 4000 Hz (mesma ordem) -> AGUDOS
fc2 = 4000;           % corte do passa-altas (Hz)
wc2 = 2*pi*fc2/FA;
bH = fir1(Ordem, wc2/pi, 'High');
agudos = conv(xAudio, bH);
fprintf('=== Atividade 5 === Passa-altas (fc = %d Hz) -> AGUDOS.\n', fc2);

%% Atividade 6 - Passa-faixas 500-4000 Hz (mesma ordem) -> MEDIOS
bB = fir1(Ordem, [wc wc2]/pi);   % Wn com 2 elementos -> passa-faixas
medios = conv(xAudio, bB);
fprintf('=== Atividade 6 === Passa-faixas (%d-%d Hz) -> MEDIOS.\n', fc, fc2);

% espectros dos tres filtros sobrepostos
[ff, HdbL] = respFreqDB(bL, NFFT2, FA);
[~,  HdbH] = respFreqDB(bH, NFFT2, FA);
[~,  HdbB] = respFreqDB(bB, NFFT2, FA);
metadeF = 1:floor(NFFT2/2);
figure('Name','Atividades 4-6 - Bandas: graves / medios / agudos');
plot(ff(metadeF), HdbL(metadeF), 'b', 'LineWidth', 1.0); hold on;
plot(ff(metadeF), HdbB(metadeF), 'g', 'LineWidth', 1.0);
plot(ff(metadeF), HdbH(metadeF), 'r', 'LineWidth', 1.0); grid on;
xlabel('Frequencia (Hz)'); ylabel('Magnitude (dB)');
title('Respostas: passa-baixas, passa-faixas e passa-altas');
legend('Graves (PB)', 'Medios (PF)', 'Agudos (PA)', 'Location', 'southwest');
xlim([0 8000]); ylim([-140 5]);

%% Atividade 7 - Reproducao dos audios filtrados
fprintf('\n=== Atividade 7 ===\n');
reproduzir('Original', xAudio, FA);
reproduzir('Graves',   graves, FA);
reproduzir('Agudos',   agudos, FA);
reproduzir('Medios',   medios, FA);
fprintf('Graves: abafados. Agudos: finos/chiados. Medios: voz e instrumentos centrais.\n');

%% Funcoes locais
function [f, Hdb] = respFreqDB(b, NFFT, FA)
    % resposta em frequencia (dB) com zero-padding
    if NFFT < numel(b)
        NFFT = 2^nextpow2(numel(b));
    end
    H = fft([b(:).', zeros(1, NFFT - numel(b))]);
    f = (0:NFFT-1) * FA / NFFT;
    Hdb = 20*log10(abs(H) + eps);
end

function reproduzir(nome, y, FA)
    fprintf('Reproduzindo: %s ...\n', nome);
    y = y / (max(abs(y)) + eps);   % normaliza p/ evitar clipping
    sound(y, FA);
    pause(length(y)/FA + 0.5);
end
