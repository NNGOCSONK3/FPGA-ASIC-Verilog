library verilog;
use verilog.vl_types.all;
entity muxB is
    port(
        clk             : in     vl_logic;
        in1             : in     vl_logic_vector(11 downto 0);
        in2             : in     vl_logic_vector(11 downto 0);
        sel             : in     vl_logic;
        outB            : out    vl_logic_vector(11 downto 0)
    );
end muxB;
