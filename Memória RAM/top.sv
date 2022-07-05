// DESCRIPTION: Verilator: Systemverilog example module
// with interface to switch buttons, LEDs, LCD and register display

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

// EXEMPLO 

  parameter NBITS_DATA = 4;
  parameter NBITS_SHIFT = 2;
  logic signed [NBITS_DATA-1:0] data_in, data_out;
  logic [NBITS_SHIFT-1:0] shift;
  logic reset;
  
  always_comb reset <= SWI[0];
  always_comb shift <= SWI[2:1];
  always_comb data_in <= SWI[7:4];
	
  always_ff @(posedge reset or posedge clk_2) begin
    if(reset) begin
	  data_out <= 0;
    end
	else begin
	  data_out <= data_in << shift;
	end
  end
  
  always_comb LED[0] <= clk_2;  
  always_comb LED[7:4] <= data_out;
  
endmodule

memória RAM R/W
// EXEMPLO 

  parameter ADDR_WIDTH = 2;
  parameter DATA_WIDTH = 2;
  
  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH-1:0] wdata;
  logic [DATA_WIDTH-1:0] rdata;
  logic [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0];
  logic wr_en;
  
  always_comb wr_en <= SWI[1];
  always_comb addr <= SWI[3:2];
  always_comb wdata <= SWI[5:4];
	
  always_ff @(posedge clk_2) begin
	if(wr_en) mem[addr] <= wdata;
	else rdata <= mem[addr];
  end
  
  always_comb LED[0] <= clk_2;  
  always_comb LED[1] <= wr_en; 
 
  always_comb LED[3:2] <= addr;
  always_comb LED[5:4] <= mem[addr];
  always_comb LED[7:6] <= rdata;  
  
endmodule
memória RAM ROM
// EXEMPLO 

  parameter ADDR_WIDTH = 2;
  parameter DATA_WIDTH = 3;
  
  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH-1:0] data_out;
  
  always_comb addr <= SWI[3:2];
	  
  always_comb
	case(addr)
	2'b00: data_out = 3'b011;
	2'b01: data_out = 3'b110;
	2'b10: data_out = 3'b100;
	2'b11: data_out = 3'b010;
	endcase
	
  always_comb LED[7:5] <= data_out;  
  
endmodule
