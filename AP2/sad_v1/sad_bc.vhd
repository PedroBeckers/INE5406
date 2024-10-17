LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sad_bc IS
	PORT (
			clk, rst, iniciar, menor: IN STD_LOGIC; --menor obtivo por meio do bloco operativo
			readc, pronto, zi, ci, cpA, cpB, zsoma, csoma, csad_reg: OUT STD_LOGIC --readc pois read eh palavra reservada?
	);
END sad_bc;

ARCHITECTURE Behavior OF sad_bc IS
	TYPE Tipo_estado IS (S0, S1, S2, S3, S4, S5);
	SIGNAL EstadoAtual : Tipo_estado;
BEGIN
	PROCESS (rst, clk)
	BEGIN
		IF rst = '1' THEN
			EstadoAtual <= S0;
		ELSIF (rising_edge(clk)) THEN
			CASE EstadoAtual IS
				WHEN S0 =>
						IF iniciar = '0' THEN
							EstadoAtual <= S0;
						ELSE
							EstadoAtual <= S1;
						END IF;
				WHEN S1 =>
						EstadoAtual <= S2;
				WHEN S2 =>
						IF menor = '0' THEN
							EstadoAtual <= S5;
						ELSE
							EstadoAtual <= S3;
						END IF;
				WHEN S3 =>
						EstadoAtual <= S4;
				WHEN S4 =>
						EstadoAtual <= S2;
				WHEN S5 =>
						EstadoAtual <= S0;
			END CASE;
		END IF;
	END PROCESS;
	pronto <= '1' WHEN EstadoAtual = S0 ELSE '0';
	readc <= '1' WHEN EstadoAtual = S3 ElSE '0';
	zi <= '1' WHEN EstadoAtual = S1 ELSE '0'; --mux
	ci <= '1' WHEN (EstadoAtual = S1 OR EstadoAtual = S4) ELSE '0';
	zsoma <= '1' WHEN EstadoAtual = S1 ELSE '0'; --mux
	csoma <= '1' WHEN (EstadoAtual = S1 OR EstadoAtual = S4) ELSE '0';
	cpA <= '1' WHEN EstadoAtual = S3 ELSE '0';
	cpB <= '1' WHEN EstadoAtual = S3 ELSE '0';
	csad_reg <= '1' WHEN EstadoAtual = S5 ELSE '0';
END Behavior;		