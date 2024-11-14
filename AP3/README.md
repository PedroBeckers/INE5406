# INE5406

Projetos da disciplina INE5406 - Sistemas Digitais - UFSC

## Grupo 9

- Arthur Erpen (Matrícula 24105030)
- Pedro Becker (Matrícula 24100605)
- Link para o repositório no GitHub : [GitHub](https://github.com/PedroBeckers/INE5406)

## Descrição Testbench Sad_v1 e explicação da simulação:

Para o desenvolvimento do testbench da Sad_v1 replicamos os testes que havíamos pensado durante o desenvolvimento dos estimulos.do da sad.
Dessa maneira, logo após declararmos os signals, as constantes e o DUV, criamos o clock, que foi feito com a seguinte linha: `clk <= not clk after clk_periodo / 2;`.
Em seguida, resetamos o circuito e esperamos o equivalente a um ciclo de relógio para simplificar a leitura dos estados de onda.
Logo após, durante o primeiro teste, mudamos o reset e o enable, atualizamos os valores das memórias e esperamos um ciclo de execução completo da Sad v1 mais 5 ns, que corresponde a
1965 ns (acrescentamos 5 ns para garantir que os valores de saída estivessem estáveis).
No segundo teste, mantivemos os valores de reset e enable e mudamos o valor de uma das memórias, em seguida esperamos os mesmos 1965 ns. No terceiro e quarto testes, os valores de reset e enable se mantiveram, apenas o valor de uma das memórias mudou.
O valor de espera se manteve (1965 ns). No que diz respeito à arquitetura do testbench, fizemos de maneira muito parecida com o exemplo fornecido nos slides, à exemplo:

```vhdl
reset <= '0';
enable <= '1';
sample_ori <= (others => '0');
sample_can <= (others => '0');
wait for clk_periodo * 196 + 5 ns;
assert (sad_value = "00000000000000") report "Falha no primeiro teste" severity error;
```

## Descrição Testbench Sad_v3 e explicação da simulação:

Para o desenvolvimento do testbench, replicamos os testes previstos no arquivo de estímulos `estimulos.dat`.  
Inicialmente, declaramos sinais, constantes e a unidade em teste (DUV). Configuramos o clock com a linha  
`clk <= not clk after clk_periodo / 2 when finished /= '1' else '0';` para alternar o clock até o final dos testes.
No início da simulação, aplicamos um reset ao circuito e mantivemos o enable desativado (`enable <= '0'`).  
Após 10 ns, desativamos o reset e ativamos o enable, garantindo que o circuito estivesse preparado para receber estímulos.
Durante a execução, o arquivo de estímulos é lido linha a linha.  
A cada linha, os valores de `sample_ori` e `sample_can` são atribuídos a partir de `estimulos.dat`, e o sistema espera três períodos de clock, conforme indicado no loop da FSM.
Para cada décima sétima linha (divisível por 17), lemos um valor esperado para a saída `sad_value`,  
sincronizando a verificação com quatro períodos de clock para voltar ao estado S2 da FSM, de modo a respeitar o tempo de estabilização da saída e prontificar a leitura da próxima memória.
Em seguida, utilizamos a seguinte linha para verificação:

```vhdl
assert (sad_value = to_stdlogicvector(valor_saida)) report "Falha na simulacao." severity error;
```
