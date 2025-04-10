#Wydrukowac parametry linii polecen i srodowisko wykonania programu
.section .data
newline: .ascii "\n"
number: .byte 0
.section .text
.global _start
_start:
	#rsp=argc
	#rsp+8 (co bajt)=argv
	#rsp po NULL=envp
	#rsp= stack pointer
	mov (%rsp), %r9		#r9-argc
	call printNum
	lea 8(%rsp), %rsi
	mov $0, %rcx
	mov $0, %r10
argv:
#	cmp %rcx, %r9
#	jge end
	mov (%rsi), %rdi
	test %rdi, %rdi
	#jz findEnvp
 	jz end
#	mov (%rsi,%r10,8),%rdi
	call print
	add $8, %rsi
#	inc %r10	
#inc %rcx
	jmp argv
print:
			#zapisanie rdi na stack
	push %rdi
	mov %rdi, %rsi
	xor %rcx, %rcx		#wyzerowanie rcx
findLen:
	cmp $0, (%rdi, %rcx)	#rsi+rcx
	je write
	inc %rcx
	jmp findLen
write:
	mov $1, %rax
	mov $1, %rdi
	mov %rsi, %rsi
	mov %rcx, %rdx
	syscall
writeNL:
	mov $1, %rax
	mov $1, %rdi
	lea newline(%rip), %rsi
	mov $1, %rdx
	syscall
	pop %rdi
	ret
printNum:
	push %rdi
	add $'0', %r9
	mov %r9b, number(%rip)
	mov $1, %rax
	mov $1, %rdi
	lea number(%rip), %rsi
	mov $1, %rdx
	syscall
	jmp writeNL
		
end:
	mov $60, %rax
	mov $0, %rdi
	syscall	
