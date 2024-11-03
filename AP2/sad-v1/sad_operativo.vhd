LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sad_operativo IS
	GENERIC (
		B : POSITIVE := 8 -- número de bits por amostra
	);
	PORT (
			clk, zi, ci, cpA, cpB, zsoma, csoma, csad_reg : IN STD_LOGIC;
			pA, pB : IN STD_LOGIC_VECTOR(B - 1 DOWNTO 0);
			menor : OUT STD_LOGIC;
			ende : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
			sad : OUT STD_LOGIC_VECTOR(13 DOWNTO 0) --end palavra reservada
	);
END sad_operativo;

ARCHITECTURE Behavior OF sad_operativo IS

	--ABS
	COMPONENT absolute IS
		 GENERIC (N : POSITIVE := 8);
		 PORT (
			  a: IN std_logic_vector (N - 1 DOWNTO 0); --Perguntar sobre diferenca entre tamanho dessa entrada,
			  s: OUT std_logic_vector (N - 2 DOWNTO 0) --e a entrada do abs do sadV1 da aulaT6
		 );
	END COMPONENT;
	 
	--MULTIPLEXADOR
	COMPONENT mux2_1 IS
	GENERIC (
		N : POSITIVE := 7 -- número de bits por amostra
	);
	PORT (
			sel : IN STD_LOGIC; -- seletor
			a : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); -- entrada mux
			b : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); -- entrada mux ("0000000")
			s : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0) -- saida mux
		);
	END COMPONENT;
	
	--REGISTRADOR
	COMPONENT reg IS 
	GENERIC (
		N : POSITIVE := 7 -- número de bits por amostra
	);
	PORT (
			clk : IN STD_LOGIC; --clock
			load : IN STD_LOGIC; --load/enable
			a : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); --entrada registrador
			s : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0) --saida registrador
		);
	END COMPONENT;
	
	--SOMADOR
	COMPONENT somador IS 
	GENERIC (N : POSITIVE := 8);
	PORT (
		a, b: IN std_logic_vector (N-1 DOWNTO 0);
		s: OUT std_logic_vector (N-1 DOWNTO 0);
		cout: OUT STD_LOGIC
	);
	END COMPONENT;
	
	--SUBTRATOR
	COMPONENT subtrator IS
	GENERIC (
		N : POSITIVE := 8 -- número de bits por amostra
	);
	PORT (
			a : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); --entrada subtrator
			b : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); --entrada subtrator
			s : OUT STD_LOGIC_VECTOR (N DOWNTO 0) --saida subtrator
		);
	END COMPONENT;
	
	--DEFINICAO DOS SINAIS
	SIGNAL smux_i : STD_LOGIC_VECTOR(6 DOWNTO 0);       --saida mux_i/entrada registrador_i
	SIGNAL sreg_i : STD_LOGIC_VECTOR(6 DOWNTO 0);       --saida registrador_i
	SIGNAL esomador_i : STD_LOGIC_VECTOR(5 DOWNTO 0);   --entrada somador_i/6 bits da direita de sreg_i/saida "ende"(endereco)
	SIGNAL ssomador_i : STD_LOGIC_VECTOR(5 DOWNTO 0);   --saida somador_i
	SIGNAL coutsomador_i : STD_LOGIC;                   --carry out somador_i
	SIGNAL sreg_pA : STD_LOGIC_VECTOR(7 DOWNTO 0);      --saida registrador pA/entrada subtrator
	SIGNAL sreg_pB : STD_LOGIC_VECTOR(7 DOWNTO 0);		 --saida registrador pB/entrada subtrator
	SIGNAL ssubtrator_d : STD_LOGIC_VECTOR(8 DOWNTO 0); --saida subtrator_d/entrada abs
	SIGNAL sabs_d : STD_LOGIC_VECTOR(7 DOWNTO 0);       --saida abs(**1 bit a menos da entrada**)
	SIGNAL esomador_d : STD_LOGIC_VECTOR(13 DOWNTO 0);  --entrada somador_d
	SIGNAL ignorar : STD_LOGIC;								 --carry out do somador_d, nao sera usado, deve ser ignorado
	SIGNAL ssomador_d : STD_LOGIC_VECTOR(13 DOWNTO 0);  --saida somador_d/entrada mux_d
	SIGNAL smux_d : STD_LOGIC_VECTOR(13 DOWNTO 0);      --saida mux_d/entrada reg_soma
	SIGNAL sreg_soma : STD_LOGIC_VECTOR(13 DOWNTO 0);   --saida registrador_soma/entrada registrador_sad
	
