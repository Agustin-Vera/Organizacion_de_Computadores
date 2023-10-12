#El valor de "a" quedara almacenado en el registro $s0
#El valor de "z" quedara alamcenado en el registro $s1

addi $s0, $0, 0	     # a = 0
addi $s1, $0, 1      # z = 1
addi $s2, $0, 10    # Numero que sera condicion en el while
While:
	beq $s2, $s1, EndWhile    # Si $s2 = $s1 salta a EndWhile
	add $s0, $s0, $s1      # a = a + z
	addi $s1, $s1, 1       # z = z + 1
	j While                # Salta a While
EndWhile:
	li $v0, 10 # Termino del programa, exit, instruccion con un 10
	syscall
