#include <stdio.h>
#include <malloc.h>

struct list {
  int value;
  struct list *next;
};

struct list *list_create(int value) {
  struct list *l = malloc(sizeof(struct list));
  l->value = value;
  return l;
}

void list_add_front(int value, struct list **lst) {
  struct list *new_node = list_create(value);
  new_node->next = *lst;
  *lst = new_node;
}

void list_add_back(int value, struct list **lst) {
  if (!(*lst)) {
    struct list *node = list_create(value);
    node->next = NULL;
    *lst = node;
    return;
  }

  struct list *last_node;
  for (last_node = *lst; last_node->next; last_node = last_node->next);
  last_node->next = list_create(value);
}

// Return NULL if out of index.
struct list *list_node_at(struct list *lst, int idx) {
  int i = 0;
  for (struct list *node = lst; node; node = node->next) {
    if (i == idx)
      return node;
    ++i;
  }
  return NULL;
}

// Return 0 if out of index.
int list_get(struct list *lst, int idx) {
  struct list *node = list_node_at(lst, idx);
  if (!node)
    return 0;
  else
    return node->value;
}

void list_free(struct list *lst) {
  free(lst);
}

int list_length(struct list *lst) {
  int len = 0;
  for (struct list *node = lst; node; node = node->next) ++len;
  return len;
}

int list_sum(struct list *lst) {
  int sum = 0;
  for (struct list *e = lst; e; e = e->next)
    sum += e->value;
  return sum;
}

// debug
void print_list(struct list *lst) {
  printf("[debug] ");
  for (struct list *n = lst; n; n = n->next)
    printf("%d, ", n->value);
  printf("\n");
}

struct list *read_list(int sz) {
  int value;
  struct list *lst = NULL;
  printf("Input %d numbers:\n", sz);
  for (int i = 0; i < sz; ++i) {
    scanf("%d", &value);
    list_add_front(value, &lst);
  }
  return lst;
}

int main(void) {
  int sz;
  printf("Input list size: ");
  scanf("%d", &sz);

  struct list *lst = read_list(sz);
  printf("sum: %d\n", list_sum(lst));
  list_free(lst);
  return 0;
}
