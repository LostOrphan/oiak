.section .data
argSzyfr: .ascii "KLUCZ="
argSzyfrLen= .-argSzyfr

argIN: .ascii "in="
argINLen= .-argIN

argOUT: .ascii "out="
argOUTLen= .-argOUT

bufferSize= 100

.section .bss
argc: .skip 8           # ilość argumentów
szyfr: .skip 4          # szyfr do XORowania <0-255>
nazwaIN: .skip 32       # nazwa pliku wejsciowego
nazwaINlen: .skip 1
nazwaOUT: .skip 32      # nazwa pliku wyjsciowego
nazwaOUTlen: .skip 1

buffer: .skip 100

.section .text
.global _start
_start:
    #
    # Szyfr XOR 
    #
    # Zczytanie argc
    mov %rsp, %rbx
    mov (%rbx), %rax
    mov %rax, argc(%rip)	    # argc->argc
    lea 8(%rbx), %rcx	        # argv
    add $8, %rcx		        # przesunięcie bo nowy argument
    # Zczytanie argv i znalezienie wymaganych argumentow
checkArgs:
    mov (%rcx), %rsi            # Zaladowanie wskaznika do rsi
    test %rsi, %rsi             # Sprawdzenie czy NULL (koniec argv)
    jz coding                   # If NULL, przejscie do szyfrowania

    #Znajdż w argumencie KLUCZ=
    lea argSzyfr(%rip), %rdi	# rdi = klucz
    mov $argSzyfrLen, %rdx	    # rdx = dlugosc klucza
    call porownajArg            # Funkcja zbiera argumenty kolejno: %rdi=a, %rsi=b, %rdx=c | porownajArg(argSzyfr, argv[i], argSzyfrLen)
    test %rax, %rax             # rax=0 -> nie znaleziono klucza
    jnz foundKey

    #Znajdż w argumencie in=
    lea argIN(%rip), %rdi	    # rdi = in=
    mov $argINLen, %rdx	        # rdx = dlugosc in=
    call porownajArg            # Funkcja zbiera argumenty kolejno: %rdi=a, %rsi=b, %rdx=c | porownajArg(argIN, argv[i], argINLen)
    test %rax, %rax             # rax=0 -> nie znaleziono klucza
    jnz foundIn

    #Znajdż w argumencie out=
    lea argOUT(%rip), %rdi	    # rdi = out=
    mov $argOUTLen, %rdx	    # rdx = dlugosc out=
    call porownajArg            # Funkcja zbiera argumenty kolejno: %rdi=a, %rsi=b, %rdx=c | porownajArg(argOUT, argv[i], argOUTLen)
    test %rax, %rax             # rax=0 -> nie znaleziono klucza
    jnz foundOut

    #Next argument
    add $8, %rcx		        # przesunięcie o bajt, nowy argument
    jmp checkArgs		    

foundKey:
    lea argSzyfrLen(%rsi), %rsi     # Skip "Klucz=" i pointer do faktycznej wartosci"
    call stringToInt
    jmp nextArg

foundIn:
    lea argINLen(%rsi), %rsi     # Skip "in=" i pointer do faktycznej wartosci
    lea nazwaIN(%rip), %rdi      # Pointer do nazwaIN
    call copyString              # Wpisanie do nazwaIN
    jmp nextArg

foundOut:
    lea argOUTLen(%rsi), %rsi    # Skip "out=" i pointer do faktycznej wartosci
    lea nazwaOUT(%rip), %rdi     # Pointer do nazwaOUT
    call copyString              # Wpisanie do nazwaOUT
    jmp nextArg

# Funkcja do skopiowania stringu do zmiennej (z rsi do rdi)
copyString:
    push %rsi                    # Zapis stanu rejestrow
    push %rdi
copyLoop:
    movb (%rsi), %al             # Załaduj bajt ze stringu 
    movb %al, (%rdi)             # Przenieś bajt do zmiennej
    test %al, %al                # Check czy NULL (koniec stringu)
    jz copyDone                  # if NULL koniec
    inc %rsi                     # next bajt w źródle
    inc %rdi                     # next bajt w zmiennej
    jmp copyLoop                 
copyDone:
    pop %rdi                     # Przywrocenie stanow rejestrow
    pop %rsi
    ret

nextArg:
    add $8, %rcx            # przesunięcie o bajt, nowy argument
    jmp checkArgs

