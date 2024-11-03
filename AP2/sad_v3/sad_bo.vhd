LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sad_bo IS
	GENERIC (
		B : POSITIVE := 32 -- número de bits por amostra -> 4x maior que sad_v1
	);
	PORT (
			clk, zi, ci, cpA, cpB, zsoma, csoma, csad_reg : IN STD_LOGIC;
			pA, pB : IN STD_LOGIC_VECTOR(B - 1 DOWNTO 0); --saida da memoria, vetor a ser fracionado para cada registrador
			menor : OUT STD_LOGIC;
			ende : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --tamanho alterado de 7 para 4 bits
			sad : OUT STD_LOGIC_VECTOR(13 DOWNTO 0) 
	);
END sad_bo;

ARCHITECTURE Behavior OF sad_bo IS

	--DECLARAO DE COMPONENTES
	
	--ABS
	COMPONENT absolute IS
		 GENERIC (N : POSITIVE := 8);
		 PORT (
			  a: IN std_logic_vector (N - 1 DOWNTO 0); 
			  s: OUT std_logic_vector (N - 2 DOWNTO 0) 
		 );
	END COMPONENT;
	 
	--MULTIPLEXADOR
	COMPONENT mux2_1 IS
	GENERIC (
		N : POSITIVE := 5
	);
	PORT (
			sel : IN STD_LOGIC; -- seletor
			a : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); -- entrada mux
			b : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); -- entrada mux ("00000")
			s : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0) -- saida mux
		);
	END COMPONENT;
	
	--REGISTRADOR
	COMPONENT reg IS 
	GENERIC (
		N : POSITIVE := 7 
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
	GENERIC (
		N : POSITIVE := 6 
	);
	PORT (
			a : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); --entrada somador
			b : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); --entrada somador
			s : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0); --saida somador
			cout : OUT STD_LOGIC --carry out
		);
	END COMPONENT;
	
	--SUBTRATOR
	COMPONENT subtrator IS
	GENERIC (
		N : POSITIVE := 8
	);
	PORT (
			a : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); --entrada subtrator
			b : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0); --entrada subtrator
			s : OUT STD_LOGIC_VECTOR (N DOWNTO 0) --saida subtrator
		);
	END COMPONENT;
	
	--DEFINICAO DOS SINAIS
	SIGNAL smux_i : STD_LOGIC_VECTOR(4 DOWNTO 0);        --saida mux_i/entrada registrador_i **tamanho alterado de 7 para 5 bits
	SIGNAL sreg_i : STD_LOGIC_VECTOR(4 DOWNTO 0);        --saida registrador_i **tamanho alterado de 7 para 5 bits 
	SIGNAL esomador_i : STD_LOGIC_VECTOR(3 DOWNTO 0);    --entrada somador_i/4 bits da direita de sreg_i/saida "ende"(endereco)
	SIGNAL ssomador_i : STD_LOGIC_VECTOR(3 DOWNTO 0);    --saida somador_i **tamanho alterado de 6 para 4
	SIGNAL coutsomador_i : STD_LOGIC;                    --carry out somador_i
	SIGNAL sreg_pA0 : STD_LOGIC_VECTOR(7 DOWNTO 0);      --saida registrador pA0/entrada subtrator_d0
	SIGNAL sreg_pA1 : STD_LOGIC_VECTOR(7 DOWNTO 0);      --saida registrador pA1/entrada subtrator_d1
	SIGNAL sreg_pA2 : STD_LOGIC_VECTOR(7 DOWNTO 0);      --saida registrador pA2/entrada subtrator_d2
	SIGNAL sreg_pA3 : STD_LOGIC_VECTOR(7 DOWNTO 0);      --saida registrador pA3/entrada subtrator_d3
	SIGNAL sreg_pB0 : STD_LOGIC_VECTOR(7 DOWNTO 0);		  --saida registrador pB0/entrada subtrator_d0
	SIGNAL sreg_pB1 : STD_LOGIC_VECTOR(7 DOWNTO 0);		  --saida registrador pB1/entrada subtrator_d1
	SIGNAL sreg_pB2 : STD_LOGIC_VECTOR(7 DOWNTO 0);		  --saida registrador pB2/entrada subtrator_d2
	SIGNAL sreg_pB3 : STD_LOGIC_VECTOR(7 DOWNTO 0);		  --saida registrador pB3/entrada subtrator_d3
	SIGNAL ssubtrator_d0 : STD_LOGIC_VECTOR(8 DOWNTO 0); --saida subtrator_d0/entrada abs
	SIGNAL ssubtrator_d1 : STD_LOGIC_VECTOR(8 DOWNTO 0); --saida subtrator_d1/entrada abs
	SIGNAL ssubtrator_d2 : STD_LOGIC_VECTOR(8 DOWNTO 0); --saida subtrator_d2/entrada abs
	SIGNAL ssubtrator_d3 : STD_LOGIC_VECTOR(8 DOWNTO 0); --saida subtrator_d3/entrada abs
	SIGNAL sabs_d0 : STD_LOGIC_VECTOR(7 DOWNTO 0);       --saida abs_d0(**1 bit a menos da entrada**)
	SIGNAL sabs_d1 : STD_LOGIC_VECTOR(7 DOWNTO 0);       --saida abs_d1(**1 bit a menos da entrada**)
	SIGNAL sabs_d2 : STD_LOGIC_VECTOR(7 DOWNTO 0);       --saida abs_d2(**1 bit a menos da entrada**)
	SIGNAL sabs_d3 : STD_LOGIC_VECTOR(7 DOWNTO 0);       --saida abs_d3(**1 bit a menos da entrada**)
	SIGNAL ssomador_d11 : STD_LOGIC_VECTOR(8 DOWNTO 0);  --saida somador_d11/entrada somador_d21
	SIGNAL coutsomador_d11 : STD_LOGIC;                  --carry out somador_d11
	SIGNAL ssomador_d12 : STD_LOGIC_VECTOR(8 DOWNTO 0);  --saida somador_d12/entrada somador_d21
	SIGNAL coutsomador_d12 : STD_LOGIC;                   --carry out somador_d12
	SIGNAL ssomador_d21 : STD_LOGIC_VECTOR(9 DOWNTO 0);  --saida somador_d21
	SIGNAL coutsomador_d21 : STD_LOGIC;                   --carry out somador_d21
	SIGNAL esomador_d31 : STD_LOGIC_VECTOR(13 DOWNTO 0); --entrada somador_d31
	SIGNAL ignorar : STD_LOGIC;								  --carry out do somador_d31, nao sera usado, deve ser ignorado
	SIGNAL ssomador_d31 : STD_LOGIC_VECTOR(13 DOWNTO 0); --saida somador_d31/entrada mux_d
	SIGNAL smux_d : STD_LOGIC_VECTOR(13 DOWNTO 0);       --saida mux_d/entrada reg_soma
	SIGNAL sreg_soma : STD_LOGIC_VECTOR(13 DOWNTO 0);    --saida registrador_soma/entrada registrador_sad
	
