.model small
.stack 100h
.data
    prompt1 db 'Enter character 1: $'            ; Prompt message for 1st char input
    prompt2 db 0Dh,0Ah,'Enter character 2: $'    ; Prompt message for 2nd char input (with newline)
    prompt3 db 0Dh,0Ah,'Enter character 3: $'    ; Prompt message for 3rd char input (with newline)
    newline db 0Dh,0Ah,'$'                       ; Newline string for output formatting
.code
main proc
               mov  ax, @data
               mov  ds, ax         ; Initialize DS register to point to data segment

    ; --- Read first character ---
               lea  dx, prompt1    ; Load offset of prompt1 string
               mov  ah, 09h        ; DOS print string function
               int  21h

               mov  ah, 01h        ; DOS read character from keyboard (with echo)
               int  21h            ; Character returned in AL
               push ax             ; Push AX (AL contains char) onto stack

    ; --- Read second character ---
               lea  dx, prompt2    ; Load offset of prompt2 string (with newline)
               mov  ah, 09h
               int  21h

               mov  ah, 01h
               int  21h
               push ax             ; Push second char on stack

    ; --- Read third character ---
               lea  dx, prompt3    ; Load offset of prompt3 string (with newline)
               mov  ah, 09h
               int  21h

               mov  ah, 01h
               int  21h
               push ax             ; Push third char on stack

    ; --- Print characters one by one, each on a new line ---
               mov  cx, 3          ; Set counter to 3 for three characters

    print_loop:
               mov  ah, 09h        ; DOS print string function
               lea  dx, newline    ; Load newline string offset
               int  21h            ; Print newline before each character

               pop  ax             ; Pop character from stack into AX
               mov  dl, al         ; Move character from AL to DL for printing
               mov  ah, 02h        ; DOS print character function
               int  21h            ; Print character in DL

               loop print_loop     ; Loop CX times

    ; --- Exit program ---
               mov  ah, 4Ch        ; DOS terminate program function
               int  21h

main endp
end main
