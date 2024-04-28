library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity crossbar is 
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
end crossbar;

architecture behavioral of crossbar is

begin
	
	out_l <=	in_e 	when (s_l = "000") else
				in_w 	when (s_l = "001") else
				in_s 	when (s_l = "010") else
				in_n  when (s_l = "011") else
				(others=>'0');
	out_n <=	in_l  when (s_n = "000") else
				in_e 	when (s_n = "001") else
				in_w 	when (s_n = "010") else
				in_s  when (s_n = "011") else
				(others=>'0');
	out_s <=	in_n 	when (s_s = "000") else
				in_l 	when (s_s = "001") else
				in_e 	when (s_s = "010") else
				in_w  when (s_s = "011") else
				(others=>'0');
	out_w <=	in_s 	when (s_w = "000") else
				in_n 	when (s_w = "001") else
				in_l 	when (s_w = "010") else
				in_e  when (s_w = "011") else
				(others=>'0');
	out_e <=	in_w 	when (s_e = "000") else
				in_s 	when (s_e = "001") else
				in_n 	when (s_e = "010") else
				in_l  when (s_e = "011") else
				(others=>'0');
end behavioral;
