extern iptChK : far
public x, k

StackS SEGMENT BYTE STACK 'Stack'  ; ������� �����
	db 100 dup(0)              ; ��������
StackS ENDS

DataS SEGMENT WORD 'Data'
	x db 1
	k db 0

DataS ENDS

ASSUME CS:CodeS, DS:DataS, SS:StackS

CodeS SEGMENT PARA 'Code'

main:
	mov ax, DataS              ; �������� �������� ������
	mov ds, ax
	
	call iptChK                ; ����� ������� ������

	                           ; ��������� � ����� ������

	mov dl, x                  ; ��������� ASCII ��� �������
	add dl, k                  ; ��������� ��������

	mov ah, 02h
	int 21h
	
	call exit
exit:
	mov AH, 4Ch
	int 21h

CodeS ENDS
END main