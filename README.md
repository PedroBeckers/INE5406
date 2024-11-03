# INE5406

Projetos da disciplina INE5406 - Sistemas Digitais - UFSC

## Grupo 9

- Arthur Erpen (Matrícula 24105030)
- Pedro Becker (Matrícula 24100605)

## Descrição Sad_v1

O circuito Sad_v1 é projetado para calcular a diferença absoluta somada entre blocos de pixels de imagens, a função deste circuito é comparar um bloco de 8x8 pixels em uma imagem atual, que está sendo codificada (Qi), com um bloco correspondente em uma imagem referência (Qref), que vem de um quadro anterior ou posterior. O circuito acessa as memórias MemA e MemB, onde os valores dos pixels estão armazenados e, para cada pixel no bloco Qi, o circuito calcula a diferença absoluta em relação ao pixel correspondente no bloco Qref. O valor da diferença absoluta para cada par de pixels é acumulado em um registrador, essa acumulação forma o valor total da Sad para o par de blocos (presentes em MemA e MemB). Quanto menor o valor acumulado na Sad, maior a similaridade entre os dois blocos. Percebe-se, além do mais, que a Sad_v1 necessita de 195 ciclos de relógio para concluir seu processamento, onde cada ciclo lê apenas um pixel de 8 bits de cada memoria.

#### Simulação Sad_v1

No que diz respeito à simulação, começamos definindo um período de clock que se adeque à frequência máxima do circuito, logo após, fizemos testes relacionados ao reset e ao enable e definimos valores para sample_ori e sample_can. Por fim, quando testamos os valores do estímulos.do no ModelSim, concluímos que os valores retornados estavam de acordo com os valores que esperávamos.
![Simulação Sad_v1](<Imagem do WhatsApp de 2024-11-03 à(s) 16.22.37_382602e2-1.jpg>)

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
