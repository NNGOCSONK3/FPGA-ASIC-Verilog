library verilog;
use verilog.vl_types.all;
entity ALU is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        opcode          : in     vl_logic_vector(2 downto 0);
        mode            : in     vl_logic;
        outALU          : out    vl_logic_vector(31 downto 0);
        za              : out    vl_logic;
        zb              : out    vl_logic;
        eq              : out    vl_logic;
        gt              : out    vl_logic;
        lt              : out    vl_logic
    );
end ALU;
