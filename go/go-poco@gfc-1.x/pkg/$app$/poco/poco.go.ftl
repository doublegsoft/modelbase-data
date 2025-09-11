<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4go.ftl" as modelbase4go>
<#if license??>
${go.license(license)}
</#if>
<#assign libname = app.name>
<#if libname?starts_with("lib")>
  <#assign libname = libname?substring(3)>
</#if>
package ${libname}
import (
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#assign found = false>
  <#list obj.attributes as attr>
    <#if attr.type.name == "time" || attr.type.name == "date" || attr.type.name == "datetime">
      <#assign found = true>
  "time"      
      <#break>
    </#if>
  </#list>
  <#if found><#break></#if>
</#list>
)
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  
/*!
** 【${modelbase.get_object_label(obj)}】
*/
type ${go.nameType(obj.name)} struct {
  <#list obj.attributes as attr>  
  /*!
  ** 【${modelbase.get_attribute_label(attr)}】
  */
  ${go.nameType(modelbase.get_attribute_sql_name(attr))} *${modelbase4go.type_attribute_primitive(attr)}
  </#list>
}
</#list>