.section .data
    string: .asciz "Wynik calki: %2.15f\n"
    const1: .double 1.0

.section .text
.global main
.extern printf
main:
    push %rbp
    mov %rsp, %rbp

    movl $100000, %ebx
    cvtsi2sd %ebx, %xmm0  # xmm0 = (double)n
    movl $1, %eax
    cvtsi2sd %eax, %xmm1  # xmm1 = 1.0

    divsd %xmm0, %xmm1  # xmm1 => h=1.0 / n, stored in xmm1, uzywane tylko 64 bity 

    xorpd %xmm4, %xmm4 # xmm4 => sum=0.0

    xor %ecx, %ecx
loop:
    cmp %ebx, %ecx
    jge done

    # x = i * h
    mov %ecx, %eax 
    cvtsi2sd %eax, %xmm2  
    mulsd %xmm1, %xmm2 
    # f(x) = sqrt(1 + x^2)
    movapd %xmm2, %xmm3  # xmm3 = x
    mulsd %xmm2, %xmm3  # xmm3 = x^2
    addsd const1(%rip), %xmm3  # xmm3 = 1 + x^2
    sqrtsd %xmm3, %xmm3  # xmm3 = sqrt(1 + x^2)
    # sum += f(x)
    addsd %xmm3, %xmm4  # xmm4 = sum + f(x)

    inc %ecx 
    jmp loop
done:
    mulsd %xmm1, %xmm4  # xmm4 = sum * h

    # wypisanie wyniku
    movapd %xmm4, %xmm0        # wynik do xmm0 (pierwszy argument)
    leaq string(%rip), %rdi    # adres string 
    movl $1, %eax              # liczba argumentow
    call printf
    
    movl $0, %eax
    pop %rbp
    ret
