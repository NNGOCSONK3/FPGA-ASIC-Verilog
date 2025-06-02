library verilog;
use verilog.vl_types.all;
entity CPU is
    port(
        clk             : in     vl_logic;
        en              : in     vl_logic;
        we_IM           : in     vl_logic;
        codein          : in     vl_logic_vector(15 downto 0);
        immd            : in     vl_logic_vector(11 downto 0);
        za              : out    vl_logic;
        zb              : out    vl_logic;
        eq              : out    vl_logic;
        gt              : out    vl_logic;
        lt              : out    vl_logic
    );
end CPU;
