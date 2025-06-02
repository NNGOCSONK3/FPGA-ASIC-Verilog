library verilog;
use verilog.vl_types.all;
entity insReg is
    port(
        clk             : in     vl_logic;
        loadIR          : in     vl_logic;
        insin           : in     vl_logic_vector(15 downto 0);
        address         : out    vl_logic_vector(11 downto 0);
        opcode          : out    vl_logic_vector(3 downto 0)
    );
end insReg;
