<#function get_module_name obj>
  <#local persistenceName = obj.getLabelledOptions('persistence')['name']>
  <#local strs = persistenceName?split("_")>
  <#return strs[1]>
</#function>

<#function get_bizunique_object_by_attribute_reference attr>
  <#local foundObj = ''>
  <#list model.objects as obj>
    <#if !obj.isLabelled('master') && !obj.isLabelled('slave')><#continue></#if>
    <#if attr.type.name == obj.name>
      <#local foundObj = obj>
      <#break>
    </#if>
  </#list>
  <#if foundObj != ''>
    <#list foundObj.attributes as objAttr>
      <#if objAttr.getLabelledOptions('properties')['businessUnique']!false == true>
        <#return foundObj>
      </#if>
    </#list>
  </#if>
  <#return ''>
</#function>

<#function get_real_object objname>
  <#local ret = ''>
  <#list model.objects as obj>
    <#if obj.name == objname && (obj.attributes?size > 1)>
      <#local ret = obj>
      <#break>
    </#if>
  </#list>
  <#return ret>
</#function>

<#function get_real_objects>
  <#local ret = []>
  <#list model.objects as obj>
    <#if (obj.attributes?size > 1)>
      <#local ret = ret + [obj]>
    </#if>
  </#list>
  <#return ret>
</#function>

<#function get_bizunique_attributes obj>
  <#local ret = []>
  <#list obj.attributes as attr>
    <#if attr.getLabelledOptions('properties')['businessUnique']!false == true>
      <#local ret = ret + [attr]>
    </#if>
  </#list>
  <#return ret>
</#function>

<#function get_bizunique_attributes_by_managed_object managedObjectId>
  <#local ret = []>
  <#list model.objects as obj>
    <#assign moid = obj.getLabelledOptions('managedObject')['managedObjectId']!''>
    <#if moid != managedObjectId><#continue></#if>
    <#list obj.attributes as attr>
      <#if attr.getLabelledOptions('properties')['input'] == 'none'><#continue></#if>
      <#if attr.getLabelledOptions('properties')['businessUnique']!false == true>
        <#local ret = ret + [attr]>
      </#if>
    </#list>
  </#list>
  <#return ret>
</#function>

<#--
 ### @deprecate 换成更直接的方式获取隐式业务标识属性
 -->
<#function get_implicit_bizunique_attributes obj>
  <#local ret = []>
  <#local existings = {}>
  <#list obj.attributes as attr>
    <#if !attr.getLabelledOptions('properties')['managedObjectId']??><#continue></#if>
    <#assign managedObjectId = attr.getLabelledOptions('properties')['managedObjectId']>
    <#if managedObjectId == '-1'><#continue></#if>
    <#local ret = get_bizunique_attributes_by_managed_object(managedObjectId)>
  </#list>
  <#return ret>
</#function>

<#function get_attribute_parameter_name attr>
  <#assign dfltval = attr.getLabelledOptions('properties')['default']!''>
  <#if dfltval == '' || !dfltval?starts_with('=')>
    <#return modelbase.get_attribute_sql_name(attr)>
  </#if>
  <#return dfltval?substring(1)>
</#function>

<#--
 ### 判断是否对象里面存在有效的属性，也就是input属性不都是none
 -->
<#function is_valid_object obj>
  <#list obj.attributes as attr>
    <#assign input = attr.getLabelledOptions('properties')['input']!'none'>
    <#if input != 'none'>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#macro print_implicit_bizunique_attributes obj>
  <#local ret = []>
  <#local existings = {}>
  <#list obj.attributes as attr>
    ${obj.name} ${attr.name} ${attr.getLabelledOptions('properties')['managedObjectId']!''}
    <#if !attr.getLabelledOptions('properties')['managedObjectId']??><#continue></#if>
    <#assign managedObjectId = attr.getLabelledOptions('properties')['managedObjectId']>
    <#if managedObjectId == '-1'><#continue></#if>
    <#list model.objects as obj>
      <#assign moid = obj.getLabelledOptions('managedObject')['managedObjectId']!''>
      <#if moid != managedObjectId><#continue></#if>
      <#list obj.attributes as attr>
        <#if attr.parent.getLabelledOptions('properties')['businessUnique']!false == true>
                  ${attr.name}
        </#if>
      </#list>
    </#list>
  </#list>
