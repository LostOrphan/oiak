.align 32
.data
message: .ascii "Hello World!\n"
message_len= . - message
.text
.global _start

_start:
	#wypisanie pierwotnego HW
	mov $1, %rax
	mov $1, %rdi	
	mov $message, %rsi
	mov $message_len, %rdx
	syscall
	#zamiana znaku
	#addb $63, message+5
	addb $13, message+5	#dodanie 63 zamieni spacje na _ ; dodanie 13 zamieni spacje na -

	#wypisanie nowego HW
	mov $1, %rax
	mov $1, %rdi
	mov $message, %rsi
	mov $message_len, %rdx
	syscall	
	#exit
	mov $60, %rax
	xor %rdi, %rdi
	syscall
