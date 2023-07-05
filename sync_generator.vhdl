----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:06:59 05/20/2023 
-- Design Name: 
-- Module Name:    sync_generator - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity sync_generator is
	Port (                       
		clk: in std_logic;
      hsync: out std_logic; 		
		vsync: out std_logic;
		pixel_count: out integer range 0 to 153599;
		myreset: out std_logic);                        
end sync_generator;

architecture Behavioral of sync_generator is
begin
	process(clk)
		Variable hcounter : integer range 0 to 799 := 0;
		Variable vcounter : integer range 0 to 520 := 0;
		Variable pixel_count_int : integer range 0 to 153599 := 0;
		begin
		if rising_edge(clk) then
			if hcounter < 799 then
				hcounter := hcounter + 1;
			elsif hcounter = 799 then
				hcounter := 0;
				if vcounter < 520 then
					vcounter := vcounter + 1;
				elsif vcounter = 520 then
					vcounter := 0;
				end if;
			end if;
		end if;
		
		if hcounter > 95 then
			hsync <= '1';
		else
			hsync <= '0';
		end if;
		
		if vcounter > 1 then
			vsync <= '1';
		else
			vsync <= '0';
		end if;
		
		if hcounter > 143 and hcounter < 783 and vcounter > 30 and vcounter < 510 then
			myreset <= '0';
			pixel_count_int := (((vcounter - 31) * 640) + hcounter - 143) mod 153600; 
		else
			pixel_count_int := 0;
			myreset <= '1';
		end if;
		pixel_count <= pixel_count_int;
	end process;
end Behavioral;