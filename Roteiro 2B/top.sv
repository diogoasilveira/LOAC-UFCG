//Diogo Alves Silveira - 120110867
//Roteiro 2B

parameter divide_by=100000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by

parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;

module top(input  logic clk_2,
           input  logic [NBITS_TOP-1:0] SWI,
           output logic [NBITS_TOP-1:0] LED,
           output logic [NBITS_TOP-1:0] SEG,
           output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
           output logic [NBITS_INSTR-1:0] lcd_instruction,
           output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
           output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
             lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
           output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);
	   
	   always_comb begin
	     //LED <= SWI;
	     lcd_WriteData <= SWI;
	     lcd_pc <= 'h12;
	     lcd_instruction <= 'h34567890;
	     lcd_SrcA <= 'hab;
	     lcd_SrcB <= 'hcd;
	     lcd_ALUResult <= 'hef;
	     lcd_Result <= 'h11;
	     lcd_ReadData <= 'h33;
	     lcd_MemWrite <= SWI[0];
	     lcd_Branch <= SWI[1];
	     lcd_MemtoReg <= SWI[2];
	     lcd_RegWrite <= SWI[3];
	     for(int i=0; i<NREGS_TOP; i++)
	        if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
	        else                   lcd_registrador[i] <= ~SWI;
	     lcd_a <= {56'h1234567890ABCD, SWI};
	     lcd_b <= {SWI, 56'hFEDCBA09876543};
	   end
	   
	   parameter NBITS_NUMS = 3;
	   logic [NBITS_NUMS-1:0] nums;
	   
	   always_comb nums <= SWI;
	   
	   always_comb begin
	     //SWI[0] representa a porta do banco, SWI[1] o relógio eletrônico e SWI[2] o interruptor, LED[1] representa o alarme.
	     //LED[1] <= SWI[0] & (~SWI[1] | SWI[2]);
	     if (nums==1) LED[1] <= 1;
	     else if (nums==5) LED[1] <= 1;
	     else if (nums==7) LED[1] <= 1;
	     else if (nums==9) LED[1] <= 1;
	     else LED[1] <= 0;
	   end
	   
	   always_comb begin
	     //SWI[6] = T1, SWI[7] = T2, LED[6] = AQUECEDOR, LED[7] = RESFRIADOR, SEG[7] = INCONSISTÊNCIA;
	     LED[6] <= ~SWI[6] & ~SWI[7];
	     LED[7] <= SWI[6] & SWI[7];
	     SEG[7] <= ~SWI[6] & SWI[7];
	   end
endmodule

