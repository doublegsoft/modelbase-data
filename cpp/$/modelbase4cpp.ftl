<#import "/$/modelbase.ftl" as modelbase>
<#--
 ###############################################################################
 ### 获取属性的 C/C++ 目标类型 (Get Attribute Type for C/C++)
 ### 
 ### 根据属性（attribute）的定义，分析并返回其映射到 C 语言的目标类型对象。
 ### 返回的哈希（Hash）对象中可能包含：
 ###   - name   : C 数据类型名称 (String)
 ###   - length : 字符数组的固定长度 (Integer) [可选]
 ###   - array  : 标识是否为集合/指针数组 (Boolean) [可选]
 ### 
 ### @param attr  属性对象 (Attribute)
 ### @return      对应的 C 目标类型哈希对象 (Hash)
 ###############################################################################
 -->
<#function type_attribute attr>
  <#if attr.type.collection>
    <#local compType = type_attribute({"type": attr.type.componentType, "constraint":{}})>
    <#if compType.name?contains("*")>
      <#return {"name": "std::string"}>
    <#else>
      <#return {"name": compType.name, "array": true}>
    </#if>
  <#elseif attr.constraint.domainType?? && attr.constraint.domainType.name?starts_with("enum")>
    <#local pairs = typebase.enumtype(attr.constraint.domainType.name)>
    <#return {"name": "char","length":pairs[0].code?length}>
  <#elseif attr.type.name == "string">
    <#if attr.constraint.maxSize?? && attr.constraint.maxSize != 0>
      <#return {"name": "char", "length": attr.constraint.maxSize}>
    <#elseif attr.type.lengthVariable??>
      <#return {"name": "std::string"}>
    <#else>
      <#return {"name": "std::string"}>
    </#if>
  <#elseif attr.type.name == "int" || attr.type.name == "integer">
    <#return {"name": "int"}>
  <#elseif attr.type.name == "long">
    <#return {"name": "long"}>  
  <#elseif attr.type.name == "number">
    <#return {"name": "double"}>    
  <#elseif attr.type.name == "date" || attr.type.name == "time" || attr.type.name == "datetime">
    <#return {"name": "char", "length": 20}>
  <#elseif attr.type.name == "bool">
    <#return {"name": "char", "length": 2}>
  <#elseif attr.type.name == "bit">
    <#if (attr.type.length <= 8)>
      <#return {"name":"uint8_t"}>
    <#elseif (attr.type.length <= 16)>
      <#return {"name":"uint16_t"}>
    <#elseif (attr.type.length <= 32)>
      <#return {"name":"uint32_t"}>
    <#elseif (attr.type.length <= 64)>
      <#return {"name":"uint64_t"}>
    <#else>
      <#return {"name":"char", "length": attr.type.length / 8}>
    </#if>
  <#elseif attr.type.name == "byte">
    <#if attr.type.lengthVariable??>
      <#return {"name":"std::unique_ptr<uint8_t[]>"}>
    <#elseif (attr.type.length <= 1)>
      <#return {"name":"uint8_t"}>
    <#elseif (attr.type.length <= 2)>
      <#return {"name":"uint16_t"}>
    <#elseif (attr.type.length <= 4)>
      <#return {"name":"uint32_t"}>
    <#elseif (attr.type.length <= 8)>
      <#return {"name":"uint64_t"}>
    <#else>
      <#return {"name":"char", "length": attr.type.length}>
    </#if>
  <#elseif attr.type.custom>
    <#return {"name": "std::vector<std::unique_ptr<" + cpp.nameType(attr.type.name) + ">>"}>  
  </#if>
  <#return {"name": "char*"}>
</#function>

<#--
 ### get re-assembling attribute type object.
 -->
<#--  <#function type_attribute attr>
  <#if attr.type.componentType??>
    <#return {"name": "std::vector<" + type_component(attr.type.componentType).name + ">*"}>
  </#if>
  <#return type_component(attr.type)>
</#function>  -->

<#function type_component type>
  <#if type.name == "any" || type.name == "any[]">
    <#return {"name": "std::any*"}>
  <#elseif type.name == "string">
    <#return {"name": "std::string"}>
  <#elseif type.name == "int" || type.name == "integer">
    <#return {"name": "int"}>
  <#elseif type.name == "date" || type.name == "time" || type.name == "datetime">
    <#return {"name": "std::string"}>
  <#elseif type.name == "bool">
    <#return {"name": "bool"}>
  <#elseif type.custom>
    <#return {"name": namespace + "::" + cpp.nameType(type.name) + "*"}>  
  </#if>
  <#return {"name": "std::string"}>
</#function>

<#--
 ### get struct field name of attribute.
 -->
<#function name_attribute attr>
  <#if attr.type.custom>
    <#return cpp.nameVariable(attr.name)>  
  </#if>
  <#return cpp.nameVariable(modelbase.get_attribute_sql_name(attr))>
</#function>

<#function name_attribute_primitive attr>
  <#return cpp.nameVariable(modelbase.get_attribute_sql_name(attr))>
</#function>

<#function name_attribute_primitive_plural attr>
  <#return cpp.nameVariable(modelbase.get_attribute_plural_as_primitive(attr))>
</#function>

<#function type_attribute_as_argument attr>
  <#local domainType = attr.constraint.domainType.name>
  <#if domainType == "integer">
    <#return "int">
  <#else>
    <#return "const char*">
  </#if>
</#function>
