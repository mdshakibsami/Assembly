    .model small
.stack 100h
.code
main proc
           

    READ:
         mov  ah, 1h     ; read a character with echo
         int  21h        ; character in AL
    
         cmp  al, ' '    ; compare with space character
         je   EXIT       ; if space, exit loop
    
         loop READ       ; decrement CX and loop if CX != 0
    
    EXIT:
         mov  ah, 4Ch    ; terminate program
         int  21h
main endp
end main
