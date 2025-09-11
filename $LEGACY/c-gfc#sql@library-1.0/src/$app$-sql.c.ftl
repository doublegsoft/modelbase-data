<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/codebase.ftl" as codebase>
<#if license??>
${c.license(license)}
</#if>
#include "${app.name}-sql.h"

<#list model.objects as obj>

/*!
** 
*/
gfc_string_p
${app.name}_sql_insert_${obj.name}(gfc_map_p params)
{
  const char* sql = "";
  gfc_string_p ret = gfc_string_new(sql);

  return ret;
}

/*!
** 
*/
gfc_string_p
${app.name}_sql_update_${obj.name}(gfc_map_p params)
{
  const char* sql = "";
  gfc_string_p ret = gfc_string_new(sql);


  return ret;
}

/*!
** 
*/
gfc_string_p
${app.name}_sql_delete_${obj.name}(gfc_map_p params)
{
  const char* sql = "";
  gfc_string_p ret = gfc_string_new(sql);


  return ret;
}

/*!
** 
*/
gfc_string_p
${app.name}_sql_select_${obj.name}(gfc_map_p params)
{
  const char* select = 
    "select "
    "from ${obj.persistenceName} ";
  const char* where = "where 1 = 1";
  
  gfc_string_p ret = gfc_string_new(select);

  gfc_string_concat(ret, where);
  return ret;
}
</#list>

