# **Laboratorio 1: Instrucciones MIPS y Programación en Lenguaje Ensamblador**

Software utilizado: [MARS - Mips Assembly and Runtime Simulator](https://courses.missouristate.edu/kenvollmar/mars/download.htm "Mips Assembly and Runtime Simulator")

## **Objetivos de Aprendizaje**
* Traducir programas escritos en un lenguaje de alto nivel a MIPS.
*  Escribir programas MIPS que usan instrucciones aritméticas, de salto y memoria.
*  Usar MARS (un IDE para MIPS) para escribir, ensamblar y depurar programas MIPS.
* Implementar algoritmos en MIPS para resolver problemas matemáticos de baja 
complejidad.


## **Escribir Programas MIPS**
Traducir los siguientes códigos en instrucciones MIPS, los archivos quedan guardados con el nombre: **programN.asm"**.

### **Ejercicio 1**
```c
a = 0;
z = 1;
while (z <> 10) {
    a = a+z;
    z = z+1;
};
```


### **Ejercicio 2**
```c
int[] arr = {11, 22, 33, 44};
arrlen = arr.length; // traduccion de lo de arriba esta dada

// complete la traduccion de lo siguiente...
int evensum = 0; // usar $t0 para valores de evensum
for (int i = 0; i < arrlen; i++) {
    if (arr[i] & 1 == 0) { // ¿Qué significa esta condicion?
        evensum += arr[i];
    }
}
```
```mips
# Tu código MIPS debería comenzar con algo así:
.data
    arr: .word 10 22 15 40
    end:
.text
    la $s0, arr # esta instrucción pone la dirección base de arr en $s0
    la $s1, end
    subu $s1, $s1, $s0
    srl $s1, $s1, 2 # ahora $s1 = num elementos en arreglo. ¿Cómo?
```


### **Ejercicio 3**
Escribe un programa en MIPS que calcule la multiplicación de dos enteros mediante la implementación de subrutinas. **No** se pueden utilizar instrucciones de multiplicación, división y desplazamiento: **mul, mul.d, mul.s, mulo, mulou, mult, multu, mulu, div, divu, rem, sll, sllv, sra, srav, srl, srlv**; sino que se debe implementar una técnica de multiplicación basada en otras operaciones matemáticas y el uso de **subrutinas**. Para este programa, los operandos deben estar escritos "en duro" en el mismo código.


---
## **Estado Actividad**
* [X] [Ejercicio 1](https://github.com/Agustin-Vera/Organizacion_de_Computadores/blob/1921727b898aab06535b0f1ca3186dfa180db20c/Laboratorio%201/program1.asm "Solución propuesta ejercicio 1")
* [X] [Ejercicio 2](https://github.com/Agustin-Vera/Organizacion_de_Computadores/blob/1921727b898aab06535b0f1ca3186dfa180db20c/Laboratorio%201/program2.asm "Solución propuesta ejercicio 2")
* [X] [Ejercicio 3](https://github.com/Agustin-Vera/Organizacion_de_Computadores/blob/1921727b898aab06535b0f1ca3186dfa180db20c/Laboratorio%201/program3.asm "Solución propuesta ejercicio 3")


---

![MARS](https://courses.missouristate.edu/kenvollmar/mars/Mars%20140.jpg "MARS Logo")