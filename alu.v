module alu(
    input [31:0] op1,
    input [31:0] op2,
    input [3:0] alu_cont,
    output reg [31:0] alu_result
    );

    always @(*) begin
        case(alu_cont)
            4'b0000: alu_result = op1 + op2;
            4'b0001: alu_result = op1 - op2;
            4'b0010: alu_result = op1 ^ op2;    
            4'b0011: alu_result = op1 | op2; 
            4'b0100: alu_result = op1 & op2;
            4'b0101: alu_result = op1 << op2;
            4'b0110: alu_result = op1 >> op2;
            4'b0111: alu_result = op1 >>> op2;
            /// 4'b1000: alu_result = op1 - op2;
        endcase
    end
endmodule