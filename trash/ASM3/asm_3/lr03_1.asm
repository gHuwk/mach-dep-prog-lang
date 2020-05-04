EXTRN output: near

STK SEGMENT PARA STACK 'STACK'
	db 100 dup(0)
STK ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, SS:STK
main:
	mov ah, 1
	int 21h
	
	call output

	mov ax, 4c00h
	int 21h
CSEG ENDS
END main