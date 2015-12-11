The majority of reversing Objective-C code is fully understanding how the compiler converts method calls - ```[SomeObject someMethod]``` - into an objc_msgSend() call.

[https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ObjCRuntimeRef/)

Feel free to dive into Apple's documentation for more information, and then I would highly recommend Nemo's first Phrack paper on abusing the Objective-C runtime. 

Here is the declaration of objc_msgSend(): 

```id objc_msgSend(id self, SEL op, ...)```

So let's say we invoke a method - ```[SomeObject someMethod]```:

- The ```id``` parameter in ```objc_msgSend()``` is referring to ```SomeObject```
- The ```SEL``` parameter is the ```selector``` - ```someMethod```

The ```selector``` is simply the method that is **selected** to be called on the corresponding class


