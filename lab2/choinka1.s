.section .data

star: .ascii "*"
prompt: .ascii "Podaj wysokosc choinki: "
promptLen= . - prompt
space: .ascii " "
newLine: .ascii "\n"
colorGreen: .ascii "\033[32m"
colorBrown: .ascii "\033[33m"
colorReset: .ascii "\033[0m"
colorLen= . - colorGreen
colorResetLen= . - colorReset

.section .bss

height: .skip 4

.section .text

.global _start
_start:
	#Wypisanie prompta
	mov $1, %rax
	mov $1, %rdi
	mov $prompt, %rsi
	mov $promptLen, %rdx
	syscall
	#Wpisanie wartosci do programu
	mov $0, %rax
	mov $0, %rdi
	mov $height, %rsi
	mov $4, %rdx
	syscall
	# Ten sposob dziala tylko dla liczb jednocyfrowych
#	#Wartosc traktowana jako ASCII, konwersja do int'a
	#movzbl height, %eax
	#sub $'1', %eax
	#mov %eax, %r9d 		#r9d ebx przechowuje wysokosc drzewa-1 bo pieniek
	# Sposob dla liczb wielocyfrowych


	mov $0, %rax
#	mov height, %rsi
	lea height(%rip), %rsi
loopConvert:
	mov (%rsi), %al
	movzbl %al, %ebx	#mov 8 to 32 z zerami po lewej stronie
	cmp $10, %ebx 		#newline check
	je convertStore
	cmp $'0', %ebx
	jl convertStore
	
	cmp $'9', %ebx
	jg convertStore
	sub $'0', %ebx
	imul $10, %r12
	add %ebx, %r12d
	
	inc %rsi
	jmp loopConvert

convertStore:
	mov %r12, %r9 		#r9d przechowuje wysokosc drzewa
	sub $1, %r9d		#minus 1 bo pieniek
	#Choinka
	mov $1, %r10d		#r10d ecx iterator zaczynajac od 1
	
	mov $1, %rax
	mov $1, %rdi
	mov $colorGreen, %rsi
	mov $5, %rdx
	syscall
loopRows:
				#r8d edi przechowuje ilosc spacji
	cmp %r9d, %r10d
	jg finalSpace
	mov %r9d, %eax
	sub %r10d, %eax
	add $1, %eax
	mov %eax, %r8d

loopSpacesPrint:
	cmp $0, %r8d
	jle loopStars
	mov $1, %rax
	mov $1, %rdi
	mov $space, %rsi
	mov $1, %rdx
	syscall
	dec %r8d
	jmp loopSpacesPrint

loopStars:
				#r8d edi przechowuje ilosc gwiazdek
	mov %r10d, %r8d	
	shl $1, %r8d
	dec %r8d

loopStarsPrint:
	#cmp $0, %r8d
	jle printNewline
	mov $1, %rax
	mov $1, %rdi
	mov $star, %rsi
	mov $1, %rdx
	syscall
	dec %r8d
	jmp loopStarsPrint

printNewline:
	mov $1, %rax
	mov $1, %rdi
	mov $newLine, %rsi
	mov $1, %rdx
	syscall
	inc %r10d
	jmp loopRows

finalSpace:
	cmp $0, %r9d
	jle finalStar
	mov $1, %rax
	mov $1, %rdi
	mov $space, %rsi
	mov $1, %rdx
	syscall
	dec %r9d
	jmp finalSpace
	
finalStar:
	mov $1, %rax
	mov $1, %rdi
	mov $colorBrown, %rsi
	mov $5, %rdx
	syscall

	mov $1, %rax
	mov $1, %rdi
	mov $star, %rsi
	mov $1, %rdx
	syscall
	mov $1, %rax
	mov $1, %rdi
	mov $newLine, %rsi
	mov $1, %rdx
	syscall
	
	mov $1, %rax
	mov $1, %rdi
	mov $colorReset, %rsi
	mov $4, %rdx
	jmp exit
	#Zamkniecie programu
exit:
	mov $60, %rax
	xor %rdi, %rdi
	syscall
