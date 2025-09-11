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
type ${go.nameType(obj.name)}Query struct {
  <#assign processedAttrs = {}>
<@modelbase4go.print_object_query_members obj=obj processedAttrs=processedAttrs />  
}

func (self *${go.nameType(obj.name)}Query) to() map[string]interface{} {
  ret := make(map[string]interface{})
  <#assign processedAttrs = {}>
<@modelbase4go.print_object_query_to_map obj=obj processedAttrs=processedAttrs />
  return ret
}

func (self *${go.nameType(obj.name)}Query) from(data map[string]interface{}) {
  <#assign processedAttrs = {}>
<@modelbase4go.print_object_query_from_map obj=obj processedAttrs=processedAttrs />
}



</#list>