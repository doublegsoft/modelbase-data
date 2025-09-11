<#import "/$/modelbase.ftl" as modelbase>
<#if license??>
${c.license(license)}
</#if>

#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <time.h>

#include "${app.name}-util.h"

int
${namespace}_util_datetime_from_millis(long millis, char* datetime)
{
  time_t secs = millis / 1000;
  struct tm* gmt = gmtime(&secs);
  strftime(datetime, sizeof(datetime), "%Y-%m-%d %H:%M:%S", gmt);
  return 0;
}