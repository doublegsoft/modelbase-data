<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4c.ftl' as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include "${app.name}-pool.h"

void*   
${namespace}_int_create()
{
  return malloc(sizeof(int));
}

bool  
${namespace}_int_validate(void* mem)
{
  int* val = (int*)mem;
  return *val == 0;
}

void  
${namespace}_int_release(void* mem)
{
  free(mem);
}
 
void* ${namespace}_thread(void* arg) {
  ${namespace}_pool_p pool = (${namespace}_pool_p)arg;
  int* pval = (int*)${namespace}_pool_obtain(pool);
  printf("%u: %d\n", (unsigned int)pthread_self(), *pval);
  usleep(500 * 1000);
  ${namespace}_pool_release(pool, (void*)pval);
  return NULL;
}

int main(int argc, char* argv[])
{
  const int THREADS_NUMBER = 20;
  pthread_t threads[THREADS_NUMBER];

  ${namespace}_pool_p pool = ${namespace}_pool_init(10, ${namespace}_int_create, ${namespace}_int_validate, ${namespace}_int_release);

  for (int i = 0; i < THREADS_NUMBER; ++i) 
  {
    if (pthread_create(&threads[i], NULL, ${namespace}_thread, pool) != 0) 
    {
      fprintf(stderr, "Error creating thread %d\n", i);
      exit(EXIT_FAILURE);
    }
  }

  for (int i = 0; i < THREADS_NUMBER; ++i)
    pthread_join(threads[i], NULL);

  ${namespace}_pool_free(pool);
  return 0;
}
