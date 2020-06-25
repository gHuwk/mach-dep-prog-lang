.MODEL TINY

CodeSeg segment
	assume CS:CodeSeg
	org 100h	; PSP
	
main:
	jmp init
	
handler_original 	dd 0					; старый адресс обработчика прерываний

string0 		 	db 23 dup(' ')
					db 'resident program buf : '
chang_dat			db 'Y'
					db ' times'
					db 27 dup(' ')
buf					db 'N'
tick				db 0
is_loaded			db 20h


; процедура, которой заменяем. uses обеспечивает загрузку и выгрузку в стек регистров


my_handler proc uses AX BX CX DX DI
	pushf									; в стек регистр флагов
	call handler_original					; вызываем стандартный обработчик, так как не имеем права его удалять, он используется
	
	
	inc tick
	
	cmp tick, 20h
	jne pass
	push AX
											; изменяем через равное количество тиков
	mov AL, chang_dat
	mov AH, buf
	mov chang_dat, AH
	mov buf, AL
	pop AX
	
	mov tick, 0
	pass:
	
	mov AX, 0B800h							; адресс начала графики
	mov ES, AX
	mov DI, 0								; смещение видиммого текста
	mov AH, 30h								; атрибуты цвета
	
	mov CX, 80
	mov BX, 0
	
	printing:
		mov AL, string0[BX]					; по символам
		stosw								; вывод символа (2b) из al
											;  DI++
		inc BX								;  BX++
		loop printing
	

	iret 									; выгрузка флагов + возврат из процедуры обработчика
my_handler endp

; макросы обработчика
;---------------
say macro info
	mov AH, 09h
	mov DX, offset &info&
	int 21h
	endm

handler_get macro num
	mov AX, 35&num&
	int 21h
	endm
	
handler_pop macro
	mov DX, word ptr ES:handler_original
	mov DS, word ptr ES:handler_original + 2
	endm

handler_push macro
	mov word ptr handler_original + 2, ES
	mov word ptr handler_original, BX
	endm

handler_refresh macro num
	mov  AX, 25&num&
	int 21h
	endm
;---------------
end_res:

init:
	handler_get 1Ch                   ; запрашиваем адрес текущего обработчика прерывания 
	
	cmp ES:is_loaded, 20h						; весьма опасная штука
	je disable

    handler_push       						; и сохраняем его для последующего вызова
	
	mov DX, offset my_handler
	
	handler_refresh 1Ch				; установка обработчика в таблицу векторов
	
	say info_in
	
	mov DX, init;			; количество байт от начала, чтобы отрезать
	
	int 27h									; завершение с сохранением резидентной части

disable:
	push DS
	handler_pop
	
	handler_refresh 1Ch				; возврат стандартного обработчика
	
	pop DS
	
	mov AH, 49h								; освобождаем память по адресу ES
	int 21h
	
	say info_di

	mov AX, 4c00h 							; Завершение программы
	int 21h	
	
	info_in				db 'init', 0Ah, 0Dh, '$'
	info_di				db 'disable', 0Ah, 0Dh, '$'	
CodeSeg ends
	end main