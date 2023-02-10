
%include "src/linux-x86_64.asm"
%include "src/syscall-macro.asm"

; --------------------- DATA START ----------------------
section .data
    ; GET method definition (len 16)
    get_start_str db "GET / HTTP/1.0", 13, 10
    ; The target host on our server (len 28)
    get_host_str db "Host: txt.miikaalikirri.fi", 13, 10
    ; Tell host to close connection after this header (len 21)
    get_connection_close_str db "Connection: close", 13, 10, 13, 10

    ; the last newline for the end of the message, len 2
    httpmsg_end db 13, 10 ; (\r\n)

    ; define null ternimated new line character for printing
    new_line db 10, 0

    ; int value 1 used to set the socket option to 1
    socketopt_1 dd 1

    ; struct sockaddr_in
    ; ipv4 struct constructed with helper socketaddr.c because dns is too much work
    socketaddr db 0x02, 0x00, 0x23, 0x82, 0x7f, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

    ;delay for sleep macro
    tv_delay dq 10, 500000000 ; x,y seconds

    ; debug message
    hello_user db "Hello user",10,0
; --------------------- DATA END ----------------------


; --------------------- BSS START ----------------------
section .bss
    ; 32 bits for the socket file descriptor
    socketfd resd 1

    ; syscall ret value
    ret_val resq 1

    ; pointer to the current address in client buff
    buf_ptr resq 1
    ; store 32kib buffer for reading data from the server
    client_buffer resb 32768
; --------------------- BSS END ------------------------

; --------------------- TEXT START ----------------------
section .text
    global _start
; --------------------- TEXT END ------------------------



_start:
    ; create a ipv4 tcp socket
    mov rax, SYS_SOCKET
    mov rdi, PF_INET
    mov rsi, SOCK_STREAM
    mov rdx, IPPROTO_TCP
    syscall

    ; check if the socket creation failed
    cmp rax, 0
    jl fail_program

    ; save the socketfd
    mov [socketfd], eax

    ; connect the socket to server ip
    mov rax, SYS_CONNECT
    mov rdi, [socketfd]
    mov rsi, socketaddr
    mov rdx, 16
    syscall

    ; make sure the connection was succesfull
    cmp rax, 0
    jl fail_program

    ; write http headers. (and assume they are successful)
    write [socketfd], get_start_str, 16
    write [socketfd], get_host_str, 28
    write [socketfd], get_connection_close_str, 21

    mov QWORD [buf_ptr], client_buffer

read_loop:
    ; read data from server
    read [socketfd], [buf_ptr], 1024
    ; Increment the reader buffer pointer
    add [buf_ptr], rax
    ; Save read rsult
    mov [ret_val], rax

    ; If read returns 0, it's done reading so we can continue
    ; If it's greater than 0, there still might be something to read
    ; If it's less than 0, there has been an error
    cmp DWORD [ret_val], 0
    jg read_loop
    cmp DWORD [ret_val], 0
    jl fail_program

    ; Close our socket
    close [socketfd]

    ; Print the result
    print client_buffer

    exit 0

; fail with the error code 1
fail_program:
    exit 1
