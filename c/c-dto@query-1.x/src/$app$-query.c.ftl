<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4c.ftl" as modelbase4c>
<#if license??>
${c.license(license)}
</#if>

#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <stdlib.h>

#include "${app.name}-query.h"

<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>

/*!
** 创建【${modelbase.get_object_label(obj)}】查询对象。
*/
${namespace}_${obj.name}_query_p
${namespace}_${obj.name}_query_init(void)
{
  ${namespace}_${obj.name}_query_p ret = (${namespace}_${obj.name}_query_p)malloc(sizeof(${namespace}_${obj.name}_query_t));
  <#list obj.attributes as attr>
    <#assign attrType = modelbase4c.type_attribute_primitive(attr)>
    <#if attrType.length?? || attrType.name == "char*">
  ret->${modelbase4c.name_attribute_primitive(attr)}  = NULL;
  ret->${modelbase4c.name_attribute_primitive(attr)}0 = NULL;
  ret->${modelbase4c.name_attribute_primitive(attr)}1 = NULL;
  ret->${modelbase4c.name_attribute_primitive(attr)}2 = NULL;
    <#elseif attrType.name == "int" || attrType.name == "long" || attrType.name == "double">
  ret->${modelbase4c.name_attribute_primitive(attr)}  = 0;
  ret->${modelbase4c.name_attribute_primitive(attr)}0 = 0;
  ret->${modelbase4c.name_attribute_primitive(attr)}1 = 0;
    </#if>
    <#if attr.identifiable || attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum")>
  ret->${modelbase4c.name_attribute_primitive_plural(attr)} = NULL;
    </#if>
  </#list>
  ret->start = INT_MIN;
  ret->limit = INT_MIN;
  return ret;
}

/*!
** 释放【${modelbase.get_object_label(obj)}】查询对象。
*/
void
${namespace}_${obj.name}_query_free(${namespace}_${obj.name}_query_p ${obj.name})
{
  free(${obj.name});
}
</#list>