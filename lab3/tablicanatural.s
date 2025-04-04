.section .bss
	array: .space 4 #(4 liczby po 1 bajcie)
.section .text
.global _start
_start:
	lea array(%rip), %rsi 	#adres tablicy do rsi
	movb $1, (%rsi)
	movb $2, 1(%rsi)		#1*rsi (przesuniecie adresu na nastepna pozycje)
	movb $3, 2(%rsi)		#2, kolejne skoki co 1 (bo 1 bajt per liczba)
	movb $4, 3(%rsi)
	
	#ladowanie do rejestru
	#i. tryb adresowania bezposredniego
	movzbl (%rsi), %eax 	#pamiec poczatku tablicy -> eax
	#ii. tryb adresowania indeksowego
	mov $1, %rcx		#indeks
	movzbl (%rsi, %rcx), %eax	#rsi+indeks
	#iii. tryb adresowania bazowo indeksowego
	mov $2, %rcx		#indeks
	movzbl (%rsi, %rcx,1),%eax	#?? teoretycznie wychodzi to samo
	#iv. tryb adresowania z przesunieciem (przesuniecie na poczatek tablicy)
	movzbl 0(%rsi), %eax
	#v. tryb adresowania z przesunieciem i skalowaniem (przesuniecie na poczatek tablicy)
	movzbl 0(%rsi,%rcx,1), %eax
	
	#exit
	mov $60, %rax
	xor %rsi, %rsi
	syscall
#movzbl- mov i uzupelnij liczbe zerami z lewej strony do 32 bitow 
