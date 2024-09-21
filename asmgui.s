; asmgui.s 
; Made and modified from tutorials as notes for myself
; From tutorial made by Philippe Gaultier

BITS 64 ; targeting 64-bit CPUs
CPU X64 ; <-

section .rodata
    ; unix domain socket path for creating the sockaddr_un socket address representation
    sun_path: db "/tmp/.X11-unix/X0", 0 
    text: db "hello"

section .data
    id: dd 0 ; window id
    id_base: dd 0 ; window id base
    id_mask: dd 0
    root_visual_id: dd 0 ;root window visual id

section .text

%define AF_UNIX 1 ;fd
%define SOCK_STREAM 1 ;socket type

%define SYS_READ 0 
%define SYS_WRITE 1 
%define SYS_POLL ; wait for event on a file descriptor
%define SYSCALL_SOCKET 41 ; socket creation
%define CONNECT 42 
%define EXIT 60
%define FCNTL 72 ; Manipulate file descriptor

; Connect to X11 server
X11server_connect:
    pop rbp
    mov rbp, rsp
    
    ;create a unix socket
    mov rax, SYSCALL_SOCKET
    mov rdi, AF_UNIX
    mov rsi, SOCK_STREAM
    mov rdx, 0
    syscall 

    cmp rax, 0
    jle terminate

    mov rdi,rax

    ; need 112 bytes for struct sockaddr_un, extending space on stack by subtracting
    ; the needed amount of bytes from stack
    sub rsp, 112

    ;creating sockaddr_un struct that is needed for connect syscall
    ; struct members in: sockaddr_un{AF_UNIX=1, Pathname=sun_path}

    mov WORD [rsp], AF_UNIX ; AF_UNIX = 1
    lea rsi, sun_path ; sun_path = "/tmp/.X11-unix/X0"
    mov r12, rdi    ; store the file descriptor in r12
    mov rdi, [rsp+2] 
    cld
    mov ecx, 19 ; lenght of sun_path 17 + 2(Null terminator)
    rep movsb

    ;connect to server
    mov rax, CONNECT 
    mov rdi, r12 ; file descriptor back to rdi
    mov rsi, [rsp] 
    %define SIZEOF_SOCKADDR_UN 2+108
    mov rdx, SIZEOF_SOCKADDR_UN
    syscall

    ; compare result from connection syscall
    ; not zero, kill program
    cmp rax, 0
    jne terminate

    mov rax, rdi

    ; function epilog adding the loaned 112 bytes back to the stack
    ; and pop the stack base pointer + return to caller routine
    add rsp, 112
    pop rbp
    ret

; Start to communicate to the X11server
X11send_handshake:
    ;same prolog- epilog structure in every function.
    pop rbp
    mov rbp, rsp

    ; reserve space for 
    sub rsp, 12

    ; using write syscall to sen handshake to x11server
    mov rax, SYS_WRITE
    mov rdi
    


    ; function epilog
    add rsp, 12
    pop rbp
    ret

; 
X11next_id:
    pop rbp
    mov rbp, rsp
    
    sub rsp, 8
    
    

    add rsp, 8
    pop rbp
    ret
X11open_font:

X11grapical_context:

X11create_window:

X11map_window:

X11read_reply:

;Set file descriptor to non blocking mode
set_fd_nonblock:

X11poll_messages:

X11draw_text:

terminate:
    mov rax, EXIT
    mov rdi, 1
    syscall

global _start:function
_start:
    call X11server_connect
    
    mov rax, r12
    call X11send_handshake


    mov rax, EXIT
    mov rdi, 0
    syscall

;    mov rdi, pathname
;    mov rax, 0x53
;    int 80h
;    mov rbx, pathname
;    mov rcx, 0777o
;    mov rax, 39
;    int 80h

