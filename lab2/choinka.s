.section .data

star: .asciz "*"
prompt: .asciz "Podaj wysokosc choinki: "
promptLen= . - prompt
space: .asciz " "
newline: .asciz "\n"
colorGreen: .asciz "\e[38;5;34m"
colorBrown: .asciz "\e[38;5;52m"
colorReset: .asciz "\e[0m"
colorLen= . - colorGreen
colorResetLen= . - colorReset
.section .bss
height: .skip 4

.section .text
.global _start

_start:
	#Wypisanie Prompta
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
	#Wartosc traktowana jako ASCII, konwersja do int'a
	movzbl height, %eax	#movzbl nie przyjmuje rax'a bo chce 32 bitowy rejestr (czysci gorna czesc rax'a)
	sub $'0', %eax
#	mov %eax, height	#height posiada wartosc jako int
#	mov $height, %ebx
	mov %eax, %ebx
	mov $0, %ecx
	#Choinka
loop_rows:
	cmp %ecx, %ebx	#for loop az ecx>height
	jg exit
	#edi zawiera ilosc spacji w danej linii
	mov %ebx, %eax
	sub %ecx, %eax
	mov %eax, %edi
loop_spaces:
	cmp $0, %edi
	jle loop_stars
	mov $1, %rax
	mov $1, %rdi
	mov $space, %rsi
	mov $1, %rdx
	syscall
	dec %edi
	jmp loop_spaces
loop_stars:
	mov %ecx, %edi
	shl $1, %edi
	dec %edi
loop_stars_print:
	cmp $0, %edi
	jle print_newline 	#jump less
	mov $1, %rax
	mov $1, %rdi
	mov $star, %rsi
	mov $1, %rdx
	syscall
	dec %edi
	jmp loop_stars_print
print_newline:
	mov $1, %rax
	mov $1, %rdi
	mov $newline, %rsi
	mov $1, %rdi
	syscall
	inc %ecx
	jmp loop_rows
	
	#Zamkniecie programu
exit:
	mov $60, %rax
	xor %rdi, %rdi
	syscall
 

	
