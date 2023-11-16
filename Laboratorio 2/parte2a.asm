.data
	# Resultado de la multiplicacion en el registro $s2
	#Resultados negativos expresados en complemento A2
	# Idea principal para multiplicacion, ir sumando el operando 1 consigo mismo tantas veces el operando 2 lo indique

.text

	
	addi $s2, $0, 6    # En S2 se almacenara el numero al cual se le quiere calcular el factorial 
	
	
	# Variable que almacenara los factoriales 
	addi $t3, $0, 1
	
	# Variable que almacenara el numero al cual se le calculo el factorial
	addi $t4, $0, 1
	
	jal Factorial
	
	#FIN DEL PROGRAMA
	# Impresion del numero respectivo a la diferencia entre los enteros
	move $v1, $v0
	li $v0, 1
	move $a0, $v1
	syscall
	li $v0, 10 # Termino del programa, exit, instruccion con un 10
	syscall
	
	
	# Subrutina factorial
	Factorial:
	
	    	addi $sp, $sp, -4  # Decrementar el puntero de pila
    		sw $ra, 0($sp)     # Guardar $ra en la pila
    		j LoopFactorial
    	
    	LoopFactorial:
		beq $s2, $0, FactorialDeCero
		bgt $t4, $s2, FinFactorial
		move $a0, $t3   # Operando 1 --- Factorial por izquierda
		move $a1, $t4   # Operando 2 --- Numero siguiente a factorial
		jal Multiplicar
		move $t3, $v0
		addi $t4, $t4, 1
		j LoopFactorial		
		
	FactorialDeCero:
		addi $v0, $0, 1
		jr $ra
		
	FinFactorial:
		# Recuperar $ra de la pila
    		lw $ra, 0($sp)     # Cargar $ra de la pila
    		addi $sp, $sp, 4   # Incrementar el puntero de pila

    		# Regresar al punto después del primer jal
    		jr $ra

	
	# $a0 = operando 1 --- $a1 = operando 2 --- $v0 = $a0¨* $a1
	Multiplicar:
		
		addi $v0, $0, 0
		# Guarda la direccion de la instruccion siguiente dps de usar jal Multiplicar
	    	addi $sp, $sp, -4  # Decrementar el puntero de pila
    		sw $ra, 0($sp)     # Guardar $ra en la pila
    		
		# $a0 = operando 1 --- $a1 = operando 2 --- $v0 = resultado multiplicacion
		addi $t0, $0, 2       # Iterador cuando el operando 2 es positivo
		addi $t2, $a1, 0      # Iterador cuando el operando 2 es negativo
		jal Operacion         # En operacion se distingue si el operando 2 es cero (multiplicacion por 0), el operando 1 es 1 (multiplicacion por 1)
		
		addi $t0, $t0, -2     # Se reinicia a cero el iterador cuando el operando 2 es positivo
		j Multiplicacion    # Salta a realizar los otros casos de multiplicacion
	
	Operacion:
		beq $a1, $0, MultiplicarPorCero     # Si el operando 2 es igual a 0, salta a MultiplicarPorCero
		addi $t1, $a0, 1                   # Suma 1 al operando 1 --> $t1 = $s0 + 1
		beq $t1, $t0, MultiplicarPorUno     # Si el operando 1 es igual a 1 --> $t1 = 2 si la suma anterior da $t1 = 2, cumple
		jr $ra

	MultiplicarPorCero:
		# Como el operando 2 es igual a 0, la multiplicacion es igual a 0
		addi $v0, $0, 0      # $s2 = $0 + 0 --> $s2 = 0
		j SalirMultiplicacion

	MultiplicarPorUno:
		# Como el operando 1 es igual a 1, la multiplicacion es igual al operando 2
		addi $v0, $a1, 0     # $s2 = $s1 + 0 --> $s2 = operando 2
		j SalirMultiplicacion

	Multiplicacion:
		# Se verfica si el operando 1 es negativo, en caso de no ser, se calcula la multiplicacion
		bltz $a1, MultiplicacionConSegundoOperandoNegativo
		beq $t0, $a1, SalirMultiplicacion    # Si el iterador es igual al operando 2, finaliza la multiplicacion
		add $v0, $v0, $a0     # $s2 = $s2 + $s0 --> realiza la multiplicacion
		addi $t0, $t0, 1      # avanza el iterador --> $t0 = $t0 + 1
		j Multiplicacion

	MultiplicacionConSegundoOperandoNegativo:
		# Se calcula la multiplicacion con el segundo operando negativo
		beq $t2, $0, FinMultiplicacion   # Si el iterador es igual a cero, finaliza la multiplicacion --> $t2 = $0
		add $v0, $v0, $a0                # $s2 = $s2 + $s0 --> realiza la multiplicacion, si el operando 1 ($s0) es negativo, ya se esta realizando la multiplicacion negativa
		addi $t2, $t2, 1                 # avanza el iterador --> $t0 = $t0 + 1
		j MultiplicacionConSegundoOperandoNegativo
				
	FinMultiplicacion:
		# Como ya venimos de una subrutina donde se sabe que el operando 2 es negativo, verificamos si el operando 1 es negativo
		bltz $a1, InvertirSignoResultado   # Si el operando 2 es negativo, se debe invetir el resultado almacenado en $s2
		j SalirMultiplicacion

	InvertirSignoResultado:
		# Invierte el resultado
		nor $t1, $v0, $0    # Invierte los bits, bit a bit compara el or negado entre un bit de $s2 y 0, guarda el resultado en $t1 
		addi $v0, $t1, 1    # Suma 1, para dejar el numero en complemento A2 dentro del registro $s2
		j SalirMultiplicacion

	SalirMultiplicacion:
		# Recuperar $ra de la pila
    		lw $ra, 0($sp)     # Cargar $ra de la pila
    		addi $sp, $sp, 4   # Incrementar el puntero de pila
		jr $ra