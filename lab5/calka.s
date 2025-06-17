.section .data
    string: .asciz "Wynik calki: %2.15f\n"
    const1: .double 1.0

    N: .double 1000000.0
    one: .double 1.0
    Nint: .long 1000000
    h: .double 0.0
    tmp_i: .long 0      # zmienna tymczasowa na i
.section .bss
    .align 8
    sum: .skip 8        # zmienna double na wynik sumy

    .align 8
    tmp_n: .skip 8      # zmienna tymczasowa na N
.section .text
    .global main
    .extern printf
#sqrt(1+x^2) w przedziale od 0 do 1
main:
    push %rbp
    mov %rsp, %rbp

    #deklaracja ilosci iteracji
    fldl N(%rip)            # ST(0) = (double)N  ST(1) = 1.0
    fld1                    # ST(0) = 1.0
    fdivp                   # ST(0) = 1.0 / N
    // fstpl h(%rip)           # h = ST(0)

    subq $16, %rsp           # rezerwacja miejsca na wynik
    leaq string(%rip), %rdi # adres formatującego
    movl $1, %eax           # 1 argument float
    call printf             # wywołanie printf
    addq $16, %rsp           # zwolnienie miejsca na stosie

    #inicjalizacja sumy
    fldz                    # ST(0) = 0.0
    fstpl sum(%rip)         # sum = 0.0

    mov $0, %ecx            # i = 0
loop:
    cmpl Nint(%rip), %ecx      # if (i >= N) then break
    jge done
    # x = i * h
    movl %ecx, tmp_i(%rip)  # zapisz i do pamięci
    fildl tmp_i(%rip)       # ST(0) = (double)i
    fldl h(%rip)            # ST(0) = h, ST(1) = i
    fmulp                   # ST(0) = i * h
    # f(x) = sqrt(1 + x^2)
    fld %st(0)              # ST(0) = x, ST(1) = x
    fmul %st(1), %st(0)     # ST(0) = x*x, ST(1) = x
    fld1                    # ST(0) = 1.0, ST(1) = x^2, ST(2) = x
    faddp                   # ST(0) = 1 + x^2, ST(1) = x
    fsqrt                   # ST(0) = sqrt(1 + x^2), ST(1) = x
    fstp %st(1)             # usuwamy niepotrzebne x z ST(1)
    # sum += f(x)
    fldl sum(%rip)          # ST(0) = sum
    faddp                   # ST(0) = f(x) + sum
    fstpl sum(%rip)         # sum = ST(0)
    incl %ecx               # i++
    jmp loop
done:
    fldl sum(%rip)          # ST(0) = sum
    fldl h(%rip)            # ST(0) = h, ST(1) = sum
    fmulp                   # ST(0) = wynik całki (sum * h)

    subq $16, %rsp           # rezerwacja miejsca na wynik
    fstpl (%rsp)            # zapisanie wyniku na stosie
    leaq string(%rip), %rdi # adres formatującego
    movl $1, %eax           # 1 argument float
    call printf             # wywołanie printf
    addq $16, %rsp           # zwolnienie miejsca na stosie

    movl $0, %eax
    pop %rbp
    ret
