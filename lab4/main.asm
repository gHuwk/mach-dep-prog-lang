extern matrixInput: far
extern loweringMatrix: far
extern matrixOut: far

extern printStringOnEs: far
extern printNextLine: far

MessageS SEGMENT WORD 'Messages'
    errorString db 13
                db 10
                db 'Error$'
    outputMessageString db 'Changed matrix:'
                        db 13
                        db 10
                        db '$'
MessageS ENDS

StackS SEGMENT WORD STACK 'Stack'
    db 100 DUP(?)
StackS ENDS

MatrixS SEGMENT WORD 'Data'
    x db 0
    y db 0
    body db 81 DUP(0)
MatrixS ENDS

ASSUME CS:CodeS, DS:MatrixS, ES:MessageS, SS:StackS

CodeS SEGMENT PARA 'Code'

main:
    mov ax, MatrixS 					; Загружаем матрицу
    mov ds, ax

    mov ax, MessageS 					; Загружаем интерфейс
    mov es, ax


    mov bx, OFFSET x
    call matrixInput

    cmp ax, 0
    jg errorExit

    call loweringMatrix
    cmp ax, 0
    jg errorExit

    call printNextLine

    mov dx, offset outputMessageString
    call printStringOnEs

    call matrixOut

    mov ah, 1
    int 21h

    jmp exit

errorExit:
    mov dx, OFFSET errorString
    call printStringOnEs

exit:
    mov ah, 4ch
    int 21h

CodeS ENDS 
end main