<#--
 ###############################################################################
 ### 生成测试用 JSON 属性值 (Generate Test JSON Value for Attribute)
 ### 
 ### 根据实体属性（attribute）的类型定义、域约束（Domain Type）及标签注解，
 ### 构造并返回用于单元测试或 Mock 数据的合法 JSON 格式字面量值。
 ### 
 ### 映射与生成规则如下：
 ###   - 枚举类型 (enum)           -> 从枚举字典中获取有效枚举编码字符串 (例如: "ENABLE")
 ###   - 主键/标识符 (id/identifiable) -> 生成 0~100 范围内的随机数字符串 (例如: "42")
 ###   - JSON 结构类型 (json)       -> 返回空 JSON 对象字面量: {}
 ###   - 状态类型 (state)          -> 返回默认状态编码字符串: "E"
 ###   - 外键引用 (reference=id)   -> 返回模拟关联主键 ID: "123456"
 ###   - 布尔型 (bool)             -> 返回布尔值字符串: "true"
 ###   - 浮点数值型 (number)        -> 生成 0~100 范围内的随机浮点数字符串
 ###   - 整型 (int, integer)       -> 返回固定整数字符串: "36"
 ###   - 长整型 (long)             -> 返回固定长整数字符串: "63"
 ###   - 日期/时间型 (date, datetime) -> 生成当前格式化日期时间字符串
 ###   - 集合/列表型 (collection)   -> 返回空 JSON 数组字面量: []
 ###   - 字符串类型 (string)        -> 根据字段最大长度按比例动态生成随机文本
 ###   - 自定义关联对象 (custom)     -> 返回固定模拟对象 ID: "654321"
 ###   - 其他未匹配类型 (默认)      -> 返回默认固定占位值: "666666"
 ### 
 ### @param attr  实体属性元数据对象 (Attribute)
 ### @return      符合 JSON 语法格式的模拟值字符串 (String)
 ###############################################################################
 -->
<#function test_json_value attr>
  <#assign Timestamp = statics['java.sql.Timestamp']>
  <#assign Date = statics['java.sql.Date']>
  <#if attr.constraint.domainType.name?contains('enum')>
    <#return '"' + tatabase.enumcode(attr.constraint.domainType.name) + '"'>
  <#elseif attr.constraint.domainType.name == 'id' || attr.name == 'id' || attr.type.custom || attr.identifiable>
    <#local val = tatabase.number(0,100)>
    <#local val = val?substring(0, val?index_of("."))>
    <#return "\"" + val + "\"">
  <#elseif attr.constraint.domainType.name == 'json'>
    <#return '{}'>
  <#elseif attr.constraint.domainType.name == 'state'>
    <#return '"E"'>
  <#elseif attr.isLabelled("reference") && attr.getLabelledOptions("reference")["value"] == "id">
    <#return '"123456"'>  
  <#elseif attr.type.name == 'bool'>
    <#return '"true"'>
  <#elseif attr.type.name == 'number'>
    <#return '"' + tatabase.number(0,100) + '"'>
  <#elseif attr.type.name == 'integer' || attr.type.name == 'int'>
    <#return '"36"'>
  <#elseif attr.type.name == 'long'>
    <#return '"63"'>
  <#elseif attr.type.name == 'date'>
    <#return '"' + tatabase.datetime() + '"'>
  <#elseif attr.type.name == 'datetime'>
    <#return '"' + tatabase.datetime() + '"'>
  <#elseif attr.type.custom>
    <#return '"654321"'>
  <#elseif attr.type.collection>
    <#return '[]'>
  <#elseif attr.type.name == 'string'>
    <#return '"' + tatabase.string((attr.type.length!12)/4) + '"'>  
  <#else>
    <#return '"666666"'>
  </#if>
</#function>