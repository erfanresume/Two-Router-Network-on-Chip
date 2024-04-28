library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_controller is
port(
	clk, reset : in std_logic;
	wr, rd: in std_logic;
	full, empty : out std_logic;
	wr_en : out std_logic;
	w_addr, r_addr : out std_logic_vector(1 downto 0)
);
end fifo_controller;

architecture behavioral of fifo_controller is
	signal wr_ptr, wr_next : unsigned(2 downto 0);
	signal rd_ptr, rd_next : unsigned(2 downto 0);
	signal full_flag, empty_flag : std_logic;
	
	begin
		process(clk, reset)
		begin
			if (reset = '1') then 
				rd_ptr <= (others => '0');
				wr_ptr <= (others => '0');
			elsif(clk'event and clk = '0') then
				rd_ptr <= rd_next;
				wr_ptr <= wr_next;
			end if;
		end process;
	-- next state logic
	
		process(rd, rd_ptr, empty_flag)
		begin	
			if rd='1' and empty_flag='0' then
				if rd_ptr(1 downto 0) = "11" then
					rd_next <= not(rd_ptr(2))&"00";
				else
					rd_next <= rd_ptr + 1;
				end if;
			else
				rd_next <= rd_ptr;
			end if;
		end process;	

		process(wr, wr_ptr, full_flag)
		begin	
			if wr='1' and full_flag='0' then
				if wr_ptr(1 downto 0) = "11" then
					wr_next <= not(wr_ptr(2))&"00";
				else
					wr_next <= wr_ptr + 1;
				end if;
			else
				wr_next <= wr_ptr;
			end if;
		end process;	
					  
		process(rd_ptr,wr_ptr)
		begin
			if (rd_ptr(1 downto 0) = wr_ptr(1 downto 0)) then
				if rd_ptr(2) = wr_ptr(2) then
					empty_flag <= '1';
					full_flag <= '0';
				else
					empty_flag<= '0';
					full_flag <= '1';
				end if;
			else
				empty_flag<='0';
				full_flag<= '0';
			end if;
		end process;	
				  
	-- output logic	
		W_addr <= std_logic_vector(wr_ptr(1 downto 0));
		r_addr <= std_logic_vector(rd_ptr(1 downto 0));
		empty <= empty_flag;
		full <= full_flag;
		wr_en <= (NOT(full_flag)) AND wr; 
		
end behavioral;	