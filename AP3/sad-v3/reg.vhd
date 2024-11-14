LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY reg IS
	GENERIC (
		N : POSITIVE := 7 -- número de bits por amostra
	);
	PORT (
			clk : IN STD_LOGIC; --clock
			load : IN STD_LOGIC; --load/enable
			a : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); --entrada registrador
			s : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0) --saida registrador
		);
END ENTITY;

ARCHITECTURE arch OF reg IS
BEGIN
	PROCESS(clk)
		BEGIN
			IF rising_edge(clk) AND load = '1' THEN
				s <= a;
			END IF;
	END PROCESS;
END ARCHITECTURE;