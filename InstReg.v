////////////////////////////////////////////////////////////////
//////	Instruction Register realization		///////
///////////////////////////////////////////////////////////////
module insReg(clk, loadIR, insin, address, opcode);
input clk;
input loadIR;
input [15:0] insin;
output [11:0] address;
output [3:0] opcode;

reg [11:0] address;
reg [3:0] opcode;
reg [15:0] temp;

// Instruction format:
// [15:12] - opcode
// [11:0]  - address/immediate

always @(posedge clk)
begin
	if (loadIR == 1) begin
		temp <= insin;
		opcode <= insin[15:12];
		address <= insin[11:0];
	end
end
endmodule
