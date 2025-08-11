.model small
.stack 100h
.data
    prompt1 db 'Enter first number: $'                 ; Prompt message for first number input
    prompt2 db 0ah, 0dh, 'Enter second number: $'      ; Prompt message for second number input (with newline)
    mul_msg db 0ah, 0dh, 'Multiplication result: $'    ; Message prefix for multiplication result (with newline)
    div_msg db 0ah, 0dh, 'Division result: $'          ; Message prefix for division result (with newline)
    newline db 0ah, 0dh, '$'                           ; Newline for formatting output

    buffer  db 255, ?, 255 dup('$')                    ; DOS buffered input structure: max size 255, current length ?, buffer for input (up to 255 chars)
    output  db 10 dup('$')                             ; Output buffer to hold converted number string (max 10 digits + '$' terminator)

    num1    dw ?                                       ; Variable to store first number (16-bit)
    num2    dw ?                                       ; Variable to store second number (16-bit)
    result  dw ?                                       ; Variable to store calculation result (16-bit)

.code
    main:       
                mov  ax, @data
                mov  ds, ax                   ; Initialize DS segment to data segment

    ; ----- First number input -----
                lea  dx, prompt1              ; Load address of first prompt string
                mov  ah, 09h                  ; DOS function: print string
                int  21h

                call take_input               ; Read user input into buffer
                call str_to_int               ; Convert input string in buffer to integer in AX
                mov  num1, ax                 ; Store converted value to num1

    ; ----- Second number input -----
                lea  dx, prompt2              ; Load address of second prompt string
                mov  ah, 09h                  ; DOS function: print string
                int  21h

                call take_input               ; Read second number input
                call str_to_int               ; Convert input string to integer in AX
                mov  num2, ax                 ; Store to num2

    ; ----- Multiplication -----
                mov  ax, num1                 ; Load first number into AX
                mov  bx, num2                 ; Load second number into BX
                mul  bx                       ; Unsigned multiplication: DX:AX = AX * BX
                mov  result, ax               ; Store low 16 bits of product in result

                lea  dx, mul_msg              ; Load multiplication result message
                mov  ah, 09h                  ; DOS print string function
                int  21h

                mov  ax, result               ; Load multiplication result
                call int_to_str               ; Convert integer to string
                lea  dx, output               ; Load address of output buffer
                mov  ah, 09h                  ; DOS print string
                int  21h

    ; ----- Division -----
                mov  ax, num1                 ; Load first number into AX (dividend)
                mov  bx, num2                 ; Load second number into BX (divisor)
                xor  dx, dx                   ; Clear DX (high 16 bits for division)
                div  bx                       ; Unsigned division: AX = quotient, DX = remainder
                mov  result, ax               ; Store quotient in result

                lea  dx, div_msg              ; Load division result message
                mov  ah, 09h                  ; DOS print string
                int  21h

                mov  ax, result               ; Load division result (quotient)
                call int_to_str               ; Convert integer to string
                lea  dx, output               ; Load address of output buffer
                mov  ah, 09h                  ; DOS print string
                int  21h

    ; ----- Exit program -----
                mov  ax, 4c00h                ; DOS terminate program function
                int  21h

    ; ===============================
    ; Procedure: take_input
    ; Uses DOS buffered input (INT 21h, AH=0Ah) to read a string from keyboard
    ; Stores input in 'buffer', supports backspace and echoing input
    ; ===============================
    take_input: 
                lea  dx, buffer               ; Load buffer address for input
                mov  ah, 0ah                  ; DOS buffered input function
                int  21h                      ; DOS interrupt to read input
                lea  dx, newline              ; Print newline for formatting after input
                mov  ah, 09h
                int  21h
                ret

    ; ===============================
    ; Procedure: str_to_int
    ; Converts ASCII string in 'buffer' to a 16-bit integer in AX
    ; Assumes buffer format: [max_size][actual_size][chars...]
    ; Stops at carriage return (0Dh)
    ; ===============================
    str_to_int: 
                mov  si, offset buffer + 2    ; Point SI to first character of input
                xor  ax, ax                   ; Clear AX to accumulate number
                mov  cx, 10                   ; Multiplier for decimal base

    next_digit: 
                mov  bl, [si]                 ; Load next ASCII character
                cmp  bl, 0dh                  ; Check if carriage return (Enter)
                je   done_conv                ; If yes, conversion done
                mul  cx                       ; Multiply AX by 10 (shift decimal place)
                sub  bl, '0'                  ; Convert ASCII digit to numeric value
                add  ax, bx                   ; Add digit to AX
                inc  si                       ; Move to next character
                jmp  next_digit

    done_conv:  
                ret

    ; ===============================
    ; Procedure: int_to_str
    ; Converts integer in AX to ASCII string stored in 'output' buffer
    ; Pads with '0' if input is zero
    ; Stores '$' as string terminator
    ; ===============================
    int_to_str: 
                lea  si, output               ; SI points to output buffer
                mov  bx, 10                   ; Divisor for decimal conversion
                xor  cx, cx                   ; Digit count
                xor  dx, dx                   ; Clear DX before division

                cmp  ax, 0
                jne  div_loop                 ; If AX != 0, continue conversion

    ; If number is 0, directly output '0'
                mov  [si], '0'
                mov  byte ptr [si+1], '$'
                ret

    div_loop:   
                div  bx                       ; Divide AX by 10, quotient in AX, remainder in DX
                add  dl, '0'                  ; Convert remainder to ASCII
                push dx                       ; Push digit on stack for reversing order
                inc  cx                       ; Increment digit count
                xor  dx, dx                   ; Clear DX for next division
                cmp  ax, 0
                jne  div_loop                 ; Continue until quotient is zero

    reverse_out:
                pop  dx                       ; Pop digits from stack in correct order
                mov  [si], dl                 ; Store ASCII digit in output buffer
                inc  si                       ; Move to next character position
                loop reverse_out              ; Repeat for all digits

                mov  byte ptr [si], '$'       ; Null-terminate string with '$'
                ret

end main
