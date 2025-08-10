.model small
.stack 100h
.code
main proc

         mov  cx, 80     ; loop 80 times to print '*'

    Star:
         mov  ah, 02h    ; DOS print character function
         mov  dl, 42     ; ASCII code for '*'
         int  21h        ; print character
         loop Star       ; decrement CX, loop if not zero

    ; Exit program
         mov  ah, 4Ch
         int  21h

main endp
end main
