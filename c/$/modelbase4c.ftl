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
      <#return {"name": "char*", "array": true}>
    <#else>
      <#return {"name": compType.name + "*", "array": true}>
    </#if>
  <#elseif attr.constraint.domainType?? && attr.constraint.domainType.name?starts_with("enum")>
    <#local pairs = typebase.enumtype(attr.constraint.domainType.name)>
    <#return {"name": "char","length":pairs[0].code?length}>
  <#elseif attr.type.name == "string">
    <#if attr.constraint.maxSize?? && attr.constraint.maxSize != 0>
      <#return {"name": "char", "length": attr.constraint.maxSize}>
    <#else>
      <#return {"name": "char*"}>
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
  <#elseif attr.type.custom>
    <#return {"name": namespace + "_" + attr.type.name + "_p"}>  
  </#if>
  <#return {"name": "char*"}>
</#function>

<#--
 ###############################################################################
 ### 获取属性的基础/原始目标类型 (Get Primitive Target Type for Attribute)
 ### 
 ### 分析属性（attribute）的定义，返回其最终映射的最底层原始/基础数据类型。
 ### 递归处理逻辑如下：
 ###   - 若为自定义关联对象 (custom) -> 递归解析该目标对象的主键（ID）属性并返回
 ###   - 若为普通基础数据类型         -> 调用 type_attribute(attr) 返回其目标类型
 ### 
 ### @param attr  属性对象 (Attribute)
 ### @return      对应的基础/原始目标类型映射结果 (Hash/String)
 ###############################################################################
 -->
<#function type_attribute_primitive attr>
  <#if attr.type.custom>
    <#local refObj = model.findObjectByName(attr.type.name)>
    <#local refObjIdAttr = modelbase.get_id_attributes(refObj)?first>
    <#return type_attribute_primitive(refObjIdAttr)>
  </#if>
  <#return type_attribute(attr)>
</#function>

<#--
 ###############################################################################
 ### 获取属性的目标变量名称 (Get Variable Name for Attribute)
 ### 
 ### 根据属性（attribute）的定义，分析并返回其映射到代码中的目标变量名称。
 ### 逻辑如下：
 ###   - 若为自定义关联对象 (custom) -> 直接返回其原始属性名称 (attr.name)
 ###   - 其他基础类型                 -> 获取其 SQL 字段名并转换为代码变量名格式
 ### 
 ### @param attr  属性对象 (Attribute)
 ### @return      对应的代码变量名称字符串 (String)
 ###############################################################################
 -->
<#function name_attribute attr>
  <#if attr.type.custom>
    <#return attr.name>  
  </#if>
  <#return c.nameVariable(modelbase.get_attribute_sql_name(attr))>
</#function>

<#--
 ###############################################################################
 ### 获取属性的基础/原始变量名称 (Get Primitive Variable Name for Attribute)
 ### 
 ### 绕过自定义对象的特殊命名逻辑，强制返回属性在物理数据库底层字段对应的
 ### 代码变量名称。通常用于获取主键/外键在底层物理存储上的变量名。
 ### 
 ### @param attr  属性对象 (Attribute)
 ### @return      对应的基础物理字段变量名称字符串 (String)
 ###############################################################################
 -->
<#function name_attribute_primitive attr>
  <#return c.nameVariable(modelbase.get_attribute_sql_name(attr))>
</#function>

<#--
 ###############################################################################
 ### 获取属性的基础/原始复数变量名称 (Get Primitive Plural Variable Name for Attribute)
 ### 
 ### 分析属性（attribute）的定义，并返回其映射到物理数据库底层复数形式（Plural）
 ### 的基础变量名称。通常用于处理一对多关系、集合字段，或复数化命名的物理字段，
 ### 并将其规范化为代码变量命名格式。
 ### 
 ### @param attr  属性对象 (Attribute)
 ### @return      对应的基础复数物理字段变量名称字符串 (String)
 ###############################################################################
 -->
<#function name_attribute_primitive_plural attr>
  <#return c.nameVariable(modelbase.get_attribute_plural_as_primitive(attr))>
</#function>

<#function type_attribute_as_argument attr>
  <#local domainType = attr.constraint.domainType.name>
  <#if domainType == "integer">
    <#return "int">
  <#else>
    <#return "const char*">
  </#if>
</#function>

