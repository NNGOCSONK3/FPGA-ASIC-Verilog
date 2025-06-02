library verilog;
use verilog.vl_types.all;
entity muxA is
    port(
        clk             : in     vl_logic;
        in1             : in     vl_logic_vector(31 downto 0);
        in2             : in     vl_logic_vector(15 downto 0);
        sel             : in     vl_logic;
        outA            : out    vl_logic_vector(31 downto 0)
    );
end muxA;
