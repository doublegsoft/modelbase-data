<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include "${app.name}-pool.h"

#define ${namespace?upper_case}_POOL_OBTAIN_TIMEOUT                 3000

struct ${namespace}_pool_s
{

  int                   max;

  ${namespace}_pooled_proxy_p proxies;

  pthread_mutex_t       lock;

  ${namespace}_pooled_object_create      create;

  ${namespace}_pooled_object_validate    validate;

  ${namespace}_pooled_object_release     release;
};

struct ${namespace}_pooled_proxy_s
{

  bool  used;

  void* pooled_object;

};

${namespace}_pool_p
${namespace}_pool_init(int max, 
  ${namespace}_pooled_object_create    create,
  ${namespace}_pooled_object_validate  validate, 
  ${namespace}_pooled_object_release   release)
{
  if (max <= 0) 
    return NULL;
  ${namespace}_pool_p ret = (${namespace}_pool_p)malloc(sizeof(${namespace}_pool_t));
  ret->max = max;
  pthread_mutex_init(&ret->lock, NULL);

  ret->create = create;
  ret->validate = validate;
  ret->release = release;

  ret->proxies = (${namespace}_pooled_proxy_p)malloc(sizeof(${namespace}_pooled_proxy_t) * max);
  for (int i = 0; i < max; i++)
  {
    ret->proxies[i].used = false;
    if (ret->create != NULL)
      ret->proxies[i].pooled_object = ret->create();
  }
  return ret;
}

void*
${namespace}_pool_obtain(${namespace}_pool_p pool)
{
  int i = 0;
  int index;
  int residue = pool->max % 8;
  void* ret = NULL;
  
  while (ret == NULL)
  {
    for (i = 0; i < pool->max; i++)
    {
      pthread_mutex_lock(&pool->lock);
      if (pool->proxies[i].used == false)
      {
        pool->proxies[i].used = true;
        ret = pool->proxies[i].pooled_object;
      }
      pthread_mutex_unlock(&pool->lock);
      if (ret != NULL)
      {
        // TODO: VALIDATE
        break;
      }
    } 
  } 

  return ret;
}

/*!
**
*/
int
${namespace}_pool_release(${namespace}_pool_p pool, void* data)
{
  for (int i = 0; i < pool->max; i++)
  {
    if (pool->proxies[i].pooled_object == data)
    {
      pthread_mutex_lock(&pool->lock);
      pool->proxies[i].used = false;
      pthread_mutex_unlock(&pool->lock);
    }
  }
  return 0;
}

void
${namespace}_pool_free(${namespace}_pool_p pool)
{
  if (pool == NULL) return;
  pthread_mutex_destroy(&pool->lock);
  for (int i = 0; i < pool->max; i++)
  {
    if (pool->proxies[i].pooled_object != NULL)
    {
      if (pool->release != NULL)
        pool->release(pool->proxies[i].pooled_object);
      else
        free(pool->proxies[i].pooled_object);
    }
      
  }
  free(pool->proxies);
  free(pool);
}