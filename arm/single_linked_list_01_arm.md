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

The pointer to the heap allocation is a return value which is placed in ```r0``` based on the ABI.  We are going to take the pointer and store it on the stack, then load that address back into ```r0``` i.e. "load / store" :

```
0000bee8         str        r0, [sp, #0xc + var_4]
0000beea         ldr        r0, [sp, #0xc + var_4]
```

We then store 5 at the heap location pointed to by ```[sp, 0xc + var_4]``` : 

```
0000beec         str        r2, [r0]
```

Here is what we can gather so far: 

- We have a heap allocation with a pointer located at ```[sp, #0xc + var_4]```
- We stored at an integer (5) within the heap allocation


Another call to ```malloc()``` is made: 

```
0000beee         mov        r0, r1
0000bef0         blx        imp___symbolstub1__malloc
```

We load are first pointer ```[sp, #0xc + var_4]``` (address) into ```r3``` . Then we are going to store our second pointer returned from ```malloc()``` in ```r0``` into the first heap structure at an index ```r0, [r3, #0x4]```. This breaks down into the following source from connects are linked list.

```
root->next = malloc(sizeof(struct node));
```

```
0000bef8         ldr        r3, [sp, #0xc + var_4]
0000befa         str        r0, [r3, #0x4]
0000befc         ldr        r0, [sp, #0xc + var_4]
0000befe         ldr        r0, [r0, #0x4]
0000bf00         str        r2, [r0]
```