</#macro>

<#macro print_sqlparams_attribute_setters obj varprefix indent>
  <#list obj.attributes as attr>
    <#assign input = attr.getLabelledOptions('properties')['input']!''>
    <#assign dfltval = attr.getLabelledOptions('properties')['default']!''>
    <#assign tplvar = attr.getLabelledOptions('properties')['templateVar']!''>
    <#if input == 'none' || attr.name == 'modifier_id'><#continue></#if>
    <#if input  == 'id'>
      <#if tplvar?starts_with("$")>
        <#assign refname = tplvar?substring(1)>
${''?left_pad(indent)}${rename_object_var_name(varprefix, obj)}.set("${modelbase.get_attribute_sql_name(attr)}", ${java.nameVariable(refname)})
      <#else>
${''?left_pad(indent)}${rename_object_var_name(varprefix, obj)}.set("${modelbase.get_attribute_sql_name(attr)}", ${rename_attribute_var_name(varprefix, attr)})
      </#if>
    <#elseif input  == 'constant'>
  <#-- 常量 -->
      <#if dfltval == 'user'>
${''?left_pad(indent)}${rename_object_var_name(varprefix, obj)}.set("${modelbase.get_attribute_sql_name(attr)}", modifierId)
      <#elseif dfltval?ends_with("?")>
${''?left_pad(indent)}if (existing${java.nameType(obj.name)} == null) {
${''?left_pad(indent)}  ${rename_object_var_name(varprefix, obj)}.set("${modelbase.get_attribute_sql_name(attr)}", ${rename_attribute_var_name(varprefix, attr)})
${''?left_pad(indent)}}
      <#elseif dfltval?ends_with("!")>
${''?left_pad(indent)}if (existing${java.nameType(obj.name)} != null) {
${''?left_pad(indent)}  ${rename_object_var_name(varprefix, obj)}.set("${modelbase.get_attribute_sql_name(attr)}", ${rename_attribute_var_name(varprefix, attr)})
${''?left_pad(indent)}}
      <#else>
${''?left_pad(indent)}${rename_object_var_name(varprefix, obj)}.set("${modelbase.get_attribute_sql_name(attr)}", ${rename_attribute_var_name(varprefix, attr)})
      </#if>
    <#elseif input  == 'sequence'>
  <#-- 顺序编码 -->
${''?left_pad(indent)}${rename_object_var_name(varprefix, obj)}.set("${modelbase.get_attribute_sql_name(attr)}", ${rename_attribute_var_name(varprefix, attr)})
    <#elseif input  == 'parameter'>
  <#-- 参数化变量 -->
  <#--!
  #### 参数化变量规则：
  ####
  #### 1. 作为页面之间的参数传递定义
  #### 2. 作为系统变量的引用
  --->
${''?left_pad(indent)}${rename_object_var_name(varprefix, obj)}.set("${modelbase.get_attribute_sql_name(attr)}", ${rename_attribute_var_name(varprefix, attr)})
    <#else>
${''?left_pad(indent)}${rename_object_var_name(varprefix, obj)}.set("${modelbase.get_attribute_sql_name(attr)}", ${rename_attribute_var_name(varprefix, attr)})
    </#if>
  </#list>
</#macro>

<#macro print_sqlparams_attribute_not_null_setters obj varprefix indent>
  <#list obj.attributes as attr>
    <#assign input = attr.getLabelledOptions('properties')['input']!''>
    <#assign dfltval = attr.getLabelledOptions('properties')['default']!''>
    <#assign tplvar = attr.getLabelledOptions('properties')['templateVar']!''>
    <#if input == 'none' || attr.name == 'modifier_id'><#continue></#if>
