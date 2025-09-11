<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/appbase.ftl" as appbase>
<#if license??>
${c.license(license)}
</#if>
#include "${app.name}-proto.h"

int main()
{
  return 0;
}