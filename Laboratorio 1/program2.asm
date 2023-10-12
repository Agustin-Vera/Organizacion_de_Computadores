.data
	arr: .word 10 22 15 40
	end:
	# $t0 = evensum
.text
	la $s0, arr          # esta instrucción pone la dirección base de arr en $s0
	la $s1, end          # carga la direccion de la etiqueta end en $s1
	subu $s1, $s1, $s0   # 
	srl $s1, $s1, 2      # ahora $s1 = num elementos en arreglo --> arrlen = largo array
	addi $t0, $0, 0      # $t0 = 0 --> evensum = 0
	addi $s2, $0, 0      # $s2 = 0 --> i = 0
For:
	beq $s2, $s1, EndFor
	sll $t1, $s2, 2         # i = i * 4 --> los indices avanzan de a 4 bytes
	add $t1, $t1, $s0       # $t1 = direccion arr[i]
	lw $t2, 0($t1)          # $t2 = arr[i]
	andi $t3, $t2, 1        # AND bit a bit entre arr[i] y 1 para saber si es par --> $t3 puede contener 1 o 0
	beq $t3, $0, SumaPar    # Si $t3 = 0 significa que el numero es par, salta a la etiqueta
	addi $s2, $s2, 1        # suma 1 al indice --> $s2 = $s2 + 1 --> i = i + 1
	j For
SumaPar:
	add $t0, $t0, $t2       # $t0 = $t0 + $t2 --> evensum = evensum + arr[i]
	addi $s2, $s2, 1        # suma 1 al indice --> $s2 = $s2 + 1 --> i = i + 1
	j For
EndFor:
	li $v0, 10 # Termino del programa, exit, instruccion con un 10
	syscall
	
	