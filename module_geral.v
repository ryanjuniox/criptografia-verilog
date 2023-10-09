module saida_geral(
    output wire [3:0] saida,
    input wire [3:0] entrada,
    input wire reset,
    input wire ready
);

reg [3:0] saida_reg; 

always @(posedge ready) begin
    saida_reg[3] <= (entrada[3] & (~entrada[2]) & (~entrada[1])) || (entrada[3] & (~entrada[1]) & entrada[0]) || (entrada[3] & (~entrada[2]) & entrada[0]) || (~(entrada[2]) & (~entrada[1]) & entrada[0]) || ((~entrada[3]) & entrada[2] & (~entrada[0])) || ((~entrada[3]) & entrada[2] & entrada[1]);

    saida_reg[2] <= (entrada[2] & entrada[1] & entrada[0]) || ((~entrada[2]) & (~entrada[1]) & (~entrada[0])) || (entrada[3] & entrada[1] & entrada[0]) || ((~entrada[3]) & (~entrada[2]) & (~entrada[1])) || (entrada[3] & entrada[2]  & entrada[1]) || ((~entrada[3]) & (~entrada[2]) &(~entrada[0]));

    saida_reg[1] <= ((~entrada[3]) & (~entrada[1]) & (~entrada[0])) || ((~entrada[3]) & entrada[1] & entrada[0]) || (entrada[3] & entrada[2] & (~entrada[1])) || (entrada[3] & entrada[2] & (~entrada[0])) || (~entrada[2] & entrada[1] & entrada[0]);

    saida_reg[0] <= ((~entrada[3]) & entrada[2]) || ((~entrada[1]) & (~entrada[0])) || ((~entrada[3]) & (~entrada[0]));
end

always @(posedge reset) begin
   saida_reg <= 4'b0000;
end

assign saida = saida_reg; 

endmodule

module teste;

    wire [3:0] saida_wire;
    reg [3:0] entrada;
    reg reset, ready;

    saida_geral UUT(
        .saida(saida_wire),
        .entrada(entrada),
        .reset(reset),
        .ready(ready)
    );

    integer i;

    initial begin

        $dumpfile("saida.vcd");
        $dumpvars(0, saida_wire, entrada, reset, ready);

        reset = 0;
        ready = 0;

        $display("| A | B | C | D |  | S3| S2| S1| S0|");
        for (i = 0; i < 16; i = i + 1) begin
            entrada = i;
            ready = 1;
            #10;
            ready = 0;
            #10;
            $display("| %b | %b | %b | %b |  | %b | %b | %b | %b |", entrada[3], entrada[2], entrada[1], entrada[0], saida_wire[3], saida_wire[2], saida_wire[1], saida_wire[0]);
        end

        reset=1;
        #10
        $display("| %b | %b | %b | %b |  | %b | %b | %b | %b |", entrada[3], entrada[2], entrada[1], entrada[0], saida_wire[3], saida_wire[2],saida_wire[1], saida_wire[0]);
        $finish;

    end

endmodule