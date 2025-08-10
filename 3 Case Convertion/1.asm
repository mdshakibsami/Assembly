.model small
.stack 100h
.data
    prompt  db "Enter a Character : $"
    newline db 0ah, 0dh, "result : $"

.code
main proc
              mov ax, @data
              mov ds, ax        ; Initialize DS register to point to the data segment

              mov ah, 09h       ; DOS function 09h: Print string at DS:DX until '$'
              lea dx, prompt    ; Load offset of prompt string into DX
              int 21h           ; Call DOS interrupt to print the prompt

              mov ah, 01h       ; DOS function 01h: Read a character from keyboard with echo
              int 21h           ; AL = ASCII code of the character read

              cmp al, 'A'       ; Compare input character with 'A'
              jl  NOT_UPPER     ; If less than 'A', jump to NOT_UPPER check
              cmp al, 'Z'       ; Compare input character with 'Z'
              jg  NOT_UPPER     ; If greater than 'Z', jump to NOT_UPPER check
              add al, 20h       ; Convert uppercase letter to lowercase (add 0x20)
              jmp DISPLAY       ; Jump to DISPLAY to output the converted character

    NOT_UPPER:
              cmp al, 'a'       ; Compare input character with 'a'
              jl  DISPLAY       ; If less than 'a', it's not a letter; jump to DISPLAY without change
              cmp al, 'z'       ; Compare input character with 'z'
              jg  DISPLAY       ; If greater than 'z', not a letter; jump to DISPLAY without change
              sub al, 20h       ; Convert lowercase letter to uppercase (subtract 0x20)

    DISPLAY:  

              mov ah, 02h       ; DOS function 02h: Display character in DL
              mov dl, al        ; Move the converted character into DL
              int 21h           ; Call DOS interrupt to print the character

              mov ah, 4Ch       ; DOS function 4Ch: Terminate process
              int 21h           ; Exit program

main endp
end main