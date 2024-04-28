library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity noc_tb is
end noc_tb;

architecture behavioral of noc_tb is

component NoC port(
	
	clk, reset: in std_logic;
	
	input_5_local: in std_logic_vector(11 downto 0);
	input_5_north: in std_logic_vector(11 downto 0);
	input_5_south: in std_logic_vector(11 downto 0);
	input_5_west : in std_logic_vector(11 downto 0);
	--input_5_east : in std_logic_vector(11 downto 0);
	input_6_local: in std_logic_vector(11 downto 0);
	input_6_north: in std_logic_vector(11 downto 0);
	input_6_south: in std_logic_vector(11 downto 0);
	--input_6_west : in std_logic_vector(11 downto 0);
	input_6_east : in std_logic_vector(11 downto 0);
	
	we_5_local: in std_logic;	
	we_5_north: in std_logic;
	we_5_south: in std_logic;
	we_5_west : in std_logic;
	--we_5_east : in std_logic;
	we_6_local: in std_logic;	
	we_6_north: in std_logic;
	we_6_south: in std_logic;
	--we_6_west : in std_logic;
	we_6_east : in std_logic;
	
	cin_5_local: in std_logic; 
	cin_5_north: in std_logic;
	cin_5_south: in std_logic;
	cin_5_west : in std_logic;
	--cin_5_east : in std_logic;
	cin_6_local: in std_logic; 
	cin_6_north: in std_logic;
	cin_6_south: in std_logic;
	--cin_6_west : in std_logic;
	cin_6_east : in std_logic;
	
	cout_5_local: out std_logic;
	cout_5_north: out std_logic;
	cout_5_south: out std_logic;
	cout_5_west: out std_logic;
	--cout_5_east: out std_logic;
	cout_6_local: out std_logic;
	cout_6_north: out std_logic;
	cout_6_south: out std_logic;
	--cout_6_west: out std_logic;
	cout_6_east: out std_logic
	
	--data_out_l : out std_logic_vector(11 downto 0); 
	--data_out_n : out std_logic_vector(11 downto 0);
	--data_out_s : out std_logic_vector(11 downto 0);
	--data_out_w : out std_logic_vector(11 downto 0);
	--data_out_e : out std_logic_vector(11 downto 0)
	);
	end component;
	
	signal tb_clk, tb_reset: std_logic;
	signal tb_input_5_local, tb_input_5_north, tb_input_5_south, tb_input_5_west,tb_input_6_local, tb_input_6_north, tb_input_6_south,tb_input_6_east: std_logic_vector(11 downto 0):="000000000000";
	signal tb_we_5_local, tb_we_5_north, tb_we_5_south, tb_we_5_west, tb_we_6_local, tb_we_6_north, tb_we_6_south, tb_we_6_east: std_logic;
	signal tb_cin_5_local, tb_cin_5_north, tb_cin_5_south, tb_cin_5_west, tb_cin_6_local,tb_cin_6_north,tb_cin_6_south, tb_cin_6_east : std_logic:='0';
	signal tb_cout_5_local, tb_cout_5_north, tb_cout_5_south, tb_cout_5_west, tb_cout_6_local, tb_cout_6_north, tb_cout_6_south, tb_cout_6_east: std_logic:='0';
	
	constant clock_period : time := 200 ns;
begin

	uut: NoC port map(
	clk => tb_clk, reset => tb_reset,  
	input_5_local => tb_input_5_local, input_5_north => tb_input_5_north, input_5_south => tb_input_5_south, input_5_west => tb_input_5_west,
	we_5_local => tb_we_5_local, we_5_north => tb_we_5_north, we_5_south => tb_we_5_south, we_5_west => tb_we_5_west,
	input_6_local => tb_input_6_local, input_6_north => tb_input_6_north, input_6_south => tb_input_6_south, input_6_east => tb_input_6_east,
	we_6_local => tb_we_6_local, we_6_north => tb_we_6_north, we_6_south => tb_we_6_south, we_6_east => tb_we_6_east,
	cin_5_local => tb_cin_5_local, cin_5_north => tb_cin_5_north, cin_5_south => tb_cin_5_south, cin_5_west => tb_cin_5_west,
	cin_6_local => tb_cin_6_local, cin_6_north => tb_cin_6_north, cin_6_south => tb_cin_6_south, cin_6_east=> tb_cin_6_east,
	cout_5_local => tb_cout_5_local, cout_5_north => tb_cout_5_north, cout_5_south => tb_cout_5_south, cout_5_west => tb_cout_5_west,
	cout_6_local => tb_cout_6_local, cout_6_north => tb_cout_6_north, cout_6_south => tb_cout_6_south, cout_6_east => tb_cout_6_east
	);
	
	
	clk_process:process
	begin
	--loop
		tb_clk <= '0';
		wait for clock_period/2;
		tb_clk <= '1';
		wait for clock_period/2;
		--if (now >= 2us)then
			--wait;
		--end if;
	--end loop;
	end process;
	
	
		tb_reset <= '1', '0' after 200 ns;

	
	--tb_current <= 5;
	--tb_input_local <= "000000000001";
	--tb_we_local <= '1';
	--tb_cin_local <='0';
	--wait for clock_period;
	--tb_current <= 5;
	--tb_input_north <= "000000000100";
	--tb_we_north <= '1';
	--tb_cin_north <='0';
	--wait for clock_period;
	

	
	--tb_input_5_west<= "000010001010","100010000000" after 700 ns; --4 => 10
	--tb_we_5_west <= '1'after 300 ns, '0' after 700 ns;
	--tb_cin_5_west <='0';
	
	tb_input_6_east<= "000011100001","100011100000" after 700 ns; --7 => 1
	tb_we_6_east <= '1'after 500 ns, '0' after 1000 ns;
	tb_cin_6_east <='0';
	
	--tb_input_5_local<= "000010100110","100010100000" after 700 ns; --5 => 6
	--tb_we_5_local <= '1'after 300 ns, '0' after 700 ns;
	--tb_cin_5_local <='0';
	
	--tb_input_6_local<= "000011001001","100011000000" after 900 ns; --6 => 9
	--tb_we_6_local <= '1'after 300 ns, '0' after 700 ns;
	--tb_cin_6_local <='0';
	
	--tb_input_6_south<= "000101000001","100101000000" after 700 ns; --10 => 1
	--tb_we_6_south <= '1'after 300 ns, '0' after 700 ns;
	--tb_cin_6_south <='0';
	
	
	
	

end behavioral;