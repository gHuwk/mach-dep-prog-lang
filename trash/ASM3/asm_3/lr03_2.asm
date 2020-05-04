PUBLIC output

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG
output proc near
	
	sub al, 2
	mov dl, al
	mov ah, 2
	int 21h
	ret
output endp
CSEG ENDS
END