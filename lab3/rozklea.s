.section .text
.global _start
_start:
	#a) zaladowanie przykladowych wartosci do eax, ebx
	mov $5, %eax
	mov $2, %ebx
	#b) wyniki rozkazu lea, TRYB %eax gdzie tryb {1,1(%eax),1(%eax,%ebx),1(%eax,%ebx,2)}
	lea 1, %eax			#eax = 1
	lea 1(%eax), %eax		#eax = eax+1
	lea 1(%eax, %ebx), %eax		#eax = eax+ebx+1
	lea 1(%eax, %ebx,2), %eax	#eax = eax+(ebx*2)+1
	#c) LEA wykonuje sume
	#    dest=base+(index*scale)+offset
	#np  eax = eax+(ebx*2)+1   1(%eax,%ebx,2),%eax == offset(base,index*scale), dest
	#funkcja lea nie modyfikuje flag (w porownaniu do add sub czy mul)

	#koniec programu
	mov $60, %rax
	xor %rdi, %rdi
	syscall
