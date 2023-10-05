.data    #Aqui van todas las "variables" que pudieras necesitar 
	myMessage: .asciiz "Hola Mundo \n"
.text    #Aqui van todas las instrucciones que tu programa necesita
	li $v0, 4
	la $a0, myMessage
	syscall