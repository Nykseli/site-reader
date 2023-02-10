;;;
; Macros for system calls
;;

; Exit with an error code (exit 0 succesfull)
%macro exit 1
    mov rax, SYS_EXIT
    mov rdi, %1
    syscall
%endmacro

; write to fd
; args: fd, str, strlen
%macro write 3
    mov rax, SYS_WRITE
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

; open a file file, args: name, option, permissions
; note that the file name must be null terminated
%macro open 3
    mov rax, SYS_OPEN
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

; read a opened file. args: fd, buffer, buff lenth
%macro read 3
    mov rax, SYS_READ
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

; close a opened file
%macro close 1
    mov rax, SYS_CLOSE
    mov rdi, %1
    syscall;
%endmacro

; Print null terminated string
%macro print 1
    mov rax, %1 ; rax char pointer
    mov rsi, rax ; save the pointer to rsi. rsi holds the char* buffer argument in syscall
    mov rbx, 0 ; rbx str len
; calculate the length of the string
%%len_loop:
    mov cl, [rax] ; get one char at the time. moving to rcx would move 8 characters
    cmp cl, 0
    je %%print_loop_end
    inc rax
    inc rbx
    jmp %%len_loop
; finally print the text
%%print_loop_end:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    ; rsi holds the char pointer since it was saved there at start of print
    mov rdx, rbx
    syscall
%endmacro
