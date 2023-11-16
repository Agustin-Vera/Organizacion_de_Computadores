.data
	int1: .asciiz "Por favor ingrese el primer entero: "
	int2: .asciiz "Por favor ingrese el segundo entero: "
	output: .asciiz "La diferencia es: "
	par: .asciiz " (Par)"
	impar: .asciiz " (Impar)"

.text
	main:
		# Impresion de mensaje para indicar al usuario ingresar el primer entero
		li $v0, 4      # 4 indica a Syscall que se imprimira un string por consola
		la $a0, int1
		syscall
		# Usuario ingresa el primer entero
		li $v0, 5      # 5 indica a Syscall que se obtendra un numero por consola y lo almacenara en $v0
		syscall
		move $s0, $v0  # Movemos el contenido de $v0 a $t0
		
		# Impresion de mensaje para indicar al usuario ingresar el segundo entero
		li $v0, 4      # 4 indica a Syscall que se imprimira un string por consola
		la $a0, int2
		syscall
		# Usuario ingresa el segundo entero
		li $v0, 5      # 5 indica a Syscall que se obtendra un numero por consola y lo almacenara en $v0
		syscall
		move $s1, $v0  # Movemos el contenido de $v0 a $t1
		
		# Movimiento de valores en los registros $s0 y $s1 a los registros $a0 y $a1 respectivamente, los cuales son los argumentos de la
		# subrutina calcularMaximo
		move $a0, $s0
		move $a1, $s1
		jal calcularMaximo
		
		# Movimiento de valores obtenidos por la subrutina calcularMaximo hacia los argumentos de subrutina calculoDeParidad
		move $a0, $v0   # Se mueve a $a0 el maximo, el cual esta almacenado en $v0
		move $a1, $v1   # Se mueve a $a1 el menor, el cual esta almacenado en $v1
		jal calculoDeParidad
		
		# Fin del programa
		li $v0, 10 # 10 indica a Syscall que se realizara el fin del programa
		syscall
		
		# Subrutina que calcula el maximo (mayor) entre dos numeros, almacena el mayor en $v0 y el menor en $v1
		calcularMaximo:
			bge $a0, $a1, entregarMaximo  # Si $a0 >= $a1 --> entregarMaximo, por ende, $a0 es maximo
			move $v0, $a1   # Retorna el maximo en $v0
			move $v1, $a0   # Retorna el menor en $v1
			jr $ra   # Vuelve al main
		entregarMaximo:
			move $v0, $a0   # Retorna el maximo en $v0
			move $v1, $a1   # Retorna el menor en $v1
			jr $ra   # Vuelve al main
		
		# Subrutina que calcula la diferencia entre dos numeros y calcula la paridad de esta diferencia
		calculoDeParidad:
			sub $t0, $a0, $a1  # Se calcula la diferencia entre el mayor y menor y se guarda en $t0
			# Se imprime el mensaje de diferencia
			li $v0, 4
			la $a0, output
			syscall
			# Impresion del numero respectivo a la diferencia entre los enteros
			li $v0, 1     # 1 indica a Syscall que se imprimira un entero por consola
			move $a0, $t0
			syscall
			
			# Calculo de paridad
			addi $t0, $0, 2 # $t0 = 2 --> Se utilizara para la division
			div $a0, $t0    # div --> divide a $a0 por $t0, el resultado lo almacena en LO y el resto en HI
			mfhi $t1        # Obtiene el resto de la division almacenado en el registro HI y lo guarda en $t1
			beq $t1, $0, esPar  # Si $t1 = 0 --> la division por 2 da resto cero, es par
			# Se imprime el mensaje de Impar
			li $v0, 4
			la $a0, impar
			syscall
			jr $ra   # Vuelve al main
			
		esPar:
			# Se imprime el mensaje de Par
			li $v0, 4
			la $a0, par
			syscall
			jr $ra   # Vuelve al main