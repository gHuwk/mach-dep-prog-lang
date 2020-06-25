.686
.MODEL FLAT, C ; определяет модель памяти, используемую программой + cdecl32 в случае с Си
			   ; FLAT - NEAR адресация данных и кода
.STACK

.CODE
; Вот тут вот аргументы идут вот таким образом, фактически мождно было бы использовать стековый кадр
copy PROC destination:dword, source:dword, len:dword
	;push EBP
	;mov EBP, ESP
	;	
	;mov ECX, [EBP + 8]      ; первый параметр
	;mov ESI, [EBP + 12]
	;mov ECX, [EBP + 16]
	;aka entry
	pushf					; сохраним значение флагов в стеке 
	mov ECX, len			; длина строки, которую копируем
	mov ESI, source			; откуда
	mov EDI, destination	; куда

	cld						; очистить флаг направления
	cmp ESI, EDI			; если адреса совпадают, зачем копировать? Выходим
	je quit

	mov EAX, ESI			; проверка на наложение
	add EAX, len			; прибавив длину к началу, чтобы найти адрес последнего 

	cmp EAX, EDI			; сравниваем и получаем проверку на наложение
	jg overlay

	rep movsb				; магия Записать в ячейку по адресу ES:(E)DI байт 
							;               из ячейки с адресом DS:(E)SI количества ECX 
							; 
	jmp quit

overlay:
	add ESI, len            ; получаем обратные адреса
	dec ESI
	add EDI, len
	dec EDI

	std                     ; устанавливаем флаг направления

	rep movsb				; снова копируем 

	jmp quit

quit:
	; Вот соотвтественно leave
	; mov sp, bp
	; pop bp
	popf					; возврат флагов
	ret

copy ENDP
END
