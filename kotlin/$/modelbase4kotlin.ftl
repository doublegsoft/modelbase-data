
<#--
 ###############################################################################
 ### 获取属性的 Kotlin 类型 (Get Attribute Type)
 ### 
 ### 根据属性（attribute）的定义，返回其对应的 Kotlin 类型名称。
 ### 会自动识别集合（Collection）类型并包装为 List<Type>。
 ### 
 ### @param attr  属性对象 (Attribute)
 ### @return      对应的 Kotlin 类型名称 (String)
 ###############################################################################
 -->
<#function type_attribute attr>
  <#-- 获取基本类型名称 -->
  <#local typeName = attr.type.name>
  <#if attr.type.custom>
    <#return java.nameType(attr.type.name) + "Query">
  <#elseif attr.type.collection>
    <#local compType = "Any">
    <#if attr.type.componentType??>
      <#local compType = java.nameType(attr.type.componentType.name)>
    </#if>
    <#return "List<" + compType + ">">
  <#else>
    <#return type_attribute_primitive(attr)>
  </#if>
</#function>

<#--
 ###############################################################################
 ### 获取属性的基础/原始类型 (Get Primitive Attribute Type)
 ### 
 ### 获取属性对应的基础 Kotlin 类型（若为集合，则返回其元素组件的类型）。
 ### 用于需要直接操作基础类型或排除集合包装的场景。
 ### 
 ### @param attr  属性对象 (Attribute)
 ### @return      基础 Kotlin 类型名称 (String)
 ###############################################################################
 -->
<#function type_attribute_primitive attr>
  <#local typeName = attr.type.name>

  <#-- 如果是集合，提取其内部的组件类型 -->
  <#if attr.type.collection?? && attr.type.collection && attr.type.componentType??>
    <#local typeName = attr.type.componentType.name>
  </#if>

  <#-- 标准类型映射 -->
  <#if typeName == "string" >
    <#return "String">
  <#elseif typeName == "int" || typeName == "integer" >
    <#return "Int">
  <#elseif typeName == "long" || typeName == "bigint">
    <#return "Long">
  <#elseif typeName == "double" || typeName == "float">
    <#return "Double">
  <#elseif typeName == "number">
    <#return "BigDecimal">
  <#elseif typeName == "boolean" || typeName == "bit">
    <#return "Boolean">
  <#elseif typeName == "date" || typeName == "datetime" || typeName == "time">
    <#return "Date">
  </#if>
  <#return "String">
</#function>