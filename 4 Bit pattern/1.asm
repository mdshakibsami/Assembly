.model small
.stack 100h
.data
input_byte db 10101011B
reverse_byte db ?
.code
main proc
    mov ax, @data
    mov ds, ax               ; Initialize DS register to point to the data segment

    mov al, input_byte       ; Load the input byte into AL for processing
    mov bl, 0                ; Clear BL to store the reversed bits
    mov cx, 8                ; Set loop counter to 8 bits (one byte)

REVERSE_LOOP:
    shl al, 1                ; Shift AL left by 1 bit, MSB goes into Carry flag
    rcr bl, 1                ; Rotate Carry flag into LSB of BL (building reversed byte)
    loop REVERSE_LOOP        ; Repeat 8 times to reverse all bits

    mov reverse_byte, bl     ; Store the reversed byte into variable

    mov ah, 4Ch              ; DOS terminate program function
    int 21h                  ; Interrupt to exit program
main endp
end main