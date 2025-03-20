.align 32
.global _start

_start:
	#flagi C O Z S P A D
	#flaga C (flaga przeniesienia)
	stc	#ustawienie na 1
	clc	#ustawienie na 0

	#flaga O (flaga przepelnienia)
	mov $0x7F, %al	#kolejnosc: rax->eax->ah/al
	add $1, %al	#overflow
	xor %al, %al	#wyzerowanie 
	
	#flaga Z (flaga zera)
	xor %eax, %eax	#wynik wynosi zero wiec zf wynosi 1
	mov $1, %eax	#eax!=0, zf=0

	#flaga S (flaga znaku)
	mov $-1, %eax	 #liczba ujemna wiec sf=1
	mov $1,  %eax	 #liczba dodatnia wiec sf=0
	
	#flaga P (flaga parzystosci)
	mov $0b00000000, %al
	test %al, %al
	mov $0b00000001, %al
	test %al, %al

	#flaga A (flaga wyrownania)
	mov $0x0F, %al
	add $1, %al	#dodanie jedynki wywola przeniesienia z 3 na 4 bit, AF=1
	mov $0x10, %al
	add $1, %al	#brak przeniesienia, AF=0

	#flaga D (flaga kierunku)
	std 		#FD=1
	cld		#FD=0	

	#mov $1, %eax
	#xor %ebx, %ebx
	#int $0x80	#to coredumpuje
	mov $60, %rax
	xor %rdi, %rdi	
	syscall		#to nie, why idk
