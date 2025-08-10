.model small              
.stack 100h               

.data
QuestionMark db '?$'      

.code
main proc
       
       mov ax, @data     ; Load data segment address into AX
       mov ds, ax        ; Initialize DS register with data segment address
       
       mov ah, 09h       
       lea dx, QuestionMark     ; Load effective address of string into DX
       int 21h                  ; Call DOS interrupt to print the string
       
       mov ah, 4Ch       
       int 21h           

main endp
end main
