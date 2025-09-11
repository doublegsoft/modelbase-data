<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/appbase.ftl" as appbase>

<#function collect_references obj holder>
	<#local ret = []>
	<#local ret = ret + holder>
	<#assign existingObjs = existingObjs + {obj.name: obj}>
	<#list obj.attributes as attr>
		<#if modelbase.is_attribute_system(attr)><#continue></#if>
		<#assign existingAttrs = existingAttrs + {attr.name: attr}>
		<#if attr.type.custom>
			<#local refObj = model.findObjectByName(attr.type.name)>
			<#if !existingObjs[refObj.name]??>
				<#local ret = ret + [refObj]>
				<#local ret = collect_references(refObj, ret)>
			</#if>>
		</#if>
	</#list>
	<#return ret>
</#function>

<#-- 事实表的所有引用的对象 -->
<#assign existingObjs = {}>
<#-- 事实表的所有的属性 -->
<#assign existingAttrs = {}>
<#-- 避免属性的重复出现 -->
<#assign existingFactAttrs = {}>
<#assign refObjs = []>
<#assign refObjs = refObjs + collect_references(entity, refObjs)>
<#assign attrIds = modelbase.get_id_attributes(entity)>

final String sql = 
  "select " +
<#list entity.attributes as attr>
  <#if !attr.persistenceName??><#continue></#if>
  "${attr.persistenceName}, " + 
</#list>  
  "0 " +    
  "from ${entity.persistenceName} ${modelbase.get_object_sql_alias(entity)} " + 
  "where ${modelbase.get_object_sql_alias(entity)}.lmt > '${r"${"}${r"}"}'"

Map<String, String> row = new HashMap<>()  
<#list refObjs as refObj>
  <#assign refObjAttrId = modelbase.get_id_attributes(refObj)[0]>
Set<String> ${java.nameVariable(modelbase.get_attribute_sql_name(refObjAttrId))}List = new HashSet<>()
</#list>

List<ObjectMap> extract(<#list attrIds as attrId><#if attrId?index != 0>,</#if>List<${modelbase.type_attribute(attrId)}> ${modelbase.get_attribute_sql_name(attrId)}List</#list>) {
  List<ObjectMap> ret = new ArrayList<>()
  SqlParams sqlParams = new SqlParams()
<#list attrIds as attrId>  
  sqlParams.set("${modelbase.get_attribute_sql_name(attrId)}s", ${modelbase.get_attribute_sql_name(attrId)}List)
</#list>  
  List<ObjectMap> rows = commonService.many("${entity.persistenceName}.find", sqlParams)
  ret.addAll(rows)
  return ret
}

List<ObjectMap> transform(List<ObjectMap> rows) {
  Calendar calendar = Calendar.getInstance()
  // 加载直接引用的关联数据 
<#list entity.attributes as attr>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#assign refObjAttrId = modelbase.get_id_attributes(refObj)[0]>
  Set<Object> ${java.nameVariable(modelbase.get_attribute_sql_name(attr))}List = new HashSet<>()
  </#if>
</#list>
  // 转换行数据
  for (ObjectMap row : rows) {
<#list entity.attributes as attr>
  <#if attr.type.custom>
    ${java.nameVariable(modelbase.get_attribute_sql_name(attr))}List.add(row.get("${modelbase.get_attribute_sql_name(attr)}"))
  </#if>
</#list>
<#list entity.attributes as attr>
  <#if attr.type.name == "datetime">
    Timestamp ${java.nameVariable(attr.name)} = row.get("${modelbase.get_attribute_sql_name(attr)}")
    if (${java.nameVariable(attr.name)} != null) {
      calendar.setTime(${java.nameVariable(attr.name)}.getTime())
      row.set("${attr.persistenceName}_yr", calendar.get(Calendar.YEAR))
      row.set("${attr.persistenceName}_mo", calendar.get(Calendar.MONTH) + 1)
      row.set("${attr.persistenceName}_dy", calendar.get(Calendar.DATE))
      row.set("${attr.persistenceName}_hr", calendar.get(Calendar.HOUR))
      row.set("${attr.persistenceName}_mn", calendar.get(Calendar.MINUTE))
      row.set("${attr.persistenceName}_sc", calendar.get(Calendar.SECOND))
      row.set("${attr.persistenceName}_wk", calendar.get(Calendar.WEEK_OF_YEAR))
      row.set("${attr.persistenceName}_wd", calendar.get(Calendar.DAY_OF_WEEK))
    }
  <#elseif attr.type.name == "date">
    Timestamp ${java.nameVariable(attr.name)} = row.get("${modelbase.get_attribute_sql_name(attr)}")
    if (${java.nameVariable(attr.name)} != null) {
      calendar.setTime(${java.nameVariable(attr.name)}.getTime())
      row.set("${attr.persistenceName}_yr", calendar.get(Calendar.YEAR))
      row.set("${attr.persistenceName}_mo", calendar.get(Calendar.MONTH) + 1)
      row.set("${attr.persistenceName}_dy", calendar.get(Calendar.DATE))
      row.set("${attr.persistenceName}_wk", calendar.get(Calendar.WEEK_OF_YEAR))
      row.set("${attr.persistenceName}_wd", calendar.get(Calendar.DAY_OF_WEEK))
    }
  </#if>
</#list>
  }
  
  // 合并关联数据
<#list entity.attributes as attr>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#assign refObjAttrId = modelbase.get_id_attributes(refObj)[0]>
  ${java.nameVariable(modelbase.get_attribute_sql_name(attr))}Rows = extract(${java.nameVariable(modelbase.get_attribute_sql_name(attr))}List)
  ret = merge(ret, "${modelbase.get_attribute_sql_name(attr)}", ${java.nameVariable(modelbase.get_attribute_sql_name(attr))}Rows, "${modelbase.get_attribute_sql_name(refObjAttrId)}")
  </#if>
</#list>
}