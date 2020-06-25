#include <iostream>

extern "C" {
	void copy(char* destination, char* source, size_t len);
}

int main() {

	// cdecl32 соглашение р вызовах, используемое компиляторами языка Си на 32разрядных
	// 1. Аргументы через стек справа налево
	// 2. Все, что из аргументов меньше 4 байт - унифицируем под 4 байта, расширяя
	// 3. Очистка стека лежит на вызывающей программе.
	// 4. Возврат параметров 1, 2, 4 байта (целые числа, указатели) через EAX
	// 5. Возврат большихз струкутур, массивов, строк - УКАЗАТЕЛЕМ через EAX

	// Перед вызовом функции вставляется код:
	// 1) Сохрангение значений регистров, используемых внутри функции
	// 2) Запись в стек аргументов функции

	// После вызоыв функции вставляем код:
	// 1) Очистка стека
	// 2) Восстановление значения стека

	// Строка нефиксированной длины
	// Фактически указатель, содержащий адрес первой ячейки
	char message[] = "It is not the strongest of the species that survives\
,nor the most intelligent, but the one most responsive to change.   (Charles Darwin)";
	// Выведем, чтобы было понятно, с чем работаем
	std::cout << "Current message is:\n";
	std::cout << message << std::endl;

	size_t result = 0;
	// длина строки
	// Все регистры сохранит копилятор
	__asm {
		mov ECX, -1
		mov AL, 0
		lea EDI, [message]
		repne scasb // repne - повторит опреацию, пока ECX != 0 && ZF
					// scasb - сравнивает байт из AL с ES:EDI
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