library verilog;
use verilog.vl_types.all;
entity controller is
    generic(
        reset           : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        load            : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        execute         : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        en              : in     vl_logic;
        opcode          : in     vl_logic_vector(3 downto 0);
        loadA           : out    vl_logic;
        loadB           : out    vl_logic;
        loadC           : out    vl_logic;
        loadIR          : out    vl_logic;
        loadPC          : out    vl_logic;
        incPC           : out    vl_logic;
        mode            : out    vl_logic;
        we_DM           : out    vl_logic;
        selA            : out    vl_logic;
        selB            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of reset : constant is 1;
    attribute mti_svvh_generic_type of load : constant is 1;
    attribute mti_svvh_generic_type of execute : constant is 1;
end controller;
