%% Laboratorio 3 - Representacoes de Fourier por FFT
% Disciplina: Processamento Digital de Sinais - PD46CP
% Professor:  Lucas Bernardo Zilch
% Aluno:      Pedro Mariano

clear; close all; clc;

%% Definicoes Gerais
FA = 500;       % frequencia de amostragem (Hz)
NA = 51;        % numero de amostras
n  = 0:NA-1;
t  = n / FA;
f  = (0:NA-1) * FA / NA;
fSenoides = [20, 100, 200, 250, 300, 400];

%% Atividade 1 - Amostragem de senoides e aliasing
for idx = 1:length(fSenoides)
    fSenoide = fSenoides(idx);

    tCont = 0:0.0001:NA/FA;              % eixo "continuo" p/ visualizacao
    sinalCont = sin(2*pi*fSenoide*tCont);
    sinalAmostrado = sin(2*pi*fSenoide*t);
    espectro = abs(fft(sinalAmostrado));
    amostrasPorCiclo = FA / fSenoide;

    figure('Name', sprintf('Atividade 1 - Senoide de %d Hz', fSenoide));
    subplot(2,1,1);
    plot(tCont, sinalCont, 'b-', 'LineWidth', 1.5); hold on;
    stem(t, sinalAmostrado, 'ro', 'LineWidth', 1.5);
    title(sprintf('Senoide Amostrada: f = %d Hz, Fs = %d Hz (%.2f amostras/ciclo)', ...
        fSenoide, FA, amostrasPorCiclo));
    xlabel('Tempo [s]'); ylabel('Amplitude');
    xlim([0 NA/FA]); ylim([-1.2 1.2]); grid on;
    legend('Senoide continua', 'Amostras');

    subplot(2,1,2);
    stem(f, espectro, 'b', 'LineWidth', 1.5);
    title('Espectro em Frequencia (Magnitude da FFT)');
    xlabel('Frequencia [Hz]'); ylabel('Modulo');
    xlim([0 max(f)]); grid on;

    fprintf('\n=== %d Hz | Nyquist = %.0f Hz | %.2f amostras/ciclo ===\n', ...
        fSenoide, FA/2, amostrasPorCiclo);

    % deteccao simples de picos (sem Signal Processing Toolbox)
    espectroMetade = espectro(1:floor(end/2));
    if max(espectroMetade) < 1e-6
        fprintf('Picos: nenhum (sinal amostrado praticamente nulo).\n');
    else
        limiar = max(espectroMetade) * 0.1;
        picosIdx = [];
        for i = 2:length(espectroMetade)-1
            if espectroMetade(i) > espectroMetade(i-1) && espectroMetade(i) > espectroMetade(i+1) && espectroMetade(i) > limiar
                picosIdx = [picosIdx, i];
            end
        end
        fprintf('Picos em: %sHz\n', sprintf('%.1f ', f(picosIdx)));
    end
end

fprintf('\n=== Aliasing (Atividade 1e) ===\n');
fprintf('- f < 250 Hz (Nyquist): representacao em frequencia coerente.\n');
fprintf('- f = 250 Hz (= Fs/2): sin(pi*n) = 0, amostras nulas, sem pico definido.\n');
fprintf('- f = 300/400 Hz (> Nyquist): aliasing, pico rebatido em %.0f/%.0f Hz.\n', FA-300, FA-400);
fprintf('- Frequencia maxima observavel com a FFT: Fs/2 = %.0f Hz.\n', FA/2);

%% Atividade 2 - Espectro em frequencia de uma onda quadrada
FA2 = 1000;        % frequencia de amostragem (Hz)
f0  = 20;          % fundamental da onda quadrada (Hz)
NA2 = 1000;        % numero de amostras

t2 = (0:NA2-1) / FA2;
ondaQuad = sign(sin(2*pi*f0*t2));        % onda quadrada entre -1 e 1
espectroQuad = abs(fft(ondaQuad));
fQuad = (0:NA2-1) * FA2 / NA2;

