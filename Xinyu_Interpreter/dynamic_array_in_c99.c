/* This example shows how dynamic-sized array will effect the performance
 * The .s file is the corresponding assembly code with some comments for key
 * code
 */
#include <stdio.h>

void f(int n){
  int i;
  int arr[n];

  arr[0] = arr[1] = 1;
  for(i = 2; i < n; i ++){
    arr[i] = arr[i - 1] + arr[i - 2];
  }
  printf("%d\n", arr[n - 1]);
}

int main(){
  int n;
  scanf("%d", &n);
  f(n);
  return 0;
}
