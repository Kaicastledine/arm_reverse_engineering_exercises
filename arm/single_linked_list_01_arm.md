## Source
We are just going to focus on these statements: 

```
struct node {
    int x;
    struct node *next;
};

root = malloc(sizeof(struct node));
root->x = 5;
root->next = malloc(sizeof(struct node));
root->next->x = 6;
root->next->next = NULL;
conductor = root;
```
## Compiler
```
clang -framework Foundation -arch armv7 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/ main.m -o main -miphoneos-version-min=7.0
```
## Walkthrough

```
000bedc          sub        sp, #0xc
0000bede         movs       r0, #0x8
0000bee0         blx        imp___symbolstub1__malloc
```
First we make some room on the stack for our local variables, and then make call to ```malloc()``` with the value ```0x08``` .  This translates into ```malloc(sizeof(struct node));```