${''?left_pad(indent)}if (!Strings.isBlank(${rename_attribute_var_name(varprefix, attr)})) {
${''?left_pad(indent)}  ${rename_object_var_name(varprefix, obj)}.set("${modelbase.get_attribute_sql_name(attr)}", ${rename_attribute_var_name(varprefix, attr)})
${''?left_pad(indent)}}
    </#list>
</#macro>

<#macro print_sqlparams_system_setters obj varprefix indent>
${''?left_pad(indent)}${rename_object_var_name(varprefix, obj)}.set("modifierId", modifierId)
${''?left_pad(indent)}${rename_object_var_name(varprefix, obj)}.set("modifierType", modifierType)
${''?left_pad(indent)}${rename_object_var_name(varprefix, obj)}.set("state", state)
${''?left_pad(indent)}${rename_object_var_name(varprefix, obj)}.set("lastModifiedTime", lastModifiedTime)
</#macro>

<#macro print_variant_sequence_assign obj attr indent>
  <#assign input = attr.getLabelledOptions('properties')['input']!''>
  <#if input == 'sequence'>
    <#assign format = attr.getLabelledOptions('properties')['format']!''>
    <#assign formatNumber = format?replace('YYYYMMDD', '')?replace('N','0')>
    <#assign formatNumber = formatNumber?substring(0, formatNumber?length - 1) + "1">
${''?left_pad(indent)}if (Strings.isBlank(${modelbase.get_attribute_sql_name(attr)})) {
${''?left_pad(indent)}  ObjectMap found = commonService.single(
${''?left_pad(indent)}      "${obj.persistenceName}.find",new SqlParams()
${''?left_pad(indent)}      .set("${modelbase.get_attribute_sql_name(attr)}0", dateCode)
${''?left_pad(indent)}      .set("_order_by", "${modelbase.get_attribute_sql_name(attr)} desc "))
${''?left_pad(indent)}  if (found != null) {
${''?left_pad(indent)}    max${java.nameType(modelbase.get_attribute_sql_name(attr))} = found.get("${modelbase.get_attribute_sql_name(attr)}")
${''?left_pad(indent)}  }
${''?left_pad(indent)}  if (max${java.nameType(modelbase.get_attribute_sql_name(attr))} == null) {
${''?left_pad(indent)}    ${modelbase.get_attribute_sql_name(attr)} = (Long.valueOf(max${java.nameType(modelbase.get_attribute_sql_name(attr))}) + 1).toString()
${''?left_pad(indent)}  } else {
${''?left_pad(indent)}    ${modelbase.get_attribute_sql_name(attr)} = dateCode + "${formatNumber}"
${''?left_pad(indent)}  }
${''?left_pad(indent)}}
  </#if>
</#macro>

<#--!
#### 数据库中已经存在数据的过程。
--->
<#macro print_variant_object_existing obj indent>
  <#assign uniques = []>
  <#list obj.attributes as attr>
    <#if attr.getLabelledOptions('properties')['businessUnique']!false == true>
      <#assign uniques = uniques + [attr]>
    </#if>
  </#list>
  <#assign attrIds = modelbase.get_id_attributes(obj)>
${''?left_pad(indent)}// 检查数据库中已经存在的【${modelbase.get_object_label(obj)}】数据
${''?left_pad(indent)}ObjectMap existing${java.nameType(obj.name)}
${''?left_pad(indent)}if (
  <#list attrIds as attrId>
${''?left_pad(indent)}  !Strings.isBlank(${modelbase.get_attribute_sql_name(attrId)}) <#if (attrId?index != attrIds?size - 1)>&& </#if>
  </#list>
${''?left_pad(indent)}) {
${''?left_pad(indent)}  // 通过系统标识查找【${modelbase.get_object_label(obj)}】对象
${''?left_pad(indent)}  existing${java.nameType(obj.name)} = commonService.single("${obj.persistenceName}.find", new SqlParams()
  <#list attrIds as attrId>
${''?left_pad(indent)}      .set("${modelbase.get_attribute_sql_name(attrId)}", ${modelbase.get_attribute_sql_name(attrId)})
  </#list>
${''?left_pad(indent)}  )
${''?left_pad(indent)}}
  <#if uniques?size != 0>
