.model small
.stack 100h

.data
msgPrompt db 'Enter marks: $'
msgAplus  db 0ah, 0dh, 'Grade: A+$'
msgA      db 0ah, 0dh, 'Grade: A$'
msgB      db 0ah, 0dh, 'Grade: B$'
msgC      db 0ah, 0dh, 'Grade: C$'

; Buffer for input (INT 21h/AH=0Ah format)
inBuffer  db 4       ; max 3 chars (up to 255)
           db 0       ; number of chars actually entered
           db 4 dup('$') ; storage for entered chars

marks     db ?       ; will store numeric marks

.code
main:
    mov ax, @data
    mov ds, ax

    ; Show prompt
    lea dx, msgPrompt
    mov ah, 09h
    int 21h

    ; Take input (buffered input)
    lea dx, inBuffer
    mov ah, 0Ah
    int 21h

    ; Convert input string to number
    mov si, offset inBuffer + 2 ; point to first digit
    xor ax, ax                  ; AX = 0
    mov cx, 10                  ; base 10 multiplier

nextDigit:
    mov bl, [si]
    cmp bl, 0Dh                 ; Enter key pressed?
    je storeMarks
    sub bl, '0'                  ; convert ASCII to number
    mul cx                       ; AX = AX * 10
    add al, bl                   ; add current digit
    inc si
    jmp nextDigit

storeMarks:
    mov marks, al

    ; ===== Grading Logic =====
    mov al, marks
    cmp al, 80
    jae ap
    cmp al, 70
    jae a
    cmp al, 60
    jae b
    jmp c

ap:
    lea dx, msgAplus
    jmp print
a:
    lea dx, msgA
    jmp print
b:
    lea dx, msgB
    jmp print
c:
    lea dx, msgC

print:
    mov ah, 09h
    int 21h

    mov ah, 4Ch
    int 21h
end main
