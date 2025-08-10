.model small
.stack 100h
.data
    minChar db 0                    ; to store minimum character found
    prompt  db 'Enter string: $'
    newline  db 0Dh, 0Ah, '$'        ; CR LF string terminated with '$'

.code
main proc
                   mov ax, @data
                   mov ds, ax

    ; Print prompt
                   mov ah, 09h
                   lea dx, prompt
                   int 21h

                   mov ah, 01h           ; Read first character
                   int 21h
                   mov minChar, al       ; Initialize minChar with first character

    read_loop:     
                   cmp al, 0Dh           ; Check for Enter (CR)
                   je  done_reading

    ; Compare current char with minChar
                   mov bl, minChar
                   cmp al, bl
                   jb  update_min        ; if current char < minChar, update minChar

                   jmp read_next_char

    update_min:    
                   mov minChar, al       ; Update minChar

    read_next_char:
                   mov ah, 01h
                   int 21h
                   jmp read_loop

    done_reading:  
    ; Print newline using data section string
                   mov ah, 09h
                   lea dx, newline
                   int 21h

    ; Display the minimum character found
                   mov ah, 02h
                   mov dl, minChar
                   int 21h

    ; Exit program
                   mov ah, 4Ch
                   int 21h
main endp
end main
