library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity NoC is
	port(
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
end NoC;

architecture behavioral of NoC is
	
	component router 
		port(
				clk, reset: in std_logic;
	
				current : in integer; --curennt router: 5 or 6
	
				input_local: in std_logic_vector(11 downto 0);--input of buffer
				input_north: in std_logic_vector(11 downto 0);
				input_south: in std_logic_vector(11 downto 0);
				input_west : in std_logic_vector(11 downto 0);
				input_east : in std_logic_vector(11 downto 0);
	
				we_local: in std_logic;	
				we_north: in std_logic;
				we_south: in std_logic;
				we_west : in std_logic;
				we_east : in std_logic;
	
				cin_local: in std_logic; 
				cin_north: in std_logic;
				cin_south: in std_logic;
				cin_west : in std_logic;
				cin_east : in std_logic;
	
				cout_local: out std_logic;
				cout_north: out std_logic;
				cout_south: out std_logic;
				cout_west: out std_logic;
				cout_east: out std_logic;
	
				w_req_l : out std_logic; 
				w_req_n : out std_logic;
				w_req_s : out std_logic;
				w_req_w : out std_logic;
				w_req_e : out std_logic;
	
				data_out_l : out std_logic_vector(11 downto 0); 
				data_out_n : out std_logic_vector(11 downto 0);
				data_out_s : out std_logic_vector(11 downto 0);
				data_out_w : out std_logic_vector(11 downto 0);
				data_out_e : out std_logic_vector(11 downto 0)
			);
	end component;
	
	
	
	signal in_east5_to_out_west6: std_logic_vector(11 downto 0);
	signal we_east5_to_wreq_west6 : std_logic;
	signal cin_east5_to_cout_west6 : std_logic;
	signal cin_west6_to_cout_east5 : std_logic;
	signal in_west6_to_out_east5: std_logic_vector(11 downto 0);
	signal we_west6_to_wreq_east5 : std_logic;

begin
	
	router_5: router port map(
		clk => clk,
		reset => reset,
		current => 5, 
		input_local => input_5_local,
		input_north => input_5_north,
		input_south => input_5_south,
		input_west  => input_5_west,
		input_east  => in_east5_to_out_west6,
		we_local => we_5_local,
		we_north => we_5_north,
		we_south => we_5_south,
		we_west  => we_5_west,
		we_east  => we_east5_to_wreq_west6,
		cin_local => cin_5_local,
		cin_north => cin_5_north,
		cin_south => cin_5_south,
		cin_west  => cin_5_west,
		cin_east  => cin_east5_to_cout_west6,
		cout_local => cout_5_local,
		cout_north => cout_5_north,
		cout_south => cout_5_south,
		cout_west  => cout_5_west,
		cout_east  => cin_west6_to_cout_east5,
		w_req_l => open,
		w_req_n => open,
		w_req_s => open,
		w_req_w => open,
		w_req_e => we_west6_to_wreq_east5,
		data_out_l => open,
		data_out_n => open,
		data_out_s => open,
		data_out_w => open,
		data_out_e => in_west6_to_out_east5 
	);
	
	router_6: router port map(
		clk => clk,
		reset => reset,
		current => 6, 
		input_local => input_6_local,
		input_north => input_6_north,
		input_south => input_6_south,
		input_west  => in_west6_to_out_east5,
		input_east  => input_6_east,
		we_local => we_6_local,
		we_north => we_6_north,
		we_south => we_6_south,
		we_west  => we_west6_to_wreq_east5,
		we_east  => we_6_east,
		cin_local => cin_6_local,
		cin_north => cin_6_local,
		cin_south => cin_6_local,
		cin_west  => cin_west6_to_cout_east5,
		cin_east  => cin_6_local,
		cout_local => cout_6_local,
		cout_north => cout_6_north,
		cout_south => cout_6_south,
		cout_west  => cin_east5_to_cout_west6,
		cout_east  => cout_6_east,
		w_req_l =>open,
		w_req_n =>open,
		w_req_s =>open,
		w_req_w => we_east5_to_wreq_west6,
		w_req_e =>open,
		data_out_l =>open,
		data_out_n =>open,
		data_out_s =>open,
		data_out_w => in_east5_to_out_west6,
		data_out_e =>open
	);
	
end behavioral;
