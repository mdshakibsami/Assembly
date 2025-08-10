.model small
.stack 100h
.code
main proc
    ; Read a character
            mov ah, 1h
            int 21h
    
            cmp al, 'y'
            je  DISPLAY
            cmp al, 'Y'
            je  DISPLAY
            jmp EXIT
    
    DISPLAY:
    ; Print the character
            mov ah, 2h
            mov dl, al
            int 21h
    
    EXIT:   
            mov ah, 4Ch
            int 21h
main endp
end main
