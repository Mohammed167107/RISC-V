module processor(input clk,
                 input rst,
                 output [31:0] pc
);

    wire [31:0] pc_out,pc_plus,instruction,rs1_data,rs2_data,op2,imm_ext,rd_data;
    wire [31:0] alu_result,mem_data_out,imm_ext_j,imm_ext_b,
                    bj_imm,pc_plus_bj,bj_mux_out,jalr_add,address_data;
    wire reg_wr_en,alu_src,mem_rd_en,mem_wr_en,s_e,rg_s,true,br,jal,jalr,and_out,or_out,bj_mux;
    wire [1:0] wb_mux;
    wire [3:0] alu_cont; 
    wire [11:0] imm;
    wire [4:0] rg;
    pc PC(
        .rst (rst),
        .clk(clk),
        .Pcin(address_data),
        .pc_out(pc)
    );

    adder plus_4(.pc_in(pc),
                    .pc_4(32'd4),
                    .pc_plus(pc_plus)
                    );

    instructionMemory i_mem(.address(pc),
                            .clk(clk),
                            .q(instruction)
                            );

    control_unit cu(
        .opCode(instruction[6:0]),
        .func3(instruction[14:12]),
        .func7(instruction[31:25]),
        .reg_wr_en(reg_wr_en),
        .alu_src(alu_src),
        .alu_cont(alu_cont),
        .mem_rd_en(mem_rd_en),
        .mem_wr_en(mem_wr_en),
        .wb_mux(wb_mux),
        .s_e(s_e),
        .rg_s(rg_s),
        .br(br),
        .jal(jal),
        .jalr(jalr),
        .bj_mux(bj_mux)
    );
    
    mux2_to_1_5bit mux4(
        .s(rg_s),
        .a(instruction[24:20]),
        .b(instruction[11:7]),
        .c(rg)
    );

    register_file rg_file(
        .clk(clk),
        .wr_en(reg_wr_en),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(rg),
        .rd_data(rd_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    extend_20bits_j sign_ext1(
        .imm({instruction[31],instruction[19:12],instruction[20],instruction[30:21]}),
        .imm_ext(imm_ext_j));

    extend_B sign_ext2(
        .imm({instruction[31],instruction[7],instruction[30:25],instruction[11:8]}),
        .imm_ext(imm_ext_b));

    mux2_to_1 mux7(
        .s(bj_mux),
        .a(imm_ext_j),
        .b(imm_ext_b),
        .c(bj_imm)
    ); 
    
    adder adder2(
        .pc_in(pc),
        .pc_4(bj_imm),
        .pc_plus(pc_plus_bj)
    );

    adder adder3(
        .pc_in(pc),
        .pc_4(rs1_data),
        .pc_plus(jalr_add)
    );

    branching_unit bu(
        .op1(rs1_data),
        .op2(rs2_data),
        .func3(instruction[14:12]),
        .true(true)
    );
    
    and_gate a_gate(
        .a(true),
        .b(br),
        .c(and_out)
    );

    or_gate o_gate(
        .a(and_out),
        .b(jal),
        .c(or_out)
    );

    mux2_to_1_12bit mux1(
        .s(s_e),
        .a(instruction[31:20]),
        .b({instruction[31:25],instruction[11:7]}),
        .c(imm)
    );

    extend sign_ext(.imm(imm),.imm_ext(imm_ext));

    mux2_to_1 mux2(
        .s(alu_src),
        .a(rs2_data),
        .b(imm_ext),
        .c(op2)
    );

    alu ALU(.op1(rs1_data),
            .op2(op2),
            .alu_cont(alu_cont),
            .alu_result(alu_result)
            );

    data_mem d_mem(.clk(clk),
                    .address(alu_result),
                    .func3(instruction[14:12]),
                    .rg2(rs2_data),
                    .wr_en(mem_wr_en),
                    .rd_en(mem_rd_en),
                    .data_out(mem_data_out)
                    );

    mux2_to_1 mux5(
        .s(or_out),
        .a(pc_plus),
        .b(pc_plus_bj),
        .c(bj_mux_out)
    );

    mux2_to_1 mux6(
        .s(jalr),
        .a(bj_mux_out),
        .b(jalr_add),
        .c(address_data)
    );

    mux3_to_1 mux3(
        .s(wb_mux),
        .a(mem_data_out),
        .b(alu_result),
        .c(pc_plus),
        .d(rd_data)
    );

endmodule

module p_tb;
    reg clk, rst;
	
	wire [31:0] PC;
	
	initial begin
		clk = 0;
		rst = 0;
		#20 rst = 1;
		#200 $stop;
	end
	
	always #5 clk = ~clk;
	
	processor uut(clk, rst, PC);
endmodule