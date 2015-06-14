# Code developed by Fernando H R silva for 2015 USP-EACH's Digital Computer Organization course.
.data 
numero_interac:  .double 10
valor_x:         .double 1
pot_resultado:   .double 1
um:              .double 1
menosum:	 .double -1
zero:            .double 0
n:               .double 6
contador:        .double 0
acumulador:      .double 1

.text
main:
	ldc1 $f14, valor_x
	ldc1 $f16, numero_interac
	jal seno
	
	j fim

# argumentos:  x = $f14 , n = $f16 , sen(x) = $f30
seno:	
	move $s0, $ra                           #salva $ra 
	ldc1 $f8, um
	ldc1 $f18, zero 			# contador = n
	ldc1 $f30, zero				# resultado
	
loop_seno:
	
	######################################### Calcula : (-1)^n
	ldc1 $f0, menosum                       # base = -1 
	mov.d $f2, $f18                         # expoente = n
	jal potencia				# retorna resultado em $f6
	mov.d $f20, $f6				# salva resultado em $f20

	######################################### Calcula : ( 2 *  n + 1 )
	ldc1 $f22, um                       	# $f22 = 1 
	add.d $f22, $f22, $f18			# $f22 = $f22 + n
	add.d $f22, $f22, $f18			# $f22 = $f22 + n
	
	######################################### Calcula : fatorial( 2 *  n + 1 )
	mov.d $f0, $f22				# chama fat( 2 *  n + 1 )
	jal fatorial				#
	mov.d $f24, $f4
		
	######################################### Calcula : x^( 2 *  n + 1 )
	mov.d $f0, $f14				# 
	mov.d $f2, $f22				#
	jal potencia				#
	mov.d $f26, $f6
		
	######################################### Calcula : ((-1)^n ) / ( 2 * n + 1 )!
	div.d $f28, $f20, $f24 			#
	
	######################################### Calcula : (((-1)^n ) / ( 2 * n + 1 )!) * x^( 2 *  n + 1 )
	mul.d $f28, $f28, $f26 			#

	######################################### Calcula : somatorio de (((-1)^n ) / ( 2 * n + 1 )!) * x^( 2 *  n + 1 ), 0..n
	add.d $f30, $f30, $f28 			#
	
	add.d $f18, $f18, $f8                   # incrementa n

	c.eq.d $f18, $f16
	bc1t return_seno
	j loop_seno

return_seno:
	mov.d $f12, $f30
	li $v0, 3
	syscall 
	move $ra, $s0                           #restaura $ra
	jr $ra

# argumentos base = $f0, expoente = $f2, resultado em: $f6
potencia:
	move $s1, $ra                           #salva $ra
	ldc1 $f4, zero 				# contador1
	ldc1 $f6, pot_resultado 		# resultado
	ldc1 $f8, um
	
se_expoente_zero:
	c.eq.d $f2, $f4
	bc1t return_potencia_um
		
loop_potencia:
	add.d $f4, $f4, $f8
	mul.d $f6, $f6, $f0
	c.eq.d $f4, $f2
	bc1t return_potencia
	j loop_potencia

return_potencia:
	move $ra, $s1                           #restaura $ra
	jr $ra

return_potencia_um:
	ldc1 $f6, um
	move $ra, $s1                           #restaura $ra
	jr $ra

#argumentos N = $f0 , retorna resultado em $f4
fatorial:
	move $s2, $ra                           #salva $ra
	ldc1 $f2, contador
	ldc1 $f4, acumulador
	ldc1 $f8, um
	mov.d $f6, $f0
	mov.d $f2, $f0
	
	c.eq.d $f0, $f8
	bc1t return_fatorial_um
	
loop_fatorial:
	mul.d $f4, $f4, $f2
	sub.d $f2, $f2, $f8
	c.eq.d $f2, $f8
	bc1t return_fatorial
	j loop_fatorial

return_fatorial_um:
	mov.d $f4, $f0				# retorna 1
	move $ra, $s2                           #restaura $ra
	jr $ra
	
return_fatorial:
	move $ra, $s2                           #restaura $ra
	jr $ra

fim:
	li $v0, 10  # encerra programa
	syscall
