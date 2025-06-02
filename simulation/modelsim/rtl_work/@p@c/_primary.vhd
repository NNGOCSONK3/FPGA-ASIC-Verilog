library verilog;
use verilog.vl_types.all;
entity PC is
    port(
        clk             : in     vl_logic;
        loadPC          : in     vl_logic;
        incPC           : in     vl_logic;
        address         : in     vl_logic_vector(11 downto 0);
        execadd         : out    vl_logic_vector(11 downto 0)
    );
end PC;
