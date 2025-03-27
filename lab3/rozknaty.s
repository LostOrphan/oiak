.text
.global _start
_start:
	mov $0, %rax
	mov $40, %rax
	mov $0, %rax
	
	add $10, %rax
	add $20, %rax
	
	sub $20, %rax
	sub $10, %rax

#	Inne przyklady rozkazow: cmp, jmp, call ,test

	mov $60, %rax
	xor %rdi, %rdi
	syscall
