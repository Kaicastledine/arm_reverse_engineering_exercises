## Source Code
```
#import <Foundation/Foundation.h>

@interface MyUser : NSObject

-(NSString*)printUserName;

@end

@implementation MyUser

-(NSString*)printUserName {
    
    NSString *userName = @"cnorris";
    
    return userName;
}
@end

int main(int argc, const char * argv[]) {
    
    MyUser *myUser = [[MyUser alloc] init];
    [myUser printUserName];
    
    return 0;
}

```

## Walkthrough

The majority of reversing Objective-C code is fully understanding how the compiler converts method calls - ```[SomeObject someMethod]``` - into an ```objc_msgSend()``` call.

[https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/)

Feel free to dive into Apple's documentation for more information, and then I would highly recommend Nemo's first Phrack paper on abusing the Objective-C runtime. 

Here is the declaration of ```objc_msgSend()``` : 

```id objc_msgSend(id self, SEL op, ...)```

So let's say we invoke a method - ```[SomeObject someMethod]```:

- The ```id``` parameter in ```objc_msgSend()``` is referring to ```SomeObject```
- The ```SEL``` parameter is the ```selector``` - ```someMethod```

The ```selector``` is simply the method that is **selected** to be called on the corresponding class.

Alright let's jump into some assembly:

```
         movw       r3, #0x11e                                          ; @selector(alloc), :lower16:(0xc084 - 0xbf66)
0000bf5e         movt       r3, #0x0                                            ; @selector(alloc), :upper16:(0xc084 - 0xbf66)
0000bf62         add        r3, pc                                              ; @selector(alloc)
0000bf64         movw       sb, #0x120                                          ; :lower16:(objc_cls_ref_MyUser - 0xbf70)
0000bf68         movt       sb, #0x0                                            ; :upper16:(objc_cls_ref_MyUser - 0xbf70)
0000bf6c         add        sb, pc                                              ; objc_cls_ref_MyUser
0000bf6e         movw       ip, #0x0
0000bf72         str.w      ip, [sp, #0x1c + var_4]
0000bf76         str        r0, [sp, #0x1c + var_8]
0000bf78         str        r1, [sp, #0x1c + var_C]
0000bf7a         ldr.w      r0, [sb]                                            ; objc_cls_ref_MyUser,_OBJC_CLASS_$_MyUser
0000bf7e         ldr        r1, [r3]                                            ; "alloc",@selector(alloc)
0000bf80         blx        r2                                                  ; _objc_msgSend
0000bf82         movw       r1, #0x72                                           ; :lower16:(imp___nl_symbol_ptr__objc_msgSend - 0xbf8e)
0000bf86         movt       r1, #0x0                                            ; :upper16:(imp___nl_symbol_ptr__objc_msgSend - 0xbf8e)
0000bf8a         add        r1, pc                                              ; imp___nl_symbol_ptr__objc_msgSend
0000bf8c         ldr        r1, [r1]                                            ; imp___nl_symbol_ptr__objc_msgSend,_objc_msgSend
0000bf8e         movw       r2, #0xee                                           ; @selector(init), :lower16:(0xc088 - 0xbf9a)
0000bf92         movt       r2, #0x0                                            ; @selector(init), :upper16:(0xc088 - 0xbf9a)
0000bf96         add        r2, pc                                              ; @selector(init)
0000bf98         ldr        r2, [r2]                                            ; "init",@selector(init)
0000bf9a         str        r1, [sp, #0x1c + var_14]
0000bf9c         mov        r1, r2
0000bf9e         ldr        r2, [sp, #0x1c + var_14]
0000bfa0         blx        r2
```

We will be focusing on - ```MyUser *myUser = [[MyUser alloc] init];```

```
0000bf5a         movw       r3, #0x11e                                         ; @selector(alloc), :lower16:(0xc084 - 0xbf66)
0000bf5e         movt       r3, #0x0                                           ; @selector(alloc), :upper16:(0xc084 - 0xbf66)
0000bf62         add        r3, pc                                             ; @selector(alloc)
```

We cannot store a 32-bit immmediate inside a register in ARM, so we split that value across two instructions - ```movw``` and ```movt``` - which move the upper and lower 16 bits into the target register.

```
0000bf64         movw       sb, #0x120                                          ; :lower16:(objc_cls_ref_MyUser - 0xbf70)
0000bf68         movt       sb, #0x0                                            ; :upper16:(objc_cls_ref_MyUser - 0xbf70)
0000bf6c         add        sb, pc                                              ; objc_cls_ref_MyUser
```

We move the class reference in the same exact way for ```MyUser``` into ```sb```.

```
000bf72          str.w      ip, [sp, #0x1c + var_4]
0000bf76         str        r0, [sp, #0x1c + var_8]
0000bf78         str        r1, [sp, #0x1c + var_C]
0000bf7a         ldr.w      r0, [sb]                                            ; objc_cls_ref_MyUser,_OBJC_CLASS_$_MyUser
0000bf7e         ldr        r1, [r3]                                            ; "alloc",@selector(alloc)
0000bf80         blx        r2                                                  ; _objc_msgSend
```

We first store what's inside ```ip```, ```r0```, ```r1``` onto the stack, then we load the class reference to ```MyUser``` into ```r0```, and ```selector``` - ```alloc``` into ```r1```.  Finally we branch to ```r2```, which contains the symbol pointer to ```objc_msgSend()```.

