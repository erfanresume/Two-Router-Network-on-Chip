library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is port(
	clk, reset : in std_logic;
	wr_en: in std_logic;
	w_addr, r_addr : in std_logic_vector(1 downto 0);	
	w_data : in std_logic_vector(11 downto 0);
	r_data : out std_logic_vector(11 downto 0)
);
end register_file;

architecture behavioral of register_file is

	type reg_file_type is array (3 downto 0) of std_logic_vector(11 downto 0);
	signal array_reg:reg_file_type;
	signal array_next:reg_file_type;
	signal en: std_logic_vector(3 downto 0);

	begin
		process(clk,reset)
		begin 
			if(reset='1') then
				array_reg(3) <= (others=>'0');
				array_reg(2) <= (others=>'0');
				array_reg(1) <= (others=>'0');
				array_reg(0) <= (others=>'0');
			elsif (clk'event and clk='0') then 
				array_reg(3) <= array_next(3);
				array_reg(2) <= array_next(2);
				array_reg(1) <= array_next(1);
				array_reg(0) <= array_next(0);
			end if;
		end process;
		process(array_reg, en, w_data)
		begin
			array_next(3) <= array_reg(3);
			array_next(2) <= array_reg(2);
			array_next(1) <= array_reg(1);
			array_next(0) <= array_reg(0);
			if en(3) = '1' then 
				array_next(3) <= w_data;
			end if;
			if en(2) = '1' then
				array_next(2) <= w_data;
			end if;
			if en(1) = '1' then
				array_next(1) <= w_data;
			end if;
			if en(0) = '1' then
				array_next(0) <= w_data;
			end if;
		end process;
		process(wr_en, w_addr)   --write kardan dataei ke tooye buffer voroodi vared shode
		begin
			if(wr_en = '0') then 
				en <= (others=>'0');
			else
				case w_addr is
					when "00" => en <="0001";
					when "01" => en <="0010";			
					when "10" => en <="0100";
					when others => en <="1000";					
				end case;
			end if;
		end process;
		
		process(r_addr, array_reg)
		begin
			case r_addr is
				when "00" => r_data <= array_reg(0);
				when "01" => r_data <= array_reg(1);
				when "10" => r_data <= array_reg(2);
				when others => r_data <= array_reg(3);				
			end case;
		end process;	
						 
	end behavioral;					 