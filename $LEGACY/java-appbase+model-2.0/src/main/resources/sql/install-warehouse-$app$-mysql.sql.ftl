<#import '/$/modelbase.ftl' as modelbase>
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
			</#if>
		</#if>

	</#list>
	<#return ret>
</#function>

<#function is_attribute_counting attr>
	<#if attr.isLabelled('primary')><#return true></#if>
	<#if attr.isLabelled('secondary')><#return true></#if>
	<#if attr.isLabelled('tertiary')><#return true></#if>
	<#if attr.isLabelled('quaternary')><#return true></#if>
	<#if attr.isLabelled('quinary')><#return true></#if>
	<#if attr.isLabelled('senary')><#return true></#if>
	<#if attr.isLabelled('septenary')><#return true></#if>
	<#if attr.isLabelled('octonary')><#return true></#if>
	<#if attr.isLabelled('nonary')><#return true></#if>
	<#if attr.isLabelled('denary')><#return true></#if>
	<#if attr.isLabelled('primary')><#return true></#if>
	<#if attr.isLabelled('duodenary')><#return true></#if>
	<#return false>
</#function>

<#macro print_attribute_sql attr prefix>
	<#if attr.type.name == attr.parent.name>
	${(prefix + attr.persistenceName + '_id')?right_pad(36)} ${'text'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 编码",	
	${(prefix + attr.persistenceName + '_nm')?right_pad(36)} ${'text'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 名称",	
		<#return>
	</#if>
	<#if existingFactAttrs[prefix + attr.persistenceName]??><#return></#if>
	<#assign existingFactAttrs = existingFactAttrs + {prefix + attr.persistenceName: attr}>
	<#assign domaintype = attr.constraint.domainType.name>
	<#if attr.type.name == 'string'>
	${(prefix + attr.persistenceName)?right_pad(36)} ${'text'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)}",	
	<#elseif attr.type.name == 'date'>
	${(prefix + attr.persistenceName)?right_pad(36)} ${'date'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)}",
	${(prefix + attr.persistenceName + '_yr')?right_pad(36)} ${'int'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 年",
	${(prefix + attr.persistenceName + '_mo')?right_pad(36)} ${'int'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 月",
	${(prefix + attr.persistenceName + '_dy')?right_pad(36)} ${'int'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 日",
	${(prefix + attr.persistenceName + '_wk')?right_pad(36)} ${'int'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 周",
	${(prefix + attr.persistenceName + '_wd')?right_pad(36)} ${'int'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 周几",
	<#elseif attr.type.name == 'datetime'>
	${(prefix + attr.persistenceName)?right_pad(36)} ${'datetime'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)}",
	${(prefix + attr.persistenceName + '_yr')?right_pad(36)} ${'int'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 年",
	${(prefix + attr.persistenceName + '_mo')?right_pad(36)} ${'int'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 月",
	${(prefix + attr.persistenceName + '_dy')?right_pad(36)} ${'int'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 日",
	${(prefix + attr.persistenceName + '_hr')?right_pad(36)} ${'int'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 时",
	${(prefix + attr.persistenceName + '_mn')?right_pad(36)} ${'int'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 分",
	${(prefix + attr.persistenceName + '_sc')?right_pad(36)} ${'int'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 秒",
	${(prefix + attr.persistenceName + '_wk')?right_pad(36)} ${'int'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 周",
	${(prefix + attr.persistenceName + '_wd')?right_pad(36)} ${'int'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 周几",
	<#elseif attr.type.custom>
		<#assign refObj = model.findObjectByName(attr.type.name)>
		<#if refObj.isLabelled('constant')>
	${(prefix + attr.persistenceName)?right_pad(36)} ${'text'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)}",	
	${(prefix + attr.persistenceName + '_cd')?right_pad(36)} ${'text'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 编码",	
	${(prefix + attr.persistenceName + '_nm')?right_pad(36)} ${'text'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)} 名称",	
			<#return>
		</#if>
		<#list refObj.attributes as refAttr>
			<#if modelbase.is_attribute_system(refAttr) || !refAttr.persistenceName??><#continue></#if>
			<#if !prefix?ends_with(attr.persistenceName + '_')>
				<#assign localPrefix = prefix + attr.persistenceName + '_'>
			<#else>
				<#assign localPrefix = prefix>
			</#if>
<@print_attribute_sql attr=refAttr prefix=localPrefix />			
		</#list>
	<#else>
		<#assign sqlType = typebase.typename(domaintype, "sql")!'text'>
		<#if attr.type.length?? && (attr.type.length >= 400)>
			<#assign sqlType = 'text'>
		</#if>
		<#if sqlType?index_of('varchar') == 0>
	${(prefix + attr.persistenceName)?right_pad(36)} ${'text'?right_pad(36)} comment "${modelbase.get_attribute_label(attr)}",		
		<#else>
	${(prefix + attr.persistenceName)?right_pad(36)} ${sqlType?right_pad(36)} comment "${modelbase.get_attribute_label(attr)}",
	  </#if>
	</#if>	
</#macro>

<#-- FACT -->
<#assign facts = {}>
<#list model.objects as obj>
	<#if !obj.persistenceName?? || obj.isLabelled('generated')><#continue></#if>
	<#assign referenced = false>
	<#list model.objects as objInner>
		<#list objInner.attributes as attrInner>
			<#if attrInner.type?? && attrInner.type.name == obj.name>
				<#assign referenced = true>
				<#break>
			</#if>
		</#list>
		<#if referenced><#break></#if>
	</#list>
	<#if !referenced>
		<#assign facts = facts + {obj.name: []}>
	</#if>
</#list>

<#list facts as name, refs>
	<#-- 事实表的所有引用的对象 -->
	<#assign existingObjs = {}>
	<#-- 事实表的所有的属性 -->
	<#assign existingAttrs = {}>
	<#-- 避免属性的重复出现 -->
	<#assign existingFactAttrs = {}>
	<#assign refObjs = []>
	<#assign fact = model.findObjectByName(name)>
	<#assign refObjs = refObjs + collect_references(fact, refObjs)>
	<#if refObjs?size == 0><#continue></#if>
create table ${fact.persistenceName?replace('tn_','wn_')?replace('tv_','wv_')?replace('tx_','wx_')} (
	<#list fact.attributes as attr>
		<#if !attr.persistenceName?? || modelbase.is_attribute_system(attr)><#continue></#if>
<@print_attribute_sql attr=attr prefix=''/>
	</#list>
	lmt	datetime
) ENGINE=MyISAM;

</#list>