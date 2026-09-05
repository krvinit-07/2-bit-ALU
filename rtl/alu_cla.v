// ---------------------------------------------------------------------------
// alu_cla.v
// 2-bit ALU using a Carry Lookahead Adder (CLA) for the addition path.
//
// Reconstructed to match the interface expected by tb/tb_alu_cla.v:
//   A, B, opcode -> result, remainder, valid, error
//
// Per the project report (Chapter 5): only the addition block is replaced
// with a CLA. Subtraction reuses the CLA adder via 2's complement. All other
// operations (AND, OR, XOR, multiplication, division) are unchanged from the
// RCA-based alu_2bit.v, with a remainder output added for division.
// ---------------------------------------------------------------------------

module alu_cla (
    input  [1:0] A,
    input  [1:0] B,
    input  [2:0] opcode,
    output reg [3:0] result,
    output reg [1:0] remainder,
    output reg       valid,
    output reg       error
);

    // -----------------------------------------------------------------
    // 2-bit Carry Lookahead Adder core.
    // Generate (G) and Propagate (P) signals are computed per bit, and
    // the carries are derived directly from G/P instead of rippling,
    // as described in Chapter 5.1 of the report.
    // -----------------------------------------------------------------
    function [2:0] cla_add;
        input [1:0] x;
        input [1:0] y;
        input       cin;
        reg         g0, g1;   // generate
        reg         p0, p1;   // propagate
        reg         c0, c1, c2;
        reg         s0, s1;
        begin
            g0 = x[0] & y[0];
            g1 = x[1] & y[1];
            p0 = x[0] ^ y[0];
            p1 = x[1] ^ y[1];

            c0 = cin;
            c1 = g0 | (p0 & c0);
            c2 = g1 | (p1 & c1);

            s0 = p0 ^ c0;
            s1 = p1 ^ c1;

            cla_add = {c2, s1, s0}; // {carry-out, sum[1:0]}
        end
    endfunction

    reg [2:0] add_res;
    reg [2:0] sub_res;

    always @ (*) begin
        // default values
        result    = 4'b0000;
        remainder = 2'b00;
        valid     = 1'b1;
        error     = 1'b0;

        case (opcode)
            // Addition (CLA)
            3'b000: begin
                add_res = cla_add(A, B, 1'b0);
                result  = {1'b0, add_res};
            end
            // Subtraction (A - B via 2's complement, using the same CLA adder).
            // The adder's carry-out here is a borrow/no-borrow flag, not part
            // of the numeric magnitude, so only the 2-bit sum is kept.
            3'b001: begin
                sub_res = cla_add(A, ~B, 1'b1);
                result  = {2'b00, sub_res[1:0]};
            end
            // AND
            3'b010: result = A & B;
            // OR
            3'b011: result = A | B;
            // XOR
            3'b100: result = A ^ B;
            // Multiplication
            3'b101: result = A * B;
            // Division
            3'b110: begin
                if (B == 2'b00) begin
                    result    = 4'b0000;
                    remainder = 2'b00;
                    valid     = 1'b0;
                    error     = 1'b1;
                end else begin
                    result    = A / B;
                    remainder = A % B;
                    valid     = 1'b1;
                    error     = 1'b0;
                end
            end
            // Default case
            default: begin
                result    = 4'b0000;
                remainder = 2'b00;
                valid     = 1'b0;
                error     = 1'b0;
            end
        endcase
    end

endmodule