BEGIN
	
	--INSTANCIAR COMPONENTES
	
	--PARTE ESQUERDA DO CIRCUITO DO BO
	
	--MULTIPLEXADOR I/END
	mux_i : mux2_1
		GENERIC MAP (
			N => 5
		)
	PORT MAP (
			sel => zi, --seletor, entrada do sad_bo
			a => coutsomador_i & ssomador_i,
			b => "00000",
			s => smux_i  --sinal de saida do mux_i
	 );
	
	--REGISTRADOR_I	
	reg_i : reg
		GENERIC MAP (
			N => 5
		)
		PORT MAP (
            clk => clk,
            load => ci,
            a => smux_i,
				s => sreg_i
       );
	
	--CONECTANDO SAIDA "menor" AO MSB DO SINAL "sreg_i" (SAIDA DO REGISTRADOR_I)
	menor <= not sreg_i(4);
	esomador_i <= sreg_i(3 DOWNTO 0); --ajustado tamanho do vetor esomador_i de 6 para 4
	ende <= esomador_i; --ajustado tamanho do vetor ende de 6 para 4
	
	--SOMADOR_I
	somador_i : somador
		GENERIC MAP (
			N => 4
		)
		PORT MAP (
            a => esomador_i,
            b => "0001",
            s => ssomador_i,
				cout => coutsomador_i
       );
	
	--PARTE DIREITA DO CIRCUITO DO BO
	
	--REGISTRADOR_pA0
	reg_pA0 : reg
		GENERIC MAP (
			N => 8
		)
		PORT MAP (
			clk => clk,
			load => cpA,
			a => pA(31 DOWNTO 24),
			s => sreg_pA0
		);
	 
	--REGISTRADOR_pA1
	reg_pA1 : reg
		GENERIC MAP (
			N => 8
		)
		PORT MAP (
			clk => clk,
			load => cpA,
			a => pA(23 DOWNTO 16),
			s => sreg_pA1
		);
	 
	 --REGISTRADOR_pA2
	 reg_pA2 : reg
		GENERIC MAP (
			N => 8
		)
		PORT MAP (
			clk => clk,
			load => cpA,
			a => pA(15 DOWNTO 8),
			s => sreg_pA2
		);
	 
	 --REGISTRADOR_pA3
	 reg_pA3 : reg
		GENERIC MAP (
			N => 8
		)
		PORT MAP (
			clk => clk,
			load => cpA,
			a => pA(7 DOWNTO 0),
			s => sreg_pA3
		);
	 
	 --REGISTRADOR_pB0
	 reg_pB0 : reg
	 GENERIC MAP (
		N => 8
	 )
	 PORT MAP (
			clk => clk,
			load => cpB,
			a => pB(31 DOWNTO 24),
			s => sreg_pB0
	 );

	 --REGISTRADOR_pB1
	 reg_pB1 : reg
	 GENERIC MAP (
		N => 8
	 )
	 PORT MAP (
			clk => clk,
			load => cpB,
			a => pB(23 DOWNTO 16),
			s => sreg_pB1
	 );

	 --REGISTRADOR_pB2
	 reg_pB2 : reg
	 GENERIC MAP (
		N => 8
	 )
	 PORT MAP (
			clk => clk,
			load => cpB,
			a => pB(15 DOWNTO 8),
			s => sreg_pB2
	 );
	
	 --REGISTRADOR_pB3
	 reg_pB3 : reg
	 GENERIC MAP (
		N => 8
	 )
	 PORT MAP (
			clk => clk,
			load => cpB,
			a => pB(7 DOWNTO 0),
			s => sreg_pB3
	 );
	 
	--SUBTRATOR_D0
	subtrator_d0 : subtrator
	GENERIC MAP (
		N => 8
	)
	PORT MAP (
			a => sreg_pA0,
			b => sreg_pB0,
			s => ssubtrator_d0
	 );
	 
	--SUBTRATOR_D1
	subtrator_d1 : subtrator
	GENERIC MAP (
		N => 8
	)
	PORT MAP (
			a => sreg_pA1,
			b => sreg_pB1,
			s => ssubtrator_d1
	 );
	 
	--SUBTRATOR_D2
	subtrator_d2 : subtrator
	GENERIC MAP (
		N => 8
	)
	PORT MAP (
			a => sreg_pA2,
			b => sreg_pB2,
			s => ssubtrator_d2
	 );
	 
	--SUBTRATOR_D3
	subtrator_d3 : subtrator
	GENERIC MAP (
		N => 8
	)
	PORT MAP (
			a => sreg_pA3,
			b => sreg_pB3,
			s => ssubtrator_d3
	 );
	
		
	--ABS_D0
	abs_d0 : absolute
	GENERIC MAP (
		N => 9
	)
	PORT MAP (
			a => ssubtrator_d0,
			s => sabs_d0
	 );
	 
	--ABS_D1	
	abs_d1 : absolute
	GENERIC MAP (
		N => 9
	)
	PORT MAP (
			a => ssubtrator_d1,
			s => sabs_d1
	 );
	 
	--ABS_D2
	abs_d2 : absolute
	GENERIC MAP (
		N => 9
	)
	PORT MAP (
			a => ssubtrator_d2,
			s => sabs_d2
	 );
	 
	--ABS_D3
	abs_d3 : absolute
	GENERIC MAP (
		N => 9
	)
	PORT MAP (
			a => ssubtrator_d3,
			s => sabs_d3
	 );
	 
	--SOMADOR_D11
	somador_d11 : somador
	GENERIC MAP (
		N => 9
	)
	PORT MAP (
			a => '0' & sabs_d0,
			b => '0' & sabs_d1,
			s => ssomador_d11,
			cout => coutsomador_d11
	 );

	--SOMADOR_D12
	somador_d12 : somador
	GENERIC MAP (
		N => 9
	)
	PORT MAP (
			a => '0' & sabs_d2,
			b => '0' & sabs_d3,
			s => ssomador_d12,
			cout => coutsomador_d12
	 );
	 
	--SOMADOR_D21
	somador_d21 : somador
	GENERIC MAP (
		N => 10
	)
	PORT MAP (
			a => coutsomador_d11 & ssomador_d11,
			b => coutsomador_d12 & ssomador_d12,
			s => ssomador_d21,
			cout => coutsomador_d21
	 );
	 
	 --AJUSTANDO TAMANHO DA SAIDA DO ABS_D PARA ENTRADA DO SOMADOR_D
	 
	 esomador_d31 <= "000" & coutsomador_d21 & ssomador_d21;
	 
	--SOMADOR_D31
	somador_d31 : somador
	GENERIC MAP (
		N => 14
	)
	PORT MAP (
			a => esomador_d31,
			b => sreg_soma,
			s => ssomador_d31,
			cout => ignorar
	 );
	
	--MUX_D
	mux_d : mux2_1
	GENERIC MAP (
		N => 14
	)
	PORT MAP (
			sel => zsoma, --seletor, entrada do sad_bo
			a => ssomador_d31,
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