<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${c.license(license)}
</#if>
#ifndef __${app.name?upper_case}_MYSQL_H__
#define __${app.name?upper_case}_MYSQL_H__

#include <mysql.h>
#include "${app.name}-poco.h"
#include "${app.name}-sql.h"

#ifdef __cplusplus
extern "C"
{
#endif

/*!
** 转义用户输入的内容，符合SQL的要求和安全。。
*/
const char*
${namespace}_mysql_escape_string(const char* user_input, ${namespace}_sql_match_e match);
<#list model.objects as obj>

/*!
** 插入【${modelbase.get_object_label(obj)}】数据。
*/
int
${namespace}_mysql_${obj.name}_insert(MYSQL*, ${namespace}_${obj.name}_query_p, char*);

/*!
** 更新【${modelbase.get_object_label(obj)}】数据。
*/
int
${namespace}_mysql_${obj.name}_update(MYSQL*, ${namespace}_${obj.name}_query_p, char*);

/*!
** 删除【${modelbase.get_object_label(obj)}】数据。
*/
int
${namespace}_mysql_${obj.name}_delete(MYSQL*, ${namespace}_${obj.name}_query_p, char*);

/*!
** 查询【${modelbase.get_object_label(obj)}】数据。
*/
int
${namespace}_mysql_${obj.name}_select(MYSQL*, ${namespace}_${obj.name}_query_p, char*, ${namespace}_table_result_p*);
</#list>

#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_MYSQL_H__