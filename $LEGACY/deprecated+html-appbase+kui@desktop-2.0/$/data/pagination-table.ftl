<#macro print_json_object customObject>
  <#list customObject.type.getAttributeNames() as attrName>
    <#assign attrVal = customObject.type.getAttributeValue(attrName)>
    <#if attrVal?index_of('&') == 0>
      <#assign attrVal = attrVal?substring(1)>
      <#if attrVal?index_of('.') == -1>
    <#if customObject.type.name?index_of('tag') != -1>
    "${attrVal}":"${tatabase.string(2)}",
    <#elseif customObject.type.getAttributeValue('align')! == 'right'>
    "${attrVal}":${tatabase.number(10, 100)},
    <#else>
    "${attrVal}":"${tatabase.string(10)}",
    </#if>
      <#else>
        <#assign attrSubobj = attrVal?substring(0, attrVal?index_of('.'))>
        <#assign attrSubobjAttr = attrVal?substring(attrVal?index_of('.') + 1)>
    "${attrSubobj}": {"${attrSubobjAttr}":"${tatabase.string(10)}"},
      </#if>
    </#if>
  </#list>
</#macro>
{
  "total": 100,
  "data": [{
<#list customObject.children as child>
<@print_json_object customObject=child />
</#list>
    "0":0
  },{
<#list customObject.children as child>
<@print_json_object customObject=child />  
</#list>
    "0":0
  },{
<#list customObject.children as child>
<@print_json_object customObject=child />  
</#list>
    "0":0
  },{
<#list customObject.children as child>
<@print_json_object customObject=child />  
</#list>
    "0":0
  },{
<#list customObject.children as child>
<@print_json_object customObject=child />  
</#list>
    "0":0
  }]
}