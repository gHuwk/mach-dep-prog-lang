extern iptChK : far
public x, k

StackS SEGMENT BYTE STACK 'Stack'  ; Сегмент стэка
	db 100 dup(0)              ; Выделить
StackS ENDS

DataS SEGMENT WORD 'Data'
	x db 1
	k db 0

DataS ENDS

ASSUME CS:CodeS, DS:DataS, SS:StackS

CodeS SEGMENT PARA 'Code'

main:
	mov ax, DataS              ; Загрузка сегмента данных
	mov ds, ax
	
	call iptChK                ; Вызов второго модуля

	                           ; Обработка и вывод данных

	mov dl, x                  ; добавляем ASCII код символа
	add dl, k                  ; добавляем смещение

	mov ah, 02h
	int 21h
	
	call exit
exit:
	mov AH, 4Ch
	int 21h

CodeS ENDS
END main