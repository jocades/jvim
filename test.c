#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Linked List REPL

typedef struct Node {
    int value;
    struct Node *next;
} Node;


Node *create_node(int value) {
    Node *node = (Node *)malloc(sizeof(Node));
    (*node).value = value;
    node->next = NULL;
    return node;
}

void append(Node *head, int value) {
    Node *current = head;
    while (current->next != NULL) {
        current = current->next;
    }
    Node *node = create_node(value);
    current->next = node;
}

void prepend(Node *head, int value) {
    Node *node = create_node(value);
    node->next = head;
}

void walk(Node *head, void (*callback)(Node *)) {
    Node *current = head;
    while (current != NULL) {
        callback(current);
        current = current->next;
    }
}

void inspect(Node *node) {
    printf("Node: %p\n", node);
    printf("  value: %d\n", node->value);
    printf("  next: %p\n", node->next);
}

int streq(char *str, char *value) {
    return strcmp(str, value) == 0;
}


int main(int argc, char *argv[]) {
    for (int i = 0; i < argc; i++) {
        printf("argv[%d] = %s\n", i, argv[i]);
    }

    int size;

    if (argc < 2) {
        printf("Enter the size of the linked list: ");
        scanf("%d", &size);
    } else {
        size = atoi(argv[1]);
    }

    Node *head = NULL;

    for (int i = size; i > 0; i--) {
        Node *node = create_node(i);
        node->next = head;
        head = node;
    }

    // start repl
    char command[10];

    while (1) {
        printf("> ");
        scanf("%s", command);

        if (streq(command, "exit")) {
            break;
        } else if (streq(command, "help")) {
            printf("Commands:\n");
            printf("  exit\n");
            printf("  walk\n");
            printf("  help\n");

        } else if (streq(command, "walk")) {
            walk(head, inspect);
        } else if (streq(command, "append")) {
            printf("append\n");
        } else if (streq(command, "prepend")) {
            printf("prepend\n");
        } else if (streq(command, "pop")) {
            printf("pop\n");
        } else if (streq(command, "insert")) {
            printf("insert\n");
        } else if (streq(command, "delete")) {
            printf("delete\n");
        } else if (streq(command, "reverse")) {
            printf("reverse\n");


        } else {
            printf("Unknown command: %s\n", command);
        }
    }

    return 0;
}
