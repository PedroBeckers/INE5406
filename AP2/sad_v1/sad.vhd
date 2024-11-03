LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.math_real.ALL;

ENTITY sad IS
	GENERIC (
		B : POSITIVE := 8; -- número de bits por amostra
		N : POSITIVE := 64; -- número de amostras por bloco
		P : POSITIVE := 1 -- número de amostras de cada bloco lidas em paralelo
		
	);
	PORT (
		clk : IN STD_LOGIC; -- ck
		enable : IN STD_LOGIC; -- iniciar
		reset : IN STD_LOGIC; -- reset
		sample_ori : IN STD_LOGIC_VECTOR (B - 1 DOWNTO 0); -- Mem_A[end]
		sample_can : IN STD_LOGIC_VECTOR (B - 1 DOWNTO 0); -- Mem_B[end]
		read_mem : OUT STD_LOGIC; -- read
		address : OUT STD_LOGIC_VECTOR (INTEGER(CEIL(log2(real(N)))) - 1 DOWNTO 0); -- end
		sad_value : OUT STD_LOGIC_VECTOR ((INTEGER(CEIL(REAL(B) / REAL(P))) + INTEGER(CEIL(log2(REAL(N)))) + INTEGER(CEIL(log2(REAL(P))))) - 1 DOWNTO 0); -- Calulo = log2[(N * P) * (2^(B / P) - 1)]  -> basta aplicar log2 no valor maximo possivel
		done : OUT STD_LOGIC -- pronto
	);
END ENTITY; -- sad

ARCHITECTURE arch OF sad IS

	 SIGNAL szi : STD_LOGIC;
	 SIGNAL sci : STD_LOGIC;
	 SIGNAL scpA : STD_LOGIC;
	 SIGNAL scpB : STD_LOGIC;
	 SIGNAL szsoma : STD_LOGIC;
	 SIGNAL scsoma : STD_LOGIC;
	 SIGNAL scsad_reg : STD_LOGIC;
	 SIGNAL smenor : STD_LOGIC;

BEGIN

	sad_bo : entity work.sad_bo(Behavior)
   generic map (B => B)
	port map (
		clk => clk,
		zi => szi,
		ci => sci,
		cpA => scpA,
		cpB => scpB,
		zsoma => szsoma,
		csoma =>scsoma,
		csad_reg => scsad_reg,
		pA => sample_ori,
		pB => sample_can,
		menor =>smenor,	
		ende => address,
		sad => sad_value
	 );
	 
	sad_bc : entity work.sad_bc(Behavior)
	port map (
		clk => clk,
		rst => reset,
		iniciar => enable,
		menor => smenor,
		readc => read_mem,
		pronto => done,
		zi => szi,
		ci => sci,
		cpA => scpA,
		cpB => scpB,
		zsoma => szsoma,
		csoma => scsoma,
		csad_reg => scsad_reg
	 );

END arch;