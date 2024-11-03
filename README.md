# INE5406
Projetos da disciplina INE5406 - Sistemas Digitais - UFSC

## Grupo 9

- Arthur Erpen (Matrícula 24105030)
- Pedro Becker (Matrícula 24100605)

## Descrição Sad_v1
O circuito Sad_v1 é projetado para calcular a diferença absoluta somada entre blocos de pixels de imagens, a função deste circuito é comparar um bloco de 8x8 pixels em uma imagem atual, que está sendo codificada (Qi), com um bloco correspondente em uma imagem referência (Qref), que vem de um quadro anterior ou posterior. O circuito acessa as memórias MemA e MemB, onde os valores dos pixels estão armazenados e, para cada pixel no bloco Qi, o circuito calcula a diferença absoluta em relação ao pixel correspondente no bloco Qref. O valor da diferença absoluta para cada par de pixels é acumulado em um registrador, essa acumulação forma o valor total da Sad para o par de blocos (presentes em MemA e MemB), quanto menor o valor acumulado na Sad, maior a similaridade entre os dois blocos. Percebe-se, além do mais, que a Sad_v1 necessita de 195 ciclos de relógio para concluir seu processamento.
#### Simulação Sad_v1

