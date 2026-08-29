<#--
 ###############################################################################
 ### 获取属性的 SQLite 目标类型 (Get Attribute Type for SQLite)
 ### 
 ### 根据属性（attribute）的定义，分析并返回其映射到 SQLite 数据库的目标列类型。
 ### 映射规则如下：
 ###   - 整型 (int, integer, long) -> "integer"
 ###   - 数值型 (number)           -> "numeric"
 ###   - 自定义关联对象 (custom)     -> 递归解析该关联目标对象的主键（ID）类型并返回
 ###   - 其他类型 (默认)            -> "text"
 ### 
 ### @param attr  属性对象 (Attribute)
 ### @return      对应的 SQLite 目标类型名称字符串 (String)
 ###############################################################################
 -->
<#function type_attribute_sqlite attr>
  <#if attr.type.name == "int" || attr.type.name == "integer" || attr.type.name == "long">
    <#return "integer">
  <#elseif attr.type.name == "number">
    <#return "numeric">
  <#elseif attr.type.custom>
    <#local refObj = model.findObjectByName(attr.type.name)>
    <#local refObjIdAttr = modelbase.get_id_attributes(refObj)?first>
    <#return type_attribute_sqlite(refObjIdAttr)>
  <#else>
    <#return "text">
  </#if>
</#function>