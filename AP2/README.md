# INE5406

Projetos da disciplina INE5406 - Sistemas Digitais - UFSC

## Grupo 9

- Arthur Erpen (Matrícula 24105030)
- Pedro Becker (Matrícula 24100605)
- Link para o repositório no GitHub (Para ver as imagens de simulação) : [GitHub](https://github.com/PedroBeckers/INE5406)

## Descrição Sad_v1

O circuito Sad_v1 é projetado para calcular a diferença absoluta somada entre blocos de pixels de imagens. A função deste circuito é comparar um bloco de 8x8 pixels em uma imagem atual, que está sendo codificada (Qi), com um bloco correspondente em uma imagem referência (Qref), que vem de um quadro anterior ou posterior. O circuito acessa as memórias MemA e MemB, onde os valores dos pixels estão armazenados e, para cada pixel no bloco (Qi), o circuito calcula a diferença absoluta em relação ao pixel correspondente no bloco (Qref). O valor da diferença absoluta para cada par de pixels é acumulado em um registrador, e essa acumulação forma o valor total do SAD para o par de blocos (presentes em MemA e MemB). Quanto menor o valor acumulado no SAD, maior a similaridade entre os dois blocos. Além disso, o circuito Sad_v1 necessita de 195 ciclos de relógio para concluir seu processamento, onde cada ciclo lê apenas um pixel de 8 bits de cada memória.

#### Simulação Sad_v1

Na simulação, começamos definindo um período de clock que se adequa à frequência máxima do circuito. Em seguida, realizamos testes relacionados ao reset e ao enable, além de definir valores para `sample_ori` e `sample_can`. Por fim, ao testar os valores dos estímulos no ModelSim, concluímos que os valores retornados estavam de acordo com os valores esperados.

![sad_v1](https://github.com/user-attachments/assets/cc52e644-0488-4087-85b4-51d1f1d1a09c)

### Primeiro teste (0 ns):

- **Valores**: `sample_ori = 00000000` (0), `sample_can = 00000000` (0).
- **Cálculo**: \( |0 - 0| \* 64 = 0 \).
- **Resultado esperado**: O valor acumulado do SAD será 0, e o circuito retorna 14 bits em zero, confirmando que o circuito responde corretamente quando os blocos são idênticos.

### Segundo teste (1950 ns):

- **Valores**: `sample_ori = 00000100` (4), `sample_can = 00000000` (0).
- **Cálculo**: \( |4 - 0| \* 64 = 256 \).
- **Resultado esperado**: O SAD acumulado deve ser 256, que está de acordo com o valor retornado pelo circuito, validando o cálculo de SAD para uma diferença constante de 4 entre todos os pixels dos blocos.

### Terceiro teste (3900 ns):

- **Valores**: `sample_ori = 00100000` (32), `sample_can = 00000000` (0).
- **Cálculo**: \( |32 - 0| \* 64 = 2048 \).
- **Resultado esperado**: O circuito acumula o valor SAD igual a 2048, confirmando que o cálculo permanece preciso para uma diferença constante de 32 entre os pixels dos blocos.

### Quarto teste (5905 ns):

- **Valores**: `sample_ori = 11111111` (255), `sample_can = 00000000` (0).
- **Cálculo**: \( |255 - 0| \* 64 = 16320 \).
- **Resultado esperado**: O SAD acumulado retorna 16320, o valor máximo que o circuito pode gerar para uma diferença absoluta máxima (255) entre todos os pixels do bloco. Este resultado demonstra que o circuito funciona corretamente mesmo nos limites superiores de operação, sem overflow.

---

## Descrição Sad_v3

O circuito Sad_v3 apresenta a mesma funcionalidade do circuito Sad_v1, porém com menor tempo de execução. O Sad_v3 lê 4 pixels de 8 bits de cada memória por ciclo, ou seja, processa 4 pixels de cada memória em paralelo, diferentemente do Sad_v1 que processa apenas 1 pixel de cada vez. Dessa forma, o Sad_v3 tem um número de ciclos reduzido em comparação com o Sad_v1, sendo aproximadamente 4 vezes mais rápido devido ao paralelismo. O Sad_v3 requer 51 ciclos para concluir a execução, reduzindo em cerca de 4 vezes o tempo de execução em comparação com os 195 ciclos necessários para o Sad_v1.

#### Simulação Sad_v3

Durante a simulação, começamos definindo um período de clock que se adeque à frequência máxima do circuito, logo após, fizemos testes relacionados ao reset e ao enable e definimos valores para `sample_ori` e `sample_can`. Por fim, quando testamos os valores do estímulos.do no ModelSim, concluímos que os valores retornados estavam de acordo com os valores que esperávamos.

![sad_v3](https://github.com/user-attachments/assets/3aac03c4-78bc-451b-859f-4f45f6e443c5)

### Primeiro teste (0 ns):

- _Valores_: sample_ori = 00000000000000000000000000000000, sample_can = 11111111111111111111111111111111.
- _Cálculo_: \( |0 - 255| \* 16 \* = 16.320 \) (decimal) = 11111111000000 (binário), sendo 16 o número de leituras da memória/qtd a ser executado o loop, o 4 a quantidade de vetores de cada memoria operados em paralelo, e |0 - 255| a diferença absoluta de dos 4 pixels de 8 bits da amostra.
- _Resultado esperado_: Durante o período completo de execução, o circuito suporta o valor máximo possível na saída, confirmando que o valor máximo de SAD é calculado corretamente, validando a capacidade do circuito de lidar com o limite superior.

### Segundo teste (540 ns):

- _Valores_: sample_ori = 11111111111111111111111111111111, sample_can = 11111111111111111111111111111111.
- _Cálculo_: \( |255 - 255| \* 16 \* 4 = 0 \), sendo 16 o número de leituras da memória/qtd a ser executado o loop, o 4 a quantidade de vetores de cada memoria operados em paralelo, e o |255 - 255| a diferença absoluta dos 4 pixels de 8 bits da amostra.
- _Resultado esperado_: O valor acumulado do SAD será 0, indicando uma diferença absoluta de 0 entre as amostras sample_ori e sample_can. Esse resultado confirma que o circuito calcula corretamente a diferença quando os blocos são idênticos.

### Terceiro teste (810 ns):

- _Valores_: sample_ori = 11111111000000001111111100000000, sample_can = 11111111000000001111111100000000.
- _Cálculo_: \( (|255 - 255| + |0 - 0| + |255 - 255| + |0 - 0|) \* 16 = 0 \), sendo (|255 - 255| + |0 - 0| + |255 - 255| + |0 - 0|) a soma das diferenças absolutas e 16 o número de leituras da memória/qtd a ser executado o loop.
- _Resultado esperado_: O circuito apresenta valor de saída 0, pois sample_ori e sample_can são idênticos, o que confirma o correto cálculo de SAD para uma diferença absoluta zero entre os pixels dos blocos.

### Quarto teste (1050 ns):

- _Valores_: sample_ori = 10000000000000000000000000000000, sample_can = 00000000000000000000000000000010.
- _Cálculo_: \((|128 - 0| + |0 - 0| + |0 - 0| + |0 - 2|) \* 16 = 2080 \) (decimal) = 00100000100000 (binário).
- _Resultado esperado_: O valor de saída do circuito deve ser 2080, confirmando que o cálculo do SAD está correto para uma diferença considerável entre sample_ori e sample_can.

### Conclusão

Esses testes confirmam que o circuito está operando conforme esperado, realizando os cálculos de SAD corretamente para diferentes condições de entrada, inclusive em limites superiores.
