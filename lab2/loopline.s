.section .data
star: .ascii "*"
ilosc: .byte 10		#ilosc gwiazdek

.section .bss
buffer: .skip 100	#buffer na 100 znakow
a: .byte 0
.section .text
.global _start

_start:
	mov $buffer, %rdi
	mov star, %rsi
petla:
	cmpb $0, ilosc
	jz writeOut
	mov %rsi, (%rdi)
	inc %rdi
	decb ilosc 
	jmp petla
writeOut:
	mov $1, %rax
	mov $1, %rdi
	mov $buffer, %rsi
	mov $ilosc, %rdx
	syscall	
end:
	mov $60, %rax
	mov %rdi, %rdi
	syscall
