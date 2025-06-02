/////////////////////////////////////////////////////////////////////
//	This describes the ALU of the design			////
////////////////////////////////////////////////////////////////////

module ALU( a, b, opcode, mode, outALU, za, zb, eq, gt, lt);
input [15:0] a;
input [15:0] b;
input [2:0] opcode;
input mode;
output [31:0] outALU;
output za, zb, eq, gt, lt;

reg [31:0] outALU;
reg za, zb, eq, gt, lt;

// Integer operations (mode = 0)
always @(a, b, opcode, mode)
begin
	if (mode == 0) begin
		case(opcode)
			3'b000: outALU = {16'h0000, a + b};      // ADD
			3'b001: outALU = {16'h0000, a - b};      // SUB
			3'b010: outALU = {16'h0000, a & b};      // AND
			3'b011: outALU = {16'h0000, a | b};      // OR
			3'b100: outALU = {16'h0000, a ^ b};      // XOR
			3'b101: outALU = a * b;                  // MUL
			3'b110: outALU = {16'h0000, a << b[3:0]}; // SLL
			3'b111: outALU = {16'h0000, a >> b[3:0]}; // SRL
			default: outALU = 32'h00000000;
		endcase
	end
	// Floating point operations (mode = 1)
	else if (mode == 1) begin
		case(opcode)
			3'b000: outALU = fp_add(a, b);           // FADD
			3'b001: outALU = fp_sub(a, b);           // FSUB
			3'b010: outALU = fp_mul(a, b);           // FMUL
			default: outALU = 32'h00000000;
		endcase
	end
	else begin
		outALU = 32'h00000000;
	end

	// Set comparison flags
	eq = (a == b);
	gt = (a > b);
	lt = (a < b);
	za = (a == 16'h0000);
	zb = (b == 16'h0000);
end

// Custom 16-bit floating point format: 1-bit sign, 5-bit exponent, 10-bit mantissa
function [31:0] fp_add;
	input [15:0] a, b;
	reg [15:0] result;
	reg [4:0] exp_a, exp_b;
	reg [9:0] mant_a, mant_b;
	reg sign_a, sign_b;
	begin
		// Unpack operands
		sign_a = a[15];
		exp_a = a[14:10];
		mant_a = a[9:0];
		sign_b = b[15];
		exp_b = b[14:10];
		mant_b = b[9:0];
		
		// Add mantissas with exponent alignment
		if (exp_a > exp_b) begin
			mant_b = mant_b >> (exp_a - exp_b);
			exp_b = exp_a;
		end
		else if (exp_b > exp_a) begin
			mant_a = mant_a >> (exp_b - exp_a);
			exp_a = exp_b;
		end
		
		// Add mantissas
		if (sign_a == sign_b)
			result = {sign_a, exp_a, mant_a + mant_b};
		else
			result = {sign_a, exp_a, mant_a - mant_b};
			
		fp_add = {16'h0000, result};
	end
endfunction

function [31:0] fp_sub;
	input [15:0] a, b;
	begin
		fp_sub = fp_add(a, {~b[15], b[14:0]});
	end
endfunction

function [31:0] fp_mul;
	input [15:0] a, b;
	reg [15:0] result;
	reg [4:0] exp_a, exp_b;
	reg [9:0] mant_a, mant_b;
	reg sign_a, sign_b;
	begin
		// Unpack operands
		sign_a = a[15];
		exp_a = a[14:10];
		mant_a = a[9:0];
		sign_b = b[15];
		exp_b = b[14:10];
		mant_b = b[9:0];
		
		// Multiply mantissas and add exponents
		result = {(sign_a ^ sign_b), (exp_a + exp_b), (mant_a * mant_b)};
		fp_mul = {16'h0000, result};
	end
endfunction

endmodule
////////////////////////////////////////////////////////////////////////
//	Testbench for the ALU design				///////
///////////////////////////////////////////////////////////////////////

module tb_ALU();
    // Khai bÃ¡o cÃ¡c tÃ­n hiá»‡u
    reg [15:0] a;
    reg [15:0] b;
    reg [2:0] opcode;
    reg mode;
    wire [31:0] outALU;
    wire za, zb, eq, gt, lt;

    // Khá»Ÿi táº¡o ALU
    ALU alu_inst (
        .a(a),
        .b(b),
        .opcode(opcode),
        .mode(mode),
        .outALU(outALU),
        .za(za),
        .zb(zb),
        .eq(eq),
        .gt(gt),
        .lt(lt)
    );

    // Task để in kết quả
    task print_result;
        input [2:0] op;
        input [15:0] in_a;
        input [15:0] in_b;
        input [31:0] result;
        begin
            $display("\nTime=%0t", $time);
            $display("Mode=%0b (0: Integer, 1: Float)", mode);
            $display("Opcode=%0b", op);
            $display("Input A: %0h (16'b%0b)", in_a, in_a);
            $display("Input B: %0h (16'b%0b)", in_b, in_b);
            $display("Output: %0h (32'b%0b)", result, result);
            $display("Flags:");
            $display("  za=%0b (A is zero)", za);
            $display("  zb=%0b (B is zero)", zb);
            $display("  eq=%0b (A equals B)", eq);
            $display("  gt=%0b (A greater than B)", gt);
            $display("  lt=%0b (A less than B)", lt);
            $display("----------------------------------------");
        end
    endtask

    // Khoi tao gia tri ban dau
    initial begin
        a = 16'h0000;
        b = 16'h0000;
        opcode = 3'b000;
        mode = 0;
    end

    // Test cases
    initial begin
        #5;
        
        // ===== TEST CAC PHEP TOAN SO NGUYEN (mode = 0) =====
        // opcode: 000-ADD, 001-SUB, 010-AND, 011-OR, 100-XOR, 101-MUL, 110-SLL, 111-SRL
        mode = 0;
        $display("\n=== KIEMTRA CAC TOAN TU SO NGUYEN ===");
        $display("Mode = 0: CHE DO SO NGUYEN");
        $display("Opcode: 000-ADD, 001-SUB, 010-AND, 011-OR, 100-XOR, 101-MUL, 110-SLL, 111-SRL");
        
        // Test ADD: 1 + 2 = 3
        #5;
        a = 16'h0001; b = 16'h0002;
        opcode = 3'b000;  // ADD
        #5 print_result(opcode, a, b, outALU);
        
        // Test SUB: 5 - 2 = 3
        #5;
        a = 16'h0005; b = 16'h0002;
        opcode = 3'b001;  // SUB
        #5 print_result(opcode, a, b, outALU);
        
        // Test AND: a = 16'h00FF → a0000 0000 1111 1111 
		  //b = 16'h0F0F → 0000 1111 0000 1111

        #5;
        a = 16'h00FF; b = 16'h0F0F;
        opcode = 3'b010;  // AND
        #5 print_result(opcode, a, b, outALU);
        
        // Test OR: 0xFF | 0x0F0F = 0x0FFF a = 16'h00FF → 
		  //0000 0000 1111 1111 b = 16'h0F0F → 0000 1111 0000 1111

        #5;
        a = 16'h00FF; b = 16'h0F0F;
        opcode = 3'b011;  // OR
        #5 print_result(opcode, a, b, outALU);
        
        // Test XOR: 0xFF ^ 0x0F0F = 0x0FF0  
		  //a = 16'h00FF = 0000 0000 1111 1111

			//b = 16'h0F0F = 0000 1111 0000 1111
        #5;
        a = 16'h00FF; b = 16'h0F0F;
        opcode = 3'b100;  // XOR
        #5 print_result(opcode, a, b, outALU);
        
        // Test MUL: 2 * 3 = 6
        #5;
        a = 16'h0002; b = 16'h0003;
        opcode = 3'b101;  // MUL
        #5 print_result(opcode, a, b, outALU);
        
        // Test SLL: 1 << 2 = 4
        #5;
        a = 16'h0001; b = 16'h0002;
        opcode = 3'b110;  // SLL
        #5 print_result(opcode, a, b, outALU);
        
        // Test SRL: 0x8000 >> 2 = 0x2000
        // KIEM TRA DỊCH PHAI VS BIT CAO NHAT
        #5;
        a = 16'h8000; b = 16'h0002;
        opcode = 3'b111;  // SRL
        #5 print_result(opcode, a, b, outALU);
        
        // ===== TEST CÁC PHÉP TOÁN SỐ THỰC (mode = 1) =====
        mode = 1;
        $display("\n=== KIEM TRA CAC PHEP TOAN SO THUC ===");
        $display("Mode = 1: Chế độ số thực");
        $display("Định dạng: 1-bit dấu, 5-bit mũ, 10-bit phần định trị");
        
        // Test FADD: 1.0 + 1.0 = 2.0
        #5;
        a = 16'h3C00;  // 1.0
        b = 16'h3C00;  // 1.0
        opcode = 3'b000;  // FADD
        #5 print_result(opcode, a, b, outALU);
        
        // Test FSUB: 1.0 - 0.5 = 0.5
        #5;
        a = 16'h3C00;  // 1.0
        b = 16'h3800;  // 0.5
        opcode = 3'b001;  // FSUB
        #5 print_result(opcode, a, b, outALU);
        
        // Test FMUL: 1.0 * 1.0 = 1.0
        #5;
        a = 16'h3C00;  // 1.0
        b = 16'h3C00;  // 1.0
        opcode = 3'b010;  // FMUL
        #5 print_result(opcode, a, b, outALU);
        
        // ===== TEST CAC TRUONG HOP DAC BIET =====
        // mode = 0: Quay lại chế độ số nguyên
        mode = 0;
        $display("\n=== KIEM TRA CAC TH DAC BIET ===");
         $display("KIEM TRA CAC TRUONG HOP DAC BIET");
        
        // Test số 0
        // Kiểm tra phép cộng với số 0
        #5;
        a = 16'h0000; b = 16'h0000;
        opcode = 3'b000;  // ADD
        #5 print_result(opcode, a, b, outALU);
        
        // Test số lớn nhất
        // Kiểm tra phép cộng với giá trị lớn nhất (0xFFFF)
        #5;
        a = 16'hFFFF; b = 16'hFFFF;
        opcode = 3'b000;  // ADD
        #5 print_result(opcode, a, b, outALU);
        
        // Test tràn số
        // Kiểm tra trường hợp tràn số dương (0x7FFF + 1)
        #5;
        a = 16'h7FFF; b = 16'h0001;
        opcode = 3'b000;  // ADD
        #5 print_result(opcode, a, b, outALU);
        
        // Test số âm
        // Kiểm tra phép cộng với số âm lớn nhất
        #5;
        a = 16'h8000; b = 16'h8000;
        opcode = 3'b000;  // ADD
        #5 print_result(opcode, a, b, outALU);
        
        // Kết thúc mô phỏng
        #5;
        $display("\n=== KET THUC MO PHONG ===");
        $finish;
    end

endmodule
