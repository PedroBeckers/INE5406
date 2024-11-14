LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY subtrator IS
	GENERIC (
		N : POSITIVE := 8 -- número de bits por amostra
	);
	PORT (
			a : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); --entrada subtrator
			b : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); --entrada subtrator
			s : OUT STD_LOGIC_VECTOR (N DOWNTO 0) --saida subtrator
		);
END ENTITY;

ARCHITECTURE arch OF subtrator IS
BEGIN
	s <= STD_LOGIC_VECTOR(UNSIGNED('0' & a) - UNSIGNED('0' & b));
END ARCHITECTURE;