library verilog;
use verilog.vl_types.all;
entity regA is
    port(
        clk             : in     vl_logic;
        loadA           : in     vl_logic;
        dataAin         : in     vl_logic_vector(15 downto 0);
        dataAout        : out    vl_logic_vector(15 downto 0)
    );
end regA;
