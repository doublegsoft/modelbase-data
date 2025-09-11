<#import '/$/modelbase.ftl' as modelbase>

<#list model.objects as obj>
  <#if !obj.isLabelled('entity') || !obj.isLabelled('value')><#continue></#if>
type ${java.nameType(obj.name)} {

}
</#list>