.model small
.stack 100h
.data      
; str1 dw 'Enter number(0-9): $'
str1 db "Enter number(0-9)$"
even_msg db 0ah, 0dh,'Result is: Even$'
odd_msg db 0ah, 0dh,'Result is: Odd$' 


num dw ?
.code
main:
    mov ax, @data
    mov ds, ax    
    
    mov ah, 09h
    lea dx, str1
    int 21h  
    
    mov ah, 01h
    int 21h   
    
    mov num, ax
    and num, 1
    jz even

    lea dx, odd_msg
    jmp print

even:
    lea dx, even_msg

print:
    mov ah, 09h
    int 21h

    mov ah, 4ch
    int 21h
end main