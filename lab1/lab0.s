.align 32
.text
message: .ascii "Hello World!\n"
message_len= . - message

.global _start

_start:
	mov $1, %rax
	mov $1, %rdi	
	mov $message, %rsi
	mov $message_len, %rdx
	syscall

	mov $60, %rax
	mov $0, %rdi
	syscall
