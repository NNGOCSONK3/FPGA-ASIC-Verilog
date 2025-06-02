library verilog;
use verilog.vl_types.all;
entity datamem is
    port(
        clk             : in     vl_logic;
        we_DM           : in     vl_logic;
        dataDM          : in     vl_logic_vector(31 downto 0);
        addDM           : in     vl_logic_vector(11 downto 0);
        outDM           : out    vl_logic_vector(31 downto 0)
    );
end datamem;
