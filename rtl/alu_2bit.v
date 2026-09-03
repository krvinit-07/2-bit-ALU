module alu_2bit (
    input  [1:0] A,
    input  [1:0] B,
    input  [2:0] opcode,
    output reg [3:0] result,
    output reg       valid,
    output reg       error
);

always @ (*) begin
    // default values
    result = 4'b0000;
    valid  = 1'b1;
    error  = 1'b0;

    case (opcode)
        // Addition
        3'b000: result = A + B;
        // Subtraction
        3'b001: result = A - B;
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
                result = 4'b0000;
                valid  = 1'b0;
                error  = 1'b1;
            end else begin
                result = A / B;
                valid  = 1'b1;
                error  = 1'b0;
            end
        end
        // Default case
        default: begin
            result = 4'b0000;
            valid  = 1'b0;
            error  = 1'b0;
        end
    endcase
end

endmodule
