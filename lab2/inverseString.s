.section .bss
tekstin: .skip 256
tekstLen: .skip 4
	.section .text
.global _start

_start:
	#Wpisanie stringu
	mov $0, %rax
	mov $0, %rdi
	mov $tekstin, %rsi
	mov $256, %rdx
	syscall
	
	#zamiana wielkosci znakow
	mov $tekstin, %rsi
loop:
	#movzb (%rsi), %rax	#message do rax
	mov (%rsi), %al
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
	mov %al, (%rsi)		#() powinno dzialac jak pointery, idk
skip:
	inc %rsi
	jmp loop
koniec:
	mov $1, %rax		
	mov $1, %rdi
	mov $tekstin, %rsi
	mov $256, %rdx
	syscall

 
	#exit
	mov $60, %rax
	xor %rdi, %rdi
	syscall
#zeby wypisac zawartosc buffora-> x/s &buffer (najlatwiej ustawic b na loop i c do kazdej iteracji
