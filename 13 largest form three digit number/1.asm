.model small
.stack 100h
.data
    prompt     db 'Enter a 2 or 3 digit number: $'
    largeDigit db 0
    error      db "please type digits$"
    newline    db 0Dh,0Ah,'$'
.code
main proc
                 mov ax, @data
                 mov ds, ax

    ; Print prompt
                 mov ah, 09h
                 lea dx, prompt
                 int 21h
    
    ; Read first digit
                 mov ah, 01h
                 int 21h
    
    ; Validate first digit is between '0' and '9'
                 cmp al, '0'
                 jb  invalid
                 cmp al, '9'
                 ja  invalid

                 sub al, '0'           ; Convert ASCII to numeric digit
                 mov largeDigit, al    ; Store as numeric digit
                 mov cx, 1             ; Initialize digit count to 1

    read_loop:   
                 cmp cx, 3             ; Maximum 3 digits allowed
                 je  done_reading
    
                 mov ah, 01h
                 int 21h               ; Read next character

                 cmp al, 0Dh           ; Enter key? End input
                 je  done_reading

                 cmp al, '0'           ; Validate digit
                 jb  invalid
                 cmp al, '9'
                 ja  invalid

                 sub al, '0'           ; Convert ASCII to numeric digit

                 mov bl, largeDigit
                 cmp al, bl
                 ja  update            ; Update largest digit if current is greater
    
                 inc cx                ; Increment digit count
                 jmp read_loop

    update:      
                 mov largeDigit, al    ; Update largest digit
                 inc cx
                 jmp read_loop

    done_reading:
    ; Print newline
                 mov ah, 09h
                 lea dx, newline
                 int 21h
    
    ; Convert numeric digit back to ASCII before printing
                 mov dl, largeDigit
                 add dl, '0'
                 mov ah, 02h
                 int 21h
    
    ; Exit program
                 mov ah, 4Ch
                 int 21h

    invalid:     
    ; Print newline
                 mov ah, 09h
                 lea dx, newline
                 int 21h
    
    ; Print error message
                 mov ah, 09h
                 lea dx, error
                 int 21h

    ; Exit program
                 mov ah, 4Ch
                 int 21h
   
main endp
end main
