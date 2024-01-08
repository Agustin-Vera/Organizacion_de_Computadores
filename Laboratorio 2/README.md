# **Laboratorio 2: Acercándose al Hardware: Programación en Lenguaje Ensamblador**

Software utilizado: [**MARS - Mips Assembly and Runtime Simulator**](https://courses.missouristate.edu/kenvollmar/mars/download.htm "Mips Assembly and Runtime Simulator")

## **Objetivos de Aprendizaje**
* Usar MARS (un simulador para MIPS) para escribir, ensamblar y depurar programas MIPS.
* Escribir programas MIPS incluyendo instrucciones aritméticas, de salto y memoria.
* Comprender el uso de subrutinas en MIPS, incluyendo el manejo del stack.
* Realizar llamadas de sistema en MIPS mediante “syscall”.
* Implementar algoritmos en MIPS para resolver problemas matemáticos.


## **Parte 1: Uso de Syscall**
Escribe un programa que lea dos enteros ingresados por el usuario, determine si su diferencia es par o impar y luego imprima este resultado. Para ello, utiliza llamadas de sistema, “syscall”, para:
* Imprimir en la consola de MARS los mensajes de interacción con el usuario.
* Permitir que el usuario ingrese los números en tiempo de ejecución.
* Imprimir el resultado en la consola.
* Terminar el programa (exit). 

(Nota que en la ayuda de MARS puedes encontrar la documentación sobre el uso de syscall). El cálculo del máximo debe ser realizado en una subrutina, utilizando los registros apropiados para argumentos y salida de un procedimiento. La consola de entrada/salida de MARS debe lucir así (los números son ejemplos):

```mips
Por favor ingrese el primer entero: 31
Por favor ingrese el segundo entero: 10
La diferencia es: 21 (Impar)
-- program is finished running—
```

Hint: Para calcular la diferencia no siempre será “primer entero – segundo entero” (considerar números negativos), es por esto que se pide realizar el cálculo del máximo en una subrutina.

---

## **Parte 2: Subrutinas para Factorial y División**
* **A)** Utilizando tu programa de multiplicación del laboratorio anterior, escribe un programa que calcule el factorial de un número entero.
* **B)** Escribe un programa en MIPS que calcule la división de dos enteros mediante la implementación de subrutinas. No se pueden utilizar instrucciones de multiplicación, división y desplazamiento: **mul, mul.d, mul.s, mulo, mulou, mult, multu, mulu, div, divu, rem, sll, sllv, sra, srav, srl, srlv**; sino que se debe implementar una técnica de división basada en otras operaciones matemáticas y el uso de subrutinas. Para el caso de divisiones no exactas (i.e., resto no nulo), el programa debe ser capaz de calcular hasta 2 decimales del cociente, sin atender a errores de precisión más allá del segundo decimal.

---

## **Parte 3: Aproximación de Funciones Matemáticas**
                                NO REALIZADA

---

![MARS](https://courses.missouristate.edu/kenvollmar/mars/Mars%20140.jpg "MARS Logo")