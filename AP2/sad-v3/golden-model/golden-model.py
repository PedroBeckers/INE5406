import random

with open("estimulos.dat", "w") as arq:

    for _ in range(16):
        for __ in range(50): #50 pares de blocos 8x8

            mem_A = [random.randint(0, 255), random.randint(0, 255), random.randint(0, 255), random.randint(0, 255)]
            mem_B = [random.randint(0, 255), random.randint(0, 255), random.randint(0, 255), random.randint(0, 255)]
            sad_value = 0

            for j in range(16): #loop para leitura inteira da memoria pela sad_v3 
                
                for k in range(4):
                    sad_value += abs(mem_A[k] - mem_B[k])
            
            linha = f"{mem_A[0]:08b}" + f"{mem_A[1]:08b}" + f"{mem_A[2]:08b}" + f"{mem_A[3]:08b}"
            linha += " " + f"{mem_B[0]:08b}" + f"{mem_B[1]:08b}" + f"{mem_B[2]:08b}" + f"{mem_B[3]:08b}"
            linha += " " + f"{sad_value:014b}" 
            
            arq.write(linha + "\n")
        
