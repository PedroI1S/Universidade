# PR2 — Gerador de Sinais (DE10-Lite) — variante Marlon Mezomo Gotardo

Gera 8 bits paralelos via GPIO -> conversor R-2R passivo -> osciloscopio.
Ondas: quadrada e dente de serra (wav 5). Frequencias: 400 Hz e 800 Hz.

## Arquivos
- `gerador_pkg.vhd`        pacote (constantes/generics + funcoes)
- `acumulador_fase.vhd`    DDS: acumulador de fase
- `conformador_onda.vhd`   gera quadrada / dente de serra
- `decodificador_7seg.vhd` decodificador 7 segmentos (ativo-baixo)
- `gerador_sinais.vhd`     circuito principal (instanciado no Golden Top)
- `DE10_LITE_Golden_Top.v` top-level (wrapper de pinos da placa)
- `gerador_sinais.sdc`     constraints de timing (clock de 50 MHz)
- `gerador_sinais.qpf/.qsf` projeto Quartus (device, pinos e arquivos)
- `gerador_sinais_tb.vhd`  testbench de integracao
- (`*_tb.vhd`)             testbenches unitarios de cada componente

## Como funciona (DDS)
Um acumulador de fase de 32 bits soma, a cada clock de 50 MHz, um incremento
constante calculado em tempo de elaboracao: `incremento = round(freq * 2^32 / clk)`.
- Dente de serra (wav 5): os 8 bits mais significativos da fase formam a rampa
  0->255 que reinicia a cada periodo.
- Onda quadrada: o bit mais significativo da fase replicado nos 8 bits
  (0x00 na primeira metade do periodo, 0xFF na segunda).

Frequencias resultantes: 400,003 Hz e 799,99 Hz (erro < 0,01 %).

## Controles
| Chave | 0 | 1 |
|-------|---|---|
| SW0   | freq1 = 400 Hz | freq2 = 800 Hz |
| SW9   | onda quadrada (HEX5=0) | dente de serra (HEX5=5) |
| KEY0  | pressionado = reset | - |

HEX4 HEX3 HEX2 = valor da frequencia (400 ou 800).

## Pinos (DE10-Lite) — ja atribuidos no `gerador_sinais.qsf`
Top-level = `DE10_LITE_Golden_Top` (wrapper), que liga os pinos da placa ao
`gerador_sinais`. Pinout completo da placa ja no `.qsf`; pinos usados:
- MAX10_CLK1_50 -> PIN_P11   (clk 50 MHz)
- KEY[0]        -> PIN_B8    (reset, ativo-baixo)
- SW[0]         -> PIN_C10   (freq1/freq2)
- SW[9]         -> PIN_F15   (quadrada/serra)
- GPIO[0..7]    -> V10, W10, V9, W9, V8, W8, V7, W7 (conector GPIO -> R-2R)
- HEX2[0..6]    -> B20, A20, B19, A21, B21, C22, B22
- HEX3[0..6]    -> F21, E22, E21, C19, C20, D19, E17
- HEX4[0..6]    -> F18, E20, E19, J18, H19, F19, F20
- HEX5[0..6]    -> J20, K20, L18, N18, M20, N19, N20

> Confira no Pin Planner se a revisao da sua placa coincide com o manual da
> DE10-Lite (device 10M50DAF484C7G).

## Conversor R-2R
- R = 10k, 2R = 20k (evita drenar corrente alem do que o GPIO 3,3V fornece).
- GPIO[7] = MSB, GPIO[0] = LSB.

## Simulacao local
Da raiz do workspace:

    ./vhdl_run.sh projeto2 gerador_sinais_tb
    ./vhdl_wave.sh projeto2   # abre no surfer

Testbenches unitarios disponiveis: `gerador_pkg_tb`, `decodificador_7seg_tb`,
`acumulador_fase_tb`, `conformador_onda_tb`.

## Sintese (Quartus Prime 20.1.1)
Projeto Quartus pronto: `gerador_sinais.qpf` (+ `gerador_sinais.qsf`).
1. Abrir `gerador_sinais.qpf` no Quartus Prime 20.1.1.
2. O `.qsf` ja define device (10M50DAF484C7G), top-level `DE10_LITE_Golden_Top`
   (que instancia o `gerador_sinais`), os 5 .vhd como VHDL-2008, o `.sdc` e os pinos.
3. Compilar (Processing > Start Compilation) e gravar na placa (Programmer).

O `.sdc` restringe MAX10_CLK1_50 a 20 ns (50 MHz); o TimeQuest fecha com folga
(Fmax ~319 MHz). Sem o `.sdc`, o Quartus assume 1 GHz e o relatorio de timing
aparece com slack negativo -- e so um falso alarme, o hardware funciona.

Os testbenches `*_tb.vhd` nao entram na compilacao (so para simulacao ghdl).

## Pendencias antes de entregar
- [x] Cabecalhos dos .vhd: nomes, circuito (wav 5) e R = 10k ja preenchidos.
- [x] RAs e link do video preenchidos nos cabecalhos dos .vhd.
- [x] Video gravado e linkado (Drive). Conferir que mostra as 4 combinacoes
      (quadrada e serra, em freq1=400 Hz e freq2=800 Hz) com as leituras de
      frequencia/forma/amplitude legiveis no osciloscopio.
- [x] Top-level com Golden Top (igual a PR1) e device correto (C7G). A pasta
      `PR2/` ficou redundante -> zipe apenas esta pasta (`projeto2/`).
- [ ] Compilar no Quartus Prime 20.1.1, conferir pinos e gravar na placa.
