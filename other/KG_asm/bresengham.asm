.model small
.stack	100h
.data
	eror dw ?
	x dw ?
	y dw ?
	x0 dw ?
	y0 dw ?
	delta dw ?
	radius dw ?
.code

Plot proc
	mov Ah, 0Ch		;Функция отрисовки точки
	mov al, 6		;Цвет
	int 10h			;Нарисовать точку
	ret
Plot endp

drawCircle proc
        mov x, 0
	mov ax, radius
        mov y, ax
        mov delta, 2
	mov ax, 2
	mov dx, 0
	imul y
	sub delta, ax
	mov eror, 0
	jmp ccicle
finally: ret
ccicle:
	mov ax, y
	cmp ax, 0
	jl  finally
	mov cx, x0
	add cx, x
	mov dx, y0
	add dx, y
	call Plot
        mov cx, x0
	add cx, x
	mov dx, y0
	sub dx, y
	call Plot
	mov cx, x0
	sub cx, x
	mov dx, y0
	add dx, y
	call Plot
	mov cx, x0
	sub cx, x
	mov dx, y0
	sub dx, y
	call Plot
	mov ax, delta
	mov eror, ax
	mov ax, y
	add eror, ax
	mov ax, eror
	mov dx, 0
	mov bx, 2
	imul bx
	sub ax, 1
	mov eror, ax
	cmp delta, 0
	jg sstep
	je sstep
	cmp eror, 0
	jg  sstep
	inc x
	mov ax, 2
	mov dx, 0
	imul x
	add ax, 1
	add delta, ax
        jmp ccicle
sstep:
	mov ax, delta
	sub ax, x
	mov bx, 2
	mov dx, 0
	imul bx
	sub ax, 1
	mov eror, ax
	cmp delta, 0
	jg tstep
	cmp eror, 0
	jg tstep
	inc x
	mov ax, x
	sub ax, y
	mov bx, 2
	mov dx, 0
	imul bx
	add delta, ax
        dec y
	jmp ccicle
tstep:
	dec y
        mov ax, 2
	mov dx, 0
	imul y
	mov bx, 1
	sub bx, ax
	add delta, bx
	jmp ccicle
drawCircle endp

start:
	mov ax, @data
	mov ds, ax
	mov Ah, 0
	mov Al, 4
	int 10h    ;Включение видеорежима VGA
	mov radius, 20    ;Радиус нашего круга.
	mov x0, 80    ;Номер строки, в котором будет находится центр круга
	mov y0, 80    ;Номер столбца, в котором будет находится центр круга
	call DrawCircle
	mov ah,	1    ;Функция захвата кода клавиши (идентична getch из "с")
	int 21h
	mov ah, 4Ch
	int 21h
end	start