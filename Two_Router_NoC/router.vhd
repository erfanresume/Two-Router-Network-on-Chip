library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity router is
	port(
	clk, reset: in std_logic;
	
	current : in integer; --curennt router: 5 or 6
	
	input_local: in std_logic_vector(11 downto 0);--input of buffer
	input_north: in std_logic_vector(11 downto 0);
	input_south: in std_logic_vector(11 downto 0);
	input_west : in std_logic_vector(11 downto 0);
	input_east : in std_logic_vector(11 downto 0);
	
	we_local: in std_logic;	--write enable input for input buffer
	we_north: in std_logic;
	we_south: in std_logic;
	we_west : in std_logic;
	we_east : in std_logic;
	
	cin_local: in std_logic; --check full signal of another router
	cin_north: in std_logic;
	cin_south: in std_logic;
	cin_west : in std_logic;
	cin_east : in std_logic;
	
	cout_local: out std_logic;--full signal for each input buffer
	cout_north: out std_logic;
	cout_south: out std_logic;
	cout_west: out std_logic;
	cout_east: out std_logic;
	
	w_req_l : out std_logic; --write enable for another router
	w_req_n : out std_logic;
	w_req_s : out std_logic;
	w_req_w : out std_logic;
	w_req_e : out std_logic;
	
	data_out_l : out std_logic_vector(11 downto 0); -- crossbar output
	data_out_n : out std_logic_vector(11 downto 0);
	data_out_s : out std_logic_vector(11 downto 0);
	data_out_w : out std_logic_vector(11 downto 0);
	data_out_e : out std_logic_vector(11 downto 0)
	);
end router;

architecture behavioral of router is
	
	component fifo_input_buffer 
		port(
				clk,reset,wr,rd :in std_logic;
				w_data : in std_logic_vector(11 downto 0);
				full, empty : out std_logic;
				r_data : out std_logic_vector(11 downto 0)
			  );
	end component;
	
	
	component arbiter 
		port(
				clk: in std_logic;
				reset: in std_logic; 
				req_in_local: in std_logic_vector(4 downto 0);--request from fifo buffer
				req_in_north: in std_logic_vector(4 downto 0);
				req_in_south: in std_logic_vector(4 downto 0);
				req_in_west : in std_logic_vector(4 downto 0);
				req_in_east : in std_logic_vector(4 downto 0);
				routing_ib_local: out std_logic_vector(4 downto 0);--request to routing unit for destination direction
				routing_ib_north: out std_logic_vector(4 downto 0);
				routing_ib_south: out std_logic_vector(4 downto 0);
				routing_ib_west : out std_logic_vector(4 downto 0);
				routing_ib_east : out std_logic_vector(4 downto 0);
				dir_local: in std_logic_vector(2 downto 0);--comes from routing unit
				dir_north: in std_logic_vector(2 downto 0);
				dir_south: in std_logic_vector(2 downto 0);
				dir_west : in std_logic_vector(2 downto 0);
				dir_east : in std_logic_vector(2 downto 0);
				g_north,g_south,g_west,g_east,g_local: out std_logic;--read signals for fifo buffer
				credit_in_local: in std_logic;--full signals from another buffer
				credit_in_north: in std_logic;
				credit_in_south: in std_logic;
				credit_in_west : in std_logic;
				credit_in_east : in std_logic;
				w_req_local: out std_logic;--write signal to another buffer
				w_req_north: out std_logic;
				w_req_south: out std_logic;
				w_req_west : out std_logic;
				w_req_east : out std_logic;
				s_local: out std_logic_vector(2 downto 0);--selector of local mux in crossbar 
				s_north: out std_logic_vector(2 downto 0);--selector of north mux in crossbar
				s_south: out std_logic_vector(2 downto 0);--selector of south mux in crossbar
				s_west : out std_logic_vector(2 downto 0);--selector of west mux in crossbar
				s_east : out std_logic_vector(2 downto 0)--selector of east mux in crossbar
			 );		
	end component;
	
	
	component routing 
		port(
				in_ib_local : in std_logic_vector(4 downto 0); --comes from arbiter
				in_ib_north : in std_logic_vector(4 downto 0);
				in_ib_south : in std_logic_vector(4 downto 0);
				in_ib_west  : in std_logic_vector(4 downto 0);
				in_ib_east  : in std_logic_vector(4 downto 0);
				current : in integer;
				local_dir: out std_logic_vector(2 downto 0);--000
				north_dir: out std_logic_vector(2 downto 0);--001
				south_dir: out std_logic_vector(2 downto 0);--010
				east_dir : out std_logic_vector(2 downto 0);--011
				west_dir : out std_logic_vector(2 downto 0) --100
			);
	end component;
	
	
	component crossbar 
		port(
				in_l : in std_logic_vector(11 downto 0); 
				in_n : in std_logic_vector(11 downto 0);
				in_s : in std_logic_vector(11 downto 0);
				in_w : in std_logic_vector(11 downto 0);
				in_e : in std_logic_vector(11 downto 0);
				s_l : in std_logic_vector(2 downto 0);
				s_n : in std_logic_vector(2 downto 0);
				s_s : in std_logic_vector(2 downto 0);
				s_w : in std_logic_vector(2 downto 0);
				s_e : in std_logic_vector(2 downto 0);
				out_l : out std_logic_vector(11 downto 0); 
				out_n : out std_logic_vector(11 downto 0);
				out_s : out std_logic_vector(11 downto 0);
				out_w : out std_logic_vector(11 downto 0);
				out_e : out std_logic_vector(11 downto 0)
			  );
	end component;
		
	signal r_data_local, r_data_north, r_data_south, r_data_west, r_data_east: std_logic_vector(11 downto 0);
	signal arb_rout_l, arb_rout_n, arb_rout_s, arb_rout_w, arb_rout_e: std_logic_vector(4 downto 0);
	signal direction_l, direction_n, direction_s, direction_w, direction_e: std_logic_vector(2 downto 0);	
	signal grant_rd_l, grant_rd_n, grant_rd_s, grant_rd_w, grant_rd_e: std_logic;
	signal to_s_local: std_logic_vector(2 downto 0);
	signal to_s_north: std_logic_vector(2 downto 0);
	signal to_s_south: std_logic_vector(2 downto 0);
	signal to_s_west : std_logic_vector(2 downto 0);
	signal to_s_east : std_logic_vector(2 downto 0);
	
