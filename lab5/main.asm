; lab 5 
; Вводим в знаковом двоичном
; Выводим в безнаковом 16
; Выводим в знаковом 10


extern get_number: near
extern print_inputed: near
extern print_uhex: near
extern print_sdec: near

StackSeg segment para stack 'Stack'
    db 200h dup (?)
StackSeg ends

DataSeg segment para public 'Data'
    menuMess	db 'Choose variant:', 0Ah, 0Dh
				db '1. Input number', 0Ah, 0Dh
				db '2. Number to unsigned hex and print', 0Ah, 0Dh
				db '3. Number to signed decimal and print', 0Ah, 0Dh
				db '4. Print number', 0Ah, 0Dh
				db '5. Exit', 0Ah, 0Dh
				db 'Input variant: '
				db '$'
	goodbye     db 0Ah, 0Dh, 'GoodBye!$'
    functions dw  get_number, print_uhex, print_sdec, print_inputed, exit ; адреса на функции
DataSeg ends

CodeSeg segment word public 'Code'
    assume CS:CodeSeg, DS:DataSeg

say macro info
	mov AH, 09h
	mov DX, offset &info&
	int 21h
	endm

get_symb macro
	mov AH, 01h
	int 21h
	endm

endl macro
	mov AH, 2
	mov DL, 13
	int 21h
	mov DL, 10
	int 21h
    endm

main:
    call preparation

menu:
	say menuMess
    get_symb
    
    mov ah, 0h
    sub al, '1'
	; Можно было сдвиг
    mov dl, 2
    mul dl
    mov bx, ax
    
	endl
    call functions[BX]
	endl
    jmp menu ; Цикл на выбор в меню

preparation proc near
	mov AX, DataSeg
	mov DS, AX
	ret
preparation endp

exit proc near ; процедура
	say goodbye
    mov AX, 4c00h
    int 21h
exit endp

CodeSeg ends
end main