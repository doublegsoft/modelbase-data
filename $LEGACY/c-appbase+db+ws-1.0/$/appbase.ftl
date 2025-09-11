
<#function type_attribute_as_argument attr>
  <#local domainType = attr.constraint.domainType.name>
  <#if domainType == "integer">
    <#return "int">
  <#else>
    <#return "const char*">
  </#if>
</#function>

<#function max_object_argument_length obj>
  <#local ret = 0>
  <#list obj.attributes as attr>
    <#local domainType = attr.constraint.domainType.name>
    <#local len = 0>
    <#if domainType == "integer">
      <#local len = "int"?length>
    <#else>
      <#local len = "const char*"?length>
    </#if>
    <#if (len > ret)>
      <#local ret = len>
    </#if>
  </#list>
  <#return ret>
</#function>

<#function get_select_attributes obj>
  <#local ret = []>
  <#list obj.attributes as attr>
    <#if attr.getLabelledOptions('persistence')['select']??>
      <#local ret = ret + [attr]>
    </#if>
  </#list>
  <#return ret>
</#function>

<#function get_update_attributes obj>
  <#local ret = []>
  <#list obj.attributes as attr>
    <#if attr.getLabelledOptions('persistence')['update']??>
      <#local ret = ret + [attr]>
    </#if>
  </#list>
  <#return ret>
</#function>

<#function get_delete_attributes obj>
  <#local ret = []>
  <#list obj.attributes as attr>
    <#if attr.getLabelledOptions('persistence')['delete']??>
      <#local ret = ret + [attr]>
    </#if>
  </#list>
  <#return ret>
</#function>

<#function get_levelled_attributes obj>
  <#local ret = []>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('primary')>
      <#local ret = ret + [attr]>
    <#elseif attr.isLabelled('secondary')>
      <#local ret = ret + [attr]>
    <#elseif attr.isLabelled('tertiary')>
      <#local ret = ret + [attr]>
    <#elseif attr.isLabelled('quaternary')>
      <#local ret = ret + [attr]>
    <#elseif attr.isLabelled('quinary')>
      <#local ret = ret + [attr]>
    <#elseif attr.isLabelled('senary')>
      <#local ret = ret + [attr]>
    <#elseif attr.isLabelled('septenary')>
      <#local ret = ret + [attr]>
    <#elseif attr.isLabelled('octonary')>
      <#local ret = ret + [attr]>
    <#elseif attr.isLabelled('nonary')>
      <#local ret = ret + [attr]>
    <#elseif attr.isLabelled('denary')>
      <#local ret = ret + [attr]>
    </#if>
  </#list>
  <#return ret>
</#function>

<#function is_duplicated_attribute_sql_name checking attrs>
  <#list attrs as attr>
    <#if modelbase.get_attribute_sql_name(attr) == modelbase.get_attribute_sql_name(checking)>
      <#return true>
    </#if>  
  </#list>
  <#return false>
</#function>

<#function get_reference_objects obj>
  <#local ret = {}>
  <#list obj.attributes as attr>
    <#if attr.type.custom>
      <#local objname = attr.type.name>
      <#local refObj = model.findObjectByName(objname)>
      <#local ret = ret + {attr.name: refObj}>
    </#if>  
  </#list>
  <#return ret>
</#function>

<#function get_reference_attribute attr>
  <#assign domainType = attr.constraint.domainType.name>
  <#assign typename = attr.type.name>
  <#assign attrname = domainType?substring(domainType?index_of('(') + 1, domainType?length - 1)>
  <#return model.findAttributeByNames(typename, attrname)>
</#function>