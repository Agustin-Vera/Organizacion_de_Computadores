.data
	# Resultado de la multiplicacion en el registro $s2
	#Resultados negativos expresados en complemento A2
	# Idea principal para multiplicacion, ir sumando el operando 1 consigo mismo tantas veces el operando 2 lo indique

.text
	main:
		addi $s0, $0, -10      # Operando 1
		addi $s1, $0, -5      # Operando 2
		addi $t0, $0, 2       # Iterador cuando el operando 2 es positivo
		addi $t2, $s1, 0      # Iterador cuando el operando 2 es negativo
		jal Operacion         # En operacion se distingue si el operando 2 es cero (multiplicacion por 0), el operando 1 es 1 (multiplicacion por 1)
		addi $t0, $t0, -2     # Se reinicia a cero el iterador cuando el operando 2 es positivo
		jal Multiplicacion    # Salta a realizar los otros casos de multiplicacion
	
	Operacion:
		beq $s1, $0, MultiplicarPorCero     # Si el operando 2 es igual a 0, salta a MultiplicarPorCero
		addi $t1, $s0, 1                   # Suma 1 al operando 1 --> $t1 = $s0 + 1
		beq $t1, $t0, MultiplicarPorUno     # Si el operando 1 es igual a 1 --> $t1 = 2 si la suma anterior da $t1 = 2, cumple
		jr $ra

	MultiplicarPorCero:
		# Como el operando 2 es igual a 0, la multiplicacion es igual a 0
		addi $s2, $0, 0      # $s2 = $0 + 0 --> $s2 = 0
		j Exit

	MultiplicarPorUno:
		# Como el operando 1 es igual a 1, la multiplicacion es igual al operando 2
		addi $s2, $s1, 0     # $s2 = $s1 + 0 --> $s2 = operando 2
		j Exit

	Multiplicacion:
		# Se verfica si el operando 1 es negativo, en caso de no ser, se calcula la multiplicacion
		bltz $s1, MultiplicacionConSegundoOperandoNegativo
		beq $t0, $s1, Exit    # Si el iterador es igual al operando 2, finaliza la multiplicacion
		add $s2, $s2, $s0     # $s2 = $s2 + $s0 --> realiza la multiplicacion
		addi $t0, $t0, 1      # avanza el iterador --> $t0 = $t0 + 1
		j Multiplicacion

	MultiplicacionConSegundoOperandoNegativo:
		# Se calcula la multiplicacion con el segundo operando negativo
		beq $t2, $0, FinMultiplicacion   # Si el iterador es igual a cero, finaliza la multiplicacion --> $t2 = $0
		add $s2, $s2, $s0                # $s2 = $s2 + $s0 --> realiza la multiplicacion, si el operando 1 ($s0) es negativo, ya se esta realizando la multiplicacion negativa
		addi $t2, $t2, 1                 # avanza el iterador --> $t0 = $t0 + 1
		j MultiplicacionConSegundoOperandoNegativo
				
	FinMultiplicacion:
		# Como ya venimos de una subrutina donde se sabe que el operando 2 es negativo, verificamos si el operando 1 es negativo
		bltz $s1, InvertirSignoResultado   # Si el operando 2 es negativo, se debe invetir el resultado almacenado en $s2
		j Exit

	InvertirSignoResultado:
		# Invierte el resultado
		nor $t1, $s2, $0    # Invierte los bits, bit a bit compara el or negado entre un bit de $s2 y 0, guarda el resultado en $t1 
		addi $s2, $t1, 1    # Suma 1, para dejar el numero en complemento A2 dentro del registro $s2
		j Exit

	Exit:
		li $v0, 10 # Termino del programa, exit, instruccion con un 10
		syscall