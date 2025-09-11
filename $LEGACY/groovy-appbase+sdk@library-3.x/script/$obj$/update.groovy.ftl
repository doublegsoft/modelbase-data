<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/appbase.ftl" as appbase>
<#-- 主对象，mapping模式 -->
<#assign master = ''>
<#-- 从对象，mapping模式 -->
<#assign slaves = []>
<#-- 多对一模式 -->
<#assign manys = []>
<#-- 扩展模式 -->
<#assign meta = ''>
<#-- 行列转换模式 -->
<#assign pivot = ''>
<#assign paramsObj = ''>

<#-- 区分各个不同类别的对象 -->
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#if obj.isLabelled('master')>
    <#assign master = obj>
  <#elseif obj.isLabelled('slave')>
    <#assign slaves = slaves + [obj]>
  <#elseif obj.isLabelled('pivot')>
    <#assign pivot = obj>
  <#elseif obj.isLabelled('meta')>
    <#assign meta = obj>
  <#elseif obj.isLabelled('many')>
    <#assign manys = manys + [obj]>
  </#if>
  <#if obj.isLabelled('params')>
    <#assign paramsObj = obj>
  </#if>
</#list>
<#-- 主对象（mapping模式下第一个对象） -->
<#assign masterAttrIds = []>
<#list master.attributes as attr>
  <#assign input = attr.getLabelledOptions('properties')['input']!''>
  <#if input == 'id'>
    <#assign masterAttrIds = masterAttrIds + [attr]>
  </#if>
</#list>
import java.sql.Timestamp;

import net.doublegsoft.appbase.service.CommonService
import net.doublegsoft.appbase.service.GroovyService
import net.doublegsoft.appbase.service.ServiceException
import net.doublegsoft.appbase.JsonData
import net.doublegsoft.appbase.ObjectMap
import net.doublegsoft.appbase.SqlParams
import net.doublegsoft.appbase.util.Values
import net.doublegsoft.appbase.util.Strings
import net.doublegsoft.appbase.util.Dates
import org.springframework.context.ApplicationContext
import com.alibaba.fastjson.JSON;

