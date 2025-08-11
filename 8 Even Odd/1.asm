.model small
.stack 100h
.data      
prompt      db 'Enter a number: $'         ; Prompt message to input a number
even_msg    db 0ah, 0dh, 'Result is: Even$' ; Message printed if number is even (with newline)
odd_msg     db 0ah, 0dh, 'Result is: Odd$'  ; Message printed if number is odd (with newline)
buffer      db 255, ?, 255 dup('$')          ; DOS buffered input format:
                                            ; 1st byte = max chars (255)
                                            ; 2nd byte = chars entered (set by DOS)
                                            ; next 255 bytes = actual input buffer
newline     db 0ah, 0dh, '$'                  ; Newline characters for formatting output
num         dw ?                              ; Variable to store converted integer number

.code
main:
    mov ax, @data
    mov ds, ax                ; Initialize DS with data segment address
    
    ; --- Display prompt ---
    lea dx, prompt            ; Load address of prompt string into DX
    mov ah, 09h               ; DOS function 09h to display string
    int 21h                  ; Print prompt message
    
    ; --- Take user input ---
    call take_input           ; Reads input from user into 'buffer'
    
    ; --- Convert ASCII input string to integer ---
    call str_to_int           ; Converts input string (in buffer) to integer in AX
    mov num, ax               ; Store converted number into variable 'num'
    
    ; --- Check if number is even or odd ---
    test ax, 1                ; Test least significant bit of AX
                              ; If bit 0 = 0 => even, else odd
    jz even_case              ; Jump if zero (even)
    
odd_case:
    lea dx, odd_msg           ; Load address of "Odd" message
    jmp print_result          ; Jump to print message
    
even_case:
    lea dx, even_msg          ; Load address of "Even" message
    
print_result:
    mov ah, 09h               ; DOS print string function
    int 21h                   ; Print appropriate message
    
    ; --- Exit program cleanly ---
    mov ax, 4c00h             ; DOS terminate program function
    int 21h
    
; ========== Subroutines ==========

; Reads input from keyboard into buffer using DOS buffered input
take_input:
    lea dx, buffer            ; Load address of input buffer
    mov ah, 0ah               ; DOS buffered input function
    int 21h                   ; Read input into buffer
    lea dx, newline           ; Load newline string address
    mov ah, 09h               ; DOS print string function
    int 21h                   ; Print newline after input
    ret
    
; Converts ASCII digits stored at buffer+2 into integer in AX
str_to_int:
    mov si, offset buffer + 2 ; SI points to first character of input string
    xor ax, ax                ; Clear AX (accumulator for result)
    mov cx, 10                ; Multiplier for decimal (base 10)
    
next_digit:
    mov bl, [si]              ; Load one character from input
    cmp bl, 0dh               ; Check if Enter key pressed (ASCII 13)
    je done_conv              ; If yes, finish conversion
    mul cx                    ; AX = AX * 10 (shift decimal place)
    sub bl, '0'               ; Convert ASCII digit to numeric value
    add ax, bx                ; Add digit to AX (accumulate number)
    inc si                    ; Move to next character
    jmp next_digit            ; Repeat for all digits
    
done_conv:
    ret                       ; Return with result in AX

end main
