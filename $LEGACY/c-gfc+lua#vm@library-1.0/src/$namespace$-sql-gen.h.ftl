<#import '/$/paradigm-internal.ftl' as internal>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${c.nameConstant(namespace)}_SQL_GEN_H__
#define __${c.nameConstant(namespace)}_SQL_GEN_H__

#ifdef __cplusplus
extern "C"
{
#endif

#include <string.h>

const char* ${c.nameConstant(namespace)}_SQL_TODO = "select 1";

<#assign sqlCount = 0>
<#list model.objects as obj>
  <#if !obj.isLabelled('persistence')><#continue></#if>
  <#assign sqlCount = sqlCount + 1>
  <#assign idAttrs = internal.get_id_attributes(obj)>
  <#assign attrRows = []>
  <#assign attrRow = []>
  <#assign attrCount = 0>
  <#list obj.attributes as attr>
    <#if !attr.persistenceName??><#continue></#if>
    <#assign attrRow = attrRow + [attr]>
    <#assign attrCount = attrCount + 1>
    <#if attrRow?size % 8 == 0>
      <#assign attrRows = attrRows + [attrRow]>
      <#assign attrRow = []>
    </#if>
  </#list>
  <#if attrRow?size != 0>
    <#assign attrRows = attrRows + [attrRow]>
  </#if>
/*!
** the insert sql to create a ${obj.name} entity object.
*/
const char* ${c.nameConstant(namespace)}_SQL_${c.nameConstant(obj.name)}_CREATE =
    "insert into ${obj.persistenceName} ("
  <#assign attrIndex = 0>
  <#list attrRows as attrRow>
    "  <#list attrRow as attr>${attr.persistenceName}<#if attrIndex != attrCount - 1>, </#if><#assign attrIndex = attrIndex + 1></#list>"
  </#list>
    ") values ("
  <#assign attrIndex = 0>
  <#list attrRows as attrRow>
    "  <#list attrRow as attr>{{{${attr.persistenceName?lower_case}}}}<#if attrIndex != attrCount - 1>, </#if><#assign attrIndex = attrIndex + 1></#list> "
  </#list>
    ")";

/*!
** the update sql to update a ${obj.name} entity object.
*/
const char* ${c.nameConstant(namespace)}_SQL_${c.nameConstant(obj.name)}_UPDATE =
    "update ${obj.persistenceName} "
    <#assign attrIndex = 0>
    <#list attrRows as attrRow>
    "<#if attrRow?index == 0>set    <#else>       </#if><#list attrRow as attr>${attr.persistenceName} = {{{${attr.persistenceName?lower_case}}}}<#if attrIndex != attrCount - 1>, </#if><#assign attrIndex = attrIndex + 1></#list> "
    </#list>
    "where  <#list idAttrs as idAttr><#if idAttr?index != 0> and </#if>${idAttr.persistenceName} = {{{${idAttr.persistenceName?lower_case}}}}</#list>";

/*!
** the delete sql to delete a ${obj.name} entity object.
*/
const char* ${c.nameConstant(namespace)}_SQL_${c.nameConstant(obj.name)}_DELETE =
    "delete from ${obj.persistenceName} \n"
    "where  <#list idAttrs as idAttr><#if idAttr?index != 0> and </#if>${idAttr.persistenceName} = {{{${idAttr.persistenceName?lower_case}}}}</#list>\n";

/*!
** the select sql to find ${obj.name} entity objects.
*/
const char* ${c.nameConstant(namespace)}_SQL_${c.nameConstant(obj.name)}_FIND =
    <#assign attrIndex = 0>
    <#list attrRows as attrRow>
    "<#if attrRow?index == 0>select <#else>       </#if><#list attrRow as attr>${attr.persistenceName}<#if attrIndex != attrCount - 1>, </#if><#assign attrIndex = attrIndex + 1></#list> "
    </#list>
    "from   ${obj.persistenceName} "
    "where  1 = 1 "
  <#list idAttrs as idAttr>
    "{{{#${idAttr.persistenceName?lower_case}}}}"
    "and    ${idAttr.persistenceName} = {{{${idAttr.persistenceName?lower_case}}}} "
    "{{{/${idAttr.persistenceName?lower_case}}}}"<#if idAttr?index == idAttrs?size - 1>;</#if>
  </#list>

</#list>
<#list model.objects as obj>
  <#if !obj.isLabelled('sql')><#continue></#if>
  <#list obj.attributes as attr>
    <#if !attr.isLabelled('sql')><#continue></#if>
    <#assign sqlCount = sqlCount + 1>
    <#assign opts = attr.getLabelledOptions('sql')>
    <#assign sql = codegen4sql.codegen(opts['model'], attr.text, model)>
    
/*!
** ${attr.text}.
*/
const char* ${c.nameConstant(namespace)}_SQL_${c.nameConstant(sql.id)} =
    <#assign sqlstr = sql.sql?replace('${', '{{{')?replace('}', '}}}')>
    <#assign lines = sqlstr?split('\n')>
    <#assign prev = {'param': '', 'line': '', 'start': '-1'}>
    <#list lines as line>
      <#assign prev = internal.freemarker_to_mustache(line?trim, prev)>
    "${prev.line?trim} \n"<#if line?index == lines?size - 1>;</#if>
    </#list>

  </#list>
</#list>

#define GM_GEN_COUNT      ${sqlCount * 2}

const char* GM_GEN_SQLS[GM_GEN_COUNT];

void
${c.nameNamespace(namespace)}_sql_init()
{
  int i = 0;
<#list model.objects as obj>
  <#if !obj.isLabelled('persistence')><#continue></#if>
  GM_GEN_SQLS[i++] = "${c.nameConstant(namespace)}_SQL_${c.nameConstant(obj.name)}_FIND";
  GM_GEN_SQLS[i++] = ${c.nameConstant(namespace)}_SQL_${c.nameConstant(obj.name)}_FIND;
</#list>
<#list model.objects as obj>
  <#if !obj.isLabelled('sql')><#continue></#if>
  <#list obj.attributes as attr>
    <#if !attr.isLabelled('sql')><#continue></#if>
      <#assign opts = attr.getLabelledOptions('sql')>
      <#assign sql = codegen4sql.codegen(opts['model'], attr.text, model)>
  GM_GEN_SQLS[i++] = "${c.nameConstant(namespace)}_SQL_${c.nameConstant(sql.id)}";
  GM_GEN_SQLS[i++] = ${c.nameConstant(namespace)}_SQL_${c.nameConstant(sql.id)};
  </#list>
</#list>
  GM_GEN_SQLS[i++] = "${c.nameConstant(namespace)}_SQL_TODO";
  GM_GEN_SQLS[i++] = ${c.nameConstant(namespace)}_SQL_TODO;
}

#ifdef __cplusplus
}
#endif

#endif // __${c.nameConstant(namespace)}_SQL_GEN_H__
