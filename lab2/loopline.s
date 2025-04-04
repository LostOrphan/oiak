.section .data
star: .ascii "*"
ilosc: .byte 10		#ilosc gwiazdek

.section .bss
iloscGwiazdek: .skip 10
buffer: .skip 100	#buffer na 100 znakow
a: .byte 0
.section .text
.global _start

_start:
	mov $0, %rax
	mov $0, %rsi
	mov $iloscGwiazdek, %rsi
	mov $10, %rdx
	syscall
	lea iloscGwiazdek(%rip), %rsi
loopConvert:
	mov (%rsi), %al
	movzbl %al, %ebx
	cmp $10, %ebx
	je convertStore
	cmp $'0', %ebx
	jl convertStore
	
	cmp $'9', %ebx
	jg convertStore
	sub $'0', %ebx
	imul $10, %r9
	add %ebx, %r9d
	
	inc %rsi
	jmp loopConvert
convertStore:
	mov %r9, iloscGwiazdek
	mov $buffer, %rdi
	mov star, %rsi
petla:
	cmpb $0, iloscGwiazdek
	jz writeOut
	mov %rsi, (%rdi)
	inc %rdi
	decb iloscGwiazdek
	jmp petla
writeOut:
	mov $1, %rax
	mov $1, %rdi
	mov $buffer, %rsi
	mov $100, %rdx
	syscall	
end:
	mov $1, %rax
	mov $1, %rdi
	mov $'\n', %rsi
	mov $1, %rdx

	mov $60, %rax
	mov %rdi, %rdi
	syscall
