module control_unit(
    input [6:0] opCode,
    input [2:0] func3,
    input [6:0] func7,
    output reg reg_wr_en,
    output reg s_e,
    output reg alu_src,
    output reg [3:0] alu_cont,
    output reg mem_rd_en,
    output reg mem_wr_en,
    output reg [1:0] wb_mux,
    output reg rg_s,
    output reg br,
    output reg jal,
    output reg jalr,
    output reg bj_mux
);

    /*
        alu control:

        op      alu_cont    func3
        add:    0000        000    
        sub:    0001        000
        xor:    0010        100
        or:     0011        110
        and:    0100        111
        sll:    0101        001
        srl:    0110        101
        sra:    0111        101
        slt:    1000        010, 011
    
    */

    always @(*) begin
        case (opCode)
            7'b0110011: begin //// r-type
                br = 0;
                jal = 0;
                jalr = 0;
                rg_s = 1;
                reg_wr_en = 1;
                alu_src = 0;
                mem_rd_en = 0;
                mem_wr_en = 0;
                wb_mux = 2'b01;
                bj_mux = 0; 
                case (func3) 
                    3'b000: begin
                        case (func7)
                            7'b0000000: alu_cont=4'b0000;
                            7'b0100000: alu_cont=4'b0001;
                        endcase
                    end
                    3'b001:  alu_cont=4'b0101;
                    3'b010:  alu_cont=4'b1000;  ///  slt
                    3'b011:  alu_cont=4'b1000;  ///  sltu
                    3'b100:  alu_cont=4'b0010;
                    3'b101: begin
                        case (func7)
                            7'b0000000: alu_cont=4'b0110;
                            7'b0100000: alu_cont=4'b0111;
                        endcase
                    end
                    3'b110:  alu_cont=4'b0011;
                    3'b111:  alu_cont=4'b0100;
                endcase
            end

            7'b0010011: begin //// i-type
                br = 0;
                jal = 0;
                jalr = 0;
                rg_s = 1;
                reg_wr_en = 1;
                alu_src = 1;
                mem_rd_en = 0;
                mem_wr_en = 0;
                s_e = 0;
                bj_mux = 0;
                wb_mux = 2'b01;
                case (func3) 
                    3'b000:  alu_cont=4'b0000;
                    3'b001:  alu_cont=4'b0101;
                    3'b010:  alu_cont=4'b1000;  ///  slt
                    3'b011:  alu_cont=4'b1000;  ///  sltu
                    3'b100:  alu_cont=4'b0010;
                    3'b101:  begin /// srl,sra 0110 0111

                    end
                    3'b110:  alu_cont=4'b0011;
                    3'b111:  alu_cont=4'b0100;
                endcase
            end

            7'b0000011: begin //// i-type load instructions
                br = 0;
                jal = 0;
                jalr = 0;
                rg_s = 1;
                s_e = 0;
                reg_wr_en = 1;
                alu_src = 1;
                mem_rd_en = 1;
                mem_wr_en = 0;
                wb_mux = 2'b00;
                alu_cont=4'b0000;
                bj_mux = 0;
            end

            7'b0100011: begin //// s-type 
                bj_mux = 0;
                br = 0;
                jal = 0;
                jalr = 0;
                rg_s = 0;
                s_e = 1;
                reg_wr_en  = 1;
                alu_src = 1;
                mem_rd_en = 0;
                mem_wr_en = 1;
                wb_mux = 2'b00;
                alu_cont=4'b0000;
            end

            7'b1100011: begin /// B-type
                br = 1;
                jal = 0;
                jalr = 0;
                bj_mux = 1;
            end

            7'b1101111: begin /// J-type jal
                br = 0;
                jal = 1;
                jalr = 0;
                bj_mux = 0;
                wb_mux = 2'b10;
                reg_wr_en  = 1;
            end

            7'b1100111: begin /// J-type jal
                reg_wr_en  = 1;
                bj_mux = 0;
                br = 0;
                jal = 0;
                jalr = 0;
                wb_mux = 2'b10;
            end
        endcase
    end

endmodule