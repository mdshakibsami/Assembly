.model small
.stack 100h
.code
main proc

    ; Read first character into AL
           mov ah, 1h
           int 21h
           mov bl, al     ; store first char in BL
    
    ; Read second character into AL
           mov ah, 1h
           int 21h
           mov bh, al     ; store second char in BH
    
    ; Compare BL and BH
           cmp bl, bh
           jbe First      ; if BL <= BH, jump to First
           jmp Second     ; else jump to Second
    
    First: 
    ; Print BL first
           mov ah, 2h
           mov dl, bl
           int 21h
    
    ; Print BH second
           mov ah, 2h
           mov dl, bh
           int 21h
           jmp exit       ; jump to exit
    
    Second:
    ; Print BH first
           mov ah, 2h
           mov dl, bh
           int 21h
    
    ; Print BL second
           mov ah, 2h
           mov dl, bl
           int 21h
           jmp exit       ; jump to exit
    
    exit:  
           mov ah, 4Ch    ; terminate program
           int 21h

main endp
end main