${''?left_pad(indent)}if (existing${java.nameType(obj.name)} == null) {
${''?left_pad(indent)}  if (
    <#list uniques as attr>
${''?left_pad(indent)}    !Strings.isBlank(${modelbase.get_attribute_sql_name(attr)}) &&
    </#list>
${''?left_pad(indent)}    true)
${''?left_pad(indent)}  // 通过业务标识查找【${modelbase.get_object_label(obj)}】对象
${''?left_pad(indent)}    existing${java.nameType(obj.name)} = commonService.single("${obj.persistenceName}.match", new SqlParams()
    <#list uniques as attr>
${''?left_pad(indent)}        .set("${modelbase.get_attribute_sql_name(attr)}", ${modelbase.get_attribute_sql_name(attr)})
    </#list>
${''?left_pad(indent)}  )
${''?left_pad(indent)}}
  </#if>
  <#if attrIds?size == 1>
    <#assign input = attrIds[0].getLabelledOptions('properties')['input']!''>
    <#assign dfltval = attrIds[0].getLabelledOptions('properties')['default']!''>
    <#assign variant = attrIds[0].getLabelledOptions('properties')['variant']!''>
    <#-- 说明是实体对象 -->
${''?left_pad(indent)}if (existing${java.nameType(obj.name)} != null) {
${''?left_pad(indent)}  ${modelbase.get_attribute_sql_name(attrIds[0])} = existing${java.nameType(obj.name)}.get("${modelbase.get_attribute_sql_name(attrIds[0])}")
${''?left_pad(indent)}} else {
${''?left_pad(indent)}  // 重新对【${modelbase.get_object_label(obj)}】对象标识赋值
    <#if input == 'constant' && dfltval?starts_with('=')>
${''?left_pad(indent)}  ${modelbase.get_attribute_sql_name(attrIds[0])} = ${dfltval?substring(1)}
    <#elseif variant != ''>
${''?left_pad(indent)}  ${modelbase.get_attribute_sql_name(attrIds[0])} = ${variant}
    <#else>
${''?left_pad(indent)}  ${modelbase.get_attribute_sql_name(attrIds[0])} = Strings.id()
    </#if>
${''?left_pad(indent)}}
  </#if>
</#macro>

<#--!
#### 打印从参数获取值的变量声明。
--->
<#macro print_variant_params_getters obj paramsName label varprefix indent>
  <#list obj.attributes as attr>
    <#if attr.name == 'modifier_id' ||
         attr.name == 'modifier_type' ||
         attr.name == 'last_modified_time' ||
         attr.name == 'state'><#continue></#if>
    <#if printedAttrs[varprefix + modelbase.get_attribute_sql_name(attr)]??><#continue></#if>
    <#global printedAttrs = printedAttrs + {varprefix + modelbase.get_attribute_sql_name(attr): attr}>
    <#assign input = attr.getLabelledOptions('properties')['input']!''>
    <#assign dfltval = attr.getLabelledOptions('properties')['default']!''>
    <#assign variant = attr.getLabelledOptions('properties')['variant']!''>
    <#if input == 'none'><#continue></#if>
    <#if input == 'sequence'>
${''?left_pad(indent)}// 需要系统赋值的自增【${modelbase.get_attribute_label(attr)}】
${''?left_pad(indent)}String ${rename_attribute_var_name(varprefix, attr)} = ${paramsName}.get("${rename_attribute_var_name(varprefix, attr)}")
    <#elseif input == 'id'>
${''?left_pad(indent)}// ${label}${modelbase.get_attribute_label(attr)}
      <#if variant == ''>
${''?left_pad(indent)}String ${rename_attribute_var_name(varprefix, attr)} = ${paramsName}.get("${rename_attribute_var_name(varprefix, attr)}")
      <#elseif variant?starts_with('=')>
${''?left_pad(indent)}String ${rename_attribute_var_name(varprefix, attr)} = ${variant?substring(1)}
      <#else>
