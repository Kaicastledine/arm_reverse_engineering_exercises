//
//  main.m
//  ObjcDevProj
//
//  Created by rotlogix on 11/28/15.
//  Copyright © 2015 rotlogix. All rights reserved.
//

#import <Foundation/Foundation.h>

void myFunction() {
    
    
    struct node {
        int x;
        struct node *next;
    };
    
    /** This will be the unchanging first node**/
    struct node *root; // Create a pointer to a struct node
    
    /** This will point to each node as it traverses the list**/
    struct node *conductor;
    
    root = malloc(sizeof(struct node));
    root->x = 5;
    root->next = malloc(sizeof(struct node));
    root->next->x = 6;
    root->next->next = NULL;

    conductor = root;
    
    if(conductor != 0) {
        while (conductor->next != 0) {
            conductor = conductor->next;
        }
    }
    
    /** Creates a node at the end of the list **/
    conductor->next = malloc(sizeof(struct node));
    conductor = conductor-> next;
    
    if (conductor == 0) {
        printf("[*] Out of memory!\n");
    }
    
    /** Initialize the new memory **/
    conductor->next = 0;
    conductor->x = 45;

    
}

int main(int argc, const char * argv[]) {
    
    printf("[*] Calling myfunction()\n");
    myFunction();
    return 0;
}
