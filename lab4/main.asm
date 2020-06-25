; 4 lab
; Matrix 9x9 symb
; Input -> Delete strings with '_' count % 2 -> Output
;.8086

StackSeg segment para stack 'Stack'
	db 100 dup(0)
StackSeg ends

DataSeg segment para 'Data'
	beginmessage db 'Enter matrix row and col: $'
	inputmessage db 'Enter matrix:', 0Dh, 0Ah, '$'
	outputmessage db 'Changed matrix:', 0Dh, 0Ah, '$'
	errormessage db 'Error!', 0Dh, 0Ah, '$'
	
	matrix db 9 * 9 dup(0) ; 9 * dup(9 * dup(0))
	rows db -1			   ; rows 
	cols db -1
	new  db -1
DataSeg ends

CodeSeg segment para 'Code'
	assume CS:CodeSeg, DS:DataSeg, SS:StackSeg

say macro info
	push AX
	push DX
	mov AH, 09h
	mov DX, offset &info&
	int 21h
	pop DX
	pop AX
	endm

print_symb macro symb
	mov AH, 2
	mov DL, &symb&
	int 21h
	endm

; DL
print_char proc near uses AX
	mov AH, 2
	int 21h
	ret
print_char endp

get_symb macro
	mov AH, 01h
	int 21h
	endm

endl macro
	push AX
	push DX
	mov AH, 2
	mov DL, 13
	int 21h
	mov DL, 10
	int 21h
	pop DX
	pop AX
    endm

preparation proc near
	mov AX, DataSeg
	mov DS, AX
	ret
preparation endp

get_n_m proc near
	say beginmessage
	; Now n = rows
	get_symb ; AL = ASCII
	; 0 < n < 10
	sub AL, 30h
	cmp AL, 10
	jae error_exit
	cmp AL, 0
	je error_exit
	mov rows, AL
	mov new, AL
	print_symb ' '
	
	; Now m = cols
	get_symb
	; 0 < n < 10
	sub AL, 30h
	cmp AL, 10
	jae error_exit
	cmp AL, 0
	je error_exit
	mov cols, AL
	
	endl
	ret
get_n_m endp

get_matrix proc near
	say inputmessage
	xor CX, CX
	xor BX, BX
	xor DI, DI ; Array index
	mov CL, rows ; Cycle index
	output_matr:
		mov CL, cols
		output_row:
			get_symb
			mov matrix[DI], AL
			inc DI ; i++
			print_symb ' '
			loop output_row
		endl
		mov CL, rows
		sub CX, BX
		inc BX
		loop output_matr
	ret
get_matrix endp

change_matrix proc near
	xor CX, CX
	xor SI, SI
	xor BX, BX
	xor DI, DI ; Array index
	mov CL, rows ; Cycle index
	output_matr:
		xor AX, AX
		mov SI, DI ; Copy index current string
		mov CL, cols
		output_row:
			; may use BX,DX
			; CX - loop, SI - current index
			; AX - count of '_'
			cmp matrix[DI], '_'
			jne continue_1
			inc AX;
			continue_1:
			inc DI ; i++
			loop output_row
		cmp AX, 0  ; no '_'
		je continue_2
		
		test AX, 1
		jne continue_2
		; is odd
		; SI - need
		call delete_string ; use SI as index
		dec new ; current size 
		mov DI, SI
		continue_2:
		mov CL, rows
		sub CX, BX
		inc BX
		loop output_matr
	ret
change_matrix endp

; use SI as index
delete_string proc near uses CX AX BX SI
	;print_symb 'Y'
	; need to delete string
	xor AX, AX
	mov AL, rows
	mov CL, cols
	mul CL
	mov CL, AL
	sub CX, SI
	xor BX, BX
	mov BL, cols
	delete_loop:
		mov AL, matrix[SI + BX]
		mov matrix[SI], AL
		inc SI
		loop delete_loop
	ret
delete_string endp

print_matrix proc near
	say outputmessage
	; Output matrix - holly magic
	xor CX, CX
	xor BX, BX
	xor DI, DI ; Array index
	mov CL, rows ; Cycle index
	output_matr:
		mov CL, cols
		output_row:
			mov DL, matrix[DI]
			call print_char
			inc DI ; i++
			print_symb ' '
			loop output_row
		endl
		mov CL, rows
		sub CX, BX
		inc BX
		loop output_matr
	ret
print_matrix endp
	
main:
	call preparation ; done
	call get_n_m ; done
	call get_matrix ; done
	call change_matrix
	
	call print_matrix ; done
	jmp exit
	
error_exit:
	endl
	say errormessage
	
exit:
	mov AX, 4c00h
	int 21h
CodeSeg ends
end main
