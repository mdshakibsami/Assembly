.model small
.stack 100h
.data
    a       db 'Enter 1st number: $'     ; Prompt for 1st number
    b       db 'Enter 2nd number: $'     ; Prompt for 2nd number
    c       db 'Enter 3rd number: $'     ; Prompt for 3rd number
    d       db 'Enter 4th number: $'     ; Prompt for 4th number
    str     db 0ah,0dh,'Result is: $'    ; Newline + message before result
    output  db 10 dup('$')               ; Buffer to store string output (max 10 chars)
    buffer  db 255, ?, 255 dup('$')      ; Input buffer for DOS function 0Ah:
    ; 1st byte: max chars (255)
    ; 2nd byte: chars entered (?)
    ; rest: actual input chars initialized with '$'
    newline db 0ah, 0dh, '$'             ; New line for output formatting
    num1    dw ?                         ; Variables to store 4 numbers (words)
    num2    dw ?
    num3    dw ?
    num4    dw ?
    sum     dw ?                         ; Variable to store sum
.code
main proc
               mov  ax, @data
               mov  ds, ax                   ; Initialize DS to point to data segment
                    
    ; -------- First number input --------
               lea  dx, a                    ; Load address of prompt a into DX
               mov  ah, 09h                  ; DOS print string function
               int  21h                      ; Print prompt
               call take_input               ; Take user input (buffered)
               call str_int                  ; Convert input string to integer in AX
               mov  num1, ax                 ; Store converted integer in num1
    
    ; -------- Second number input --------
               lea  dx, b
               mov  ah, 09h
               int  21h
               call take_input
               call str_int
               mov  num2, ax
    
    ; -------- Third number input --------
               lea  dx, c
               mov  ah, 09h
               int  21h
               call take_input
               call str_int
               mov  num3, ax
    
    ; -------- Fourth number input --------
               lea  dx, d
               mov  ah, 09h
               int  21h
               call take_input
               call str_int
               mov  num4, ax
    
    ; -------- Sum the four numbers --------
               mov  ax, num1
               add  ax, num2
               add  ax, num3
               add  ax, num4
               mov  sum, ax                  ; Store sum
    
    ; -------- Convert sum (integer) to string --------
               mov  ax, sum
               call int_string               ; Converts AX into ASCII string in 'output'
    
    ; -------- Print result message --------
               lea  dx, str
               mov  ah, 09h
               int  21h                      ; Print "Result is: " with newline
    
    ; -------- Print the sum string --------
               lea  dx, output
               mov  ah, 09h
               int  21h                      ; Print converted sum string
    
    ; -------- Exit program --------
               mov  ax, 4c00h
               int  21h
main endp
    
    ; ===== Subroutines =====

    ; Reads user input into 'buffer' using DOS function 0Ah
    take_input:
               lea  dx, buffer
               mov  ah, 0ah                  ; DOS buffered input function
               int  21h
               lea  dx, newline
               mov  ah, 09h                  ; Print newline after input
               int  21h
               ret
    
    ; Converts the string input stored at buffer+2 into an integer in AX
    str_int:   
               mov  si, offset buffer + 2    ; Point SI to first character of input string
               xor  ax, ax                   ; Clear AX (accumulator)
               mov  cx, 10                   ; Decimal base multiplier
    
    next:      
               mov  bl, [si]                 ; Get next character
               cmp  bl, 0dh                  ; Check for Enter key (carriage return)
               je   done                     ; If Enter, stop conversion
               mul  cx                       ; AX = AX * 10 (shift decimal place)
               sub  bl, '0'                  ; Convert ASCII digit to number
               add  ax, bx                   ; Add digit to AX (AX += digit)
               inc  si                       ; Move to next character
               jmp  next
    done:      
               ret
    
    ; Converts integer in AX to ASCII string stored at 'output'
    int_string:
               lea  si, output               ; Point SI to output buffer
               mov  bx, 10                   ; Divisor for decimal conversion
               xor  cx, cx                   ; Clear digit count
               xor  dx, dx                   ; Clear DX for division
    
               cmp  ax, 0
               jnz  div_loop                 ; If AX != 0, do division
               mov  [si], '0'                ; If AX = 0, store ASCII '0'
               ret
    
    div_loop:  
               div  bx                       ; AX / 10, quotient in AX, remainder in DX
               add  dl, '0'                  ; Convert remainder to ASCII digit
               push dx                       ; Push digit on stack (reversed order)
               inc  cx                       ; Increase digit count
               xor  dx, dx                   ; Clear DX before next division
               cmp  ax, 0
               jnz  div_loop                 ; Repeat if quotient not zero
    
    reversing: 
               pop  dx                       ; Pop digit from stack
               mov  [si], dl                 ; Store digit into output buffer
               inc  si                       ; Move output pointer
               loop reversing                ; Repeat for all digits
    
               ret
end main
