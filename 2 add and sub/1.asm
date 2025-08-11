.MODEL SMALL
.STACK 100H

.DATA
    prompt1   DB 'Enter first number (up to 3 digits): $'           ; Prompt for first number input
    prompt2   DB 13,10,'Enter second number (up to 3 digits): $'    ; Prompt for second number (newline before)
    sum_msg   DB 13,10,'Result of Addition: $'                      ; Message to display addition result
    diff_msg  DB 13,10,'Result of Difference: $'                    ; Message to display subtraction result

    num1      DW 0                                                  ; Storage for first input number
    num2      DW 0                                                  ; Storage for second input number
    result    DW 0                                                  ; Storage for arithmetic result

    inBuffer1 DB 4,0,4 DUP('$')                                    ; Input buffer for first number (DOS buffered input)
    inBuffer2 DB 4,0,4 DUP('$')                                    ; Input buffer for second number

.CODE
MAIN PROC
                MOV  AX, @DATA             ; Initialize data segment
                MOV  DS, AX

    ; ===== Input first number =====
                LEA  DX, prompt1           ; Load address of first input prompt
                MOV  AH, 09H               ; DOS function 09h - print string
                INT  21H                   ; Call DOS interrupt

                LEA  DX, inBuffer1         ; Load address of first input buffer
                MOV  AH, 0AH               ; DOS function 0Ah - buffered input
                INT  21H                   ; Read input from user

                CALL StrToNum              ; Convert input string in buffer to number in AX
                MOV  num1, AX              ; Store converted number in num1

    ; ===== Input second number =====
                LEA  DX, prompt2           ; Load address of second input prompt
                MOV  AH, 09H               ; DOS print string function
                INT  21H                   ; Print second prompt

                LEA  DX, inBuffer2         ; Load address of second input buffer
                MOV  AH, 0AH               ; DOS buffered input function
                INT  21H                   ; Read second input

                CALL StrToNum              ; Convert second input to number
                MOV  num2, AX              ; Store in num2

    ; ===== Addition =====
                MOV  AX, num1              ; Move first number into AX
                ADD  AX, num2              ; Add second number to AX
                MOV  result, AX            ; Store sum in result

                LEA  DX, sum_msg           ; Load addition message
                MOV  AH, 09H               ; DOS print string function
                INT  21H                   ; Display addition message

                CALL PrintNum              ; Call procedure to print number stored in 'result'

    ; ===== Subtraction (absolute value) =====
                MOV  AX, num1              ; Load first number into AX
                SUB  AX, num2              ; Subtract second number
                TEST AX, AX                ; Test if result is negative
                JNS  StoreDiffResult       ; If positive or zero, jump to store result

                NEG  AX                    ; Otherwise, negate AX to get absolute value

    StoreDiffResult:
                MOV  result, AX            ; Store absolute value of difference

                LEA  DX, diff_msg          ; Load subtraction message
                MOV  AH, 09H               ; DOS print string function
                INT  21H                   ; Display subtraction message

                CALL PrintNum              ; Print absolute difference

    ; ===== Exit Program =====
                MOV  AH, 4CH               ; DOS terminate program function
                INT  21H                   ; Exit program

MAIN ENDP

; ===============================
; Procedure: StrToNum
; Converts string digits in input buffer to numeric value in AX
; Assumes DX points to input buffer
; Buffer format:
;   [0] max chars, [1] actual chars entered, [2..] ASCII digits
; ===============================
StrToNum PROC
                PUSH BX                    ; Save registers used
                PUSH CX
                PUSH DX
                PUSH SI

                MOV  SI, DX                ; SI points to input buffer
                ADD  SI, 2                 ; Skip max chars and length bytes
                XOR  AX, AX                ; Clear AX for result
                MOV  CX, 10                ; Base 10 multiplier

    NextDigit:  
                MOV  BL, [SI]              ; Load current ASCII character
                CMP  BL, 0DH               ; Check for Enter key (carriage return)
                JE   ConvDone              ; If Enter, done converting

                SUB  BL, '0'               ; Convert ASCII digit to number
                MUL  CX                    ; Multiply current result by 10
                ADD  AL, BL                ; Add digit to result
                INC  SI                   ; Move to next digit
                JMP  NextDigit

    ConvDone:   
                POP  SI                    ; Restore registers
                POP  DX
                POP  CX
                POP  BX
                RET
StrToNum ENDP

; ===============================
; Procedure: PrintNum
; Prints the number stored in 'result' as a 3-digit zero-padded number
; ===============================
PrintNum PROC
                PUSH AX                    ; Save registers
                PUSH BX
                PUSH CX
                PUSH DX

                MOV  AX, result            ; Load number to print
                XOR  CX, CX                ; Digit counter
                MOV  BX, 10                ; Divisor for decimal digits

    ConvertLoop:
                XOR  DX, DX                ; Clear DX before division
                DIV  BX                    ; Divide AX by 10
                ADD  DL, '0'               ; Convert remainder to ASCII digit
                PUSH DX                   ; Push digit for printing later
                INC  CX                    ; Increment digit count
                TEST AX, AX                ; Check if quotient is zero
                JNZ  ConvertLoop           ; Loop if not zero

    ; Pad with zeros if less than 3 digits
                CMP  CX, 3
                JGE  PrintLoop             ; If 3 or more digits, skip padding

    PadLoop:    
                PUSH '0'                   ; Push ASCII '0'
                INC  CX                    ; Increment digit count
                CMP  CX, 3
                JL   PadLoop              ; Repeat until 3 digits

    PrintLoop:  
                POP  DX                    ; Pop digit to DL
                MOV  AH, 02H               ; DOS print char function
                INT  21H                   ; Print digit
                LOOP PrintLoop             ; Repeat for all digits

                POP  DX                    ; Restore registers
                POP  CX
                POP  BX
                POP  AX
                RET
PrintNum ENDP

END MAIN
