----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:33:06 05/20/2023 
-- Design Name: 
-- Module Name:    lab7 - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lab7 is
	Port (
		en: in std_logic;
		clk: in std_logic;
      hsync: out std_logic; 		
		vsync: out std_logic;                        
      red: out std_logic_vector(2 downto 0);           
      green: out std_logic_vector(2 downto 0);          
      blue: out std_logic_vector(1 downto 0));
	end; 

	
architecture Behavioral of lab7 is
	
	component img_processor is
	  PORT (
		 en: IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 pixel_num : IN integer range 0 to 153599;
		 img : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	  );
	end component;
	
	component img_rom IS
	  PORT (
		 clka : IN STD_LOGIC;
		 addra : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	  );
	END component;
	

	component image_generator is
		Port (                       
			count: in std_logic_vector(15 downto 0);
			image: out std_logic_vector(1 downto 0)); 
	end component;
	
	component lab_7_divider is
    Port ( myinputclk : in  STD_LOGIC;
           myoutputclk : out  STD_LOGIC := '0' );
	end component;
	
	component sync_generator is
		Port (                       
			clk: in std_logic;
			hsync: out std_logic; 		
			vsync: out std_logic;
			pixel_count: out integer range 0 to 153599;
			myreset: out std_logic);			
	end component;
	
	component counter19 is
		Port (                       
			clk: in std_logic;
			res : in std_logic;
			enb : in std_logic;
			count: out std_logic_vector(15 downto 0)); 
	end component;
	
	
	--signal image : STD_LOGIC_VECTOR(2 downto 0);
	signal counter_count : integer range 0 to 153599;
	signal myreset: STD_LOGIC;
	signal slowclk: STD_LOGIC;
	signal hsync_sig: std_logic;
	signal vsync_sig: std_logic;
	signal image: std_logic_vector(2 downto 0);
	
	-- idle signals
	signal ceo : STD_LOGIC;
	signal tc : STD_LOGIC;
	
	
begin
	frequencydivider: lab_7_divider port map(clk, slowclk);
	-- mycounter: counter19 port map(slowclk, '0', hsync_sig or vsync_sig, counter_count);
	-- myimg_rom: blk_mem_gen_v7_3 port map(clk, counter_count, image);
	-- myimg_generator: image_generator port map(counter_count,image);
	-- myimg_rom: img_rom port map(clk, counter_count, image);
	myimg_processor: img_processor port map('1', slowclk, counter_count, image);
	mysync_generator: sync_generator port map(slowclk, hsync_sig, vsync_sig, counter_count, myreset);

	red <= image(2 downto 0);
	green <= image(2 downto 0);
	blue <= image(2 downto 1);
	hsync <= hsync_sig;
	vsync <= vsync_sig;

end Behavioral;

