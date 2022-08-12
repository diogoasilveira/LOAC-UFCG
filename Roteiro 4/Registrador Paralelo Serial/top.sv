//Diogo Alves Silveira - 120110867
//Roteiro 4 Primeira Questão

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
  
  parameter BITWIDTH_REG = 4;
  logic [BITWIDTH_REG-1:0] _output;
  logic serial, parallel, reset, selection;
  
  always_comb begin
	reset <= SWI[0];
	SEG[7] <= clk_2;
	LED[3:0] <= _output;
	selection <= SWI[2];
	serial <= SWI[1];
  parallel <= SWI[7:4];
  end

  always_ff @(posedge reset or posedge clk_2) begin
    if(reset) begin
      _output <= 0;  // atribuição do reset ao _output
    end
    else begin
      if(selection) begin
        _output <= parallel; // atribuição do paralelo ao _output
      end 
      else begin
        _output[3] <= serial;  // atribuição do serial ao _output
        _output[2] <= _output[3];
        _output[1] <= _output[2];
        _output[0] <= _output[1];
      end
    end
  end

  always_comb begin
  if (_output == 0) SEG <= 'b00111111;
  else if (_output == 1) SEG <= 'b00000110;
  else if (_output == 2) SEG <= 'b01011011;
  else if (_output == 3) SEG <= 'b01001111;
  else if (_output == 4) SEG <= 'b01100110;
  else if (_output == 5) SEG <= 'b01101101;
  else if (_output == 6) SEG <= 'b01111101;
  else if (_output == 7) SEG <= 'b00000111;
  else if (_output == 8) SEG <= 'b01111111;
  else if (_output == 9) SEG <= 'b01101111;
  else if (_output == 10) SEG <= 'b01110111;
  else if (_output == 11) SEG <= 'b01111100;
  else if (_output == 12) SEG <= 'b00111001;
  else if (_output == 13) SEG <= 'b01011110;
  else if (_output == 14) SEG <= 'b01111001;
  else if (_output == 15) SEG <= 'b01110001;
  else SEG <= 'b00000000;
  end
	
endmodule