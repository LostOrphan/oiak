.section .data
newline : .ascii "\n"
.section .bss
argc : .skip 8
argv : .skip 8
buffer : .skip 1       

.section .text
.global _start
_start:
	# Najpierw argc na stosie
	# Następnie tablica argv zawierająca wskaźniki do argumentów
	# Koniec NULL
	mov %rsp, %rbx
	mov (%rbx), %rax
	mov %rax, argc(%rip)	# argc
	call writeNum
	lea 8(%rbx), %rcx	# argv (jeden bajt przesunięcia)
	mov %rcx, argv(%rip)	# aktualny adres argv

	mov argc(%rip), %rax	# argc
	test %rax, %rax         # if (argc == 0)
	jz end
	mov argv(%rip), %rbx	# argv->rbx
printArg:
	mov (%rbx), %rsi		# wczytaj pointer do argumentu
	test %rsi, %rsi			# if (argv[i] == NULL)
	jz moveEnvp

	mov %rsi, %rdi			# rdi = argv[i]
	xor %rcx, %rcx			# rcx = 0 (Długość argumentu)
findLen:
	cmpb $0, (%rdi, %rcx)	# jezeli koniec stringa (string null terminated)
	je writeArg
	inc %rcx
	jmp findLen
writeArg:
	mov $1 , %rax
	mov $1 , %rdi			
	mov %rsi, %rsi			#rsi pointer do argumentu
	mov %rcx, %rdx			# rcx = długość argumentu
	syscall

	#new line
	mov $1 , %rax
	mov $1 , %rdi
	lea newline(%rip), %rsi
	mov $1 , %rdx
	syscall
	
	add $8, %rbx			# przesunięcie o bajt, nowy argument
	jmp printArg			# jeżeli więcej argumentów->printArg
writeNum:
	push %rax				#zapis stanu RAX
	add $'0', %al		
	mov $1 , %rdi
	lea buffer(%rip), %rsi
	mov %al, (%rsi)         # zapisanie liczby do bufora
	mov $1 , %rax
	mov $1 , %rdx
	syscall
	
	#new line
	mov $1 , %rax
	mov $1 , %rdi
	lea newline(%rip), %rsi
	mov $1 , %rdx
	syscall
	pop %rax				#przywrócenie stanu RAX
	ret
moveEnvp:
	add $8, %rbx
printEnvp:
	mov (%rbx), %rsi		# wczytaj pointer do argumentu
	test %rsi, %rsi			# if (argv[i] == NULL)
	jz end

	mov %rsi, %rdi			# rdi = argv[i]
	xor %rcx, %rcx			# rcx = 0 (Długość argumentu)
findEnvLen:
	cmpb $0, (%rdi, %rcx)	# jezeli koniec stringa (string null terminated)
	je writeEnv
	inc %rcx
	jmp findEnvLen
writeEnv:
	mov $1 , %rax
	mov $1 , %rdi			
	mov %rsi, %rsi			#rsi pointer do argumentu
	mov %rcx, %rdx			# rcx = długość argumentu
	syscall

	#new line
	mov $1 , %rax
	mov $1 , %rdi
	lea newline(%rip), %rsi
	mov $1 , %rdx
	syscall
	
	add $8, %rbx			# przesunięcie o bajt, nowy argument
	jmp printEnvp			# jeżeli więcej argumentów->printEnvp
end:
	mov $60, %rax			
	xor %rdi, %rdi			
	syscall
