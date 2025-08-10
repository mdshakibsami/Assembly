.model small
.stack 100h

.data     
str db 'Enter a string: $'           ; Prompt message
buffer db 20, ? , 20 dup('$')        ; Input buffer: max 20 chars, actual entered chars, storage area
msg db 13,10,'Reversed: $'           ; Message with CR+LF before "Reversed:"
newline db 0ah, 0dh                  ; Newline chars (LF+CR), not used explicitly

.code
main:
    mov ax, @data
    mov ds, ax                      ; Initialize DS to data segment

    ; Print prompt
    mov ah, 09h
    lea dx, str
    int 21h

    ; Read buffered input from keyboard
    lea dx, buffer
    mov ah, 0Ah
    int 21h

    ; Print "Reversed:" message
    lea dx, msg
    mov ah, 09h
    int 21h

    ; Setup registers for reversing string:
    lea si, buffer + 2              ; SI points to first char entered
    mov cl, [buffer + 1]            ; CL = count of characters entered
    mov ch, 0                       ; Clear CH to make CX full count
    add si, cx                     ; SI points to byte after last character
    dec si                         ; Move SI to last character

print_loop:
    mov dl, [si]                   ; Load character to DL
    mov ah, 02h                    ; DOS function: print character in DL
    int 21h

    dec si                        ; Move SI backward to previous char
    loop print_loop               ; Loop CX times

    ; Exit program
    mov ah, 4Ch
    int 21h

end main
