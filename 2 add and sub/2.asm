.MODEL SMALL
.STACK 100H

.DATA
    prompt1   DB 'Enter first number (up to 3 digits): $'           ; Prompt for first number
    prompt2   DB 13,10,'Enter second number (up to 3 digits): $'    ; Prompt for second number (newline before)
    sum_msg   DB 13,10,'Result of Addition: $'                      ; Message for addition result
    diff_msg  DB 13,10,'Result of Difference: $'                    ; Message for subtraction result

    num1      DW 0                                                  ; Storage for first input number
    num2      DW 0                                                  ; Storage for second input number
    result    DW 0                                                  ; Storage for arithmetic result

    ; Input buffers for DOS buffered input function (max 3 digits)
    inBuffer1 DB 4,0,4 DUP('$')                                     ; buffer for first number input
    inBuffer2 DB 4,0,4 DUP('$')                                     ; buffer for second number input

.CODE
MAIN PROC
                MOV  AX, @DATA        ; Initialize data segment
                MOV  DS, AX

    ; =========== Input first number ===========
                LEA  DX, prompt1      ; Load address of first prompt string
                MOV  AH, 09H          ; DOS print string function
                INT  21H

                LEA  DX, inBuffer1    ; Load address of first input buffer
                MOV  AH, 0AH          ; DOS buffered input function
                INT  21H
                CALL StrToNum         ; Convert string input to number in AX
                MOV  num1, AX         ; Store converted number in num1

    ; =========== Input second number ===========
                LEA  DX, prompt2      ; Load address of second prompt string
                MOV  AH, 09H          ; DOS print string
                INT  21H

                LEA  DX, inBuffer2    ; Load address of second input buffer
                MOV  AH, 0AH          ; DOS buffered input function
                INT  21H
                CALL StrToNum         ; Convert string input to number in AX
                MOV  num2, AX         ; Store converted number in num2

    ; =========== Addition ===========
                MOV  AX, num1         ; Load first number into AX
                ADD  AX, num2         ; AX = num1 + num2
                MOV  result, AX       ; Store result

                LEA  DX, sum_msg      ; Load addition message
                MOV  AH, 09H          ; Print string
                INT  21H
                CALL PrintNum         ; Print the numeric result stored in 'result'

    ; =========== Subtraction ===========
                MOV  AX, num1         ; Load first number
                SUB  AX, num2         ; AX = num1 - num2
                MOV  result, AX       ; Store result (may be negative)

                TEST AX, AX           ; Check if AX is negative (sign flag)
                JNS  PrintDiff        ; If positive or zero, jump to print result

    ; If result negative:
                NEG  AX               ; Take two's complement to get positive value
                MOV  result, AX       ; Store absolute value back
                MOV  AH, 02H          ; DOS print char function
                MOV  DL, '-'          ; Load minus sign character
                INT  21H              ; Print minus sign

    PrintDiff:  
                LEA  DX, diff_msg     ; Load subtraction message
                MOV  AH, 09H          ; Print string
                INT  21H
                CALL PrintNum         ; Print numeric result (absolute value)

    ; =========== Exit Program ===========
                MOV  AH, 4CH          ; DOS terminate program function
                INT  21H
MAIN ENDP

    ; ===============================
    ; Convert string in buffer to number (in AX)
    ; DX points to buffer where:
    ; [0] = max length
    ; [1] = actual length entered
    ; [2..] = ASCII digits
    ; ===============================
StrToNum PROC
                PUSH BX
                PUSH CX
                PUSH DX
                PUSH SI

                MOV  SI, DX           ; SI = start of input buffer
                ADD  SI, 2            ; Skip max length and actual length bytes
                XOR  AX, AX           ; Clear AX to store result
                MOV  CX, 10           ; Base 10 for decimal number

    NextDigit:  
                MOV  BL, [SI]         ; Load ASCII digit
                CMP  BL, 0DH          ; Check for Enter (carriage return)
                JE   ConvDone         ; End of input string

                SUB  BL, '0'          ; Convert ASCII digit to numeric
                MUL  CX               ; Multiply AX by 10
                ADD  AL, BL           ; Add current digit
                INC  SI               ; Next character
                JMP  NextDigit

    ConvDone:   
                POP  SI
                POP  DX
                POP  CX
                POP  BX
                RET
StrToNum ENDP

    ; ===============================
    ; Print number stored in 'result' variable as 3-digit zero-padded number
    ; ===============================
PrintNum PROC
                PUSH AX
                PUSH BX
                PUSH CX
                PUSH DX

                MOV  AX, result       ; Load number to print
                XOR  CX, CX           ; Digit counter
                MOV  BX, 10           ; Divisor for decimal digits

    ConvertLoop:
                XOR  DX, DX           ; Clear DX before DIV
                DIV  BX               ; Divide AX by 10; quotient in AX, remainder in DX
                ADD  DL, '0'          ; Convert remainder to ASCII digit
                PUSH DX               ; Push digit for later printing
                INC  CX               ; Increment digit count
                TEST AX, AX           ; Check if quotient is zero
                JNZ  ConvertLoop      ; Continue if not zero

    ; Pad with leading zeros if digits less than 3
                CMP  CX, 3
                JGE  PrintLoop        ; If already 3 or more digits, skip padding

    PadLoop:    
                PUSH '0'              ; Push ASCII zero
                INC  CX               ; Increment digit count
                CMP  CX, 3
                JL   PadLoop          ; Loop until 3 digits

    PrintLoop:  
                POP  DX               ; Pop digit
                MOV  AH, 02H          ; DOS print character function
                INT  21H
                LOOP PrintLoop        ; Loop CX times

                POP  DX
                POP  CX
                POP  BX
                POP  AX
                RET
PrintNum ENDP

END MAIN
