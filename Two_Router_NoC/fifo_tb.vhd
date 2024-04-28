library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity fifo_tb is 
end fifo_tb;

  
architecture behavioral of fifo_tb is
 
component fifo_buffer is
	port (
			clk,reset: in std_logic;
			wr,rd: in std_logic;
			w_data: in std_logic_vector(11 downto 0);
			full,empty: out std_logic;
			r_data: out std_logic_vector(11 downto 0)
		  );
end component;

    signal tb_clk,tb_reset : std_logic:='0';
    signal tb_wr,tb_rd : std_logic;
    signal tb_w_data : std_logic_vector(11 downto 0);
	 signal tb_full,tb_empty: std_logic;
	 signal tb_r_data : std_logic_vector(11 downto 0);
    
	 constant clk_period : time := 10 ns;
	 constant reset_period : time := 10 ns;

  begin
		
		utt: fifo_buffer port map(
								clk => tb_clk,
								reset => tb_reset,
								wr => tb_wr,
								rd => tb_rd,
								w_data => tb_w_data,
								full => tb_full,
								empty => tb_empty,
								r_data => tb_r_data
								);
        --U1_Test: entity work.fifo(behavioral) port map(
           --   clk => tb_clk, 
            --  reset => tb_reset,
            --  input => tb_input,
            --  output => tb_output
           -- );
 
 reset_process :process
		begin
			tb_reset <= '1';
			wait for 10ns;
			tb_reset <= '0';
			wait;
		end process;
 
 clk_process :process
		begin
			tb_clk <= '0';
			wait for clk_period; 
			tb_clk <= '1';
			wait for clk_period;
		end process;
	
	
 sim_proc: process   
      begin
		
			tb_wr <= '1';
			for i in 0 to 11 loop
				tb_w_data <= std_logic_vector(to_unsigned(i,12));
				wait until tb_clk' event and tb_clk='1';
			end loop;
			tb_wr <= '0';
			wait;
     end process;
	  
	  process   
      begin
		
			for i in 0 to 11 loop
				tb_rd <='1';
				wait until tb_clk' event and tb_clk='1';
				tb_rd<= '0';
				wait until tb_clk' event and tb_clk='1';
			end loop;
			tb_rd <= '0';
			wait;
     end process;
       
end  behavioral;








