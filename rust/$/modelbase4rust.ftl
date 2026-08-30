<#--
 ###############################################################################
 ### 获取属性在 Rust 结构体中的字段名称 (Get Struct Field Name for Attribute)
 ### 
 ### 根据属性（attribute）的定义，分析并返回其在 Rust 结构体中的目标字段名。
 ### 特殊处理逻辑：
 ###   - 若属性名为 "type"（Rust 保留关键字） -> 返回原始标识符 "r#type"
 ###   - 若为自定义关联对象 (custom)            -> 直接返回其属性名称 (attr.name)
 ###   - 其他普通类型                         -> 转换为符合 Rust 命名规范的字段名
 ### 
 ### @param attr  属性对象 (Attribute)
 ### @return      对应的 Rust 结构体字段名称字符串 (String)
 ###############################################################################
 -->
<#function name_attribute attr>
  <#if attr.name == "type">
    <#return "r#type">
  </#if>
  <#if attr.type.custom>
    <#return attr.name>  
  </#if>
  <#return rust.nameVariable(modelbase.get_attribute_sql_name(attr))>
</#function>

<#--
 ###############################################################################
 ### 获取属性的基础/原始字段名称 (Get Primitive Field Name for Attribute)
 ### 
 ### 绕过自定义对象的命名逻辑，强制返回属性在物理数据库底层字段对应的基础
 ### 字段变量名称。通常用于获取主键/外键在底层物理存储上的变量名。
 ### 
 ### @param attr  属性对象 (Attribute)
 ### @return      对应的基础物理字段变量名称字符串 (String)
 ###############################################################################
 -->
<#function name_attribute_primitive attr>
  <#return rust.nameVariable(modelbase.get_attribute_sql_name(attr))>
</#function>

<#--
 ###############################################################################
 ### 获取属性的基础复数物理字段名称 (Get Primitive Plural Field Name for Attribute)
 ### 
 ### 分析属性的定义，并返回其映射到物理数据库底层复数形式（Plural）的基础
 ### 字段名称。通常用于处理一对多关系或集合属性的物理字段变量命名。
 ### 
 ### @param attr  属性对象 (Attribute)
 ### @return      对应的基础复数物理字段名称字符串 (String)
 ###############################################################################
 -->
<#function name_attribute_primitive_plural attr>
  <#return rust.nameVariable(modelbase.get_attribute_plural_as_primitive(attr))>
</#function>

<#--
 ###############################################################################
 ### 获取作为函数参数的属性数据类型 (Get Argument Type for Attribute)
 ### 
 ### 根据属性的域类型（Domain Type）定义，分析并返回其在 C 语言或 FFI
 ### 接口函数中作为输入参数时的目标数据类型（例如 "int" 或 "const char*"）。
 ### 
 ### @param attr  属性对象 (Attribute)
 ### @return      对应的 FFI/C 接口参数类型名称字符串 (String)
 ###############################################################################
 -->
<#function type_attribute_as_argument attr>
  <#local domainType = attr.constraint.domainType.name>
  <#if domainType == "integer">
    <#return "int">
  <#else>
    <#return "const char*">
  </#if>
</#function>