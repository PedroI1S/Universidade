# PR3 — Máquina de Lavar (DE10-Lite)

Lógica Reconfigurável (LR27CP-7CP) — Prof. MSc. André Macário Barros.
Placa **Terasic DE10-Lite** · FPGA **MAX 10 10M50DAF484C7G** · **Quartus Prime 20.1.1** · **VHDL-2008**.

Equipe (nome — RA):
- Rodrigo Rodriguez Tato Gama da Silva — 2562804
- Pedro Mariano dos Santos — 2562790
- Marlon Mezomo Gotardo — 2562766

## Descrição

Controle de uma "máquina de lavar" como uma **máquina de estados finitos (FSM)** de
4 estados, em ordem cíclica:

```
stand by --key1--> enxágue --key1--> molho --key1--> centrífuga --key1--> stand by
   ^                                                                          |
   +------------------ key0 (a qualquer momento, qualquer estado) ------------+
```

- **key1** (pushbutton): avança para o próximo estado.
- **key0** (pushbutton): retorna ao `stand by` a qualquer momento (tem prioridade).
- Ambos são **ativo-baixo** e passam por sincronização + debounce + detecção de borda.
- Estado inicial (power-on): `stand by`.

## Comportamento por estado

| Estado | LEDs (LEDR9..LEDR0) | HEX2 HEX1 HEX0 | Frequência |
|--------|---------------------|----------------|------------|
| stand by | só LEDR0 aceso | `Stb` | — |
| enxágue | LEDR9–5 ⇄ LEDR4–0 (alterna) | `EnH` | onda quadrada 1 Hz (inverte a cada 0,5 s) |
| molho | LEDR9 pisca, resto apagado | `nOL` | 0,5 Hz (1 s aceso / 1 s apagado) |
| centrífuga | 1 LED por vez, LEDR0→LEDR9 | `CEn` | passo a 10 Hz |

HEX5–HEX3 sempre apagados; ponto decimal apagado.

## Arquivos / módulos

| Arquivo | Responsabilidade |
|---------|------------------|
| `lavadora_pkg.vhd` | Pacote: tipo `estado_t`, constantes, função `calc_div`, declaração dos componentes |
| `divisor_clock.vhd` | Gera *enable* de 1 ciclo a cada `DIV` ciclos (parametrizável) |
| `sincronizador_botao.vhd` | Sincroniza + debounce + borda do pushbutton → pulso de 1 ciclo |
| `maquina_estados.vhd` | FSM dos 4 estados (avança / reset prioritário) |
| `gerador_leds.vhd` | Estado + 3 divisores → padrões de `LEDR[9:0]` |
| `decodificador_7seg.vhd` | Estado → segmentos de HEX2/HEX1/HEX0 (ativo-baixo) |
| `lavadora.vhd` | Entidade TOP (VHDL) — instancia tudo via pacote |
| `DE10_LITE_Golden_Top.v` | Top de síntese (Verilog): pinos oficiais da placa, instancia `lavadora` |
| `lavadora.sdc` | Constraints de timing (clock 50 MHz, false paths) |
| `lavadora.qsf` / `.qpf` | Projeto Quartus + pinout completo da DE10-Lite |