ObjectMap save(ApplicationContext spring, ObjectMap params) {
  Timestamp now = new Timestamp(System.currentTimeMillis())
  ObjectMap ret = new ObjectMap()
  CommonService commonService = spring.getBean("commonService")

  // 公共参数
  Timestamp lastModifiedTime = now
  String modifierId = params.get("modifierId")
  String modifierType = "STDBIZ.SAM.USER"
  String state = "E"

  // 当前用户
  if (Strings.isBlank(modifierId)) {
    throw new ServiceException(401, "未授权的访问！")
  }
  ObjectMap currentUser = commonService.single("tn_sam_usr.find", new SqlParams()
      .set("userId", modifierId))
  if (currentUser == null) {
    throw new ServiceException(401, "未检索到授权用户！")
  }
<#--!
#### 列出所有对象的所有字段的变量获取形式。
####
#### 示例：
####
#### String patientName = params.get("paitientName")
####
#### 规则：
####
#### 1. 同一名称的变量名表达的意思是一致的。
####
--->
<#global printedAttrs = {}>
<#assign existingAttrIds = {}>
<#list masterAttrIds as masterAttrId>
  <#assign varMasterAttrId = modelbase.get_attribute_sql_name(masterAttrId)>
  <#assign existingAttrIds = existingAttrIds + {varMasterAttrId: masterAttrId}>
</#list>
<#list slaves as slave>
  <#assign slaveAttrIds = modelbase.get_id_attributes(slave)>
  <#if appbase.is_slave_being_master(master, slave)>
    <#assign existingAttrIds = existingAttrIds + {modelbase.get_attribute_sql_name(slaveAttrIds[0]): slaveAttrIds[0]}>
    <#continue>
  </#if>
  <#list slaveAttrIds as slaveAttrId>
    <#assign varSlaveAttrId = modelbase.get_attribute_sql_name(slaveAttrId)>
    <#if existingAttrIds[varSlaveAttrId]??><#continue></#if>
    <#assign existingAttrIds = existingAttrIds + {varSlaveAttrId: slaveAttrId}>
  </#list>
</#list>
<#-- 参数变量 -->
<@appbase.print_variant_params_getters obj=master paramsName="params" label='' varprefix='' indent=2 />

<#--
 ### 隐式业务标识字段。
 -->
<#assign implicitBizuniques = appbase.get_implicit_bizunique_attributes(master)>
<#list implicitBizuniques as attr>
  String ${modelbase.get_attribute_sql_name(attr)} = params.get("${appbase.get_attribute_parameter_name(attr)}")
</#list>
<#list slaves as slave>
<@appbase.print_variant_params_getters obj=slave paramsName='params' label='' varprefix='' indent=2 />
</#list>
<#list manys as many>
<@appbase.print_variant_params_getters obj=many paramsName='params' label='' varprefix='' indent=2 />
</#list>

<#--
 ### FIXME
 ### 自己关联的对象是否存在多个业务标识字段。
 ###
 -->
<#assign bizuniqueAttrs = []>
<#assign bizuniqueObjRefAttr = ''>
<#assign bizuniqueObj = ''>
<#list master.attributes as attr>
  <#assign bizuniqueObj = appbase.get_bizunique_object_by_attribute_reference(attr)>
  <#if bizuniqueObj != ''>
    <#assign bizuniqueAttrs = appbase.get_bizunique_attributes(bizuniqueObj)>
    <#assign bizuniqueObjRefAttr = attr>
    <#break>
  </#if>
</#list>
<#list bizuniqueAttrs as bizuniqueAttr>
  String ${modelbase.get_attribute_sql_name(bizuniqueAttr)} = params.get("${modelbase.get_attribute_sql_name(bizuniqueAttr)}")
</#list>
<#if bizuniqueObj != ''>
  if (Strings.isBlank(${modelbase.get_attribute_sql_name(bizuniqueObjRefAttr)})) {
    if (
  <#list bizuniqueAttrs as bizuniqueAttr>
      Strings.isBlank(${modelbase.get_attribute_sql_name(bizuniqueAttr)}) ||
  </#list>
      false
    ) {
      throw new ServiceException(400, "未传入${modelbase.get_object_label(bizuniqueObj)}查询参数！")
    }
  }
  if (Strings.isBlank(${modelbase.get_attribute_sql_name(bizuniqueObjRefAttr)})) {
    ObjectMap existing${java.nameType(bizuniqueObj.name)} = commonService.single(
      '${bizuniqueObj.persistenceName}.match', new SqlParams()
  <#list bizuniqueAttrs as bizuniqueAttr>
      .set('${modelbase.get_attribute_sql_name(bizuniqueAttr)}', ${modelbase.get_attribute_sql_name(bizuniqueAttr)})
  </#list>
    )
    if (existing${java.nameType(bizuniqueObj.name)} == null) {
      throw new ServiceException(404, "未检索到${modelbase.get_object_label(bizuniqueObj)}信息！")
    }
    ${modelbase.get_attribute_sql_name(bizuniqueObjRefAttr)} = existing${java.nameType(bizuniqueObj.name)}.get('${modelbase.get_attribute_sql_name(bizuniqueObjRefAttr)}')
  }
</#if>
<#--!
#### 变量有效性验证，变量的值来源于客户端的传参。
####
#### 规则：
####
#### 1. 必填
#### 2. 格式，通过正则表达式
#### 3. 唯一性，系统字段的唯一性原则
#### 4. 业务唯一性，业务组合字段构成的唯一性原则
####
--->
<#global printedAttrs = {}>
  // 有效性验证
  String errors = ""
<#-- 值域对象标识验证 -->
<#if masterAttrIds?size != 1>
  // 值域对象标识参数传入验证
  <#list masterAttrIds as masterAttrId>
    <#assign varMasterAttrId = modelbase.get_attribute_sql_name(masterAttrId)>
  if (Strings.isBlank(${varMasterAttrId})) {
    errors += "对象标识参数【${modelbase.get_attribute_label(masterAttrId)}】未传入！\n"
  }
  </#list>
</#if>
<#-- 【映射模式】必填验证 -->
<@appbase.print_params_required_validations obj=master label='' varprefix='' indent=2 />
<#list slaves as slave>
<@appbase.print_params_required_validations obj=slave label='' varprefix='' indent=2 />
</#list>

<#-- 【映射模式】格式验证 -->
<@appbase.print_params_format_validations obj=master indent=2 />
<#list slaves as slave>
<@appbase.print_params_format_validations obj=slave indent=2 />
</#list>

  /*!
  ** 值域有效性验证。
  */
<@appbase.print_params_value_validations obj=master label='' varprefix='' indent=2 />
<#list slaves as slave>
<@appbase.print_params_value_validations obj=slave label='' varprefix='' indent=2 />
</#list>
  if (errors != "") {
    throw new ServiceException(400, errors)
  }
<#--
 ### 值域验证
 -->

<#-- 【映射模式】的业务唯一性验证，业务唯一性值存在于【映射模式】的情况 -->
<#assign existingBusinessUniques = {}>
<@appbase.print_params_bizunique_validation obj=master indent=2 />
<#list slaves as slave>
<@appbase.print_params_bizunique_validation obj=slave indent=2 />
</#list>

<#--!
#### 获取已经存在的数据，如果对象标识字段或者业务唯一字段存在值，则需要从数据库中
#### 检测并且获取已经存在的数据。在【映射模式】情况下，通常存在从对象和主对象的主
#### 键是相同的情况，在指定从对象的主键可以设定为常量，并且默认值为"=patientId"
#### 来表达。
####
#### 示例：
####
#### personId = patientId
####
#### 规则：
####
#### 1. 主键标识
#### 2. 业务唯一字段
####
--->
<@appbase.print_variant_object_existing obj=master indent=2 />
  if (existing${java.nameType(master.name)} == null) {
    throw new ServiceException(404, "未检索到相关的【${modelbase.get_object_label(master)}】数据")
  }
<#list slaves as slave>
  <#-- 主键同值的情况 -->
  <#if masterAttrIds?size == 1>
    <#list slave.attributes as attr>
      <#if attr == masterAttrIds[0]><#continue></#if>
        <#assign input = attr.getLabelledOptions('properties')['input']!''>
        <#assign dfltval = attr.getLabelledOptions('properties')['default']!''>
        <#if input == 'constant' && dfltval == ('=' + modelbase.get_attribute_sql_name(masterAttrIds[0]))>
  ${modelbase.get_attribute_sql_name(attr)} = ${modelbase.get_attribute_sql_name(masterAttrIds[0])}
        </#if>
    </#list>
  </#if>
</#list>
<#list slaves as slave>
<@appbase.print_variant_object_existing obj=slave indent=2 />
</#list>

<#--!
#### 【映射模式】的情况下，装配变量数据到持久化数据中。
####
#### 规则：
####
#### 1. 在数据库中已经存在的数据先装配，再装配现有的变量数据，保持未修改的历史数据不变。
#### 2. 系统字段采用系统字段应该有的值，不需要从客户端获取。
#### 3. 存在已有数据才更新，否则就创建。
####
--->
  // 装配【${modelbase.get_object_label(master)}】参数
  SqlParams ${java.nameVariable(master.name)} = new SqlParams()

<@appbase.print_sqlparams_attribute_not_null_setters obj=master varprefix='' indent=2 />

<@appbase.print_sqlparams_system_setters obj=master varprefix='' indent=2 />

  // 更新保存【${modelbase.get_object_label(master)}】对象
  commonService.execute("${master.getLabelledOptions("persistence")["name"]}.update", ${java.nameVariable(master.name)})

<#-- 从对象 -->
<#list slaves as slave>

  // 装配【${modelbase.get_object_label(slave)}】参数
  SqlParams ${java.nameVariable(slave.name)} = new SqlParams()

  if (existing${java.nameType(slave.name)} != null) {
    ${java.nameVariable(slave.name)}.set(existing${java.nameType(slave.name)})
  }

  <#assign slaveAttrIds = modelbase.get_id_attributes(slave)>
<@appbase.print_sqlparams_attribute_not_null_setters obj=slave varprefix='' indent=2 />

<@appbase.print_sqlparams_system_setters obj=slave indent= 2/>

  // 保存【${modelbase.get_object_label(slave)}】对象
  if (existing${java.nameType(slave.name)} == null) {
    commonService.execute("${slave.getLabelledOptions("persistence")["name"]}.create", ${java.nameVariable(slave.name)})
  } else {
    commonService.execute("${slave.getLabelledOptions("persistence")["name"]}.update", ${java.nameVariable(slave.name)})
  }
</#list>

<#--!
#### 返回值。
####
#### 规则：返回数据原则是系统生成的业务数据，包括：标识，自动编码
####
--->
<#list masterAttrIds as masterAttrId>
  ret.set("${modelbase.get_attribute_sql_name(masterAttrId)}", ${modelbase.get_attribute_sql_name(masterAttrId)})
</#list>
<#list slaves as slave>
  <#assign slaveAttrIds = modelbase.get_id_attributes(slave)>
  <#list slaveAttrIds as slaveAttrId>
  ret.set("${modelbase.get_attribute_sql_name(slaveAttrId)}", ${modelbase.get_attribute_sql_name(slaveAttrId)})
  </#list>
</#list>
<#list master.attributes as attr>
  <#assign input = attr.getLabelledOptions('properties')['input']!''>
  <#if input == 'sequence'>
  ret.set("${modelbase.get_attribute_sql_name(attr)}", ${modelbase.get_attribute_sql_name(attr)})
  </#if>
</#list>
<#list slaves as slave>
  <#list slave.attributes as attr>
    <#assign input = attr.getLabelledOptions('properties')['input']!''>
    <#if input == 'sequence'>
  ret.set("${modelbase.get_attribute_sql_name(attr)}", ${modelbase.get_attribute_sql_name(attr)})
    </#if>
  </#list>
</#list>
  return ret
}

ApplicationContext spring = binding.getVariable("spring")
ObjectMap params = binding.getVariable("params")
GroovyShell shell = new GroovyShell()

CommonService commonService = spring.getBean("commonService")
GroovyService groovyService = spring.getBean("groovyService")

String scriptRoot = groovyService.getRoot()
Script common = shell.parse(new File(scriptRoot + "/common.groovy"))

<#if paramsObj != ''>
params.putAll(JSON.parse("""
${paramsObj.getLabelledOptions('params')['params']}
"""))
</#if>

JsonData ret = new JsonData()
try {
  commonService.beginTransaction()
  ObjectMap data = save(spring, params)
  data = common.transact(spring, shell, scriptRoot, params, data)
  ret.set("data", data)
  commonService.commit()
} catch (Throwable cause) {
  if (cause instanceof ServiceException) {
    ServiceException ex = (ServiceException) cause
    ret.error(ex.getCode(), ex.getMessage())
  } else {
    ret.error(500, cause.getMessage())
  }
  commonService.rollback()
}

return ret


