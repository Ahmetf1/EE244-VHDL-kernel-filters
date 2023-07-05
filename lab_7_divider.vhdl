----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:36:31 05/20/2023 
-- Design Name: 
-- Module Name:    lab_7_divider - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lab_7_divider is
    Port ( myinputclk : in  STD_LOGIC;
           myoutputclk : out  STD_LOGIC := '0' );
end lab_7_divider;


architecture Behavioral of lab_7_divider is

	
	signal toggle : std_logic := '0';

begin
  process(myinputclk)
  variable mycounter : integer range 0 to 3 := 0;
  begin
    if rising_edge(myinputclk) then
      if mycounter = 3 then
        toggle <= '1';
        mycounter := 0;
      else
	  toggle <= '0';
        mycounter := mycounter + 1;
      end if;
    end if;
  end process;
  
  myoutputclk <= toggle;

end Behavioral;