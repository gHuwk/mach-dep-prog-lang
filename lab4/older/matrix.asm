public matrixInput
public matrixOut

extern inputSymbol: far
extern printSymbol: far
extern printSpace: far
extern printNextLine: far


MatrixS SEGMENT PARA 'MatrixOffsets'
    X label BYTE
    ORG 1
    Y label BYTE
    ORG 2
    body label BYTE
MatrixS ENDS

ASSUME DS:MatrixS, CS:CodeS

CodeS SEGMENT PARA 'Code'

; for all funcs
; ds - source matrix segment. bx - offset; indexation from 1

matrixInput proc far
    
    call inputSymbol  ; read x symbol
    sub al, 30h       ; transform to digit
    
    cmp al, 10     
    jae errorExit  ; если не цифра - выход с ошибкой
    cmp al, 0
    je errorExit   ; если ноль - выход с ошибкой
    mov ah, 0      ; иначе - сохранить

    push ax

    call printSpace

    call inputSymbol      ; read y symbol
    sub al, 30h           ; transform to digit

    cmp al, 10     
    jae errorExit  ; если не цифра - выход с ошибкой
    cmp al, 0
    je errorExit   ; если ноль - выход с ошибкой

    call printNextLine
    mov byte ptr [bx + offset Y], al ; иначе - записать
    pop ax
    mov byte ptr [bx + offset X], al

    push cx
    push dx
    mov dx, bx
    mov ch, byte ptr [bx + offset X]
    add bx, offset body

    mov ah, 1 ; set to optimixation input

    readCycle:
        cmp ch, 0
        jna readCycleEnd
        xchg bx, dx
        mov cl, byte ptr [bx + offset Y]
        xchg bx, dx

        readLineCycle:
            cmp cl, 0
            jna reaLineCycleEnd

            int 21h                  ; input
            mov byte ptr ds:[bx], al ; save
            call printSpace
            inc bx
            dec cl
            jmp readLineCycle

        reaLineCycleEnd:
        dec ch
        call printNextLine
        jmp readCycle
    readCycleEnd:

    mov bx, dx
    pop dx
    pop cx
    jmp correctExit

    errorExit:
        mov ax, 1
        ret
    correctExit:
        mov ax, 0
        ret

matrixInput endp


matrixOut proc far
    push ax ; pusha from i286
    push bx
    push cx
    push dx

    mov ax, 0
    mov al, byte ptr [bx + offset X]
    mul byte ptr [bx + offset Y]

    cmp ax, 0
    jna errorExit

    mov ch, byte ptr [bx + offset X]
    mov ax, bx
    add bx, offset body
    
    printMatrixCycle:
        cmp ch, 0
        jna printMatrixCycleEnd

        xchg ax, bx
        mov cl, byte ptr [bx + offset Y]
        xchg ax, bx
        printLineCycle:
            cmp cl, 0
            jna printLineCycleEnd

            mov dl, byte ptr ds:[bx]
            call printSymbol
            call printSpace
            inc bx
            dec cl
            jmp printLineCycle
        printLineCycleEnd:

        dec ch
        call printNextLine
        jmp printMatrixCycle
    
    printMatrixCycleEnd:

    mov bx, ax
    pop dx
    pop cx
    pop bx
    pop ax
    mov ax, 0
    ret

    errorExit:
        mov ax, 1
        ret
        
matrixOut endp

; out - ch = x, cl = y
getSize proc far
    mov ch, byte ptr [bx + offset X]
    mov cl, byte ptr [bx + offset Y]
    ret
getSize endp

; input - ch = x index, cl = y index; out - al = elem, ah = error
getElem proc far
    cmp ch, byte ptr [bx + offset X]
    ja errorExit
    cmp ch, 0
    je errorExit

    cmp cl, byte ptr [bx + offset Y]
    ja errorExit
    cmp cl, 0
    je errorExit

    push bx
    push cx

    dec ch
    dec cl
    mov al, byte ptr [bx + offset Y]
    mul ch
    add al, cl

    add bx, offset body
    add bx, ax
    mov al, byte ptr [bx]

    pop cx
    pop bx

    correctExit:
        mov ah, 0
        ret
    errorExit:
        mov ah, 1
        ret
getElem endp

; input - ch = x, cl = y, al = elem; out - ah = error
setElem proc far
    cmp ch, byte ptr [bx + offset X]
    ja errorExit
    cmp ch, 0
    je errorExit

    cmp cl, byte ptr [bx + offset Y]
    ja errorExit
    cmp cl, 0
    je errorExit

    push cx
    push bx
    push ax

    dec ch
    dec cl
    mov al, byte ptr [bx + offset Y]
    mul ch
    add al, cl

    add bx, ax
    add bx, offset body

    pop ax
    mov byte ptr [bx], al
    pop bx
    pop cx

    correctExit:
        mov ah, 0
        ret
    errorExit:
        mov ah, 1
        ret
setElem endp

CodeS ENDS
END