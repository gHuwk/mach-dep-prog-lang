/*
FPU.
FPU (Floating Point Unit) используется для ускорения и упрощения вычислений с плавающей точкой.
Сопроцессор (другое название FPU) ориентирован на матиматические вычисления - в нем отсутсвуют 
операции с битами, зато расширен набор математических ф-ций: тригонометрические, логарифм и т.д.
*/

// В программе находится сторона треугольника по двум сторонам и углу между ними

#include <iostream>
#include <cmath>

#define PI 3.14159265


unsigned long tick(void)
{
	// Возможно, это реализовано лучше.
	unsigned long tmp;
	__asm {
		rdtsc
		mov tmp, EAX
	}
	return tmp;
}

// find z = sqrt(a ^ 2 + b ^ 2 - 2*ab*cos(angle))
float find_asm(const float x, const float y, const float angle)
{
	float result = 0;
	__asm {					// STACK
		fld x				// x
		fmul x				// TOP = TOP * x
		fld y				// x^2, y
		fmul y				// x^2, y^2
		faddp ST(1), ST(0)	// x^2+y^2			equal without param // pop

		fld angle			// x^2+y^2, angle
		fcos				// x^2+y^2, cos(angle)	; IN RADS!
		fmul x				// x^2+y^2, cos(angle) * x
		fmul y				// x^2+y^2, cos(angle) * x * y

		fadd ST(0), ST(0)   // x^2+y^2, cos(angle) * x * y * 2

		fsubp ST(1), ST(0)  // x^2+y^2 - cos(angle) * x * y * 2 // it doesnotwork without param


		fsqrt				// sqrt (x^2+y^2 - cos(angle) * x * y * 2)
		fstp result
	}
	return result;
}

float find_std(const float x, const float y, const float angle)
{
	float result = sqrt(x * x + y * y - 2 * x * y * cos(angle));
	return result;
}

void compare_times(const float x, const float y, const float angle)
{
	unsigned long tick1, tick2, tick3;
	tick1 = tick();
	float asm_res = find_asm(x, y, angle);
	tick2 = tick();
	float std_res = find_std(x, y, angle);
	tick3 = tick();

	std::cout << "asm_res: " << asm_res << std::endl;
	std::cout << "Ticks: = " << tick2 - tick1 << std::endl;
	std::cout << "std_res: " << std_res << std::endl;
	std::cout << "Ticks: = " << tick3 - tick2 << std::endl;
}

int input_values(float* x, float* y, float* angle)
{
	std::cout << "Input x: ";
	std::cin >> *x;
	std::cout << "Input y: ";
	std::cin >> *y;
	std::cout << "Input angle (grad): ";
	std::cin >> *angle;
	// To rads
	(*angle) *= (float) PI / 180;
	return 0;
}

int main()
{
	std::cout << "Choose your fighter:\n";
	std::cout << "1. Find Z with assembler\n";
	std::cout << "2. Find Z with standart C-Math\n";
	std::cout << "3. Compare finds\n";
	std::cout << "0. Exit\n";
	
	int choice = 0;
	float result = 0;

	std::cout << ":> ";
	std::cin >> choice;
	if ((choice < 4) && (choice > 0))
	{
		float x = 0;
		float y = 0;
		float angle = 0;

		input_values(&x, &y, &angle);
		switch (choice)
		{
		case 1:
			result = find_asm(x, y, angle);
			std::cout << "Result: ";
			std::cout << result;
			break;
		case 2:
			result = find_std(x, y, angle);
			std::cout << "Result: ";
			std::cout << result;
			break;
		case 3:
			compare_times(x, y, angle);
			break;
		default:
			break;
		}
		
	}
	else
		std::cout << "Exit!\n";

	return 0;
}