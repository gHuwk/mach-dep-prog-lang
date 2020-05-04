StkSeg SEGMENT PARA STACK 'STACK'
	DB 200h DUP (?)
StkSeg ENDS
;
DataS SEGMENT WORD 'DATA'
HelloMessage DB 13
			DB 10
			DB 'Hello, world !'
			DB '$'
DataS ENDS
;
Code SEGMENT WORD 'CODE'
	ASSUME CS:Code, DS:DataS
DispMsg:
	mov AX, DataS
	mov DS, AX
	mov DX, OFFSET HelloMessage
	mov AH, 9				; Выдать на дисплей строку
	mov CX, 3
	mylabel:
	int 21h
	loop mylabel
	mov AH, 7				; ввести символ без эха
	int 21h
	mov AH, 4Ch 			; Конец программы
	int 21h
Code ENDS
END DispMsg