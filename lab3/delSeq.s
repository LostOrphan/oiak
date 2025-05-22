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
	#Wczytaj string
	mov $0, %rax
	mov $0, %rdi
	mov $textin, %rsi
	mov $256, %rdx
	syscall

	#Wczytaj długoość stringa do textlen
	mov %rax, textlen(%rip)
	
    #Wczytaj substring
	mov $0, %rax
	mov $0, %rdi
	mov $pattern, %rsi
	mov $256, %rdx
	syscall
	
    #Usuń newline z końca patternu
	dec %rax
    mov %rax, %rcx
    mov $pattern, %rbx
    add %rcx, %rbx          # rbx z rcx offsetem
    cmpb $10, (%rbx)        # if \n
    jne no_newline_pattern
    movb $0, (%rbx)         # zmiana na 0
no_newline_pattern:
    #zapis długości do patternlen
	mov %rax, patternlen(%rip)
	
    #Pierwsza litera patternu do patternfirst
	mov pattern(%rip), %al
	mov %al, patternfirst(%rip)

	#Pointery [rsi=textin, rdx=pattern, rdi=textout]
	mov $textin, %rsi
	mov $pattern, %rdx
	mov $textout, %rdi

	#Iteracja przez string
	loopLetter:
	#cmp pierwsza litera substringa z pierwsza litera stringa
	mov (%rsi), %al
	cmp patternfirst(%rip), %al
	je checkPattern
	returnFunctionFalse:
    #Zapis znaku do textout
	mov %al, (%rdi)
	inc %rdi
	inc %rsi
	returnFunctionTrue:
    #jezeli newline wypisz string
	cmp $10, %al
	je stringPrint

    #przesun pointery
	jmp loopLetter

    #Porownanie tekstu z patternem
	checkPattern:
    #Zapisanie stanu rejestrów
	push %rsi
	push %rdx
	push %rax
	mov $0, %rax
    #Rcx iterator (dlugosc patternu)
	movzbq patternlen(%rip), %rcx
	loopPattern:
	#Porównaj text z patternem
	mov (%rsi), %al
	mov (%rdx), %bl
	cmp %bl, %al
	jne loopEndFalse
	#Jeśli są równe, przesuń wskaźnik substringa
	inc %rdx
	inc %rsi
	dec %rcx
	#Jeśli koniec substringa, skocz do loopEnd
	cmp $0, %rcx
	je loopEndTrue
	jmp loopPattern

    #Jesli nie sa rowne, przywroc pointery i wroc
	loopEndFalse:
	pop %rax
	pop %rdx
	pop %rsi
	jmp returnFunctionFalse
	
    #Jesli sa rowne, przywroc pointer patternu, wyrzuc reszte wartosci ze stosu i wroc 
    loopEndTrue:
	pop %r9
	pop %rdx
	pop %r10
	jmp returnFunctionTrue

    #Wypisanie stringu
	stringPrint:
	mov $1, %rax
	mov $1, %rdi
	mov $textout, %rsi
	mov $256, %rdx
	syscall
	
    end:
	mov $60, %rax
	mov $0, %rdi
	syscall	