<#--
 ### 获取属性在二进制序列化或内存布局中所占的字节数（或长度引用）。
 ### <p>
 ### 该函数用于 C/C++ 等底层语言的结构体（Struct）解析、网络协议封包/解包或内存分配。
 ### 它的返回值具有动态类型特征：
 ### 1. 静态大小: 返回 Integer (例如 4, 8, 256)，表示该字段占用固定的字节数。
 ### 2. 动态大小: 返回 String (例如 "->name_len")，表示该字段是一个指针，其实际长度由结构体中的另一个字段决定。
 ### 3. 集合类型: 隐式返回空，因为集合的长度通常需要通过循环或额外的方法计算。
 ###
 ### @param attr
 ###        待计算字节长度的属性定义对象 (AttributeDefinition)
 ### @param var
 ###        当前的变量上下文名（在本段代码中暂未使用，可能预留作后续扩展）
 ###
 ### @return
 ###        字节数 (Integer) 或 动态长度引用的 C 代码片段 (String)
 -->
<#function get_attribute_bytes attr var>
  <#local attrtype = type_attribute(attr)>
  <#if attr.type.collection && attr.type.countedName??>
    <#local len = get_primitive_bytes(attr.type.componentType.name)>
    <#if len != 0>
      <#return len?string + " * " + var + "->" + attr.type.countedName>
    <#else>
      <#return "0">
    </#if>  
  <#elseif attrtype.name == 'char'><#-- 定长字节 -->
    <#return attrtype.length?string>
  <#elseif attrtype.name == 'char*' && attr.type.lengthName??><#-- 变长字节，某个属性的值就是另一个属性的字节长度 -->
    <#return var + "->" + attr.type.lengthName>
  <#else>
    <#return get_primitive_bytes(attrtype.name)?string>
  </#if>
</#function>

<#--
 ### 获取基础数据类型（Primitive Type）在内存或序列化中所占的字节数。
 ### <p>
 ### 该函数根据传入的底层类型名称字符串，直接映射并返回其固定的物理字节大小。
 ### 常用于 C/C++ 结构体生成、网络底层协议封包（Packet）长度计算，或内存对齐偏移量计算。
 ###
 ### 映射规则 (Mapping Rules):
 ### - date/time/datetime -> 8 bytes (64位时间戳)
 ### - int/integer        -> 4 bytes (32位有符号整数)
 ### - long               -> 8 bytes (64位有符号整数)
 ### - char/bool          -> 1 byte
 ### - 其他未知类型默认兜底为 1 byte
 ###
 ### @param typename
 ###        基础数据类型的名称字符串 (例如 "int", "datetime", "bool")
 ###
 ### @return
 ###        该基础类型占用的固定字节数 (Integer)
 -->
<#function get_primitive_bytes typename>
  <#if typename == "date" || typename == "time" || typename == "datetime">
    <#return 8>
  <#elseif typename == 'char'>
    <#return 1>  
  <#elseif typename == "bool">
    <#return 1>
  <#elseif typename == "int" || typename == "integer">
    <#return 4>
  <#elseif typename == "long">
    <#return 8>
  <#else>
    <#return 0>
  </#if>
</#function>

<#--
 ### 获取用于表示属性长度或元素个数的关联字段名称。
 ### <p>
 ### 在底层数据结构（如 C 语言的 struct 或 TCP/IP 自定义协议包）中，
 ### 变长集合（List/Array）通常不能独立存在，它依赖于另一个特定的整型字段来指明其长度。
 ### 
 ### 逻辑流程 (Logic Flow):
 ### 1. 检查当前属性是否为集合类型，并且是否在元数据中显式定义了记录其长度的字段名 (countedName)。
 ### 2. 如果满足条件，回溯到当前属性的父对象（Parent Object）。
 ### 3. 遍历父对象的所有属性，寻找与 countedName 匹配的兄弟属性。
 ### 4. 【递归】找到长度属性后，对其再次调用本函数（支持多层别名或代理引用的极端场景）。
 ### 5. 【基线条件】如果不是集合、没有定义 countedName，或者递归触底，则直接返回属性自身的名称。
 ###
 ### 示例场景:
 ### struct Message {
 ###     int item_count;    // 长度字段
 ###     Item items[0];     // 集合字段 (countedName = "item_count")
 ### }
 ### 调用 get_attribute_counted_name(items) 将返回 "item_count"。
 ###
 ### @param attr
 ###        待解析的属性定义对象 (AttributeDefinition)
 ###
 ### @return
 ###        表示长度的关联字段名称 (String)。若无关联字段，则返回自身名称。
 -->
<#function get_attribute_counted_name attr>
  <#if attr.type.collection && attr.type.countedName??>
    <#local obj = attr.parent>
    <#list obj.attributes as objAttr>
      <#if objAttr.name == attr.type.countedName>
        <#return get_attribute_counted_name(objAttr)>
      </#if>
    </#list>
  </#if>
  <#return attr.name>
</#function>

