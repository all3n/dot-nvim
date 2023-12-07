#include <string.h>
#include <stdio.h>
int main(int argc, char *argv[]) {
    int n = 0;
    scanf("%d", &n);
    int a;
    while(n--){
        scanf("%d", &a);
        printf("%d ", a);
    }
    printf("\n");
    return 0;
}
