.section .bss
	array: .space 100 #100 bajtowa tablica 
.section .text
.global _start
_start:
	mov $array, %rsi
	mov $0, %rcx
	mov $1, %al
loopFill:
	cmp $100, %rcx
	jge exit

	mov %al, (%rsi, %rcx,1)	#mov na al bo 1 bajt
	inc %rcx
	jmp loopFill

exit:
	mov $60, %rax
	xor %rdi, %rdi
	syscall
#wyswietlenie w gdb 	x/100xb &array
	
