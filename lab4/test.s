.section .data
label_arg:   .asciz "Arg: "
label_env:   .asciz "Env: "
newline:     .asciz "\n"

.section .text
.global _start

_start:
    mov %rsp, %rdi              # stack pointer
    mov (%rdi), %rdi            # argc
    lea 8(%rdi), %rsi           # &argv[0]

    mov %rdi, %rbx              # kopiuj argc
    xor %rcx, %rcx              # indeks

print_args:
    cmp %rcx, %rbx
    jge find_env

    mov $1, %rax
    mov $1, %rdi
    lea label_arg(%rip), %rsi
    mov $5, %rdx
    syscall

    mov %rcx, %r8
    lea 8(%rsp,%r8,8), %r9     # adres argv[i]
    mov (%r9), %rsi            # załaduj wskaźnik do stringa
    call print_str

    mov $1, %rax
    mov $1, %rdi
    lea newline(%rip), %rsi
    mov $1, %rdx
    syscall

    inc %rcx
    jmp print_args


find_env:
    # oblicz adres envp: &argv[argc + 1]
    lea 8(%rsp,%rbx,8), %r12    # &argv[argc]
    add $8, %r12                # skip NULL → envp[0]

print_env_loop:
    mov (%r12), %rsi
    test %rsi, %rsi
    je exit

    mov $1, %rax
    mov $1, %rdi
    lea label_env(%rip), %r8
    mov %r8, %rsi
    mov $5, %rdx
    syscall

    mov (%r12), %rsi
    call print_str

    mov $1, %rax
    mov $1, %rdi
    lea newline(%rip), %rsi
    mov $1, %rdx
    syscall

    add $8, %r12
    jmp print_env_loop

print_str:
    # wejście: %rsi = ptr do null-terminated string
    push %rdi
    push %rdx
    mov %rsi, %rcx
    xor %rdx, %rdx
count_loop:
    cmpb $0, (%rcx,%rdx)
    je write_it
    inc %rdx
    jmp count_loop
write_it:
    mov $1, %rax
    mov $1, %rdi
    mov %rcx, %rsi
    syscall
    pop %rdx
    pop %rdi
    ret

exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall
