//////////////////////////////////////////////////////////////////////////////
////	This module describes a Arithmatic unit of ALU.			/////
///	This will have two inputs of 16 bits each.			/////
///	It has to provide either Arithmatic operation 			////
////////////////////////////////////////////////////////////////////////////
module arith(a,b,opcode,outau);
input [15:0] a;
input [15:0] b;
input [2:0] opcode;
output [31:0] outau;
reg [31:0] outau;

always@(a,b,opcode)
begin
	case(opcode)
	3'b000: outau = {16'h0000, a+b};
	3'b001: outau = a * b;
	3'b010: if (a > b) begin
		outau = a - b;
		end
		else begin
		outau = b - a;
		end
	3'b011: if (a > b) begin
		outau = a / b;
		end
		else begin
		outau = b /a;
		end
	default outau = 32'h00000000;
	endcase
end
endmodule

////////////////////////////////////////////////////////////////
///////	Test bench for the Arithmetic unit		///////
//////////////////////////////////////////////////////////////
module tb_arith();
reg [15:0] a;
reg [15:0] b;
reg [2:0] opcode;
wire [31:0] outau;

// Instantiation of the design

arith a1 (.a(a), .b(b), .opcode(opcode), .outau(outau));

// Initialization
initial
begin
	a = 16'h0000;
	b = 16'h0000;
	opcode = 3'b000;
end

// Stimulus
initial
begin
	#5 a = 16'h0001;
	#5 b = 16'h0010;

	# 5 opcode = 3'b001;
	# 5 opcode = 3'b010;
	# 5 opcode = 3'b011;
	# 5 opcode = 3'b100;
	# 5 opcode = 3'b101;
	# 5 opcode = 3'b110;
	# 5 opcode = 3'b111;

	#5 a = 16'h0100;
	#5 b = 16'h0110;
	# 5 opcode = 3'b001;
	# 5 opcode = 3'b010;
	# 5 opcode = 3'b011;
	# 5 opcode = 3'b100;
	# 5 opcode = 3'b101;
	# 5 opcode = 3'b110;
	# 5 opcode = 3'b111;
end
endmodule
	

	

