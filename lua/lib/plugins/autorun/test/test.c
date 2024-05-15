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

int pop(Node *head) {
  int value;

  if (head->next == NULL) {
    value = head->value;
    free(head);
    return value;
  }

  Node *current = head;
  while (current->next->next != NULL) {
    current = current->next;
  }

  value = current->next->value;
  free(current->next);
  current->next = NULL;

  return value;
}

int shift(Node **head) {
  Node *node = *head;
  int value = node->value;
  *head = node->next;
  free(node);
  return value;
}

int delete(Node **head, int index) {
  Node *current = *head;

  for (int i = 0; i < index - 1; i++) {
    if (current->next == NULL) {
      return -1;
    }
    current = current->next;
  }

  Node *node = current->next;
  int value = node->value;
  current->next = node->next;
  free(node);

  return value;
}

void insert(Node *head, int index, int value) {
  Node *current = head;

  for (int i = 0; i < index - 1; i++) {
    if (current->next == NULL) {
      printf("Index out of bounds: %d\n", i);
      return;
    }
    current = current->next;
  }

  Node *node = create_node(value);
  node->next = current->next;
  current->next = node;
}

void walk(Node *head, void (*callback)(Node *, int)) {
  Node *current = head;
  int i = 0;
  while (current != NULL) {
    callback(current, i);
    i++;
    current = current->next;
  }
}

void inspect(Node *node, int i) {
  printf("(%d) Node: %p\n", i, node);
  printf("  value: %d\n", node->value);
  printf("  next: %p\n", node->next);
}

int streq(char *str, char *value) { return strcmp(str, value) == 0; }

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
      printf("  help\n");
      printf("  walk\n");
      printf("  append\n");
      printf("  prepend\n");
      printf("  pop\n");
      printf("  shift\n");
      printf("  insert\n");
      printf("  delete\n");
      printf("  reverse\n");

    } else if (streq(command, "walk")) {
      walk(head, inspect);
    } else if (streq(command, "append")) {
      char value[10];
      printf("Enter value: ");
      scanf("%s", value);
      append(head, atoi(value));
    } else if (streq(command, "prepend")) {
      char value[10];
      printf("Enter value: ");
      scanf("%s", value);
      prepend(head, atoi(value));
    } else if (streq(command, "pop")) {
      pop(head);
    } else if (streq(command, "shift")) {
      shift(&head);
    } else if (streq(command, "insert")) {
      char index[10];
      printf("Enter index: ");
      scanf("%s", index);
      char value[10];
      printf("Enter value: ");
      scanf("%s", value);
      insert(head, atoi(index), atoi(value));
    } else if (streq(command, "delete")) {
      char index[10];
      printf("Enter index: ");
      scanf("%s", index);
      delete (&head, atoi(index));
    } else if (streq(command, "reverse")) {
      printf("reverse\n");

    } else {
      printf("Unknown command: %s\n", command);
    }
  }

  return 0;
}
