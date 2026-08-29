<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${app.name?upper_case}_SQL_H__
#define __${app.name?upper_case}_SQL_H__

#include <stdlib.h>
#include "${app.name}-poco.h"
#include "${app.name}-query.h"

#ifdef __cplusplus
extern "C"
{
#endif

#define ${namespace?upper_case}_SQL_ERROR_SUCCESS                             0
#define ${namespace?upper_case}_SQL_ERROR_PRIMARY_KEY_NOT_FOUND               401101
#define ${namespace?upper_case}_SQL_ERROR_NO_COLUMN_UPDATE                    401102
#define ${namespace?upper_case}_SQL_ERROR_NO_OBJECT_SPECIFIED                 402101

typedef enum ${namespace}_sql_match_e
{
  EXACT,
  PREFIX,
  SUFFIX,
  GLOBAL
}
${namespace}_sql_match_e;
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  
  <#assign persistAttrs = []>
  <#list obj.attributes as attr>
    <#if !attr.persistenceName??><#continue></#if>
    <#assign persistAttrs += [attr]>
  </#list>
/*!
** 【${modelbase.get_object_label(obj)}】的语句。
*/
#define ${namespace?upper_case}_SQL_${obj.name?upper_case}_INSERT     "" \
    "insert into ${obj.persistenceName} (<#list persistAttrs as attr><#if attr.isLabelled("redefined")><#continue></#if><#if attr?index != 0>,</#if>${attr.persistenceName}</#list>)" \
    "values (<#list persistAttrs as attr><#if attr?index != 0>,</#if>?</#list>);"

#define ${namespace?upper_case}_SQL_${obj.name?upper_case}_DELETE     "" \
    "delete from ${obj.persistenceName} " \
    "where 1 = 1 "
</#list> 

/*!
** 查询结果对象。
*/
typedef struct ${namespace}_table_result_s 
{
  /*!
  ** 结果集列表头。
  */
  char**  labels;

  /*!
  ** 结果集列数据类型。
  */
  int*    types;

  /*!
  ** 结果集所有单元格值。
  */
  void**  values;

  /*!
  ** 行数量。
  */
  int     rows;

  /*!
  ** 列数量。
  */
  int     cols;
}
${namespace}_table_result_t;

typedef ${namespace}_table_result_t* ${namespace}_table_result_p;

/*!
**
*/
${namespace}_table_result_p
${namespace}_table_result_init(int cols);

/*!
**
*/
void
${namespace}_table_result_set_label(${namespace}_table_result_p, int col, const char* label);

/*!
**
*/
void
${namespace}_table_result_set_type(${namespace}_table_result_p, int col, int type);

/*!
**
*/
void
${namespace}_table_result_set_value(${namespace}_table_result_p, int row, int col, void* value, int size);

/*!
**
*/
void
${namespace}_table_result_free(${namespace}_table_result_p);

/*!
** 把以逗号“，”分隔的由多个值构成的字符串转换成in-statement形式的SQL语句。
** 比如：
**     a,b,c,d,e => 'a','b','c','d','e'
*/
char*
${namespace}_sql_str2in(const char* str);

/*!
** 把字符串转换成右模糊匹配。
** 比如：
**     a => '%a'
*/
char*
${namespace}_sql_str2like_r(const char* str);

/*!
** 把字符串转换成左模糊匹配。
** 比如：
**     a => 'a%'
*/
char*
${namespace}_sql_str2like_l(const char* str);

/*!
** 把字符串转换成全模糊匹配。
** 比如：
**     a => '%a%'
*/
char*
${namespace}_sql_str2like_g(const char* str);

/*!
** 获取对象或者字段对应的持久化名称。如果字段名称为NULL，则返回对象的持久化名称。
*/
int
${namespace}_sql_persistence_name(const char* objname, const char* attrname, char* persistence_name);
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

/*!
** 获得【${modelbase.get_object_label(obj)}】的SELECT SQL语句。
*/
int
${namespace}_sql_${obj.name}_select(${namespace}_${obj.name}_query_p ${obj.name}, char* sql_select, int* bind_count);
</#list>

#ifdef __cplusplus
}
#endif

#endif // __${app.name?upper_case}_SQL_H__
