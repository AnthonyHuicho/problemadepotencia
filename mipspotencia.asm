.data
tab: .asciiz "\t"
endl: .asciiz "\n"
error_mensaje: .asciiz "El error esta en los argumentos "
m_base: .asciiz "Ingrese la base:  "
m_exponente: .asciiz "Ingrese el exponente:  "
m_resultado: .asciiz "El resultado es :  "
.text
.globl start
start:
    jal pot
    li $v0, 10
    syscall
#a0 = base
#a1 = exponente
#v0 = resultado
pot:
    # Cargar el contador
    li $t4, 0
    
    # Cargar el m_base 
    li $v0, 4
    la $a0, m_base    
    syscall
    
    # Cargar la base
    li $v0, 5
    syscall
    move $a2, $v0
    bltz $a2,error_pri
    # Cargar el m_exponente
    li $v0, 4
    la $a0, m_exponente
    syscall
    
    # Cargar el exponente
    li $v0, 5
    syscall
    move $a1, $v0
    
    move $a0, $a2
    bltz $a1,error_pri
    beqz $a1,valor_0
    # Graba los valores en la pila
    sw $a0,-4($sp) # save the old frame pointer
    addi $a0,$sp,0 # save ($sp) into $fp
    addi $sp,$sp,-8 # create 3 spaces on stack top
    sw $a1,-8($a0) # save ($ra) in 2nd stack space
    
    # Verificar si el exponente es cero
    move $a0, $a2
    li $t5,1
    move $v0,$t5
    bleu $t4, $a1, multiplicacion
    
    #Devuelve los valores de la pila 
    lw $a1,-8($a0) # put 2nd stack elem in $ra
    addi $sp,$a0, 0 # restore $sp to orig. state
    lw $a0,-4($sp) # restore $fp to orig. state
    jr $a1 # return from procedure
    j end_pot

multiplicacion:
    mul $v0, $v0, $a0
    addi $t4, $t4, 1
    bne $t4, $a1, multiplicacion
    move $t7,$v0
    beq $t4, $a1, p_resultado
p_resultado:
    bltz $t7,error_pri

    move $t2, $t7
	# Cargar el mensaje de resultado
    li $v0, 4
    la $a0, m_resultado
    syscall
    
    # Imprimir el resultado
    li $v0, 1
    move $a0, $t2
    syscall

	
end_pot:
    jr $ra
    
error_pri:
	li $v0,4
	la $a0,error_mensaje
	syscall
	jr $ra
valor_0:
	beqz $a0,error_pri
