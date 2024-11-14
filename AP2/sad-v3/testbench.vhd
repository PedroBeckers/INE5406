library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity testbench is
end entity testbench;

architecture tb of testbench is
    constant B_BITS : natural := 32;
    constant N_BITS : natural := 16;
    constant P_BITS : natural := 4;
    constant clk_periodo : time := 10 ns;
	 
    signal finished : std_logic := '0';
    signal clk       : std_logic := '0';
    signal enable    : std_logic := '0';
    signal reset     : std_logic := '1';
    signal sample_ori, sample_can : std_logic_vector(B_BITS - 1 downto 0);
    signal sad_value : std_logic_vector((integer(ceil(real(B_BITS) / real(P_BITS))) + integer(ceil(log2(real(N_BITS)))) + integer(ceil(log2(real(P_BITS)))) - 1) downto 0);
    signal read_mem, done : std_logic := '0';
    signal address : std_logic_vector(integer(ceil(log2(real(N_BITS)))) - 1 downto 0);

begin
    DUV: entity work.sad
        port map(
            clk => clk,
            enable => enable,
            reset => reset,
            sample_ori => sample_ori,
            sample_can => sample_can,
            read_mem => read_mem,
            address => address,
            sad_value => sad_value,
            done => done
        );

    clk <= not clk after clk_periodo / 2 when finished /= '1' else '0';

    stim: process is
        file arquivo_de_estimulos : text open read_mode is "../../estimulos.dat";
        variable linha_de_estimulos : line;
        variable espaco : character;
        variable valor1 : bit_vector(31 downto 0);
        variable valor2 : bit_vector(31 downto 0);
        variable valor_saida : bit_vector(13 downto 0);
        variable contador : integer := 1;
		  
    begin
		  reset <= '1'; 
        enable <= '0';
		  wait for 10 ns;
		  
		  
        reset <= '0'; 
        enable <= '1';
        wait for 20 ns;
		  

        while not endfile(arquivo_de_estimulos) loop
            if (contador mod 17 /= 0) then
                readline(arquivo_de_estimulos, linha_de_estimulos);
                read(linha_de_estimulos, valor1);
                sample_ori <= to_stdlogicvector(valor1);
                read(linha_de_estimulos, espaco);
                read(linha_de_estimulos, valor2);
                sample_can <= to_stdlogicvector(valor2);
					 wait for clk_periodo * 3;
            else
                readline(arquivo_de_estimulos, linha_de_estimulos);
                read(linha_de_estimulos, valor_saida);
                wait for clk_periodo * 4;
                assert (sad_value = to_stdlogicvector(valor_saida))
                    report "Falha na simulacao." severity error;
            end if;

            contador := contador + 1;
        end loop;

        wait for clk_periodo;
        assert false report "Teste finalizado." severity note;
        finished <= '1';
        wait;
    end process;
end architecture tb;
