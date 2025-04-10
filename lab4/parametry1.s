.section .data
newline: .ascii "\n"
.section .bss
argc: .skip 8
argPos: .skip 8
.section .text
.global _start
_start:
	mov $0, %rax
	lea argPos(%rip), %rax
	pop (%rax)
	mov %rax, argc(%rip)

argv:
	inc (%rax)	
	pop %rax
	
end:
	mov $60, %rax
	mov $0, %rdi
	syscall
