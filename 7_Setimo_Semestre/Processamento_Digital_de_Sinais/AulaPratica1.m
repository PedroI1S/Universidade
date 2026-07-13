% Pedro Mariano dos Santos

%% a)Geração de uma Função Impulso:
clear;
close all;
clc;

n=32;
imp=zeros(1,n);
imp(1)=1;

stem(imp);
figure;
plot(imp);

%% b)Geração de uma Função Degrau:
clear;
nn=1:32;
dg(nn)=1;

stem(nn,dg);
figure; plot(nn,dg);

%% c)Geração de uma exponencial puramente complexa:
clear;
nn=0:31;
x1=exp(j*pi*nn/3);

subplot(4,1,1);
stem(nn,real(x1) ); %Plota a parte real da exponencial
subplot(4,1,2);
stem(nn,imag(x1) ); %Plota a parte imaginária da exp.
subplot(4,1,3);
plot(nn,real(x1) ); %Plota a parte real da exponencial
subplot(4,1,4);
plot(imag(x1) ); %Plota a parte imaginária da exp.

%% d)Geração de exponenciais reais discretas:
clear;
nn=0:31;
a1=1.1; a2=0.6; a3=-0.6; a4=-1.1;
x1=a1.^nn;
x2=a2.^nn;
x3=a3.^nn;
x4=a4.^nn;

subplot(4,1,1);stem(nn,x1);
subplot(4,1,2);stem(nn,x2);
subplot(4,1,3);stem(nn,x3);
subplot(4,1,4);stem(nn,x4);

%% e)Geração de uma exponencial complexa:
clear;
nn=0:31;
alpha=-0.1+0.3j;
x1=exp(alpha*nn);

subplot(4,1,1);stem(real(x1) ); %Plota a parte real
subplot(4,1,2);stem(imag(x1) );%Plota a parte imaginária
subplot(4,1,3);stem(abs(x1) ); %Plota o módulo
subplot(4,1,4);stem(angle(x1) );%Plota a fase

%% f)Senóide
clear;
nn=0:31;
a=3;
x1=a*sin(pi*nn/17); %Qual o período desta onda? "freq = 1/17, logo T = 17ms
x2=a*sin(pi*nn/sqrt(23)); %E desta onda? "T = 23ms"

subplot(2,1,1);stem(nn,x1);
subplot(2,1,2);stem(nn,x2);

%% g)Senóide Amostrada
n=0:100; % Mudei o valor para melhor visualizacao
fs=8000; 
ts=1/fs;
t=n*ts;
x=cos(2*pi*1200*t+ pi/4); %cossenóide de 1200Hz, amostra a 8kHz;

plot(x);

%% h)Quadrada
clear;
n=0:200; % Mudei o valor para melhor visualizacao
fs=3000;
t=n*1/fs;
x=square(2*pi*150*t); %onda quadrada de 150Hz amostrada à 3kHz

plot(x);

%% i) Dente de Serra
clear;
n=0:800; % Mudei o valor para melhor visualizacao
fs=8000;
ts=1/fs;
t=n*ts;
%w especifica a forma da onda dente de serra (0.5 = triangular)
w=1; %usa periodo para subir a rampa se w=0 usa periodo para descer a rampa
x = sawtooth(2*pi*100*t,w); %dente de serra de 100Hz, amostrado em 8kHz

plot(x);

%% j) Chirp – Senóide Cerscente no tempo
clear;
n=0:3000; % Mudei o valor para melhor visualizacao
fs=8000; 
ts=1/fs;
t=n*ts;
f0=0; %frequencia inicial
t1=1; %instante de mudança em segundos
f1=100; % frequencia em t1 segundos
x=chirp(t,f0,t1,f1); %cossenóide com freq. crescente

plot(x);

%% 2)Com base nos conhecimentos adquiridos acima, então agora gere a seguinte família de cosenóides:
% xk[n]=cos(Ωk.n); k=0,1,2,3,4,5; e n=0,1,2,3,...,35 e com Ωk=2.π .k/4.
n = 0:35;
k = 0:5;
omega = 2 * pi * k / 4; % Calculo de Ωk
xk = cos(omega' * n); % Uso multiplicação de matriz para compute xk[n] for each k

figure;
subplot(length(k), 1, 1);
plot(n, xk(1, :));
subplot(length(k), 1, 2);
plot(n, xk(2, :));
subplot(length(k), 1, 3);
plot(n, xk(3, :));
subplot(length(k), 1, 4);
plot(n, xk(4, :));
subplot(length(k), 1, 5);
plot(n, xk(5, :));
subplot(length(k), 1, 6);
plot(n, xk(6, :));

%% 3). Gere uma senóide amostrada conforme o código abaixo:
clear all; close all;
n = 0:200;
fs = 8000;
t = n * 1/fs;
x = sin(2 * pi * 100 * t); % Senóide de 100Hz amostrada a 8kHz
y = fft(x);

