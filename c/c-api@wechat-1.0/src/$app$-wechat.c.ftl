<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>
#include <string.h>
#include <curl/curl.h>
#include "${app.name}-wechat.h"

#define ${namespace?upper_case}_WECHAT_HOST           "https://api.weixin.qq.com"

static size_t 
${namespace}_wechat_get_access_token_respond(void* ptr, size_t size, size_t nmemb, char* s)
{
  size_t new_len = 0;
  if (s == NULL)
  {
    new_len = size * nmemb + 1;
    s = (char*)malloc(new_len);
    strcpy(s, (char*)ptr);
  }
  else 
  {
    size_t len = strlen(s);
    new_len = len + size * nmemb + 1;
    s = realloc(s, new_len);
    strcat(s, (char*)ptr);
  }
  s[new_len] = '\0';

  return size*nmemb;
}

int
${namespace}_wechat_get_access_token(const char* appid, const char* secret, char** access_token)
{
  CURL *curl;
  CURLcode res;
  char url[8912] = {'\0'};
  char* resp =  NULL;

  sprintf(url, 
          ${namespace?upper_case}_WECHAT_HOST "/cgi-bin/token?grant_type=client_credential&appid=%s&secret=%s", 
          appid, 
          secret);

  curl = curl_easy_init();
  if(curl) 
  {
    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, ${namespace}_wechat_get_access_token_respond);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, resp);
 
    res = curl_easy_perform(curl);

    if(res != CURLE_OK)
      fprintf(stderr, "curl_easy_perform() failed: %s\n",
              curl_easy_strerror(res));

    curl_easy_cleanup(curl);
  }
  return 0;
}

int
${namespace}_wechat_get_pain_union_id(const char* access_token, const char* openid)
{
  CURL *curl;
  CURLcode res;
  char url[8912] = {'\0'};
  char* resp =  NULL;

  sprintf(url, 
          ${namespace?upper_case}_WECHAT_HOST "/wxa/getpaidunionid?access_token=%s&openid=%s", 
          access_token, 
          openid);

  curl = curl_easy_init();
  if(curl) 
  {
    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, ${namespace}_wechat_get_access_token_respond);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, resp);
 
    res = curl_easy_perform(curl);

    if(res != CURLE_OK)
      fprintf(stderr, "curl_easy_perform() failed: %s\n",
              curl_easy_strerror(res));

    curl_easy_cleanup(curl);
  }
  return 0;
}