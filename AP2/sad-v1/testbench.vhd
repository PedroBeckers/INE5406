library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity testbench is
end entity testbench;

architecture tb of testbench is
    constant B_BITS : POSITIVE := 8;
    constant N_BITS : POSITIVE := 64;
    constant P_BITS : POSITIVE := 1;
    constant clk_periodo : time := 10 ns;

    signal clk, enable, reset       : std_logic := '0';
    signal sample_ori, sample_can   : std_logic_vector(B_BITS - 1 downto 0);
    signal sad_value                : std_logic_vector((integer(ceil(real(B_BITS) / real(P_BITS))) + integer(ceil(log2(real(N_BITS)))) + integer(ceil(log2(real(P_BITS)))) - 1) downto 0);
    signal read_mem, done           : std_logic := '0';
    signal address                  : std_logic_vector(integer(ceil(log2(real(N_BITS)))) - 1 downto 0);

begin
    DUV: entity work.sad(arch)
    generic map(
        B => B_BITS,
        N => N_BITS,
        P => P_BITS
    )
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

    clk <= not clk after clk_periodo / 2;

    process
    begin
        -- teste 1
        reset <= '1';
        enable <= '0';
        sample_ori <= (others => '0');
        sample_can <= (others => '0');
        wait for clk_periodo * 195;
        assert (sad_value = "00000000000000") report "Falha no primeiro teste" severity error;

        -- teste 2
        sample_ori <= "00000100";
        wait for clk_periodo * 195;
        assert (sad_value = "00000010000000") report "Falha no segundo teste" severity error;

        -- teste 3
        sample_ori <= "00100000";
        wait for clk_periodo * 195;
        assert (sad_value = "00100000000000") report "Falha no terceiro teste" severity error;

        -- teste 4
        sample_ori <= "11111111";
        wait for clk_periodo * 195 + 5 ns;
        assert (sad_value = "11111111000000") report "Falha no quarto teste" severity error;

        wait;
    end process;
end architecture tb;
