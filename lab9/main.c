#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    char input[256];
    char serial[] = "f2hwldozg|:wbq";
    int i;

    printf("Enter flag to check: ");
    scanf("%s", input);
    for (i = 0; i < strlen(serial); i++) {
        if (input[i] + i != serial[i]) {
            printf("Wrong position %d!\n", i);
            return 0;
        }
    }
    printf("Yes! Correct flag is %s\n", input);
    return 0;
}