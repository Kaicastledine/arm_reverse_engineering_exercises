## Source Code
```
#import <Foundation/Foundation.h>

void myFunction() {
    
    char *first_name = "chuck";
    char *second_name = "sly";
    char *third_name = "burt";
    char *fourth_name = "dolf";
    
    char *myArray[5];
    
    myArray[0] = first_name;
    myArray[1] = second_name;
    myArray[2] = third_name;
    myArray[3] = fourth_name;
    
    for(int i = 0; myArray[i] != '\0'; i++) {
        printf("[*] %s\n", myArray[i]);
    }

}

int main(int argc, const char * argv[]) {
    
    printf("[*] Calling myfunction()\n");
    myFunction();
    return 0;
}
```
## Compiler
```
clang -framework Foundation -arch armv7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/ main.m -o main -miphoneos-version-min=7.0
```

