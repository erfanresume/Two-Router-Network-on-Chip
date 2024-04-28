library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity routing is 
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
end routing;

architecture behavioral of routing is
	
	signal x_des_local, y_des_local : integer;
	signal x_des_north, y_des_north : integer;
	signal x_des_south, y_des_south : integer;
	signal x_des_west , y_des_west  : integer;
	signal x_des_east , y_des_east  : integer;
	signal x_node, y_node : integer;
begin
	x_des_local <= to_integer(unsigned(in_ib_local(4 downto 0))) mod 4 ;
	y_des_local <= to_integer(unsigned(in_ib_local(4 downto 0))) / 4 ;
	
	x_des_north <= to_integer(unsigned(in_ib_north(4 downto 0))) mod 4 ;
	y_des_north <= to_integer(unsigned(in_ib_north(4 downto 0))) / 4 ;
	
	x_des_south <= to_integer(unsigned(in_ib_south(4 downto 0))) mod 4 ;
	y_des_south <= to_integer(unsigned(in_ib_south(4 downto 0))) / 4 ;
	
	x_des_west <= to_integer(unsigned(in_ib_west(4 downto 0))) mod 4 ;
	y_des_west <= to_integer(unsigned(in_ib_west(4 downto 0))) / 4 ;
	
	x_des_east <= to_integer(unsigned(in_ib_east(4 downto 0))) mod 4 ;
	y_des_east <= to_integer(unsigned(in_ib_east(4 downto 0))) / 4 ;
	
	x_node <= current mod 4;
	y_node <= current / 4;
		
	process (x_node, y_node, x_des_local, y_des_local)
	begin
		
		local_dir <= "000";
		
		if (x_node < x_des_local) then
			local_dir <= "100";
		elsif (x_node > x_des_local) then
			local_dir <= "011";
		else
			if (y_node < y_des_local) then
				local_dir <= "010";
			elsif (y_node > y_des_local) then
				local_dir <= "001";
			else
				local_dir <= "000";
			end if;
		end if;	
	end process;
	
	
	process (x_node, y_node, x_des_north, y_des_north)
	begin
		
		north_dir <= "000";
		
		if (x_node < x_des_north) then
			north_dir <= "100";
		elsif (x_node > x_des_north) then
			north_dir <= "011";
		else
			if (y_node < y_des_north) then
				north_dir <= "010";
			elsif (y_node > y_des_north) then
				north_dir <= "001";
			else
				north_dir <= "000";
			end if;
		end if;	
	end process;
	
	
	process (x_node, y_node, x_des_south, y_des_south)
	begin
		
		south_dir <= "000";
		
		if (x_node < x_des_south) then
			south_dir <= "100";
		elsif (x_node > x_des_south) then
			south_dir <= "011";
		else
			if (y_node < y_des_south) then
				south_dir <= "010";
			elsif (y_node > y_des_south) then
				south_dir <= "001";
			else
				south_dir <= "000";
			end if;
		end if;	
	end process;
	
	
	process (x_node, y_node, x_des_west, y_des_west)
	begin
		
		west_dir <= "000";
		
		if (x_node < x_des_west) then
			west_dir <= "100";
		elsif (x_node > x_des_west) then
			west_dir <= "011";
		else
			if (y_node < y_des_west) then
				west_dir <= "010";
			elsif (y_node > y_des_west) then
				west_dir <= "001";
			else
				west_dir <= "000";
			end if;
		end if;	
	end process;
	
	
	process (x_node, y_node, x_des_east, y_des_east)
	begin
		
		east_dir <= "000";
		
		if (x_node < x_des_east) then
			east_dir <= "100";
		elsif (x_node > x_des_east) then
			east_dir <= "011";
		else
			if (y_node < y_des_east) then
				east_dir <= "010";
			elsif (y_node > y_des_east) then
				east_dir <= "001";
			else
				east_dir <= "000";
			end if;
		end if;	
	end process;
	
end behavioral;
