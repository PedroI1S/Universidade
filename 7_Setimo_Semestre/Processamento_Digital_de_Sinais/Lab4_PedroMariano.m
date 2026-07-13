%% Laboratorio 4 - Comparacao DTFT e FFT
% Disciplina: Processamento Digital de Sinais - PD46CP
% Professor:  Lucas Bernardo Zilch
% Aluno:      Pedro Mariano

clear; close all; clc;

%% Atividade 1 - Sinal x[n] e sua DTFT
% x[n] = (cos(0.2*pi*n) + 0.5*sin(0.4*pi*n)) * (u[n] - u[n-32])  (indexacao i = 1..NA, conforme o roteiro)
NA = 32;
n = 0:NA-1;
x = zeros(1, NA);
for i = 1:NA
    if i < 33
        x(i) = cos(0.2*pi*i) + 0.5*sin(0.4*pi*i);
    else
        x(i) = 0;
    end
end

omega = -pi:0.001:pi;
X = zeros(size(omega));
for i = 1:length(omega)
    X(i) = sum(x .* exp(-1j*omega(i)*n));
end

figure('Name','Atividade 1');
subplot(2,1,1);
stem(n, x, 'filled'); grid on;
xlabel('n'); ylabel('x[n]'); title('Sinal x[n]');

subplot(2,1,2);
plot(omega, abs(X), 'LineWidth', 1.2); grid on;
xlabel('omega (rad/amostra)'); ylabel('|X(e^{j\omega})|'); title('Modulo da DTFT');

%% Atividade 2 - Comparacao DTFT x FFT (N = 32)
X_fft = fft(x);
omega_fft = 2*pi*(0:length(x)-1)/length(x);

figure('Name','Atividade 2');
plot(omega, abs(X), 'LineWidth', 1.2); hold on;
stem(omega_fft, abs(X_fft), 'o'); grid on;
xlabel('omega (rad/amostra)'); ylabel('Magnitude');
title('DTFT (linha) e FFT (amostras)');
legend('DTFT', 'FFT', 'Location', 'best');

%% Atividade 2c - Mesmo sinal com N = 128 (zero-padding)
NA2 = 128;
n2 = 0:NA2-1;
x2 = zeros(1, NA2);
for i = 1:NA2
    if i < 33
        x2(i) = cos(0.2*pi*i) + 0.5*sin(0.4*pi*i);
    else
        x2(i) = 0;
    end
end

omega2 = -pi:0.001:pi;
X2 = zeros(size(omega2));
for i = 1:length(omega2)
    X2(i) = sum(x2 .* exp(-1j*omega2(i)*n2));
end
X2_fft = fft(x2);
omega2_fft = 2*pi*(0:length(x2)-1)/length(x2);

figure('Name','Atividade 2c');
plot(omega2, abs(X2), 'LineWidth', 1.2); hold on;
stem(omega2_fft, abs(X2_fft), 'o'); grid on;
xlabel('omega (rad/amostra)'); ylabel('Magnitude');
title('DTFT (linha) e FFT (N=128)');
legend('DTFT', 'FFT N=128', 'Location', 'best');

fprintf('\n=== Atividade 2c ===\n');
fprintf('A DTFT nao muda (mesmo sinal). A FFT com N=128 amostra a MESMA DTFT mais\n');
fprintf('densamente: ganho de resolucao de visualizacao, sem informacao nova.\n');

%% Atividade 3 - Remocao de ruido de 1 kHz via FFT/IFFT
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

duracaoSeg = 10;
maxSamples = min(length(xAudio), round(duracaoSeg * FA));
xAudio = xAudio(1:maxSamples);
fprintf('\n=== Atividade 3 ===\n');
fprintf('Arquivo: "%s" | Fs = %d Hz | %d amostras (mono).\n', audioFile, FA, length(xAudio));

f0 = 1000;
t = (0:length(xAudio)-1).' / FA;
ruido = 0.3 * sin(2*pi*f0*t);
xRuido = xAudio + ruido;

N = length(xRuido);
Xruido = fft(xRuido);
f = (0:N-1).' * FA / N;

figure('Name','Atividade 3 - FFT com ruido');
plot(f, abs(Xruido), 'LineWidth', 1.0); grid on;
xlabel('Frequencia (Hz)'); ylabel('Magnitude');
title('FFT do sinal com ruido (pico em 1 kHz)');
xlim([0 min(5000, FA/2)]);

% zera a raia de 1 kHz e sua espelhada
k = round(f0 / FA * N);
Xruido(k+1) = 0;
Xruido(N-k+1) = 0;
xLimpo = real(ifft(Xruido));

% reproducao para comparacao auditiva
fprintf('Reproduzindo: original / com ruido / limpo...\n');
sound(xAudio, FA);  pause(length(xAudio)/FA + 0.5);
sound(xRuido, FA);  pause(length(xRuido)/FA + 0.5);
sound(xLimpo, FA);  pause(length(xLimpo)/FA + 0.5);

fprintf('Zerando a raia de %d Hz e aplicando a IFFT, o tom e praticamente eliminado e\n', f0);
fprintf('o audio volta a soar proximo do original (remocao perfeita se f0*N/Fs for inteiro).\n');
