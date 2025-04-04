.section .data
	newLine: .ascii "\n"
.section .bss
	buffer: .skip 256
	output: .skip 256

.section .text
.global _start
_start:
	#wczytanie ciagu
	mov $0, %rax
	mov $0, %rdi
	mov $buffer, %rsi
	mov $256, %rdx
	syscall
	#przypisanie do operacji na pozniej
	mov $buffer, %rsi
	mov $output, %rdi
	#przejscie przez kazdy znak, pomijajac te ktorych nie chcemy
	#zakladam usuwanie duzych liter i spacji
loopFilter:
	mov (%rsi), %al
	cmp $10, %al	#newline check
	je printResult
	
	cmp $'A', %al	#uppercase check
	jge checkUpper
	
	cmpb $' ', %al	#space check
	je skipChar
	jmp storeChar

checkUpper:
	cmp $'Z', %al
	jle skipChar
	jmp storeChar

storeChar:
	mov %al, (%rdi)
	inc %rdi

skipChar:
	inc %rsi
	jmp loopFilter	
printResult:
	mov $1, %rax
	mov $1, %rdi
	mov $output, %rsi
	mov $256, %rdx
	syscall

	mov $1, %rax
	mov $1, %rdi
	mov $newLine, %rsi
	mov $1, %rdx
	syscall
	
	mov $60, %rax
	xor %rdi, %rdi
	syscall	