begin
	
	buffer_local: fifo_input_buffer port map(
		clk => clk, reset => reset,
		wr => we_local, 
		rd => grant_rd_l, 
		w_data => input_local,
		full => cout_local ,
		empty => open ,
		r_data => r_data_local   
	);
	
	buffer_north: fifo_input_buffer port map(
		clk => clk, reset => reset,
		wr => we_north, 
		rd => grant_rd_n, 
		w_data => input_north,
		full => cout_north ,
		empty => open ,
		r_data => r_data_north 
	);
	
	buffer_south: fifo_input_buffer port map(
		clk => clk, reset => reset,
		wr => we_south, 
		rd => grant_rd_s, 
		w_data => input_south,
		full => cout_south ,
		empty => open ,
		r_data => r_data_south 
	);
	
	buffer_west: fifo_input_buffer port map(
		clk => clk, reset => reset,
		wr => we_west, 
		rd => grant_rd_w, 
		w_data => input_west,
		full => cout_west ,
		empty => open,
		r_data => r_data_west
	);
	
	buffer_east: fifo_input_buffer port map(
		clk => clk, reset => reset,
		wr => we_east, 
		rd => grant_rd_e, 
		w_data => input_east,
		full => cout_east ,
		empty => open,
		r_data => r_data_east 
	);
	------------------------------------------------------
	------------------------------------------------------
	arbiter_unit : arbiter port map(
		clk => clk,
		reset => reset,
		req_in_local => input_local(4 downto 0),
		req_in_north => input_north(4 downto 0),
		req_in_south => input_south(4 downto 0),
		req_in_west  => input_west(4 downto 0),
		req_in_east  => input_east(4 downto 0),
		routing_ib_local => arb_rout_l,
		routing_ib_north => arb_rout_n,
		routing_ib_south => arb_rout_s,
		routing_ib_west =>  arb_rout_w, 
		routing_ib_east =>  arb_rout_e, 
		dir_local => direction_l,
		dir_north => direction_n,
		dir_south => direction_s,
		dir_west  => direction_w, 
		dir_east  => direction_e, 
		g_north => grant_rd_l,
		g_south => grant_rd_n,
		g_west  => grant_rd_s,
		g_east  => grant_rd_w,
		g_local => grant_rd_e,
		credit_in_local => cin_local,
		credit_in_north => cin_north,
		credit_in_south => cin_south,
		credit_in_west  => cin_west, 
		credit_in_east  => cin_east, 
		w_req_local => w_req_l ,
		w_req_north => w_req_n ,
		w_req_south => w_req_s,
		w_req_west  => w_req_w, 
		w_req_east  => w_req_e,
		s_local => to_s_local,
		s_north => to_s_north,
		s_south => to_s_south,
		s_west  => to_s_west,
		s_east  => to_s_east
	);
	-----------------------------------------------
	-----------------------------------------------
	routig_unit: routing port map(
		in_ib_local => arb_rout_l,
		in_ib_north => arb_rout_n,
		in_ib_south => arb_rout_s,
		in_ib_west  => arb_rout_w,
		in_ib_east  => arb_rout_e,	
		current => current,
		local_dir => direction_l,
		north_dir => direction_n,
		south_dir => direction_s,
		east_dir  => direction_e,
		west_dir  => direction_w
	);
	-----------------------------------------------
	-----------------------------------------------
	crossbar_switch: crossbar port map(
		in_l => r_data_local, 
		in_n => r_data_north,
		in_s => r_data_south,
		in_w => r_data_west,
		in_e => r_data_east,
		s_l  => to_s_local,
		s_n  => to_s_north,
		s_s  => to_s_south,
		s_w  => to_s_west,
		s_e  => to_s_east,
		out_l=>data_out_l, 
		out_n=>data_out_n,
		out_s=>data_out_s,
		out_w=>data_out_w,
		out_e=>data_out_e  
	);
	
end behavioral;
