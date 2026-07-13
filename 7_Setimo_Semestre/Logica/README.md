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