BEGIN
	
	--INSTANCIAR COMPONENTES
	
	--PARTE ESQUERDA DO CIRCUITO DO BO
	
	--MULTIPLEXADOR I/END
	mux_i : mux2_1
		GENERIC MAP (
			N => 7
		)
	PORT MAP (
			sel => zi, --seletor, entrada do sad_operativo
			a => coutsomador_i & ssomador_i,
			b => "0000000",
			s => smux_i  --sinal de saida do mux_i
	 );
	
	--REGISTRADOR_I	
	reg_i : reg
		GENERIC MAP (
			N => 7
		)
		PORT MAP (
            clk => clk,
            load => ci,
            a => smux_i,
				s => sreg_i
       );
	
	--CONECTANDO SAIDA "menor" AO MSB DO SINAL "sreg_i" (SAIDA DO REGISTRADOR_I)
	menor <= not sreg_i(6);
	esomador_i <= sreg_i(5 DOWNTO 0);
	ende <= esomador_i;
	
	--SOMADOR_I
	somador_i : somador
		GENERIC MAP (
			N => 6
		)
		PORT MAP (
            a => esomador_i,
            b => "000001",
            s => ssomador_i,
				cout => coutsomador_i
       );
	
	--PARTE DIREITA DO CIRCUITO DO BO
	
	--REGISTRADOR_pA
	reg_pA : reg
	GENERIC MAP (
		N => 8
	)
	PORT MAP (
			clk => clk,
			load => cpA,
			a => pA,
			s => sreg_pA
	 );
	 
	--REGISTRADOR_pB
	reg_pB : reg
	GENERIC MAP (
		N => 8
	)
	PORT MAP (
			clk => clk,
			load => cpB,
			a => pB,
			s => sreg_pB
	 );
	 
	--SUBTRATOR
	subtrator_d : subtrator
	GENERIC MAP (
		N => 8
	)
	PORT MAP (
			a => sreg_pA,
			b => sreg_pB,
			s => ssubtrator_d
	 );
	 
	--ABS
	abs_d : absolute
	GENERIC MAP (
		N => 9
	)
	PORT MAP (
			a => ssubtrator_d,
			s => sabs_d
	 );
	 
	 --AJUSTANDO TAMANHO DA SAIDA DO ABS_D PARA ENTRADA DO SOMADOR_D
	 
	 esomador_d <= "000000" & sabs_d;
	 
	--SOMADOR_D
	somador_d : somador
	GENERIC MAP (
		N => 14
	)
	PORT MAP (
			a => esomador_d,
			b => sreg_soma,
			s => ssomador_d,
			cout => ignorar
	 );
	
	--MUX_D
	mux_d : mux2_1
	GENERIC MAP (
		N => 14
	)
	PORT MAP (
			sel => zsoma, --seletor, entrada do sad_operativo
			a => ssomador_d,
			b => "00000000000000",
			s => smux_d  --sinal de saida do mux_d
	 );
	
	--REGISTRADOR_SOMA
	reg_soma : reg
	GENERIC MAP (
		N => 14
	)
	PORT MAP (
			clk => clk,
			load => csoma,
			a => smux_d,
			s => sreg_soma
	 );
	
	--REGISTRADOR_SAD
	reg_sad : reg
	GENERIC MAP (
		N => 14
	)
	PORT MAP (
			clk => clk,
			load => csad_reg,
			a => sreg_soma,
			s => sad
	 );
	
END Behavior;		