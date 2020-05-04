public printSymbol, printSpace, inputSymbol, printNextLine, printStringOnEs

extern getSize: far
extern getElem: far
extern setElem: far

ASSUME CS:CodeS

CodeS SEGMENT PARA 'baseIO'

; result in al
inputSymbol proc far
    push bx
    push ax
    mov ah, 1
    int 21h
    mov bl, al
    pop ax
    mov al, bl
    pop bx
    ret
inputSymbol endp

; input - dl
printSymbol proc far
    push ax
    mov ah, 2
    int 21h
    pop ax
    ret
printSymbol endp

; void
printSpace proc far
    push dx
    mov dl, 20h
    call printSymbol
    pop dx
    ret
printSpace endp

; void. Print '10' '13'
printNextLine proc far
    push dx
    mov dl, 10
    call printSymbol
    mov dl, 13
    call printSymbol
    pop dx
    ret
printNextLine endp

; input - es,dx
printStringOnEs proc far
    push ax
    push ds
    push es
    pop ds   ; ds = ex
    mov ah, 09h
    int 21h
    pop ds
    pop ax
    ret
printStringOnEs endp

CodeS ENDS
END