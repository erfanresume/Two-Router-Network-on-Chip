library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arbiter is
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
	
end arbiter;

architecture behavioral of arbiter is
	
	type my_type is (waitrl, waitrn, waitrs, waitrw, waitre, grantl, grantn, grants, grantw, grante);
	signal state_reg, state_next: my_type;
	
	signal to_s_local: std_logic_vector(1 downto 0);
	signal to_s_north: std_logic_vector(1 downto 0);
	signal to_s_south: std_logic_vector(1 downto 0);
	signal to_s_west : std_logic_vector(1 downto 0);
	signal to_s_east : std_logic_vector(1 downto 0);
	signal w_reql_en : std_logic;
	signal w_reqn_en : std_logic;
	signal w_reqs_en : std_logic;
	signal w_reqw_en : std_logic;
	signal w_reqe_en : std_logic;
	signal rd_l_en : std_logic;--grant or read from arbiter to input buffer
	signal rd_n_en : std_logic;
	signal rd_s_en : std_logic;
	signal rd_w_en : std_logic;
	signal rd_e_en : std_logic;
	
begin  
	
-- state register
	process(clk,reset)
	begin
		if (reset='1') then
			state_reg <= waitrl; 
		elsif (clk'event and clk='1') then
			state_reg <= state_next;
end if;
end process;

-- next state 
process(state_reg,req_in_local,req_in_north,req_in_south,req_in_west,req_in_east,dir_local,dir_north,dir_south,dir_west,dir_east,credit_in_local,credit_in_north,credit_in_south,credit_in_west,credit_in_east)
begin
	s_local <="100";
	s_north <="100";
	s_south <="100";
	s_west <="100";
	s_east <="100";
	g_north<= '0';
	g_south<= '0';
	g_west <= '0';
	g_east <= '0';
	g_local<= '0';
	w_req_local <= '0';
	w_req_north <= '0';
	w_req_south <= '0';
	w_req_west  <= '0';
	w_req_east  <= '0';
	routing_ib_local <= req_in_local;
	routing_ib_north <= req_in_north;
	routing_ib_south <= req_in_south;
	routing_ib_west <= req_in_west;
	routing_ib_east <= req_in_east;
	
	case state_reg is
		when waitrl => 
			if (req_in_local /= "00000") then
				state_next <= grantl;
			elsif (req_in_north /= "00000") then
				state_next <= grantn;
			elsif (req_in_south /= "00000") then
				state_next <= grants;
			elsif (req_in_west /= "00000") then
				state_next <= grantw;
			elsif (req_in_east /= "00000") then
				state_next <= grante;
			else
				state_next <= waitrl;
			end if;
			
		when waitrn =>
			if (req_in_north /= "00000") then
				state_next <= grantn;
			elsif (req_in_south /= "00000") then
				state_next <= grants;
			elsif (req_in_west /= "00000") then
				state_next <= grantw;
			elsif (req_in_east /= "00000") then
				state_next <= grante;
			elsif (req_in_local /= "00000") then
				state_next <= grantl;
			else
				state_next <= waitrn;
			end if;
			
		when waitrs => 
			if (req_in_south /= "00000") then
				state_next <= grants;
			elsif (req_in_west /= "00000") then
				state_next <= grantw;
			elsif (req_in_east /= "00000") then
				state_next <= grante;
			elsif (req_in_local /= "00000") then
				state_next <= grantl;
			elsif (req_in_north /= "00000") then
				state_next <= grantn;
			else
				state_next <= waitrs;
			end if;
			
		when waitrw =>
			if (req_in_west /= "00000") then
				state_next <= grantw;
			elsif (req_in_east /= "00000") then
				state_next <= grante;
			elsif (req_in_local /= "00000") then
				state_next <= grantl;
			elsif (req_in_north /= "00000") then
				state_next <= grantn;
			elsif (req_in_south /= "00000") then
				state_next <= grants;
			else
				state_next <= waitrw;
			end if;

		when waitre =>
			if (req_in_east /= "00000") then
				state_next <= grante;
			elsif (req_in_local /= "00000") then
				state_next <= grantl;
			elsif (req_in_north /= "00000") then
				state_next <= grantn;
			elsif (req_in_south /= "00000") then
				state_next <= grants;
			elsif (req_in_west /= "00000") then
				state_next <= grantw;
			else
				state_next <= waitre;
			end if;

		when grantl =>		
			if(req_in_local /= "00000" and dir_local = "001" and credit_in_north /= '1' )then
				state_next <= grantl;
				s_north <= "000";--local to north 
				g_local <= '1';
				w_req_north <= '1';--north output will map to the south input buffer from another router
			elsif(req_in_local /= "00000" and dir_local = "010" and credit_in_south /= '1' )then
				state_next <= grantl;
				s_south <= "001"; 
				g_local <= '1';
				w_req_south <= '1';
			elsif(req_in_local /= "00000" and dir_local = "011" and credit_in_west /= '1' )then
				state_next <= grantl;
				s_west <= "010"; 
				g_local <= '1';
				w_req_west <= '1';
			elsif(req_in_local /= "00000" and dir_local = "100" and credit_in_east /= '1' )then
				state_next <= grantl;
				s_east <= "011"; 
				g_local <= '1';
				w_req_east <= '1';
			else
				--req_in_local <= "00000";
				state_next <= waitrn;
			end if;
		
		when grantn =>
			if(req_in_north /= "00000" and dir_north = "000" and credit_in_local /= '1' )then
				state_next <= grantn;
				s_local <= "011";--north to local 
				g_north <= '1';
				w_req_local <= '1';--local output will map to the local input buffer from another router
			elsif(req_in_north /= "00000" and dir_north = "010" and credit_in_south /= '1' )then
				state_next <= grantn;
				s_south <= "000"; 
				g_north <= '1';
				w_req_south <= '1';
			elsif(req_in_north /= "00000" and dir_north = "011" and credit_in_west /= '1' )then
				state_next <= grantn;
				s_west <= "001";
				g_north <= '1';	
				w_req_west <= '1';
			elsif(req_in_north /= "00000" and dir_north = "100" and credit_in_east /= '1' )then
				state_next <= grantn;
				s_east <= "010"; 
				g_north <= '1';
				w_req_east <= '1';
			else
				--req_in_north <= "00000";
				state_next <= waitrs;
			end if;
			
		when grants =>
			if(req_in_south /= "00000" and dir_south = "000" and credit_in_local /= '1' )then
				state_next <= grants;
				s_local <= "010";--south to local 
				g_south <= '1';
				w_req_local <= '1';--local output will map to the local input buffer from another router
			elsif(req_in_south /= "00000" and dir_south = "001" and credit_in_north /= '1' )then
				state_next <= grants;
				s_north <= "011"; 
				g_south <= '1';
				w_req_north <= '1';
			elsif(req_in_south /= "00000" and dir_south = "011" and credit_in_west /= '1' )then
				state_next <= grants;
				s_west <= "000"; 
				g_south <= '1';
				w_req_west <= '1';
			elsif(req_in_south /= "00000" and dir_south = "100" and credit_in_east /= '1' )then
				state_next <= grants;
				s_east <= "001"; 
				g_south <= '1';
				--rd_s_en <= g_south; 
				w_req_east <= '1';
			else
				--req_in_south <= "00000";
				state_next <= waitrw;
			end if;
			
		when grantw =>
			if(req_in_west /= "00000" and dir_west = "000" and credit_in_local /= '1' )then
				state_next <= grantw;
				s_local <= "001";--west to local 
				g_west <= '1';
				w_req_local <= '1';--local output will map to the local input buffer from another router
			elsif(req_in_west /= "00000" and dir_west = "001" and credit_in_north /= '1' )then
				state_next <= grantw;
				s_north <= "010"; 
				g_west <= '1';
				w_req_north <= '1';
			elsif(req_in_west /= "00000" and dir_west = "010" and credit_in_south /= '1' )then
				state_next <= grantw;
				s_south <= "011"; 
				g_west <= '1';
				w_req_south <= '1';
			elsif(req_in_west /= "00000" and dir_west = "100" and credit_in_east /= '1' )then
				state_next <= grantw;
				s_east <= "000"; 
				g_west <= '1';
				w_req_east <= '1';
			else
				--req_in_west <= "00000";
				state_next <= waitre;
			end if;
			
		when grante =>
			if(req_in_east /= "00000" and dir_east = "000" and credit_in_local /= '1' )then
				state_next <= grante;
				s_local <= "000";--east to local 
				g_east <= '1';
				w_req_local <= '1';--local output will map to the local input buffer from another router
			elsif(req_in_east /= "00000" and dir_east = "001" and credit_in_north /= '1' )then
				state_next <= grante;
				s_north <= "001"; 
				g_east <= '1';
				w_req_north <= '1';
			elsif(req_in_east /= "00000" and dir_east = "010" and credit_in_south /= '1' )then
				state_next <= grante;
				s_south <= "010"; 
				g_east <= '1';
				w_req_south <= '1';
			elsif(req_in_east /= "00000" and dir_east = "011" and credit_in_west /= '1' )then
				state_next <= grante;
				s_west <= "011"; 
				g_east <= '1';
				w_req_west <= '1';
			else
				--req_in_east <= "00000";
				state_next <= waitrl;
			end if;	
	end case;				
end process;
end behavioral;


	