figure('Name', 'Atividade 2 - Onda Quadrada (1000 amostras)');
subplot(2,1,1);
plot(t2(1:200), ondaQuad(1:200), 'b-', 'LineWidth', 1.5);
title(sprintf('Onda Quadrada: f = %d Hz, Fs = %d Hz, N = %d amostras', ...
    f0, FA2, NA2));
xlabel('Tempo [s]'); ylabel('Amplitude'); xlim([0 0.2]); grid on;

subplot(2,1,2);
freqPlot = fQuad(1:floor(NA2/2));
espectroPlot = espectroQuad(1:floor(NA2/2));
stem(freqPlot, espectroPlot, 'b', 'LineWidth', 1.5);
title('Espectro em Frequencia (Magnitude da FFT)');
xlabel('Frequencia [Hz]'); ylabel('Modulo'); xlim([0 200]); grid on;

fprintf('\n=== Onda quadrada N = %d (Atividade 2d) ===\n', NA2);
fprintf('Esperado: apenas harmonicos impares da fundamental (20, 60, 100, 140, 180 Hz...).\n');
limiar = max(espectroQuad) * 0.05;
picosIdx = [];
for i = 2:length(espectroPlot)-1
    if espectroPlot(i) > espectroPlot(i-1) && espectroPlot(i) > espectroPlot(i+1) && espectroPlot(i) > limiar
        picosIdx = [picosIdx, i];
    end
end
fprintf('Picos em: %sHz\n', sprintf('%.1f ', freqPlot(picosIdx)));

%% Atividade 2e - Onda quadrada com 51 amostras (aliasing)
NA51 = 51;
t51 = (0:NA51-1) / FA2;
ondaQuad51 = sign(sin(2*pi*f0*t51));
espectroQuad51 = abs(fft(ondaQuad51));
fQuad51 = (0:NA51-1) * FA2 / NA51;

figure('Name', 'Atividade 2e - Onda Quadrada (51 amostras - Aliasing)');
subplot(2,1,1);
plot(t51, ondaQuad51, 'r-', 'LineWidth', 1.5); hold on;
stem(t51, ondaQuad51, 'ro', 'LineWidth', 1);
title(sprintf('Onda Quadrada com Aliasing: f = %d Hz, Fs = %d Hz, N = %d amostras', ...
    f0, FA2, NA51));
xlabel('Tempo [s]'); ylabel('Amplitude'); grid on;

subplot(2,1,2);
freqPlot51 = fQuad51(1:floor(NA51/2));
espectroPlot51 = espectroQuad51(1:floor(NA51/2));
stem(freqPlot51, espectroPlot51, 'r', 'LineWidth', 1.5);
title('Espectro em Frequencia (com Aliasing)');
xlabel('Frequencia [Hz]'); ylabel('Modulo'); xlim([0 300]); grid on;

limiar51 = max(espectroQuad51) * 0.05;
picosIdx51 = [];
for i = 2:length(espectroPlot51)-1
    if espectroPlot51(i) > espectroPlot51(i-1) && espectroPlot51(i) > espectroPlot51(i+1) && espectroPlot51(i) > limiar51
        picosIdx51 = [picosIdx51, i];
    end
end
fprintf('\n=== Onda quadrada N = %d (Atividade 2e) ===\n', NA51);
fprintf('Picos em: %sHz\n', sprintf('%.1f ', freqPlot51(picosIdx51)));
fprintf('Com poucas amostras surgem MAIS componentes (aliasing); reduzir N nao resolve.\n');

%% Atividade 2f - Como resolver o aliasing
fprintf('\n=== Solucao do aliasing (Atividade 2f) ===\n');
fprintf('1) Aumentar Fs de modo que Fs/2 > maior frequencia do sinal.\n');
fprintf('2) Filtro anti-aliasing (passa-baixas) antes da amostragem.\n');
