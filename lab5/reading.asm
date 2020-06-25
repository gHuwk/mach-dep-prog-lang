public get_number

public input_sign
public input_number

DataSeg segment para public 'Data'
	input_sign db '+', '$'
	input_number db 17 dup ('$')
	input_info db 0Ah, 0Dh, 'Input number: ', 0Ah, 0Dh, '$'
DataSeg ends

CodeSeg segment word public 'Code'
	assume CS:CodeSeg, DS:DataSeg

say macro info
	mov AH, 09h
	mov DX, offset &info&
	int 21h
	endm

get_symb macro
	mov AH, 01h ;; Функция дос 01h Считать символ из STDIN с эхом, ожиданием и проверкой на Ctrl-Break
				;; Вход AH = 01h
				;; Выход AL = ASCII-код символа или 0
	int 21h
	endm

get_number proc near
	; В самом начале у нас вводится символ так как знаковое двоичное число
	; Так что будем читать его
	say input_info
	get_symb
	mov input_sign, AL
	mov CX, 00h
	
	loop_get_number:
		get_symb
		cmp AL, 0Dh
		je end_loop_get_number
		
		mov AH, 00h
		mov BX, CX
		mov input_number[BX], AL
		inc CX
		cmp CX, 16
		jnz loop_get_number
	end_loop_get_number:
	mov AL, '$'
	mov BX, CX
	mov input_number[BX], AL
	ret
get_number endp
CodeSeg ends
end
	