#include <stdio.h>

const int g_vec1[] = {1,2,3,4,5,6};
const int g_vec2[] = {2,3,4,5,6,7};

int scalar_product(const int* vec1, const int* vec2, size_t count) {
  int ans = 0;
  size_t i;
  for (i = 0; i < count; i++)
    ans += vec1[i] * vec2[i];
  return ans;
}

int main(void) {
  printf(
    "scalar product is: %d\n",
    scalar_product(g_vec1, g_vec2, sizeof(g_vec1) / sizeof(int))
  );
  return 0;
}
