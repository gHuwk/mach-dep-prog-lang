; io
; Тут просто дергается из main соотвевтствующие команды
; Т.е. main <- print_uhex <- get_uhex
;						  <- print_string
; Вызод вывода споровождает изменение и соответственно показ строки

public print_inputed
public print_uhex
public print_sdec

extern hex_data: near
extern dec_data: near

extern input_sign: near
extern input_number: near

extern get_uhex: near
extern get_sdec: near

DataSeg segment word public 'Data'
	info_inputed db 'Inputed:', 0Ah, 0Dh, '$'
	info_uhex    db 'Unsigned HEX is:', 0Ah, 0Dh, '$'
	info_sdec	 db 'Signed DEC is:', 0Ah, 0Dh, '$'
DataSeg ends

CodeSeg segment word public 'Code'
    assume CS:CodeSeg, ds:DataSeg

say macro info
	endl
	mov AH, 09h
	mov DX, offset &info&
	int 21h
	endm

endl macro
	mov AH, 2
	mov DL, 13
	int 21h
	mov DL, 10
	int 21h
    endm

print_string macro nead
	mov AH, 09h
	mov DX, offset &nead&
	int 21h
	endm

print_inputed proc near
	say info_inputed
	print_string input_sign
	print_string input_number
	endl
	ret
print_inputed endp

print_uhex proc near
	say info_uhex
	call get_uhex
	print_string hex_data
	ret
print_uhex endp

print_sdec proc near
	say info_sdec
	call get_sdec
	print_string dec_data
	ret
print_sdec endp

CodeSeg ends
end