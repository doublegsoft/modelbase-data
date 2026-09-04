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
      <#return {"name": compType.name, "array": true}>
    </#if>
  <#elseif attr.constraint.domainType?? && attr.constraint.domainType.name?starts_with("enum")>
    <#local pairs = typebase.enumtype(attr.constraint.domainType.name)>
    <#return {"name": "char","length":pairs[0].code?length}>
  <#elseif attr.type.name == "string">
    <#if attr.constraint.maxSize?? && attr.constraint.maxSize != 0>
      <#return {"name": "char", "length": attr.constraint.maxSize}>
    <#elseif attr.type.lengthVariable??>
      <#return {"name": "char"}>
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
  <#elseif attr.type.name == "bit">
    <#if (attr.type.length <= 8)>
      <#return {"name":"char"}>
    <#elseif (attr.type.length <= 16)>
      <#return {"name":"short"}>
    <#elseif (attr.type.length <= 32)>
      <#return {"name":"int"}>
    <#elseif (attr.type.length <= 64)>
      <#return {"name":"long"}>
    <#else>
      <#return {"name":"char", "length": attr.type.length / 8}>
    </#if>
  <#elseif attr.type.name == "byte">
    <#if (attr.type.length <= 1)>
      <#return {"name":"char"}>
    <#elseif (attr.type.length <= 2)>
      <#return {"name":"short"}>
    <#elseif (attr.type.length <= 4)>
      <#return {"name":"int"}>
    <#elseif (attr.type.length <= 8)>
      <#return {"name":"long"}>
    <#else>
      <#return {"name":"char", "length": attr.type.length}>
    </#if>
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
  <#local attrType = type_attribute(attr)>
  <#if attr.type.collection && attr.type.lengthVariable??>
    <#local len = get_primitive_bytes(attr.type.componentType.name)>
    <#if len != 0>
      <#return len?string + " * " + var + "->" + attr.type.lengthVariable>
    <#else>
      <#return "0">
    </#if>  
  <#elseif attrType.name == "char"><#-- 定长字节 -->
    <#if attrType.length??>
      <#return attrType.length?string>
    <#elseif attr.type.lengthVariable??>
      <#return var + "->" + attr.type.lengthVariable>
    </#if>
    <#return "1">
  <#elseif attrType.name == "char*" && attr.type.lengthVariable??><#-- 变长字节，某个属性的值就是另一个属性的字节长度 -->
    <#return var + "->" + attr.type.lengthVariable>
  <#else>
    <#return get_primitive_bytes(attrType.name)?string>
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
  <#elseif typename == "short">
    <#return 2>
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
 ### 1. 检查当前属性是否为集合类型，并且是否在元数据中显式定义了记录其长度的字段名 (lengthVariable)。
 ### 2. 如果满足条件，回溯到当前属性的父对象（Parent Object）。
 ### 3. 遍历父对象的所有属性，寻找与 lengthVariable 匹配的兄弟属性。
 ### 4. 【递归】找到长度属性后，对其再次调用本函数（支持多层别名或代理引用的极端场景）。
 ### 5. 【基线条件】如果不是集合、没有定义 lengthVariable，或者递归触底，则直接返回属性自身的名称。
 ###
 ### 示例场景:
 ### struct Message {
 ###     int item_count;    // 长度字段
 ###     Item items[0];     // 集合字段 (lengthVariable = "item_count")
 ### }
 ### 调用 get_attribute_length_variable(items) 将返回 "item_count"。
 ###
 ### @param attr
 ###        待解析的属性定义对象 (AttributeDefinition)
 ###
 ### @return
 ###        表示长度的关联字段名称 (String)。若无关联字段，则返回自身名称。
 -->
<#function get_attribute_length_variable attr>
  <#if attr.type.lengthVariable??>
    <#local obj = attr.parent>
    <#list obj.attributes as objAttr>
      <#if objAttr.name == attr.type.lengthVariable>
        <#return get_attribute_length_variable(objAttr)>
      </#if>
    </#list>
  </#if>
  <#return attr.name>
</#function>

<#--
 ###############################################################################
 ### 获取单元测试模拟默认值 (Get Mock Default Value for Unit Testing)
 ### 
 ### 根据属性的数据类型生成对应的单元测试模拟初始值（Mock Value）。
 ### 用于在自动生成测试用例（如编解码测试）时，为各类基础数据类型（数值型、
 ### 定长字符数组、字符串指针、单字符以及指针/复杂对象）提供合法且具有代表性的测试数据。
 ### 
 ### @param attr  属性对象 (Attribute)
 ### @return      对应的 C 代码字面量测试值字符串 (String)，如 "88", "\"ABCD\"", "'K'", "NULL"
 ###############################################################################
 -->
<#function test_unit_value attr>
  <#local attrType = type_attribute(attr)>
  <#if attrType.name == "int" || attrType.name == "integer" || 
       attrType.name == "long" || attrType.name == "short" || 
       attrType.name == "double" || attrType.name == "float">
    <#if is_length_variable(attr)>
      <#return "3">
    <#else>    
      <#return "88">
    </#if>
  <#elseif attrType.name == "char" && attr.type.lengthVariable??>
    <#return '(char*)"ABC"'>
  <#elseif attrType.name == "char" && attrType.length??>
    <#return '(char*)"LMN"'>
  <#elseif attrType.name == "char*" >
    <#return '(char*)"XYZ"'>
  <#elseif attrType.name == "char">
    <#return "'K'">
  </#if>
  <#return 'NULL'>
</#function>

<#--
 ###############################################################################
 ### 判断属性是否为长度变量 (Check if Attribute is a Length Variable)
 ### 
 ### 检查当前属性是否被所属父对象（结构体/消息体）中的其他同级属性引用为长度标识字段。
 ### 常用于网络协议编解码（Codec）与二进制序列化场景，用以识别某个整数字段是否专门
 ### 用来指示后续变长字段（如动态字符串、字节流、变长数组）的数据长度。
 ### 
 ### @param attr  待检查的属性对象 (Attribute)
 ### @return      若当前属性作为其他字段的长度描述变量返回 true，否则返回 false (Boolean)
 ###############################################################################
 -->
<#function is_length_variable attr>
  <#if attr.parent?? && attr.parent.attributes??>
    <#list attr.parent.attributes as parentAttr>
      <#if parentAttr.type.lengthVariable?? && parentAttr.type.lengthVariable == attr.name>
        <#return true>
      </#if>
    </#list>
  </#if>
  <#return false>
</#function>

<#--
 ###############################################################################
 ### 根据长度变量名获取绑定的目标属性 (Get Target Attribute Using Specified Length Variable)
 ### 
 ### 在指定的数据对象（结构体/消息体）中进行反向查找，定位使用指定长度变量作为其数据
 ### 长度标识的目标属性。常用于协议编解码与代码生成场景，实现从长度字段（例如：`message_len`）
 ### 反查其所修饰的动态变长数据字段（例如：`message` 内容载荷）。
 ### 
 ### @param obj             包含属性列表的数据对象/模型实体 (Object / Entity)
 ### @param lengthVariable  长度描述变量的名称标识 (String)
 ### @return                绑定并使用该长度变量的目标属性对象；若未找到则返回 null (Attribute / null)
 ###############################################################################
 -->
<#function get_attribute_using_length_variable obj lengthVariable>
  <#list obj.attributes as attr>
    <#if attr.type.lengthVariable?? && attr.type.lengthVariable == lengthVariable>
      <#return attr>
    </#if>
  </#list>
</#function>