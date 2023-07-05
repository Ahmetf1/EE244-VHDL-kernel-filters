----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:31:12 06/06/2023 
-- Design Name: 
-- Module Name:    img_processor - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity img_processor is
	  PORT (
		 en: IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 pixel_num : IN integer range 0 to 153599;
		 img : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	  );
end img_processor;

architecture Behavioral of img_processor is

	component img_rom IS
	  PORT (
		 clka : IN STD_LOGIC;
		 addra : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	  );
	END component;
	
	component dual_image_rom IS
	  PORT (
		 clka : IN STD_LOGIC;
		 addra : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 clkb : IN STD_LOGIC;
		 addrb : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		 doutb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	  );
	end component;	
	
	signal img_0_0 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal img_0_1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal img_0_2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal img_1_0 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal img_1_1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal img_1_2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal img_2_0 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal img_2_1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal img_2_2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	
	type kernelfilter is array(0 to 2,0 to 2) of unsigned(2 downto 0);

	-- Example 3x3 Gaussian Blur Kernel
	signal Kernel : kernelfilter := (
	  ("001", "000", "000"),
	  ("000", "000", "000"),
	  ("000", "000", "001")
	);
	
	
	Signal h: integer range 0 to 639;
	Signal v: integer range 0 to 239;
	
	signal img_unsigned: unsigned(2 downto 0);
	signal flag : std_logic := '0'; 
	
begin

	process (clk)
		begin
		h <= pixel_num mod 640;
		v <= pixel_num / 640;
		if (h = 0) or (h=639) or (v=0) or (v=239) then
			flag <= '1';
		else
			flag <= '0';
		end if;
	end process;

	--myimg_rom_0_0: img_rom port map(clk, std_logic_vector(to_unsigned(h - 1 + (v - 1) * 640, 18)), img_0_0);
	--myimg_rom_0_1: img_rom port map(clk, std_logic_vector(to_unsigned(h - 1 + (v    ) * 640, 18)), img_0_1);
	--myimg_rom_0_2: img_rom port map(clk, std_logic_vector(to_unsigned(h - 1 + (v + 1) * 640, 18)), img_0_2);
	--myimg_rom_1_0: img_rom port map(clk, std_logic_vector(to_unsigned(h     + (v - 1) * 640, 18)), img_1_0);
	--myimg_rom_1_1: img_rom port map(clk, std_logic_vector(to_unsigned(h     + (v    ) * 640, 18)), img_1_1);
	--myimg_rom_1_2: img_rom port map(clk, std_logic_vector(to_unsigned(h     + (v + 1) * 640, 18)), img_1_2);
	--myimg_rom_2_0: img_rom port map(clk, std_logic_vector(to_unsigned(h + 1 + (v - 1) * 640, 18)), img_2_0);
	--myimg_rom_2_1: img_rom port map(clk, std_logic_vector(to_unsigned(h + 1 + (v    ) * 640, 18)), img_2_1);
	--myimg_rom_2_2: img_rom port map(clk, std_logic_vector(to_unsigned(h + 1 + (v + 1) * 640, 18)), img_2_2);
	mydualimg_rom: dual_image_rom port map(clk, std_logic_vector(to_unsigned(h - 1 + (v - 1) * 640, 18)), img_0_0, clk, std_logic_vector(to_unsigned(h + 1 + (v + 1) * 640, 18)), img_2_2);
--	img_unsigned <=
--	((kernel(0,0) * unsigned(img_0_0)) +
--	(kernel(0,1) * unsigned(img_0_1)) +
--	(kernel(0,2) * unsigned(img_0_2)) +
--	(kernel(1,0) * unsigned(img_1_0)) +
--	(kernel(1,1) * unsigned(img_1_1)) +
--	(kernel(1,2) * unsigned(img_1_2)) +
--	(kernel(2,0) * unsigned(img_2_0)) +
--	(kernel(2,1) * unsigned(img_2_1)) +
--	(kernel(2,2) * unsigned(img_2_2)));

	img_unsigned <= unsigned(img_0_0) - unsigned(img_2_2);
	
	process(clk)
	begin
	if (flag = '1') then
		img <= "000";
	else
		-- img <= std_logic_vector(img_unsigned(2 downto 0));
		img <= img_0_0 - img_2_2;
	end if;
	end process;


	
end Behavioral;

