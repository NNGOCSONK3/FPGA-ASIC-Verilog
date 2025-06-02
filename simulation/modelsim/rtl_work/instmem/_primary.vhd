library verilog;
use verilog.vl_types.all;
entity instmem is
    port(
        clk             : in     vl_logic;
        we_IM           : in     vl_logic;
        dataIM          : in     vl_logic_vector(15 downto 0);
        addIM           : in     vl_logic_vector(11 downto 0);
        outIM           : out    vl_logic_vector(15 downto 0)
    );
end instmem;