${''?left_pad(indent)}String ${rename_attribute_var_name(varprefix, attr)} = ${paramsName}.get("${variant}")
      </#if>
    <#elseif input == 'parameter'>
${''?left_pad(indent)}// 系统内部传递的【${modelbase.get_attribute_label(attr)}】参数，用户无法修改的
${''?left_pad(indent)}${rename_attribute_var_name(varprefix, attr)} = ${paramsName}.get("${rename_attribute_var_name(varprefix, attr)}")
    <#elseif input == 'constant' && dfltval?starts_with('now')>
${''?left_pad(indent)}// ${label}${modelbase.get_attribute_label(attr)}
${''?left_pad(indent)}Timestamp ${rename_attribute_var_name(varprefix, attr)} = now
    <#elseif input == 'constant' && dfltval == 'user'>
${''?left_pad(indent)}// ${label}${modelbase.get_attribute_label(attr)}
${''?left_pad(indent)}String ${rename_attribute_var_name(varprefix, attr)} = modifierId
    <#elseif input == 'constant' && dfltval?starts_with('=')>
${''?left_pad(indent)}// ${label}${modelbase.get_attribute_label(attr)}
${''?left_pad(indent)}String ${rename_attribute_var_name(varprefix, attr)} = ${paramsName}.get("${rename_attribute_var_name(varprefix, attr)}")
    <#elseif input == 'constant' && (dfltval?ends_with('@user') || dfltval?ends_with('@user?'))>
${''?left_pad(indent)}// ${label}${modelbase.get_attribute_label(attr)}
${''?left_pad(indent)}String ${rename_attribute_var_name(varprefix, attr)} = currentUser.get("${dfltval?substring(0, dfltval?index_of('@user'))}")
    <#elseif input == 'constant'>
${''?left_pad(indent)}// ${label}${modelbase.get_attribute_label(attr)}
${''?left_pad(indent)}String ${rename_attribute_var_name(varprefix, attr)} = "${dfltval}"
    <#else>
${''?left_pad(indent)}// ${label}${modelbase.get_attribute_label(attr)}
      <#if dfltval?starts_with('=')>
${''?left_pad(indent)}String ${rename_attribute_var_name(varprefix, attr)} = ${paramsName}.get("${dfltval?substring(1)}")
      <#else>
${''?left_pad(indent)}String ${rename_attribute_var_name(varprefix, attr)} = ${paramsName}.get("${rename_attribute_var_name(varprefix, attr)}")
      </#if>
    </#if>
  </#list>
</#macro>

<#--!
#### 把创建后不可更新的字段重置为空。
--->
<#macro print_variant_null_setters obj indent>
  <#list obj.attributes as attr>
    <#assign input = attr.getLabelledOptions('properties')['input']!''>
    <#assign dfltval = attr.getLabelledOptions('properties')['default']!''>
    <#if input == 'constant' && dfltval == 'now'>
${''?left_pad(indent)}// ${modelbase.get_attribute_label(attr)}
${''?left_pad(indent)}${modelbase.get_attribute_sql_name(attr)} = null
    </#if>
  </#list>
</#macro>

<#macro print_params_bizunique_validation obj indent>
  <#assign businessUniques = {}>
  <#if businessUniques?size == 0><#return></#if>
${''?left_pad(indent)}ObjectMap found${java.nameType(obj.name)} = commonService.single("${obj.persistenceName}.match", new SqlParams()
    <#list businessUniques?values as attr>
${''?left_pad(indent)}  .set("${modelbase.get_attribute_sql_name(attr)}", ${modelbase.get_attribute_sql_name(attr)})
    </#list>
  )
</#macro>

<#macro print_params_required_validations obj label varprefix indent>
  <#list obj.attributes as attr>
    <#assign input = attr.getLabelledOptions("properties")["input"]!'none'>
    <#assign dfltval = attr.getLabelledOptions("properties")["default"]!''>
    <#if input == 'none'><#continue></#if>
