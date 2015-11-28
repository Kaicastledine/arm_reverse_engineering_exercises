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
