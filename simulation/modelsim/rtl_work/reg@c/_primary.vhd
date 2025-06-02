library verilog;
use verilog.vl_types.all;
entity regC is
    port(
        clk             : in     vl_logic;
        loadC           : in     vl_logic;
        dataCin         : in     vl_logic_vector(31 downto 0);
        dataCout        : out    vl_logic_vector(31 downto 0)
    );
end regC;
