import random

with open("estimulos.dat", "w") as arq:

    for i in range(50):
        s = 0
        for j in range(16):
            a1 = random.randint(0, 255)
            a2 = random.randint(0, 255)
            a3 = random.randint(0, 255)
            a4 = random.randint(0, 255)
            b1 = random.randint(0, 255)
            b2 = random.randint(0, 255)
            b3 = random.randint(0, 255)
            b4 = random.randint(0, 255)
            s += (abs(a1 - b1) + abs(a2 - b2) + abs(a3 - b3) + abs(a4 - b4))

            linha = f"{a1:08b}" + f"{a2:08b}" + f"{a3:08b}" + f"{a4:08b}"
            linha += " " + f"{b1:08b}" + f"{b2:08b}" + f"{b3:08b}" + f"{b4:08b}"
            arq.write(linha + "\n")
            
        resultado = f"{s:014b}"
        if i != 49:
            arq.write(resultado + "\n")
        else:
            arq.write(resultado)
            
