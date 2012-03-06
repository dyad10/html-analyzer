#define MIN3(a,b,c) (a < b ? \
    (a < c ? a : c) : \
    (b < c ? b : c))
 
int levenshtein(const void *s1, size_t l1,
    const void *s2, size_t l2, size_t nmemb,
    int (*comp)(const void*, const void*)) {
  int i, j;
  size_t len = (l1 + 1) * (l2 + 1);
  char *p1, *p2;
  unsigned int d1, d2, d3, *d, *dp, res;
 
  if (l1 == 0) {
    return l2;
  } else if (l2 == 0) {
    return l1;
  }
 
  d = (unsigned int*)malloc(len * sizeof(unsigned int));
 
  *d = 0;
  for(i = 1, dp = d + l2 + 1;
      i < l1 + 1;
      ++i, dp += l2 + 1) {
    *dp = (unsigned) i;
  }
  for(j = 1, dp = d + 1;
      j < l2 + 1;
      ++j, ++dp) {
    *dp = (unsigned) j;
  }
 
  for(i = 1, p1 = (char*) s1, dp = d + l2 + 2;
      i < l1 + 1;
      ++i, p1 += nmemb, ++dp) {
    for(j = 1, p2 = (char*) s2;
        j < l2 + 1;
        ++j, p2 += nmemb, ++dp) {
      if(!comp(p1, p2)) {
        *dp = *(dp - l2 - 2);
      } else {
        d1 = *(dp - 1) + 1;
        d2 = *(dp - l2 - 1) + 1;
        d3 = *(dp - l2 - 2) + 1;
        *dp = MIN3(d1, d2, d3);
      }
    }
  }
  res = *(dp - 2);
 
  dp = NULL;
  free(d);
  return res;
}