#funkcja porownujaca poczatek argumentu z okreslonym tekstem
#porownajArg(rdi, rsi, rdx)
#porownajArg(argNAZWA, argv[i], argNazwaLen)
porownajArg:
    #zapisanie stanow rejestrow
    push %rdi
    push %rsi
    push %rdx
compareLoop:
    test %rdx, %rdx         # if len==0
    jz match
    movb (%rsi), %al        # wczytanie bajtu z argv[i] (pojedynczy znak)
    movb (%rdi), %bl        # wczytanie bajtu z argNazwa (pojedynczy znak)
    cmpb %bl, %al           # porownanie bajtow
    jne notMatch            # jezeli nie sa rowne przerwij

    inc %rsi                # przejscie do kolejnego znaku argv[i]
    inc %rdi                # przejscie do kolejnego znaku argNazwa
    dec %rdx                # zmniejszenie dlugosci o 1 (rdx jako iterator)
    jmp compareLoop         # powrot do petli
match:
    mov $1, %rax            # jezeli sa rowne to zwroc 1
    jmp endCompare
notMatch:  
    xor %rax, %rax          # jezeli nie sa rowne to zwroc 0
endCompare:
                            #przywrócenie stanów rejestrów
    pop %rdx
    pop %rsi
    pop %rdi
    ret
# Input: %rsi = pointer to the string
# Output: %rax = integer value
# Funkcja zamieniajaca string na liczbe calkowita
# Input: %rsi = wskaznik do stringa
# Output: %rax = wartosc calkowita (zapisanie do zmiennej w funkcji)
stringToInt:
    push %rcx
    push %rsi                # Zapis rejestrow
    push %rax
    xor %rax, %rax           # Wyczysczenie %rax (wynik)
    xor %rcx, %rcx           # Wyczyszczenie %rcx
convertLoop:
    movb (%rsi), %cl         # Zaladowanie bajtu (znaku) ze stringu do cl
    test %cl, %cl            # Check IF NULL
    jz convertDone           # if null, koniec
    sub $'0', %cl            # zmiana z ascii na liczbe
    imul $10, %rax           # wynik x10
    add %rcx, %rax           # dodanie cyfry do wyniku
    inc %rsi                 # next znak
    jmp convertLoop          
convertDone:
    mov %rax, szyfr(%rip)    # wynik do zmiennej 
    pop %rax                 # przywrocenie rejestrow
    pop %rsi                
    pop %rcx                 
    ret                      
coding:
 # Otwarcie input file (read only)
    lea nazwaIN(%rip), %rdi
    mov $0, %rsi                 # O_RDONLY
    mov $2, %rax                 # syscall 2 -> open
    syscall
    test %rax, %rax
    js exit
    mov %rax, %r12               # file descriptor inputu (odnosnik do pliku)

    # Otwarcie output file (write + create + truncate)
    lea nazwaOUT(%rip), %rdi
    mov $0x241, %rsi             # O_WRONLY | O_CREAT | O_TRUNC
    mov $0666, %rdx              # permisje 0666 (rw-rw-rw-)
    mov $2, %rax                 # syscall 2 -> open
    syscall
    test %rax, %rax
    js closeFiles
    mov %rax, %r13               # file descriptor outputu (odnosnik do pliku)

readLoop:
    mov %r12, %rdi               # 
    lea buffer(%rip), %rsi
    mov $bufferSize, %rdx
    mov $0, %rax                 # syscall: read
    syscall
    test %rax, %rax              # Sprawdzenie czy EOF   
    jz closeFiles                

    mov %rax, %rcx               # Ilość bajtów przeczytanych
    mov %rax, %r8                # zapis liczby bajtów do późniejszego zapisu

    lea buffer(%rip), %rsi
processLoop:
    movb (%rsi), %al
    xor szyfr(%rip), %al
    movb %al, (%rsi)
    inc %rsi
    dec %rcx
    jnz processLoop

    # Zapis bufora do outputu
    mov %r13, %rdi               # file descriptor outputu
    lea buffer(%rip), %rsi
    mov %r8, %rdx                # Ilość bajtów przeczytanych (zapisanych)
    mov $1, %rax                 # syscall: write
    syscall
    js closeFiles                # if error (ujemna liczba ustawia sign flag) zamknij pliki

    jmp readLoop

closeFiles:
    mov %r12, %rdi
    mov $3, %rax                 # syscall: close
    syscall

    mov %r13, %rdi
    mov $3, %rax
    syscall

exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall
