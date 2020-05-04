public iptChK

extern x: byte
extern k: byte

CodeS SEGMENT PARA 'CODE'
	assume CS:CodeS

endline proc near
	mov ah, 2
	mov dl, 10
	int 21h
	mov dl, 13
	int 21h
	ret
endline endp

iptChK proc far
	                           ; ввод x
	mov ah, 01h
	int 21h
	mov x, al
	call endline
	
	                           ; ввод k
	mov ah, 01h
	int 21h
	sub al, 30h
	mov k, al
	call endline

	ret
iptChK endp

CodeS ENDS
END
