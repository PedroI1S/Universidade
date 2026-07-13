## =====================================================================
## PR2 - Gerador de Sinais (DE10-Lite)
## Constraints de timing (SDC) para o Quartus / TimeQuest
## =====================================================================

## Clock de 50 MHz da placa (MAX10_CLK1_50) -> periodo de 20 ns
create_clock -name MAX10_CLK1_50 -period 20.000 [get_ports MAX10_CLK1_50]

## Incerteza de clock (jitter etc.) derivada automaticamente
derive_clock_uncertainty

## E/S de placa (chaves, botoes, displays, GPIO->R-2R) sao assincronas:
## nao ha requisito de timing entre elas e o clock -> remove da analise.
set_false_path -from [get_ports {SW[*]}]  -to [all_registers]
set_false_path -from [get_ports {KEY[*]}] -to [all_registers]
set_false_path -from [all_registers] -to [get_ports {HEX2[*] HEX3[*] HEX4[*] HEX5[*]}]
set_false_path -from [all_registers] -to [get_ports {GPIO[*]}]
