	.section .data
message: .asciz "Hello World\n"
message_len= . - message
.lcomm buffer, 20
	.section .text
.global _start

_start:
	#wypisanie podstawowego Hello World
	mov $1, %rax
	mov $1, %rdi
	mov $message, %rsi
	mov $message_len, %rdx
	syscall
	
	#zamiana wielkosci znakow
	mov $message, %rsi
	mov $buffer, %rdi
loop:
	movzb (%rsi), %rax	#message do rax
	test %al, %al		#Warunek zakonczenia petli. bitwise AND operacja, szukamy zakonczenia stringu (zero)
	jz koniec
	cmp $' ', %al		#
	je zapisz		#Hardcoded spacja i newline
	cmp $'\n', %al		#
	je zapisz		#
	cmp $'A', %al
	jl skip
	cmp $'Z', %al
	jg check_low
	add $32, %al
	jmp zapisz
check_low:
	cmp $'a', %al
	jl skip
	cmp $'z', %al
	jg skip
	sub $32, %al
zapisz:
	mov %al, (%rdi)		#() powinno dzialac jak pointery, idk
skip:
	inc %rsi
	inc %rdi
	jmp loop
koniec:
	mov $1, %rax		
	mov $1, %rdi
	mov $buffer, %rsi
	mov $message_len, %rdx
	syscall

 
	#exit
	mov $60, %rax
	xor %rdi, %rdi
	syscall
#zeby wypisac zawartosc buffora-> x/s &buffer (najlatwiej ustawic b na loop i c do kazdej iteracji