<#--    <#if printedAttrs[modelbase.get_attribute_sql_name(attr)]??><#continue></#if>-->
    <#global printedAttrs = printedAttrs + {modelbase.get_attribute_sql_name(attr): attr}>
    <#if attr.constraint.identifiable><#continue></#if>
    <#assign nullable = attr.getConstraint().isNullable()>
    <#if nullable == true><#continue></#if>
    <#if input == 'constant' && dfltval?starts_with('=')><#continue></#if>
    <#if obj.isLabelled('meta') || obj.isLabelled('pivot')>
${''?left_pad(indent)}if (Strings.isBlank(params.get("${attr.getLabelledOptions('properties')['title']}"))) {
    <#else>
      <#if varprefix == ''>
${''?left_pad(indent)}if (Strings.isBlank(${modelbase.get_attribute_sql_name(attr)})) {
      <#else>
${''?left_pad(indent)}if (Strings.isBlank(${java.nameVariable(varprefix)}${java.nameType(modelbase.get_attribute_sql_name(attr))})) {
      </#if>
    </#if>
${''?left_pad(indent)}  errors += "${label}${attr.getLabelledOptions('properties')['title']!'无标题'}必须填写\n";
${''?left_pad(indent)}}
  </#list>
</#macro>

<#macro print_params_format_validations obj indent>
  <#list obj.attributes as attr>
    <#assign format = attr.getLabelledOptions('properties')['format']!''>
    <#assign format = format?replace("\\", "\\\\")>
    <#assign input = attr.getLabelledOptions('properties')['input']!''>
    <#if (input == 'text' || input == 'number') && format !=''>
      <#if obj.isLabelled('meta') || obj.isLabelled('pivot')>
${''?left_pad(indent)}if (!Strings.isBlank(params.get("${attr.getLabelledOptions('properties')['title']}"))) {
${''?left_pad(indent)}  if (!Pattern.matches('${format}', params.get("${attr.getLabelledOptions('properties')['title']}"))) {
${''?left_pad(indent)}    errors += "${attr.getLabelledOptions('properties')['title']}格式不正确！\n"
${''?left_pad(indent)}  }
${''?left_pad(indent)}}
      <#else>
${''?left_pad(indent)}if (!Strings.isBlank(${modelbase.get_attribute_sql_name(attr)})) {
${''?left_pad(indent)}  if (!Pattern.matches('${format}', ${modelbase.get_attribute_sql_name(attr)})) {
${''?left_pad(indent)}    errors += "${modelbase.get_attribute_label(attr)}格式不正确！\n"
${''?left_pad(indent)}  }
${''?left_pad(indent)}}
      </#if>
    </#if>
  </#list>
</#macro>

<#macro print_params_value_validations obj label varprefix indent>
  <#list obj.attributes as attr>
    <#assign datatype = attr.getLabelledOptions('properties')['datatype']!''>
    <#assign input = attr.getLabelledOptions('properties')['input']!'none'>
    <#if input == 'none'><#continue></#if>
    <#if datatype?index_of('(code)') != -1>
      <#assign datatype = attr.getLabelledOptions('properties')['datatype']>
${''?left_pad(indent)}if (!Strings.isBlank(${rename_attribute_var_name(varprefix, attr)})) {
${''?left_pad(indent)}  if(!Values.contains("${datatype?substring(1, datatype?index_of('('))}", ${rename_attribute_var_name(varprefix, attr)})) {
${''?left_pad(indent)}    errors += "${label}${modelbase.get_attribute_label(attr)}值域错误！\n"
${''?left_pad(indent)}  }
${''?left_pad(indent)}}
    </#if>
  </#list>
</#macro>

<#macro print_json_attributes obj varprefix>
  <#list obj.attributes as attr>
    <#if modelbase.is_attribute_system(attr)><#continue></#if>
    <#assign input = attr.getLabelledOptions('properties')['input']!'none'>
    <#assign datatype = attr.getLabelledOptions('properties')['datatype']!'string(10)'>
    <#if input == 'none'><#continue></#if>
    <#if attr.name == 'mobile'>
  "${appbase.rename_attribute_var_name(varprefix, attr)}":"18974658374",
    <#elseif attr.name == 'id_card_number'>
  "${appbase.rename_attribute_var_name(varprefix, attr)}":"500010198808088828",
    <#elseif datatype?starts_with('string')>
  "${appbase.rename_attribute_var_name(varprefix, attr)}":"${tatabase.string(datatype?substring(7, datatype?index_of(')'))?number)}",
    <#elseif datatype?starts_with('enum')>
  "${appbase.rename_attribute_var_name(varprefix, attr)}":"${tatabase.enumcode(datatype)}",
    <#elseif datatype?starts_with('&')>
  "${appbase.rename_attribute_var_name(varprefix, attr)}":"001",
    <#elseif datatype == 'date'>
  "${appbase.rename_attribute_var_name(varprefix, attr)}":"${tatabase.date()}",
    <#elseif datatype == 'datetime'>
  "${appbase.rename_attribute_var_name(varprefix, attr)}":"${tatabase.date()} 00:00:00",
    <#elseif datatype == 'json'>
  "${appbase.rename_attribute_var_name(varprefix, attr)}":{
    "prop1":"${tatabase.string(20)}",
    "prop2":${tatabase.number(1,100)}
  },
    </#if>
  </#list>
</#macro>

<#function is_slave_including_master master slave>
  <#if modelbase.get_id_attributes(master)?size != 1><#return false></#if>
  <#list slave.attributes as attr>
    <#if attr.type.custom && attr.type.name == master.name>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#function is_slave_being_master master slave>
  <#if modelbase.get_id_attributes(master)?size != 1><#return false></#if>
  <#if modelbase.get_id_attributes(slave)?size != 1><#return false></#if>
  <#assign attrIds = modelbase.get_id_attributes(slave)>
  <#list attrIds as attr>
    <#if attr.type.custom && attr.type.name == master.name>
      <#return true>
    </#if>
  </#list>
  <#assign attrIds = modelbase.get_id_attributes(master)>
  <#list attrIds as attr>
    <#if attr.type.custom && attr.type.name == slave.name>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#function get_conj_enum conj>
  <#list conj.attributes as attr>
    <#local dfltval = attr.getLabelledOptions('properties')['default']!''>
    <#if string_is_array(dfltval)>
      <#return {
        'values': string_to_value_array(dfltval),
        'texts': string_to_text_array(dfltval),
        'codes': string_to_code_array(dfltval)
      }>
    </#if>
  </#list>
  <#return {}>
</#function>

<#function string_is_array str>
  <#return str?starts_with('[') && str?ends_with(']')>
</#function>

<#function string_to_value_array str>
  <#local ret = []>
  <#local s = str?substring(1, str?length - 1)>
  <#local arr = s?split(',')>
  <#list arr as item>
    <#local ret = ret + [item?trim?substring(0, item?index_of(':'))]>
  </#list>
  <#return ret>
</#function>

<#function string_to_text_array str>
  <#local ret = []>
  <#local s = str?substring(1, str?length - 1)>
  <#local arr = s?split(',')>
  <#list arr as item>
    <#local ret = ret + [item?trim?substring(item?index_of(':') + 1, item?last_index_of(':'))]>
  </#list>
  <#return ret>
</#function>

<#function string_to_code_array str>
  <#local ret = []>
  <#local s = str?substring(1, str?length - 1)>
  <#local arr = s?split(',')>
  <#list arr as item>
    <#local ret = ret + [item?trim?substring(item?last_index_of(':') + 1)]>
  </#list>
  <#return ret>
</#function>

<#function rename_attribute_var_name prefix attr>
  <#if prefix == ''>
    <#return modelbase.get_attribute_sql_name(attr)>
  </#if>
  <#return java.nameVariable(prefix) + java.nameType(modelbase.get_attribute_sql_name(attr))>
</#function>

<#function rename_object_var_name prefix obj>
  <#if prefix == ''>
    <#return java.nameVariable(obj.name)>
  </#if>
  <#return java.nameVariable(prefix) + java.nameType(obj.name)>
</#function>