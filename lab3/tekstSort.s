.section .bss
	tekst: .skip 256
	length: .byte 0 
.section .text
.global _start
_start:
	#wczytanie tekstu
	mov $0, %rax
	mov $0, %rdi
	mov $tekst, %rsi
	mov $256, %rdx
	syscall
	#rax- dlugosc tekstu - \nl -> length
	dec %rax
	mov %rax, length(%rip)
	
	#sortowanie bubble sortem
bubbleSort:
	mov $0, %rdi		# i=0
outerLoop:
	cmp length(%rip), %rdi #       
	jge endSort		#if i>=length end
	mov $0, %rsi		#j=0
innerLoop:
	cmp length(%rip), %rsi	
	jge nextOuter		#if j>=length, nastepna petla wewn
	
	#tekst[j] i tekst[j+1]
	lea tekst(%rip), %rdx
	mov (%rdx, %rsi,1), %al
	mov 1(%rdx, %rsi,1), %bl
	
	cmp $'\n', %bl
	je skipSwap
	#if tekst[j]>tekst[j+1] swap
	cmp %al, %bl
	jg skipSwap
	movb %bl, (%rdx, %rsi, 1)
	movb %al, 1(%rdx, %rsi, 1)
skipSwap:
	inc %rsi
	jmp innerLoop
nextOuter:
	inc %rdi
	jmp outerLoop
endSort:
	#wypisanie
	mov $1, %rax
	mov $1, %rdi
	lea tekst(%rip), %rsi
	movzx length(%rip), %rdx
	inc %rdx
	syscall

	mov $60, %rax
	mov $0, %rdi
	syscall
