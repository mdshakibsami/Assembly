.model small                
.stack 100h                
.data                      
msg db 'Fibonacci: $'      

.code                      
main:
    mov ax, @data          
    mov ds, ax             

    lea dx, msg            
    mov ah, 09h            
    int 21h                

    mov ax, 0              ; Initialize AX with 0 (first Fibonacci number)
    mov bx, 1              ; Initialize BX with 1 (second Fibonacci number)
    mov cx, 15             ; Set counter CX to 15 (print first 15 Fibonacci numbers)

print_fib:
    push ax                ; Save AX (current Fibonacci number) on stack for PrintNum
    call PrintNum          ; Call procedure to print number in AX
    mov dl, ' '            ; Load ASCII space character into DL for spacing output
    mov ah, 02h            ; DOS print character function
    int 21h                ; Print space character
    pop ax                 ; Restore AX from stack (current Fibonacci number)

    mov dx, ax             ; Move current Fibonacci number from AX to DX (temporarily store)
    add ax, bx             ; AX = AX + BX (next Fibonacci number)
    mov bx, dx             ; Move old AX (previous Fibonacci number) into BX

    loop print_fib         ; Decrement CX and loop if CX != 0

    mov ah, 4ch            ; DOS terminate program function
    int 21h                ; Call DOS interrupt to exit program

; Procedure to print the number in AX as decimal digits
PrintNum proc
    push ax                ; Save AX on stack (number to print)
    push bx                ; Save BX on stack (used as divisor)
    push cx                ; Save CX on stack (digit count)
    push dx                ; Save DX on stack (used for remainder)

    xor cx, cx             ; Clear CX (digit counter = 0)
    mov bx, 10             ; Load BX with 10 (decimal divisor)

print_loop:
    xor dx, dx             ; Clear DX before division (required for DIV)
    div bx                 ; Divide DX:AX by BX, quotient in AX, remainder in DX
    push dx                ; Push remainder (digit) onto stack
    inc cx                 ; Increment digit count
    test ax, ax            ; Check if quotient is zero (no more digits)
    jnz print_loop         ; If not zero, repeat to get next digit

print_digits:
    pop dx                 ; Pop digit from stack into DX
    add dl, '0'            ; Convert digit to ASCII character by adding '0'
    mov ah, 02h            ; DOS print character function
    int 21h                ; Print character in DL
    loop print_digits      ; Loop CX times to print all digits

    pop dx                 ; Restore saved DX
    pop cx                  
    pop bx                 
    pop ax                 
    ret                    ; Return from procedure
PrintNum endp
