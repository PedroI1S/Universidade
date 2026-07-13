// =====================================================================
// Projeto: PR3 - Maquina de Lavar (DE10-Lite)
// Disciplina: Logica Reconfiguravel - LR27CP-7CP - Prof. MSc. Andre Macario Barros
// Equipe (nome - RA):
//   Rodrigo Rodriguez Tato Gama da Silva - RA: 2562804
//   Pedro Mariano dos Santos             - RA: 2562790
//   Marlon Mezomo Gotardo                - RA: 2562766
// Circuito implementado: FSM stand by / enxague / molho / centrifuga
// =====================================================================
module DE10_LITE_Golden_Top (
    input         MAX10_CLK1_50,
    input  [1:0]  KEY,
    input  [9:0]  SW,
    output [9:0]  LEDR,
    output [7:0]  HEX0,
    output [7:0]  HEX1,
    output [7:0]  HEX2,
    output [7:0]  HEX3,
    output [7:0]  HEX4,
    output [7:0]  HEX5
);
    wire [6:0] seg2, seg1, seg0;

    lavadora u_lavadora (
        .clk50 (MAX10_CLK1_50),
        .key   (KEY),
        .ledr  (LEDR),
        .hex2  (seg2),
        .hex1  (seg1),
        .hex0  (seg0)
    );

    // bit 7 = ponto decimal (apagado, ativo-baixo)
    assign HEX0 = {1'b1, seg0};
    assign HEX1 = {1'b1, seg1};
    assign HEX2 = {1'b1, seg2};
    assign HEX3 = 8'hFF;  // apagado
    assign HEX4 = 8'hFF;  // apagado
    assign HEX5 = 8'hFF;  // apagado
endmodule
