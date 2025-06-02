library verilog;
use verilog.vl_types.all;
entity regB is
    port(
        clk             : in     vl_logic;
        loadB           : in     vl_logic;
        dataBin         : in     vl_logic_vector(15 downto 0);
        dataBout        : out    vl_logic_vector(15 downto 0)
    );
end regB;
