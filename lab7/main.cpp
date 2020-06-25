#include <iostream>

extern "C" {
	void copy(char* destination, char* source, size_t len);
}

int main() {

	// cdecl32 ���������� � �������, ������������ ������������� ����� �� �� 32���������
	// 1. ��������� ����� ���� ������ ������
	// 2. ���, ��� �� ���������� ������ 4 ���� - ����������� ��� 4 �����, ��������
	// 3. ������� ����� ����� �� ���������� ���������.
	// 4. ������� ���������� 1, 2, 4 ����� (����� �����, ���������) ����� EAX
	// 5. ������� �������� ���������, ��������, ����� - ���������� ����� EAX

	// ����� ������� ������� ����������� ���:
	// 1) ����������� �������� ���������, ������������ ������ �������
	// 2) ������ � ���� ���������� �������

	// ����� ������ ������� ��������� ���:
	// 1) ������� �����
	// 2) �������������� �������� �����

	// ������ ��������������� �����
	// ���������� ���������, ���������� ����� ������ ������
	char message[] = "It is not the strongest of the species that survives\
,nor the most intelligent, but the one most responsive to change.   (Charles Darwin)";
	// �������, ����� ���� �������, � ��� ��������
	std::cout << "Current message is:\n";
	std::cout << message << std::endl;

	size_t result = 0;
	// ����� ������
	// ��� �������� �������� ���������
	__asm {
		mov ECX, -1
		mov AL, 0
		lea EDI, [message]
		repne scasb // repne - �������� ��������, ���� ECX != 0 && ZF
					// scasb - ���������� ���� �� AL � ES:EDI
		not ECX
		dec ECX
		mov result, ECX
	}
	std::cout << "Length is: \n";
	std::cout << result << "\n";

	char history[400] = { 0 };

	std::cout << "Now in history are: \n";
	copy(history, message, result);

	std::cout << history << "\n";

	std::cout << "Changed history: \n";
	copy(history, history + result - 16, 16);

	std::cout << history;

	return 0;
}