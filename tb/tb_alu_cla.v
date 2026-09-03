`timescale 1ns/1ps

module tb_alu_cla;

    reg  [1:0] A, B;
    reg  [2:0] opcode;
    wire [3:0] result;
    wire [1:0] remainder;
    wire       valid;
    wire       error;

    // Device Under Test (DUT)
    alu_cla uut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .remainder(remainder),
        .valid(valid),
        .error(error)
    );

    initial begin
        $dumpfile("cla_dump.vcd");
        $dumpvars(0, tb_alu_cla);

        // Addition (3 + 3 = 6)
        A = 2'b11; B = 2'b11; opcode = 3'b000; #10;
        // Subtraction
        A = 2'b10; B = 2'b01; opcode = 3'b001; #10;
        // AND
        A = 2'b11; B = 2'b01; opcode = 3'b010; #10;
        // OR
        A = 2'b10; B = 2'b01; opcode = 3'b011; #10;
        // XOR
        A = 2'b11; B = 2'b01; opcode = 3'b100; #10;
        // Multiplication (3 x 3 = 9)
        A = 2'b11; B = 2'b11; opcode = 3'b101; #10;
        // Division (valid case)
        A = 2'b10; B = 2'b01; opcode = 3'b110; #10;
        // Division by zero (error case)
        A = 2'b10; B = 2'b00; opcode = 3'b110; #10;

        $finish;
    end

endmodule
