## =====================================================================
## PR3 - Maquina de Lavar (DE10-Lite) - constraints de timing (SDC)
## =====================================================================
create_clock -name MAX10_CLK1_50 -period 20.000 [get_ports MAX10_CLK1_50]
derive_clock_uncertainty

## Entradas/saidas de placa sao assincronas -> fora da analise de timing
set_false_path -from [get_ports {KEY[*]}] -to [all_registers]
set_false_path -from [all_registers] -to [get_ports {LEDR[*]}]
set_false_path -from [all_registers] -to [get_ports {HEX0[*] HEX1[*] HEX2[*] HEX3[*] HEX4[*] HEX5[*]}]
