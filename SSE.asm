extern printf 
extern scanf 

section .data 
p dd 0 
f db '%f', 0xa, 0 
fl db '%.6f', 0xa, 0

section .bss 
fim RESQ 1
N RESD 80 
M RESD 80
resultado RESQ 80

section .text
global main
main:
    mov ebp, esp; for correct debugging
    
    ; P = A[1]*B[1] + A[2]*B[2] + ... A[N]*B[N]

    mov ecx, 80
    mov esi, N

    pega_N: ; pega os valores de N 
    
    push ecx
    push esi
    push f
    call scanf
    add esp, 4
    pop esi
    pop ecx
    add esi, 4
    
    loop pega_N
    
    mov ecx, 80
    mov esi, M

    pega_M: ; pega valores de M 
    
    push ecx
    push esi
    push f
    call scanf
    add esp, 4
    pop esi
    pop ecx
    add esi, 4
    
    loop pega_M 
    
    mov ecx, 20 ; 128/4 (pois o vetor de resultado só pega 4 valores por vez) = 20 
    mov esi, 0
    
    repeat:
    
    movups xmm1, [N+esi] ; move os valores do vetor N para o registrador 
    movups xmm2, [M+esi] ; move os valores do vetor M para o registrador

    ; faz a multiplicação dos valores dos registradores 
    
    multiplicacao: 
    
    mulps xmm1, xmm2
    movups[resultado+esi], xmm1
    add esi, 16
    
    loop repeat

    finit
    fld DWORD[p]
    fadd st1, st0
    mov ecx, 80
    mov ebx, 0
    
    ; soma os valores de cada produto calculado
    
    soma: 
    
    fld DWORD[resultado+ebx*4] 
    faddp st1, st0

    inc ebx
    
    loop soma
    
    fst QWORD[fim] 
    
    ; mostra resultado final
    
    push DWORD[fim+4]
    push DWORD[fim]
    push fl 
    call printf
    add esp, 12 
    
    xor eax, eax
    ret
