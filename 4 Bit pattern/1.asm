.model small
.stack 100h
.data
input_byte db 10011101B        ; Original byte to reverse (binary literal)
reverse_byte db ?              ; Variable to store the reversed byte
newline db 0Dh,0Ah,'$'         ; DOS string for newline (carriage return + line feed + string terminator)
.code
main proc
    mov ax, @data
    mov ds, ax               ; Initialize DS register to point to data segment

    mov al, input_byte       ; Load input byte into AL register for processing
    mov bl, 0                ; Clear BL, will hold reversed bits
    mov cx, 8                ; Set counter for 8 bits to reverse

reverse_loop:
    shl al, 1                ; Shift AL left by 1 bit, MSB goes into Carry flag
    rcr bl, 1                ; Rotate Carry flag into LSB of BL (building reversed byte)
    loop reverse_loop        ; Loop 8 times, once for each bit

    mov reverse_byte, bl     ; Store the reversed byte into variable

    ; Print newline before output for formatting
    lea dx, newline          ; Load address of newline string into DX
    mov ah, 09h              ; DOS function 09h - print string at DS:DX until '$'
    int 21h                  ; Call DOS interrupt to print newline

    mov al, reverse_byte     ; Load reversed byte into AL for printing
    call PrintByteBinary     ; Call procedure to print AL as binary bits

    ; Exit program
    mov ah, 4Ch              ; DOS function 4Ch - terminate process
    int 21h                  ; Call DOS interrupt to exit

main endp

;----------------------------------------
; Procedure: PrintByteBinary
; Prints 8 bits of AL as '0' or '1' characters.
; Copies AL into BL to preserve AL.
; Prints bits from most significant bit (left) to least significant bit (right).
;----------------------------------------
PrintByteBinary proc
    push ax                  ; Save AX on stack because we modify registers
    mov bl, al               ; Copy AL into BL for bitwise processing
    mov cx, 8                ; We have 8 bits to print

print_bit_loop:
    mov ah, 02h              ; DOS function 02h - print character in DL
    test bl, 10000000b       ; Test MSB of BL (bit 7)
    jz print_zero            ; If MSB = 0, print '0'
    mov dl, '1'              ; Else print '1'
    jmp print_char

print_zero:
    mov dl, '0'              ; Load ASCII '0' to DL

print_char:
    int 21h                  ; Print the character in DL
    shl bl, 1                ; Shift BL left by 1 bit to move next bit into MSB
    loop print_bit_loop      ; Repeat until all 8 bits are printed

    pop ax                   ; Restore AX from stack
    ret                      ; Return from procedure
PrintByteBinary endp

end main
