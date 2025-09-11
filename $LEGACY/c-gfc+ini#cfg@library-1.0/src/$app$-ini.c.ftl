<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/appbase.ftl" as appbase>
<#if license??>
${c.license(license)}
</#if>


#include "${app.name}-ini.h"

struct ${app.name}_ctx_s
{

};

static int 
${app.name}_ini_handle(void* user, const char* section, const char* name,
                   const char* value)
{
  ${app.name}_ctx_p conf = (${app.name}_ctx_p) user;

  #define MATCH(s, n) strcmp(section, s) == 0 && strcmp(name, n) == 0
  if (MATCH("protocol", "version")) {
    conf->version = atoi(value);
  } else if (MATCH("user", "name")) {
    conf->name = strdup(value);
  } else if (MATCH("user", "email")) {
    conf->email = strdup(value);
  } else {
    return 0;  /* unknown section/name, error */
  }
  return 1;
}
