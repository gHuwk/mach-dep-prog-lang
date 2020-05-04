public loweringMatrix

extern getSize: far
extern getElem: far
extern setElem: far

ASSUME CS:CodeS

CodeS SEGMENT PARA 'logic'

; input al
loweringSymbolVowel proc near
    cmp al, 65
    je lowering

    cmp al, 69
    je lowering

    cmp al, 73
    je lowering

    cmp al, 79
    je lowering

    cmp al, 85
    je lowering

    cmp al, 89
    je lowering

    jmp exit

    lowering:
        add al, 20h

    exit:
        ret
loweringSymbolVowel endp

; input - ds:bx - matrix first (x)
loweringMatrix proc far
    push ax
    push cx
    push dx

    call getSize

    mov dl, cl
    handleCycle:
        cmp ch, 0
        jna handleCycleEnd

        mov cl, dl
        handleLineCycle:
            cmp cl, 0
            jna handleLineCycleEnd

            call getElem

            cmp ah, 0
            jg exit ; wrong size

            call loweringSymbolVowel
            call setElem
        handleLineCycleContinue:
            dec cl
            jmp handleLineCycle
        handleLineCycleEnd:
        dec ch
        jmp handleCycle

    handleCycleEnd:

    exit:
        pop dx
        pop cx
        pop ax
        ret

loweringMatrix endp

CodeS ENDS
END