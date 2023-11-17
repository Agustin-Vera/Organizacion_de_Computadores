.data
	

.text
	addi $a0, $0, 6    # $a0 = Numero al cual se le quiere calcular el factorial (Ej: 6)
	jal Factorial      # Salto a subrutina Factorial
	
	# Impresion de resultado (Ej: Si $a0 = 6 --> $v1 = 6! --> $v1 = 720
	move $v1, $v0    # $v1 = $v0 --> $v0 = Retorno de subrutina Factorial
	li $v0, 1        # 1 indica a Syscall que se imprimira un entero por consola
	move $a0, $v1
	syscall
	#FIN DEL PROGRAMA
	li $v0, 10 # 10 indica a Syscall que se finalizara el programa
	syscall
	
	# Subrutina Factorial
	Factorial:
	    	addi $sp, $sp, -4  # $sp = $sp - 4 --> Decrementar el puntero de pila
    		sw $ra, 0($sp)     # Guardar $ra en la pila
    		move $s2, $a0      # $s2 = $a0 --> La entrada (factorial a ser calculado) se guarda en $s2
    		addi $t3, $0, 1    # $t3 = 1 --> Este registro ayudara en los calculos del factorial
		addi $t4, $0, 1    # $t4 = 1 --> Este registro ayudara en los calculos del factorial
    		j LoopFactorial
    	
    	LoopFactorial:
		beq $s2, $0, FactorialDeCero   # ¿ $s2 = $0 ? --> Si, salta  a FactorialDeCero
		bgt $t4, $s2, FinFactorial     # ¿ $t4 > $s2 ? --> Si, salta a FinFactorial
		move $a0, $t3      # $a0 = $t3 --> Operando 1 contiene la acumulacion de multiplicaciones
		move $a1, $t4      # $a1 = $t4 --> Operando 2 contiene el siguiente numero a multiplicarle a la acumulacion
		jal Multiplicar    # Salta a la subrutina Multiplicar
		move $t3, $v0      # $t3 = $v0 --> Almacena en $t3 el resultado de la multiplicacion
		addi $t4, $t4, 1   # $t4 = $t4 + 1 --> Aumenta el operando 2
		j LoopFactorial	   # Salta a LoopFactorial
		
	FactorialDeCero:
		addi $v0, $0, 1    # $v0 = 1 --> El factorial de 0 es igual a 1
		jr $ra             # Salta a la instruccion posterior al uso de jal Factorial
		
	FinFactorial:
		# Recuperar $ra de la pila (stack)
    		lw $ra, 0($sp)     # Cargar $ra de la pila
    		addi $sp, $sp, 4   # Incrementar el puntero de pila
    		jr $ra             # Salta a la instruccion posterior al uso de jal Factorial

	# Subrutina multiplicar --> $a0 = operando 1 -- $a1 = operando 2
	Multiplicar:
		addi $v0, $0, 0    # $v0 = 0 --> Se reinicia el registro contenedor del valor a retornar
		# Guarda la direccion de la instruccion siguiente posterior al uso de jal Multiplicar
	    	addi $sp, $sp, -4  # Decrementar el puntero de pila
    		sw $ra, 0($sp)     # Guardar $ra en la pila
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
		addi $v0, $0, 0      # $v0 = $0 + 0 --> $v0 = 0
		j SalirMultiplicacion

	MultiplicarPorUno:
		# Como el operando 1 es igual a 1, la multiplicacion es igual al operando 2
		addi $v0, $a1, 0     # $v0 = $a1 + 0 --> $v0 = operando 2
		j SalirMultiplicacion

	Multiplicacion:
		# Se verfica si el operando 1 es negativo, en caso de no ser, se calcula la multiplicacion
		bltz $a1, MultiplicacionConSegundoOperandoNegativo
		beq $t0, $a1, SalirMultiplicacion    # Si el iterador es igual al operando 2, finaliza la multiplicacion
		add $v0, $v0, $a0     # $v0 = $v0 + $a0 --> realiza la multiplicacion
		addi $t0, $t0, 1      # avanza el iterador --> $t0 = $t0 + 1
		j Multiplicacion

	MultiplicacionConSegundoOperandoNegativo:
		# Se calcula la multiplicacion con el segundo operando negativo
		beq $t2, $0, FinMultiplicacion   # Si el iterador es igual a cero, finaliza la multiplicacion --> $t2 = $0
		add $v0, $v0, $a0                # $v0 = $v0 + $a0 --> realiza la multiplicacion, si el operando 1 ($a0) es negativo, ya se esta realizando la multiplicacion negativa
		addi $t2, $t2, 1                 # avanza el iterador --> $t0 = $t0 + 1
		j MultiplicacionConSegundoOperandoNegativo
				
	FinMultiplicacion:
		# Como ya venimos de una subrutina donde se sabe que el operando 2 es negativo, verificamos si el operando 1 es negativo
		bltz $a1, InvertirSignoResultado   # Si el operando 2 es negativo, se debe invetir el resultado almacenado en $v0
		j SalirMultiplicacion

	InvertirSignoResultado:
		# Invierte el resultado
		nor $t1, $v0, $0    # Invierte los bits, bit a bit compara el or negado entre un bit de $v0 y 0, guarda el resultado en $t1 
		addi $v0, $t1, 1    # Suma 1, para dejar el numero en complemento A2 dentro del registro $v0
		j SalirMultiplicacion

	SalirMultiplicacion:
		# Recuperar $ra de la pila (stack)
    		lw $ra, 0($sp)     # Cargar $ra de la pila
    		addi $sp, $sp, 4   # Incrementar el puntero de pila
		jr $ra             # Salta a la instruccion posterior al uso de jal Multiplicar
