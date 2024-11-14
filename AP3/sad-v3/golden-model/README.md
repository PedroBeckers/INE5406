# Descrição golden-model

  Este arquivo Python implementa um algoritmo que gera valores aleatórios de 8 bits 64 vezes, representando as 64 linhas de cada
posição de memória no circuito VHDL, e grava esses valores no arquivo estimulos.dat. Em seguida, o algoritmo calcula a soma das
diferenças absolutas entre pares desses valores de 8 bits e, após somar todas as 64 diferenças absolutas, grava o resultado
final no mesmo arquivo estimulos.dat. Esse processo é repetido 50 vezes, produzindo um arquivo estimulos.dat contendo os dados de
50 memórias 8x8, que são testados por meio de um testbench, a fim de verificar a correta funcionalidade do circuito para
quaisquer valores de entrada.
