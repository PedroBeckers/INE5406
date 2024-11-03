LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux2_1 IS
	GENERIC (
		N : POSITIVE := 7 -- número de bits por amostra
	);
	PORT (
			sel : IN STD_LOGIC; -- seletor
			a : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); -- entrada mux
			b : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); -- entrada mux ("0000000")
			s : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0) -- saida mux
		);
END ENTITY;

ARCHITECTURE arch OF mux2_1 IS
BEGIN
	s <= a WHEN sel = '0' ELSE b;
END ARCHITECTURE;