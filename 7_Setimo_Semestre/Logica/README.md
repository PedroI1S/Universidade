# Ambiente VHDL em Logica

Guia rapido para editar, compilar, simular e visualizar ondas VHDL no workspace Logica.

## 1) Preparacao

Abra a pasta Logica como raiz no VS Code.

Se abrir a raiz 7_semestre, as tasks de Logica/.vscode podem nao aparecer corretamente.

## 2) Estrutura recomendada

Use uma pasta por projeto VHDL dentro de Logica.

Exemplos:

- Logica/projeto1
- Logica/projeto2
- Logica/projeto_uart

## 3) Ferramentas

- Simulador: ghdl
- Visualizador: surfer
- Fallback opcional: gtkwave

Instalacao do fallback:

```bash
brew install gtkwave
```

## 4) Fluxo mais simples por terminal

Executar simulacao completa:

```bash
cd /Users/pedro_mariano/Documents/7_semestre/Logica
./vhdl_run.sh <projectDir> <tbName>
```

Executar e abrir onda ao final:

```bash
./vhdl_run.sh <projectDir> <tbName> --open
```

Abrir grafico manualmente quando quiser:

```bash
./vhdl_wave.sh <projectDir> [ghw|vcd]
```

Exemplos:

```bash
./vhdl_wave.sh projeto2
./vhdl_wave.sh projeto2 vcd
```

Limpar artefatos (preserva wave.ghw):

```bash
./vhdl_clean.sh <projectDir> [tbName]
```

Exemplos:

```bash
./vhdl_clean.sh projeto2
./vhdl_clean.sh projeto2 alu4_tb
```

## 5) O que cada script faz

vhdl_run.sh:

- analisa todos os .vhdl do projeto
- elabora o testbench
- roda simulacao
- gera wave.vcd e wave.ghw
- opcionalmente abre o grafico com --open

vhdl_wave.sh:

- abre o grafico no Surfer
- por padrao prioriza wave.ghw
- pode forcar vcd com segundo argumento

vhdl_clean.sh:

- remove *.cf, *.o, e~*.o, wave.vcd
- nao remove wave.ghw
- remove o executavel do testbench se tbName for informado

## 6) Tasks do VS Code

Arquivo: Logica/.vscode/tasks.json

Tasks disponiveis:

- VHDL: Create project folder
- VHDL: Analyze current file (project folder)
- VHDL: Analyze all in project folder
- VHDL: Elaborate testbench
- VHDL: Run testbench (VCD)
- VHDL: Open waveform
- VHDL: Clean generated files
- VHDL: Run all (Project folder)

Fluxo recomendado nas tasks:

1. Rode VHDL: Run all (Project folder).
2. Informe projectDir, por exemplo projeto1.
3. Informe tbName, por exemplo teste_tb.

## 7) Atalhos

Arquivo: Logica/.vscode/keybindings.json

- cmd+alt+r: VHDL: Run all (Project folder)
- cmd+alt+v: VHDL: Open waveform

## 8) Troubleshooting Surfer no macOS

Em alguns macOS com surfer 0.6.0 pode aparecer aviso de file watcher.

Se abrir mas ficar instavel:

1. Gere a onda novamente com vhdl_run.sh.
2. Abra manualmente com vhdl_wave.sh.
3. Se necessario, use gtkwave como fallback.

---

Total de arquivos de programacao neste ramo: 30

## Subpastas

- projeto1: 2 arquivo(s) de programacao (exemplo introdutorio GHDL)
- projeto2: 10 arquivo(s) de programacao (PR2 - Gerador de Sinais na DE10-Lite)
- projeto3: 16 arquivo(s) de programacao (PR3 - Maquina de Lavar na DE10-Lite)

## O que cada codigo faz

### projeto1

- teste.vhdl: circuito combinacional simples usado para validar o fluxo de simulacao com GHDL.
- teste_tb.vhdl: testbench do circuito de exemplo.

### projeto2 (PR2 - Gerador de Sinais, onda dente de serra via DDS)

- gerador_pkg.vhd: package com constantes e funcoes compartilhadas do gerador.
- acumulador_fase.vhd: acumulador de fase do sintetizador digital direto (DDS) que define a frequencia da onda.
- conformador_onda.vhd: converte a fase acumulada nas amostras da onda dente de serra para o DAC R-2R.
- decodificador_7seg.vhd: decodificador para os displays de 7 segmentos da placa.
- gerador_sinais.vhd: top-level que integra acumulador de fase, conformador de onda e displays.
- *_tb.vhd: testbenches correspondentes de cada modulo acima.

### projeto3 (PR3 - Maquina de Lavar, FSM stand by / molho / enxague / centrifuga)

- DE10_LITE_Golden_Top.v: top-level Verilog com o mapeamento de pinos da placa DE10-Lite.
- lavadora_pkg.vhd: package com os estados e constantes da lavadora.
- maquina_estados.vhd: FSM principal com os ciclos de lavagem.
- divisor_clock.vhd: divisor do clock de 50 MHz para a base de tempo dos ciclos.
- sincronizador_botao.vhd: sincronizacao e debounce dos botoes da placa.
- gerador_leds.vhd: padrao dos LEDs conforme o estado atual.
- decodificador_7seg.vhd: exibicao do estado/tempo nos displays de 7 segmentos.
- lavadora.vhd: top-level VHDL que integra todos os modulos.
- *_tb.vhd: testbenches correspondentes de cada modulo acima.

### Scripts de apoio

- vhdl_run.sh: compila e simula um testbench com GHDL, gerando forma de onda.
- vhdl_wave.sh: abre a forma de onda gerada (ghw/vcd) no visualizador.
- vhdl_clean.sh: remove os artefatos de compilacao/simulacao do projeto.
