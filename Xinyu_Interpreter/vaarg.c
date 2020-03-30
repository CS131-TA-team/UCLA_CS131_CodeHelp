/* This example shows how va_arg works
 */
#include <stdio.h>
#include <stdarg.h>
#include <stdbool.h>

/* Print Types */
#define PRINT_INT 0
#define PRINT_BOOL 1
#define PRINT_UINT64 2
#define PRINT_STR 3

void print_all(int n, ...){
  va_list vl;
  int i;
  int argType;
  int iVal;
  bool bVal;
  unsigned long long ullVal;
  char* szVal;
  
  printf("The variables are: ");
  va_start(vl, n);
  for(i = 0; i < n; i ++){
    argType = va_arg(vl, int);
    switch (argType) {
    case PRINT_INT:
      iVal = va_arg(vl, int); /* 4B */
      printf("%d ", iVal);
      break;
    case PRINT_BOOL:
      bVal = (bool)va_arg(vl, int); /* The minimum size of a va_arg is 4B. */
      printf(bVal ? "TRUE " : "FALSE ");
      break;
    case PRINT_UINT64:
      ullVal = va_arg(vl, unsigned long long); /* 8B */
      printf("%llu ", ullVal);
      break;
    case PRINT_STR:
      szVal = va_arg(vl, char*); /* 4B or 8B, unknown */
      printf("%s ", szVal);
      break;
    default:
      break;
    }
  }
  va_end(vl);
  printf("\n");
}

int main(){
  print_all(4, PRINT_BOOL, true, PRINT_INT, 3, PRINT_UINT64, 999, PRINT_STR, "hello");
  return 0;
}
