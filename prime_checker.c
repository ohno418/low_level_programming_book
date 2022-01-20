#include <stdio.h>

// returns 1 or 0.
int is_prime(unsigned long n) {
  unsigned long i;

  if (n < 2UL) return 0;
  if (n == 2UL) return 1;

  for (i = 2UL; i < n / 2UL + 1UL; i++)
    if (!(n % i)) return 0;

  return 1;
}

int main(void) {
  unsigned long input;
  scanf("%lu", &input);

  if (is_prime(input)) {
    printf("%lu is a prime.\n", input);
  } else {
    printf("%lu is not a prime.\n", input);
  }
  return 0;
}
