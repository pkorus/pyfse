#include <stdio.h>
// #include "fse.h"

int main() {

    unsigned char src [] = "Hello world, hello all, hello world, Hello, Hello, world, world?";
    unsigned char * dst = malloc(1000);

    size_t ret = FSE_compress(dst, 1000, src, strlen(src));
    // int ret = 0;

    printf("Start function!\n");
    printf("%s\n", src);
    int i = 0;
    int counter = 0;
    printf("Dst:");
    while (dst[i] != 0) {
        printf("%d ", dst[i]);
        i++;
        counter++;
    }
    printf("\n");
    // printf("%s\n", dst);
    printf("In length: %d\n", strlen(src));
    printf("Out length: %d\n", counter);
    printf("%d\n", ret);

}