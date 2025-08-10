.model small
.stack 100h
.code
main proc


        ; Read a single character from keyboard (with echo)
                mov ah, 1h
                int 21h            ; AL = input character
    
        ; Compare input character with 'y'
                cmp al, 'y'
                je  DISPLAY        ; If equal, jump to DISPLAY
    
        ; Compare input character with 'Y'
                cmp al, 'Y'
                je  DISPLAY        ; If equal, jump to DISPLAY
    
        ; If character is not 'y' or 'Y', exit program
                jmp EXIT
    
        DISPLAY:
        ; Print the character stored in AL
                mov ah, 2h
                mov dl, al         ; DL = character to print
                int 21h            ; DOS function to print char
    
        EXIT:   
        ; Terminate the program and return control to DOS
                mov ah, 4Ch
                int 21h
main endp
end main
