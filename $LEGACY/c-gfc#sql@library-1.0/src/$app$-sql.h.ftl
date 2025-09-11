<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/codebase.ftl" as codebase>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${app.name?upper_case}_SQL_H__
#define __${app.name?upper_case}_SQL_H__

#include <stdio.h>
#include <gfc.h>

#ifdef __cplusplus
extern "C"
{
#endif
<#list model.objects as obj>

/*!
** 
*/
gfc_string_p
${app.name}_sql_insert_${obj.name}(gfc_map_p params);

/*!
** 
*/
gfc_string_p
${app.name}_sql_update_${obj.name}(gfc_map_p params);

/*!
** 
*/
gfc_string_p
${app.name}_sql_delete_${obj.name}(gfc_map_p params);

/*!
** 
*/
gfc_string_p
${app.name}_sql_select_${obj.name}(gfc_map_p params);
</#list>

#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_SQL_H__
