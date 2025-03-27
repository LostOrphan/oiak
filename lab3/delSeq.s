.section .bss
	textin: .skip 256
	pattern: .skip 256
	textout: .skip 256
.section .text
.global _start
_start:
	mov $0, %rax
	mov $0, %rdi
	mov $textin, %rsi
	mov $256, %rdx
	syscall
					#r8-dlugosc tekstu wejciowego
	mov %rax, %r8
	
	mov $0, %rax
	mov $0, %rdi
	mov $pattern, %rsi
	mov $256, %rdx
	syscall
					#r9- dlugosc patternu minus \n
	mov %rax, %r9
	dec %r9				#minus \n
	#iteracja przez tekst az nie znajdziemy 1 znaku patternu
	mov $0, %rdi
	movb pattern(%rdi), %r10b	#r10- pierwsza litera patternu

	mov , %rsi
	mov $textout, %rdi
	
loopMain:
	cmp %r8, %rcx			#check czy przeszlismy tekst
	je end
	
		
end:
	mov $60, %rax
	mov $0, %rdi
	syscall	
