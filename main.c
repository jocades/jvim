
#include <stdio.h>

typedef struct {
  char *name;
  int age;
} User;

void do_smth(User *user) {
  printf("Hello, %s\n", (*user).name);
  (*user).age += 1;
}

typedef enum {
  MALE,
  FEMALE,
} Sex;

int main() {
  User users[2] = {
      [MALE] = {.name = "John", .age = 10},
      [FEMALE] = {.name = "Jane", .age = 20},
  };

  for (int i = 0; i < 2; i++) {
    printf("Name: %s, Age: %d\n", users[i].name, users[i].age);
    do_smth(&users[i]);
    printf("Name: %s, Age: %d\n", users[i].name, users[i].age);
  }

  return 0;
}
