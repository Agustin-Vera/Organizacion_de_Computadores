.data
	punto: .asciiz "."
.text
	main:
		addi $a0, $0, 10  # Dividendo
		addi $a1, $0, -3    # Divisor
		
		jal Dividir
		
		# Impresion de resultado 
		# Impresion parte entera
		move $s1, $v0    # $v1 = $v0 --> $v0 = Retorno de subrutina Dividir
		li $v0, 1        # 1 indica a Syscall que se imprimira un entero por consola
		move $a0, $s1
		syscall
		
		#Impresion punto
		li $v0, 4      # 4 indica a Syscall que se imprimira un string por consola
		la $a0, punto
		syscall
		
		# Impresion primer decimal
		li $v0, 1        # 1 indica a Syscall que se imprimira un entero por consola
		move $a0, $v1
		syscall
		
		# Impresion segundo decimal
		li $v0, 1        # 1 indica a Syscall que se imprimira un entero por consola
		move $a0, $s0
		syscall
		
		#FIN DEL PROGRAMA
		li $v0, 10 # 10 indica a Syscall que se finalizara el programa
		syscall
		
		
		# v0 = parte entera
		# v1 = primer decimal
		# s0 = segundo decimal
		
		Dividir:
			addi $sp, $sp, -4  # $sp = $sp - 4 --> Decrementar el puntero de pila
    			sw $ra, 0($sp)     # Guardar $ra en la pila
			move $v0, $0    # $v0 = 0 --> Se vacia el registro de retorno en caso de tener algo
			move $v1, $0    # $v1 = 0 --> Se vacia el registro de retorno en caso de tener algo
			move $s0, $0    # $s0 = 0 --> Se vacia el registro de retorno en caso de tener algo
			
			addi $t4, $0, 0 # Indica la cantidad de numeros negativos encontrados entre el dividendo y el divisor --> si es par el resultado es positivo, si es impar el resultado es negativo
			
			bltz $a1, TransformarDivisorAPositivo
			bltz $a0, TransformarDividendoAPositivo
			j Division
			
			# Caso: El divisor es negativo se pasa a positivo
			TransformarDivisorAPositivo:
				nor $t1, $a1, $0    # Invierte los bits, bit a bit compara el or negado entre un bit de $a1 y 0, guarda el resultado en $t1 
				addi $a1, $t1, 1    # Suma 1, para dejar el numero en complemento A2 dentro del registro $v0
				addi $t4, $t4, 1     # Se deja marcado $t4 con 1 para indicar que hay 1 negativo transformado
				bltz $a0, TransformarDividendoAPositivoConDivisorNegativo
				j Division
				
			# Caso: El divisor fue pasado a positivo y el dividendo tambien es pasado a positivo
			TransformarDividendoAPositivoConDivisorNegativo:
				nor $t1, $a0, $0    # Invierte los bits, bit a bit compara el or negado entre un bit de $a1 y 0, guarda el resultado en $t1 
				addi $a0, $t1, 1    # Suma 1, para dejar el numero en complemento A2 dentro del registro $v0
				addi $t4, $t4, 1     # Se deja marcado $t4 con 1 para indicar que hay 1 negativo transformado
				j Division
			
			# Caso: El dividendo es negativo pasa a positivo
			TransformarDividendoAPositivo:
				nor $t1, $a0, $0    # Invierte los bits, bit a bit compara el or negado entre un bit de $a1 y 0, guarda el resultado en $t1 
				addi $a0, $t1, 1    # Suma 1, para dejar el numero en complemento A2 dentro del registro $v0
				addi $t4, $t4, 1     # Se deja marcado $t4 con 1 para indicar que hay 1 negativo transformado
				bltz $a1, TransformarDivisorAPositivoConDividendoNegativo
				j Division

			TransformarDivisorAPositivoConDividendoNegativo:
				nor $t1, $a1, $0    # Invierte los bits, bit a bit compara el or negado entre un bit de $a1 y 0, guarda el resultado en $t1 
				addi $a1, $t1, 1    # Suma 1, para dejar el numero en complemento A2 dentro del registro $v0
				addi $t4, $t4, 1     # Se deja marcado $t4 con 1 para indicar que hay 1 negativo transformado
				j Division		
			
			# Caso: Division entre numeros positivos
			Division:
				beq $a0, $0, FinDivision
				bgt $a1, $a0, MultiplicacionPrimerDecimal
				addi $v0, $v0, 1       # Se le agrega 1 a la parte entera por cada vez que se pueda restar: dividendo - divisor
				sub $a0, $a0, $a1      # Dividendo - Divisor
				j Division
			
			# Se multiplica por 10 el primer decimal y se continua la division
			MultiplicacionPrimerDecimal:
				#addi $a0, $a0, $a1   # Aumenta el dividendo en divisor unidades, porque si llega a este punto realiza una resta demas
				#addi $v0, $v0, -1    # Disminuye la parte entera del cociente, porque si llega a este punto realiza una suma demas
				move $s3, $a0
				move $s4, $a1
				move $s5, $v0        # En $s5 se mantiene el resultado de la parte entera
				addi $a1, $0, 10
				jal Multiplicar   # DividendoRestante * 10
				move $a0, $v0
				move $a1, $s4
				move $v0, $s5
				j DivisionPrimerDecimal
				
			DivisionPrimerDecimal:
				beq $a0, $0, FinDivision
				bgt $a1, $a0, MultiplicacionSegundoDecimal
				addi $v1, $v1, 1       # Se le agrega 1 al primer decimal por cada vez que se pueda restar: dividendo - divisor
				sub $a0, $a0, $a1      # Dividendo - Divisor
				j DivisionPrimerDecimal
				
			MultiplicacionSegundoDecimal:
				move $s3, $a0
				move $s4, $a1
				#move $s5, $v0
				#move $a0, $a1
				addi $a1, $0, 10
				jal Multiplicar   # DividendoRestante * 10
				move $a0, $v0
				move $a1, $s4
				move $v0, $s5
				j DivisionSegundoDecimal
				
			DivisionSegundoDecimal:
				beq $a0, $0, FinDivision
				bgt $a1, $a0, FinDivision
				addi $s0, $s0, 1       # Se le agrega 1 al segundo decimal por cada vez que se pueda restar: dividendo - divisor
				sub $a0, $a0, $a1      # Dividendo - Divisor
				j DivisionSegundoDecimal
			
			FinDivision:
				addi $t1, $0, 1
				#move $v0, $s5
				beq $t1, $t4, CambiarSignoANegativo
				# Recuperar $ra de la pila (stack)
    				lw $ra, 0($sp)     # Cargar $ra de la pila
    				addi $sp, $sp, 4   # Incrementar el puntero de pila
    				jr $ra             # Salta a la instruccion posterior al uso de jal Dividir
				
			CambiarSignoANegativo:
				nor $t1, $v0, $0    # Invierte los bits, bit a bit compara el or negado entre un bit de $v0 y 0, guarda el resultado en $t1 
				addi $v0, $t1, 1    # Suma 1, para dejar el numero en complemento A2 dentro del registro $v0
				#move $v0, $s5
				# Recuperar $ra de la pila (stack)
    				lw $ra, 0($sp)     # Cargar $ra de la pila
    				addi $sp, $sp, 4   # Incrementar el puntero de pila
    				jr $ra             # Salta a la instruccion posterior al uso de jal Dividir
				
			
		# Subrutina multiplicar --> $a0 = operando 1 -- $a1 = operando 2
		Multiplicar:
			move $v0, $0         # $v0 = 0 --> Se reinicia el registro contenedor del valor a retornar
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
			
		
			
			