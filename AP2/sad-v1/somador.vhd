LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY somador IS
	GENERIC (
		N : POSITIVE := 6 -- número de bits por amostra
	);
	PORT (
			a : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); -- entrada somador
			b : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); -- entrada somador
			s : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0); -- saída somador
			cout : OUT STD_LOGIC -- carry out
		);
END ENTITY;

ARCHITECTURE arch OF somador IS
	SIGNAL soma : STD_LOGIC_VECTOR(N DOWNTO 0);
BEGIN
	soma <= ('0' & a) + ('0' & b);
	cout <= soma(N);
	s <= soma(N - 1 downto 0);
END ARCHITECTURE;
