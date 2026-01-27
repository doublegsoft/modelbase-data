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
  "queryHandlers":[{
<#list collAttrs as attr>
  <#assign collObj = model.findObjectByName(attr.type.componentType.name)>
  <#if attr.isLabelled("conjunction")>
    <#assign collObj = model.findObjectByName(attr.getLabelledOptions("conjunction")["name"])>
  </#if>
  <#list collObj.attributes as collObjAttr>
    <#if collObjAttr.type.name == obj.name>
      <#assign refAttrInCollObj = collObjAttr>
      <#break>
    </#if>
  </#list>
  <#if !refAttrInCollObj??>
    <#assign conjObj = model.findObjectByName(attr.getLabelledOptions("conjunction")["name"])>
    <#if attr.getLabelledOptions("conjunction")["attribute"]??>
      <#assign refAttrInCollObj = model.findAttributeByNames(conjRefObj.name, attr.getLabelledOptions("conjunction")["attribute"])>
    <#else>
      <#list conjObj.attributes as conjObjAttr>
        <#if conjObjAttr.type.name == obj.name>
          <#assign refAttrInCollObj = conjObjAttr>
          <#break>
        </#if>
      </#list>  
    </#if>
  </#if>
  <#if !refAttrInCollObj??><#continue></#if>
  <#if attr?index != 0>
  },{
  </#if>
    <#-- TODO -->
    "handler": "//${collObj.name}/find",
    "sourceField": "${modelbase.get_attribute_sql_name(idAttrs[0])}",
    "targetField": "${modelbase.get_attribute_sql_name(refAttrInCollObj)}",
    "resultName": "${java.nameVariable(attr.name)}",
    "query": {}
</#list>    
  }]
</#if>  
}