public get_uhex
public get_sdec

public hex_data
public dec_data

extern input_sign: near
extern input_number: near


DataSeg segment word public 'Data'
    numcopy  db 17 dup ('$')
    numsize  dw 1 ; длина числа ; to stack
    copysize db 1
    degree   dw 1 ; степень ; to stack

    hex_data db 5 dup ('$')
	
    dec_data db '+' 
			 db 6 dup ('$')

    startend dw 0 ; ???
    mem  dw 1 ; to stack
    bmem db 1 ; to stack
    cur  dw 1 ; to stack
DataSeg ends

CodeSeg segment word public 'Code'
	assume CS:CodeSeg, DS:DataSeg



make_sign macro sign
	xor BX, BX
	mov dec_data[BX], &sign&
	endm

copyTetrade proc near
    xor CX, CX
	forHex:
		mov BX, CX
		mov DX, 0
		mov DX, input_number[BX]
		inc CX
		cmp DH, '$'
		je endHex
		cmp CX, 16
		jnz forHex
		endHex:    
			mov numsize, CX
			
			mov BX, 4
			mov mem, CX
			mov AX, mem
			
			div BL
			
			mov mem, 0
			mov bmem, AH
			mov BL, 4
			sub BL, bmem
			mov copysize, 0
			add copysize, BL
			
			
			mov BL, 12
			mov bmem, 4
			mul bmem
			sub BL, AL
			add copysize, BL
			
			cmp copysize, 0
			je endFor
		
		noMainZeroes:
			mov BX, 0
			mov BL, copysize
			mov mem, BX
			forZero:
				dec copysize
				mov BL, copysize
				mov numcopy[BX], '0'
				cmp copysize, 0
				jnz forZero
		endFor:

    xor CX, CX
    xor DX, DX
	forIn:
		mov BX, CX
		mov DX, input_number[BX]
		cmp DL, '$'
		je endForIn
		mov cur, DX
		mov BX, mem
		mov numcopy[BX], DL
		inc mem
		inc CX
		jmp forIn
		endForIn:
    ret
copyTetrade endp

complementeAdd proc near
    xor BX, BX
    mov AX, input_sign[BX]
    mov AH, 0
    cmp AX, '-'
    jnz compEnd
    
    xor CX, CX
	forCompleted:
		mov BX, CX
		mov DH, numcopy[BX]
		inc CX
		cmp DH, '$'
		je endForComp
		cmp DH, '1'
		jz decDec
		jnz incDec
		backDecInc:
		mov numcopy[BX], DH
		jmp forCompleted
	endForComp:
	
    mov CX, 16
	forSum:
		dec CX
		mov BX, CX
		mov DH, numcopy[BX]
		cmp DH, '1'
		jz decDecC
		jnz incDecC
	backdecincDecC:
		mov numCopy[BX], DH
		cmp CX, 0
		jz endForSum
		cmp DH, '0'
		jz forSum
	endForSum:
compEnd:
    ret
    
decDec:
    dec DH
    jmp backDecInc
 
incDec:
    inc DH
    jmp backDecInc
    
decDecC:
    dec DH
    jmp backdecincDecC
 
incDecC:
    inc DH
    jmp backdecincDecC
complementeAdd endp

get_uhex proc near
	call copyTetrade
    call complementeAdd
    xor CX, CX
	forTrans:
		mov AX, CX
		mov bmem, 4
		mul bmem
		mov bmem, AL
		mov BX, 0
		mov BL, bmem
		cmp numCopy[BX], '$'
		je endForTrans
	
    mov DL, 0
    mov AL, numcopy[BX]
    sub AL, '0'
    mov bmem, 8
    mul bmem
    mov bmem, AL
    add DL, bmem
    inc BX
    mov AL, numcopy[BX]
    sub AL, '0'
    mov bmem, 4
    mul bmem
    mov bmem, AL
    add DL, bmem
    inc BX
    mov AL, numcopy[BX]
    sub AL, '0'
    mov bmem, 2
    mul bmem
    mov bmem, AL
    add DL, bmem
    inc BX
    mov AL, numcopy[BX]
    sub AL, '0'
    mov bmem, 1
    mul bmem
    mov bmem, AL
    add DL, bmem
    add DL, '0'
    cmp DL, '9'
    jg toLetter
back:
    mov BX, CX
    mov hex_data[BX], DL
    
    inc CX
    JMP forTrans
endForTrans:
    ;call printHexNum
    ret
    
toLetter:
    add DL, 7
    jmp back
    
get_uhex endp


get_sdec proc near
	; зубков
	;mem 		equ word ptr [bp-2] ; локальные переменные
	;degree 		equ word ptr [bp-4]
	;startEnd 	equ word ptr [bp-6]
	
	;push BP
	;mov BP, SP
	;sub SP, 3h 
	
	;mov mem, 		01h
	;mov degree, 	01h
	;mov startEnd, 	00h
	xor CX, CX
	forDec: ; пока не 16 - итерируем
		mov BX, CX
		mov DX, input_number[BX]
		inc CX
		
		cmp DH, '$'
		je endForDec
		
		cmp CX, 16
		jnz forDec
	endForDec:    
    mov numSize, CX
    mov BX, numSize
    mov degree, 1
    mov mem, 0
    
    dec BX
    
	forToSum:
		mov AX, degree
		mov DX, input_number[BX]
		sub DL, '0'
		mov DH, 0
		mul DX
		add mem, AX
		mov AX, 2
		mul degree
		mov degree, AX
		dec BX
		cmp BX, startEnd
		jge forToSum
	mov CX, 1
    mov BX, 10
    mov AX, mem
    
    
    cmp AX, 65535
    je forDecTrans
	
    cmp AX, 10
    jb endDecTrans
	
	forDecTrans:
		mov AX, mem
		mov DX, 0
		div BX
		push DX
		mov mem, AX
		inc CX
		cmp AX, 10
		jge forDecTrans
	endDecTrans:

    push AX
    
    mov mem, CX
    mov CX, 1
	forStack:
		pop DX
		mov BX, CX
		add DL, '0'
		mov dec_data[BX], DL
		inc CX
		cmp CX, mem
		jle forStack
    
    xor AX, AX
    mov AL, '+'
    xor BX, BX
    mov BX, input_sign[BX]
    mov BH, 0
    cmp BX, AX
    jne changeSignDec
	
	changeBack:
    ;call printDecNum
    ;make_sign '+'
    
	;mov sp, bp
	;pop bp
	
    ;ret 3
	ret
	changeSignDec:
		make_sign '-'
		jmp changeBack
get_sdec endp


CodeSeg ends
end