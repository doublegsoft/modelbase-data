<#--
 ### 递归深度优先遍历（DFS）收集实体及其引用对象的所有物理属性。
 ### 支持自动检测并解析多层级引用关联，并直接以数组形式返回扁平化结果。
 ### <p>
 ### 针对 `date` 或 `datetime` 类型的属性，函数会自动将其拆分为年、月、日、时、分 
 ### 5 个虚拟时间粒度属性，并在生成的元数据中附带 `datePart` 字段，
 ### 便于分析型宽表（OBT）构建时间维度层次结构。
 ###
 ### @param obj
 ###        当前正在处理的实体或对象元数据定义
 ###
 ### @param currentPath
 ###        当前的深度引用路径节点数组，用于拼接出唯一的字段名前缀
 ###
 ### @param visited
 ###        已访问对象的记录映射集合，在 DFS 遍历中提供循环依赖保护
 ###
 ### @return
 ###        收集到的扁平化属性元数据序列。对于日期类型，会额外返回含有 `datePart`
 ###        键值（值分别为: year, month, day, hour, minute）的派生属性对象。
 -->
<#function collect_attributes_dfs obj currentPath visited>
  <#-- 1. 循环引用检测保护，如果已访问则终止递归并返回空序列 -->
  <#if visited[obj.name]??>
    <#return []>
  </#if>
  <#local localVisited = visited + {obj.name: true}>
  <#local accumulatedAttrs = []>

  <#-- 定义时间粒度的中文描述映射 -->
  <#local datePartLabels = {
    "year": "年",
    "month": "月",
    "day": "日",
    "hour": "时",
    "minute": "分"
  }>

  <#-- 2. 遍历当前对象的所有属性 -->
  <#list obj.attributes as attr>
    <#-- 判断该属性是否为关联/引用对象 -->
    <#local isReference = false>
    <#if attr.type.custom>
      <#local targetObj = model.findObjectByName(attr.type.name)!>
      <#if targetObj?? && targetObj?has_content>
        <#local isReference = true>
      </#if>
    </#if>

    <#if isReference>
      <#-- 情况 A: 引用属性。下钻递归 -->
      <#local nextPath = currentPath + [attr.persistenceName]>
      <#local childAttrs = collect_attributes_dfs(targetObj, nextPath, localVisited)>
      <#local accumulatedAttrs = accumulatedAttrs + childAttrs>
    <#else>
      <#-- 情况 B: 物理持久化叶子属性。执行收集 -->
      <#if attr.isLabelled("persistence")>
        <#-- 生成扁平化后的唯一字段命名规范，采用路径下划线连接 -->
        <#local pathTokens = []>
        <#list currentPath as pathNode>
          <#local pathTokens = pathTokens + [pathNode?lower_case]>
        </#list>
        <#if (pathTokens?size > 0) && pathTokens?last == attr.persistenceName?lower_case>
          <#local uniqueFieldName = pathTokens?join("_")>
        <#else>
          <#local uniqueFieldName = (pathTokens + [attr.persistenceName?lower_case])?join("_")>
        </#if>

        <#-- 获取属性描述，依次尝试 description、comment、label，若都为空则使用 attr.name -->
        <#local attrDesc = attr.getLabelledOption("name","label")!"">

        <#-- A. 收集原始字段（保留原始时间戳/日期类型，供精密查询使用） -->
        <#local baseAttrMeta = {
          "owner": obj,
          "attribute": attr,
          "path": currentPath,
          "uniqueName": uniqueFieldName,
          "type": attr.type.name,
          "description": attrDesc  <#-- 新增：原始物理字段的描述 -->
        }>
        <#local accumulatedAttrs = accumulatedAttrs + [baseAttrMeta]>

        <#-- B. 日期类型拆分：如果属性类型为 date 或 datetime，自动追加五个派生的时间粒度属性 -->
        <#if attr.type.name == "date" || attr.type.name == "datetime">
          <#local dateParts = ["year", "month", "day", "hour", "minute"]>
          <#list dateParts as part>
            <#local partMeta = {
              "owner": obj,
              "attribute": attr,
              "path": currentPath,
              "uniqueName": uniqueFieldName + "_" + part,
              "datePart": part,
              "type": "integer",
              "description": attrDesc + " (" + datePartLabels[part] + ")"  <#-- 新增：派生时间字段的描述（如：创建时间 (年)） -->
            }>
            <#local accumulatedAttrs = accumulatedAttrs + [partMeta]>
          </#list>
        </#if>
      </#if>
    </#if>
  </#list>
  <#return accumulatedAttrs>
</#function>
<#list model.objects as obj>
  <#if !obj.isLabelled("fact")><#continue></#if>
  <#assign paths = []>
  <#assign visited = {}>
  <#assign metaAttrs = collect_attributes_dfs(obj, paths, visited)>

${obj.name}< 
  <#list metaAttrs as metaAttr> 

  @name(label='${metaAttr.description}')
  @persistence(name='${metaAttr.uniqueName}')
  ${metaAttr.uniqueName}: ${metaAttr.type}<#if metaAttr?index != metaAttrs?size - 1>,</#if>
  </#list>
>  
</#list>