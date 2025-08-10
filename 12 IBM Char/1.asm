.model small
.stack 100h
.code
main proc

               mov  cx, 256       ; total 256 characters (0 to 255)
               mov  bl, 0         ; character counter

    print_loop:
               mov  ah, 02h       ; DOS function: print char in DL
               mov  dl, bl        ; load character code
               int  21h

               inc  bl            ; next character

               loop print_loop

    ; Exit program
               mov  ah, 4Ch
               int  21h
main endp
end main
