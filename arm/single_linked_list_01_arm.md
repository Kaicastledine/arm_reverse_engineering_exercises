## Source
We are just going to focus on these statements: 

```
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
