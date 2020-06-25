.686
.MODEL FLAT, C ; ���������� ������ ������, ������������ ���������� + cdecl32 � ������ � ��
			   ; FLAT - NEAR ��������� ������ � ����
.STACK

.CODE
; ��� ��� ��� ��������� ���� ��� ����� �������, ���������� ������ ���� �� ������������ �������� ����
copy PROC destination:dword, source:dword, len:dword
	;push EBP
	;mov EBP, ESP
	;	
	;mov ECX, [EBP + 8]      ; ������ ��������
	;mov ESI, [EBP + 12]
	;mov ECX, [EBP + 16]
	;aka entry
	pushf					; �������� �������� ������ � ����� 
	mov ECX, len			; ����� ������, ������� ��������
	mov ESI, source			; ������
	mov EDI, destination	; ����

	cld						; �������� ���� �����������
	cmp ESI, EDI			; ���� ������ ���������, ����� ����������? �������
	je quit

	mov EAX, ESI			; �������� �� ���������
	add EAX, len			; �������� ����� � ������, ����� ����� ����� ���������� 

	cmp EAX, EDI			; ���������� � �������� �������� �� ���������
	jg overlay

	rep movsb				; ����� �������� � ������ �� ������ ES:(E)DI ���� 
							;               �� ������ � ������� DS:(E)SI ���������� ECX 
							; 
	jmp quit

overlay:
	add ESI, len            ; �������� �������� ������
	dec ESI
	add EDI, len
	dec EDI

	std                     ; ������������� ���� �����������

	rep movsb				; ����� �������� 

	jmp quit

quit:
	; ��� �������������� leave
	; mov sp, bp
	; pop bp
	popf					; ������� ������
	ret

copy ENDP
END
