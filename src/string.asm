;;;
; String related macros
;;


; compare n bytes between str1 and 2, rax == 1 if equal rax == 0 if not
; args: str1, str2, str1len, str2len
%macro strncmp 4
%%_strncmp:
    mov r9,  %3 ; r9 is length 1
    mov r10, %4 ; r10 is length 2
    mov rax, %1 ; rax contains the str1
    mov rbx, %2 ; rbx contains the str2
    ; if strings are different length, they cannot be the same length
    cmp r9, r10
    jne %%_strncmp_false
    mov r10, 0
%%_strncmp_loop:
    mov cl, [rax]
    ; mov r8b, [rcx]
    mov r12b, [rbx]
    cmp r12b, cl
    jne %%_strncmp_false
    inc rbx
    inc rax
    inc r10
    cmp r10, r9
    jne %%_strncmp_loop
%%_strncmp_true:
    mov rax, 1
    jmp %%_strncmp_end
%%_strncmp_false:
    mov rax, 0
%%_strncmp_end:
%endmacro

; calculate length of string, rax will hold the length of the string
; args: str1
%macro strlen 1
    mov rax, 0 ; rax
    mov, rbx, %1 ; ptr to string
%%_str_len_loop:
    mov cl, [rbx] ; get one char at the time. moving to rcx would move 8 characters
    cmp cl, 0
    je %%_str_len_loop_end
    inc rax
    inc rbx
    jmp %%_str_len_loop
%%_str_len_loop_end:
%endmacro