onda_quadrada = square(2 * pi * 100 * t);
onda_dente_serra = sawtooth(2 * pi * 100 * t);
sinal_chirp = chirp(t, 0, 0.26, 3000);

figure;
subplot(4, 1, 1); plot(t, x); title('Senoide (100Hz)');
subplot(4, 1, 2); plot(t, onda_quadrada); title('Onda Quadrada (100Hz)');
subplot(4, 1, 3); plot(t, onda_dente_serra); title('Dente de Serra (100Hz)');
subplot(4, 1, 4); plot(t, sinal_chirp); title('Chirp (0Hz a 3kHz)');

% Cálculo da FFT dos sinais amostrados
Y_quadrada = fft(onda_quadrada);
Y_serra = fft(onda_dente_serra);
Y_chirp = fft(sinal_chirp);

% Cálculo do eixo de frequências para os gráficos da FFT
% Caso contrario o eixo x toma valor menor que o necessário para mostrar o grafico completo
f_seno = (0:length(y)-1) * fs / length(y);
f_quadrada = (0:length(Y_quadrada)-1) * fs / length(Y_quadrada);
f_serra = (0:length(Y_serra)-1) * fs / length(Y_serra);
f_chirp = (0:length(Y_chirp)-1) * fs / length(Y_chirp);

figure;
subplot(4, 1, 1); plot(f_seno, abs(y)); title('FFT da Senoide (100Hz)');
subplot(4, 1, 2); plot(f_quadrada, abs(Y_quadrada)); title('FFT da Onda Quadrada (100Hz)');
subplot(4, 1, 3); plot(f_serra, abs(Y_serra)); title('FFT da Dente de Serra (100Hz)');
subplot(4, 1, 4); plot(f_chirp, abs(Y_chirp)); title('FFT do Chirp (0Hz a 3kHz)');

% O eixo de frequência é calculado corretamente com base na frequência de amostragem e no comprimento do sinal.
% A DTFT relaciona os componentes de frequência dos sinais às suas representações no domínio do tempo.

%% 3) Gere a seguinte família de exponenciais:
clear all; close all;
n = 0:63;
k = 0:9;
N = 8;
x = exp(1i * (2 * pi * k' * n) / N); % Geração da família de exponenciais

figure;
for idx = 1:length(k)
    subplot(length(k),1,idx);
    plot(n, real(x(idx, :)));
    title(['Exponencial k=' num2str(k(idx))]);
end

figure;
for idx = 1:length(k)
    Xk = fft(x(idx, :));
    subplot(length(k),1,idx);
    plot(abs(Xk));
    title(['FFT da Exponencial k=' num2str(k(idx))]);
end

% Observado os gráficos (cuidado, sinais são complexos), pergunta-se: quantas exponenciais são diferentes? Explique sua resposta baseado na
% teoria e nos gráficos obtidos.

% Embora tenha gerado 10 sinais, apenas 8 exponenciais são diferentes.
% Como o período fundamental é N=8:
% A exponencial para k=8 é idêntica à de k=0.
% A exponencial para k=9 é idêntica à de k=1.
% Se observados os gráficos (tanto no tempo quanto na frequência), ve-se que o 1º e o 9º gráfico são espelhados, assim como o 2º e o 10º.

%% 4) Gere 3 senóides de dois mil e 48 pontos cada com as respectivas freqüências de f1=1000, f2=3000 e f3=5000Hz, amostradas a 8kHz.
clear all; close all;

n = 0:2048;
fs = 8000;

senoide1 = sin(2 * pi * 1000 * n / fs);
senoide2 = sin(2 * pi * 3000 * n / fs);
senoide3 = sin(2 * pi * 5000 * n / fs);

figure;
subplot(3, 1, 1); plot(senoide1); title("Senoide 1Khz");
subplot(3, 1, 2); plot(senoide2); title("Senoide 3kHz");
subplot(3, 1, 3); plot(senoide3); title("Senoide 5kHz");

%% 5) Gere o gráfico de um sinal que seja a soma das três senoides anteriores, porem com amplitudes de 1 para senoide f1, 0.5 para f2e 0.25 para f3
clear all; close all;

n = 0:2048;
fs = 8000;

senoide1 = sin(2 * pi * 1000 * n / fs);
senoide2 = 0.5 * sin(2 * pi * 3000 * n / fs);
senoide3 = 0.25 * sin(2 * pi * 5000 * n / fs);
sinal_soma = senoide1 + senoide2 + senoide3;

figure;
plot(n, sinal_soma);

%% 6) Some o sinal do exercicio anterior com uma onda quadrada de frequencia 800Hz.
onda_quadrada_800Hz = square(2 * pi * 800 * n / fs);
sinal_final = sinal_soma + onda_quadrada_800Hz;

figure;
plot(n, sinal_final);
