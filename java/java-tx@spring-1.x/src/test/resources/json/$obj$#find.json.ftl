<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#assign collAttrs = []>
<#list obj.attributes as attr>
  <#if !attr.type.collection><#continue></#if>
  <#assign collAttrs += [attr]>
</#list>  
{
<#if collAttrs?size == 0> 
  "queryHandlers":[]
<#else>
  "queryHandlers":[]
  <#--  "queryHandlers":[{  -->
<#list collAttrs as attr>
  <#assign collObj = model.findObjectByName(attr.type.componentType.name)>
  <#list collObj.attributes as collObjAttr>
    <#if collObjAttr.type.name == obj.name>
      <#assign refAttrInCollObj = collObjAttr>
    </#if>
  </#list>
  <#if !refAttrInCollObj??>
    <#assign refAttrInCollObj = model.findObjectByName(attr.getLabelledOptions("conjunction")["name"])>
  </#if>
  <#if !refAttrInCollObj??><#continue></#if>
  <#if attr?index != 0>
  },{
  </#if>
    <#--  "handler": "//${collObj.name}/find",
    "sourceField": "${modelbase.get_attribute_sql_name(idAttrs[0])}",
    "targetField": "${modelbase.get_attribute_sql_name(refAttrInCollObj)}",
    "resultName": "${java.nameVariable(attr.name)}",
    "query": {}  -->
</#list>    
  <#--  }]  -->
</#if>  
}