.section .bss
	textin: .skip 256
	pattern: .skip 256
	textout: .skip 256
	
	textpointer: .skip 1
	patternpointer: .skip 1
	
	textlen: .skip 1
	patternlen: .skip 1

	patternfirst: .skip 1
.section .text
.global _start
_start:
	mov $0, %rax
	mov $0, %rdi
	mov $textin, %rsi
	mov $256, %rdx
	syscall
	
	mov %rax, textlen(%rip)
	
	mov $0, %rax
	mov $0, %rdi
	mov $pattern, %rsi
	mov $256, %rdx
	syscall
	dec %rax
	
	mov %rax, patternlen(%rip)

	mov $0, textpointer(%rip)
	mov $0, patterpointer(%rip)
	
	mov pattern(%rip), %rsi
	lea (%rsi), patternfirst(%rip)
	mov $60, %rax
	mov $0, %rdi
	syscall	
