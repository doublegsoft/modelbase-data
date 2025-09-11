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
</#list>
<#-- 主对象（mapping模式下第一个对象） -->
<#assign masterAttrIds = []>
<#list master.attributes as attr>
  <#assign input = attr.getLabelledOptions('properties')['input']!''>
  <#if input == 'id'>
    <#assign masterAttrIds = masterAttrIds + [attr]>
  </#if>
</#list>
<#--!
#### 【同一模型不同业务描述】模式的保存操作。由三个对象组成：
####  1. 连接对象
####  2. 主要对象
####  3. 详细对象
####  填写的内容主要是在详细对象中，通过连接对象关联到主要对象。
####
#### 规则：
#### 1. 从自己的属性中找到应用主对象或者从对象的属性
#### 2.
####
--->
<#assign attrRefDetailSlave = ''>
<#-- 连接作用的对象 -->
<#assign conjSlave = ''>
<#assign conjSlaveEnum = {}>
<#-- 连接的主要对象 -->
<#assign masterInSlave = ''>
<#-- 连接的详细对象 -->
<#assign detailSlave = ''>
<#-- 算法：分别找到以上三个对象 -->
<#list slaves as slave>
  <#if modelbase.get_id_attributes(slave)?size != 1>
    <#assign conjSlave = slave>
    <#assign conjSlaveEnum = appbase.get_conj_enum(conjSlave)>
  </#if>
  <#list slave.attributes as attr>
    <#if attr.type.name == master.name>
      <#assign masterInSlave = master>
      <#break>
    </#if>
    <#list slaves as innerSlave>
      <#if attr.type.name == innerSlave.name>
        <#assign masterInSlave = innerSlave>
        <#break>
      </#if>
    </#list>
  </#list>
</#list>
<#if conjSlave != ''>
  <#list conjSlave.attributes as attr>
    <#list slaves as slave>
      <#if attr.type.name == slave.name>
        <#assign detailSlave = slave>
        <#assign attrRefDetailSlave = attr>
        <#break>
      </#if>
    </#list>
  </#list>
</#if>
<#--!
#### 【多对一】模式的保存操作。由三个对象组成：
####  1. 连接对象
####  2. 主要对象
####  3. 详细对象
####  填写的内容主要是在详细对象中，通过连接对象找到映射模式中的主对象并与其关联。
####
#### 规则：
#### 1. 从自己的属性中找到应用主对象或者从对象的属性
#### 2.
####
--->
<#assign attrRefDetailMany = ''>
<#-- 连接作用的对象 -->
<#assign conjMany = ''>
<#-- 连接的主要对象 -->
<#assign masterMany = ''>
<#-- 连接的详细对象 -->
<#assign detailMany = ''>
<#-- 算法：分别找到以上三个对象 -->
<#list manys as many>
  <#if modelbase.get_id_attributes(many)?size != 1>
    <#assign conjMany = many>
  </#if>
  <#list many.attributes as attr>
    <#if attr.type.name == master.name>
      <#assign masterMany = master>
      <#break>
    </#if>
    <#list slaves as slave>
      <#if attr.type.name == slave.name>
        <#assign masterMany = slave>
        <#break>
      </#if>
    </#list>
  </#list>
</#list>
<#if conjMany != ''>
  <#list conjMany.attributes as attr>
    <#list manys as many>
      <#if attr.type.name == many.name>
        <#assign detailMany = many>
        <#assign attrRefDetailMany = attr>
        <#break>
      </#if>
    </#list>
  </#list>
</#if>
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

ObjectMap save(ApplicationContext spring, ObjectMap params) {
  Timestamp now = new Timestamp(System.currentTimeMillis())
  ObjectMap ret = new ObjectMap()
  CommonService commonService = spring.getBean("commonService")

  /*!
  ** 公共参数
  */
  Timestamp lastModifiedTime = now
  String modifierId = params.get("modifierId")
  String modifierType = "STDBIZ.SAM.USER"
  String state = "E"

  /*!
  ** 授权验证
  */
  if (Strings.isBlank(modifierId)) {
    throw new ServiceException(401, "未授权的访问！")
  }
  ObjectMap currentUser = commonService.single("tn_sam_usr.find", new SqlParams()
      .set("userId", modifierId)
      .set("_left_join", "left join tn_pcm_dr dr on dr.drid = usr.usrId ")
      .set("_other_select", "dr.hospid hospitalId, dr.clinid clinicId, dr.drid doctorId "))
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
<@appbase.print_variant_params_getters obj=master paramsName='params' label='' varprefix='' indent=2 />

<#--
 ### 隐式业务标识字段。
 -->
<#assign implicitBizuniques = appbase.get_implicit_bizunique_attributes(master)>
<#list implicitBizuniques as attr>
  String ${modelbase.get_attribute_sql_name(attr)} = params.get("${appbase.get_attribute_parameter_name(attr)}")
</#list>
<#list slaves as slave>
  <#if slave == detailSlave && conjSlaveEnum.values??>
    <#list conjSlaveEnum.values as val>
<@appbase.print_variant_params_getters obj=slave paramsName='params' label=conjSlaveEnum.texts[val?index] varprefix=conjSlaveEnum.codes[val?index] indent=2 />
    </#list>
  <#else>
<@appbase.print_variant_params_getters obj=slave paramsName='params' label='' varprefix='' indent=2 />
  </#if>
</#list>
<#if manys?size != 0 && conjMany != ''>
  // ${modelbase.get_object_label(conjMany)}
  List<ObjectMap> ${java.nameVariable(conjMany.name)}List = params.get("${java.nameVariable(conjMany.name)}List")
</#if>

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
  // 序列字段
  String dateCode = Dates.stringify(now).replaceAll("-", "")
<#--<@appbase.print_implicit_bizunique_attributes obj=master />-->
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
  /*!
  ** 必填项验证。
  */
<#-- 【映射模式】必填验证 -->
<@appbase.print_params_required_validations obj=master label='' varprefix='' indent=2 />
<#list slaves as slave>
  <#if slave == detailSlave && conjSlaveEnum.values??>
    <#list conjSlaveEnum.values as val>
<@appbase.print_params_required_validations obj=slave label=conjSlaveEnum.texts[val?index] varprefix=conjSlaveEnum.codes[val?index] indent=2 />
    </#list>
  <#else>
<@appbase.print_params_required_validations obj=slave label='' varprefix='' indent=2 />
  </#if>

</#list>
<#-- 【扩展模式】必填验证 -->
<#if meta != '' && appbase.is_valid_object(meta)>
<@appbase.print_params_required_validations obj=meta label='' varprefix='' indent=2 />
</#if>
  /*!
  ** 格式验证。
  */
<#-- 【映射模式】格式验证 -->
<@appbase.print_params_format_validations obj=master indent=2 />
<#list slaves as slave>
<@appbase.print_params_format_validations obj=slave indent=2 />
</#list>
<#if meta != '' && appbase.is_valid_object(meta)>
<#-- 【扩展模式】必填验证 -->
<@appbase.print_params_format_validations obj=meta indent=2 />
</#if>
  /*!
  ** 值域有效性验证。
  */
<@appbase.print_params_value_validations obj=master label='' varprefix='' indent=2 />
<#list slaves as slave>
  <#if slave == detailSlave && conjSlaveEnum.values??>
    <#list conjSlaveEnum.values as val>
<@appbase.print_params_value_validations obj=slave label=conjSlaveEnum.texts[val?index] varprefix=conjSlaveEnum.codes[val?index] indent=2 />
    </#list>
  <#else>
<@appbase.print_params_value_validations obj=slave label='' varprefix='' indent=2 />
  </#if>
</#list>
<#if meta != '' && appbase.is_valid_object(meta)>
<@appbase.print_params_value_validations obj=meta label='' varprefix='' indent=2 />
</#if>
<#if pivot != '' && appbase.is_valid_object(pivot)>
<@appbase.print_params_value_validations obj=pivot label='' varprefix='' indent=2 />
</#if>
  if (errors != "") {
    throw new ServiceException(400, errors)
  }

<#-- 【映射模式】的业务唯一性验证，业务唯一性值存在于【映射模式】的情况 -->
<#assign existingBusinessUniques = {}>
<@appbase.print_params_bizunique_validation obj=master indent=2 />
<#list slaves as slave>
<@appbase.print_params_bizunique_validation obj=slave indent=2 />
</#list>

<#if bizuniqueObj != ''>
  /*!
  ** 通过业务标识查询已存在的【${modelbase.get_object_label(bizuniqueObj)}】
  */
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
  ObjectMap existing${java.nameType(bizuniqueObj.name)} = commonService.single(
      '${bizuniqueObj.persistenceName}.match', new SqlParams()
  <#list bizuniqueAttrs as bizuniqueAttr>
    .set('${modelbase.get_attribute_sql_name(bizuniqueAttr)}', ${modelbase.get_attribute_sql_name(bizuniqueAttr)})
  </#list>
  )
  if (existing${java.nameType(bizuniqueObj.name)} != null) {
    <#assign refObj = model.findObjectByName(bizuniqueObj.name)>
    <#assign refObjAttrId = modelbase.get_id_attributes(refObj)[0]>
    if (Strings.isBlank(${modelbase.get_attribute_sql_name(bizuniqueObjRefAttr)})) {
      ${modelbase.get_attribute_sql_name(bizuniqueObjRefAttr)} = existing${java.nameType(bizuniqueObj.name)}.get('${modelbase.get_attribute_sql_name(refObjAttrId)}')
    } else if (!${modelbase.get_attribute_sql_name(bizuniqueObjRefAttr)}.equals(existing${java.nameType(bizuniqueObj.name)}.get('${modelbase.get_attribute_sql_name(refObjAttrId)}'))) {
      throw new ServiceException(400, "已存在${modelbase.get_object_label(bizuniqueObj)}数据，但是标识不一致，请检查传入参数！")
    }
  }
</#if>

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
  <#if conjSlave != '' && (slave == conjSlave || detailSlave == slave)><#continue></#if>
<#--<@appbase.print_variant_object_existing obj=slave indent=2 />-->
</#list>

<#--!
#### 业务编码的字段的赋值。通常商业业务存在用时间编码，也就是这种20221012110001
#### 数据格式，利用YYYYMMDDNNNNNN模式对流水号进行有序增加。这种统一叫序列字段，
#### 在系统中用sequence表示。
####
#### 规则：
####
#### 1. 主键标识
#### 2. 业务唯一字段
####
--->
<#assign codeFields = {}>
<#list master.attributes as attr>
<@appbase.print_variant_sequence_assign obj=master attr=attr indent=2/>
</#list>
<#list slaves as slave>
  <#list slave.attributes as attr>
<@appbase.print_variant_sequence_assign obj=slave attr=attr indent=2/>
  </#list>
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

  if (existing${java.nameType(master.name)} != null) {
    ${java.nameVariable(master.name)}.set(existing${java.nameType(master.name)})
<@appbase.print_variant_null_setters obj=master indent=4 />
  }

<@appbase.print_sqlparams_attribute_setters obj=master varprefix='' indent=2 />

<@appbase.print_sqlparams_system_setters obj=master varprefix='' indent=2 />

  // 保存【${modelbase.get_object_label(master)}】对象
  if (existing${java.nameType(master.name)} == null) {
    commonService.execute("${master.getLabelledOptions("persistence")["name"]}.create", ${java.nameVariable(master.name)})
  } else {
    commonService.execute("${master.getLabelledOptions("persistence")["name"]}.update", ${java.nameVariable(master.name)})
  }
<#list slaves as slave>
  <#if conjSlave != ''>
    <#if slave == conjSlave><#continue></#if>
  </#if>
  <#if detailSlave != ''>
    <#if slave == detailSlave><#continue></#if>
  </#if>
  // 装配【${modelbase.get_object_label(slave)}】参数
  SqlParams ${java.nameVariable(slave.name)} = new SqlParams()

  if (existing${java.nameType(slave.name)} != null) {
    ${java.nameVariable(slave.name)}.set(existing${java.nameType(slave.name)})
  }

  <#assign slaveAttrIds = modelbase.get_id_attributes(slave)>
<@appbase.print_sqlparams_attribute_setters obj=slave varprefix='' indent=2 />

<@appbase.print_sqlparams_system_setters obj=slave varprefix='' indent= 2/>

  // 保存【${modelbase.get_object_label(slave)}】对象
  if (existing${java.nameType(slave.name)} == null) {
    commonService.execute("${slave.getLabelledOptions("persistence")["name"]}.create", ${java.nameVariable(slave.name)})
  } else {
    commonService.execute("${slave.getLabelledOptions("persistence")["name"]}.update", ${java.nameVariable(slave.name)})
  }
</#list>
<#-- 开始列出代码 -->
<#if conjSlave != ''>
  <#if conjSlaveEnum.values??>
  /*!
  ************************
  ** 同一张表不同类型的表达 **
  ************************
  */
    <#list conjSlaveEnum.values as val>
  <#-- 连接对象的参数定义 -->
  <#assign attrIds = modelbase.get_id_attributes(conjSlave)>
  <#assign detailSlaveAttrIds = modelbase.get_id_attributes(detailSlave)>
  <#list attrIds as attrId>
    <#if existingAttrIds[modelbase.get_attribute_sql_name(attrId)]??><#continue></#if>
    <#assign existingAttrIds = existingAttrIds + {modelbase.get_attribute_sql_name(attrId): attrId}>
  </#list>
  /*!
  ** 查询已经存在的【${conjSlaveEnum.texts[val?index]}】${modelbase.get_object_label(conjSlave)}
  */
  SqlParams ${java.nameVariable(conjSlaveEnum.codes[val?index])}${java.nameType(conjSlave.name)} = new SqlParams()
  SqlParams ${java.nameVariable(conjSlaveEnum.codes[val?index])}${java.nameType(detailSlave.name)} = new SqlParams()
<#--<@appbase.print_sqlparams_attribute_setters obj=conjSlave varprefix=conjSlaveEnum.codes[val?index] indent=2 />-->
  <#list conjSlave.attributes as attr>
    <#if modelbase.is_attribute_system(attr)><#continue></#if>
    <#assign dfltval = attr.getLabelledOptions("properties")['default']!''>
    <#if attr.name == attrRefDetailSlave.name>
  ${appbase.rename_object_var_name(conjSlaveEnum.codes[val?index], conjSlave)}.set("${modelbase.get_attribute_sql_name(attr)}", ${appbase.rename_attribute_var_name(conjSlaveEnum.codes[val?index], attr)})
    <#elseif appbase.string_is_array(dfltval)>
  ${appbase.rename_object_var_name(conjSlaveEnum.codes[val?index], conjSlave)}.set("${modelbase.get_attribute_sql_name(attr)}", "${conjSlaveEnum.values[val?index]}")
    <#else>
  ${appbase.rename_object_var_name(conjSlaveEnum.codes[val?index], conjSlave)}.set("${modelbase.get_attribute_sql_name(attr)}", ${modelbase.get_attribute_sql_name(attr)})
    </#if>
  </#list>
  ObjectMap existing${java.nameType(conjSlaveEnum.codes[val?index])}${java.nameType(detailSlave.name)} = null
  ObjectMap existing${java.nameType(conjSlaveEnum.codes[val?index])}${java.nameType(conjSlave.name)} = null
  <#list conjSlave.attributes as attr>
    <#if attr.type.name == detailSlave.name?replace('_obj', '')>
      <#-- 关联属性关联到明细对象时，则忽略此参数 -->
  ${java.nameVariable(conjSlaveEnum.codes[val?index])}${java.nameType(conjSlave.name)}.set("${modelbase.get_attribute_sql_name(attr)}", null)
    </#if>
  </#list>
  existing${java.nameType(conjSlaveEnum.codes[val?index])}${java.nameType(conjSlave.name)} = commonService.single("${conjSlave.persistenceName}.find", ${java.nameVariable(conjSlave.name)})
  if (existing${java.nameType(conjSlaveEnum.codes[val?index])}${java.nameType(conjSlave.name)} != null) {
  <#list conjSlave.attributes as attr>
    <#if attr.type.name == detailSlave.name?replace('_obj', '')>
    ${modelbase.get_attribute_sql_name(attr)} = existing${java.nameType(conjSlaveEnum.codes[val?index])}${java.nameType(conjSlave.name)}.get("${modelbase.get_attribute_sql_name(detailSlaveAttrIds[0])}")
    existing${java.nameType(conjSlaveEnum.codes[val?index])}${java.nameType(conjSlave.name)} = commonService.single("${detailSlave.persistenceName}.find", new SqlParams().set("${modelbase.get_attribute_sql_name(detailSlaveAttrIds[0])}", ${modelbase.get_attribute_sql_name(attr)}))
    </#if>
  </#list>
  }
  if (existing${java.nameType(conjSlaveEnum.codes[val?index])}${java.nameType(detailSlave.name)} != null) {
    ${java.nameVariable(conjSlaveEnum.codes[val?index])}${java.nameType(conjSlave.name)}.set(existing${java.nameType(conjSlaveEnum.codes[val?index])}${java.nameType(conjSlave.name)})
    ${appbase.rename_attribute_var_name(conjSlaveEnum.codes[val?index], attrRefDetailSlave)} = existing${java.nameType(detailSlave.name)}.get("${modelbase.get_attribute_sql_name(detailSlaveAttrIds[0])}")
  } else {
    ${appbase.rename_attribute_var_name(conjSlaveEnum.codes[val?index], attrRefDetailSlave)} = Strings.id()
  }
<@appbase.print_sqlparams_attribute_setters obj=detailSlave varprefix=conjSlaveEnum.codes[val?index] indent=2 />
  if (existing${java.nameType(detailSlave.name)} == null) {
    commonService.execute("${detailSlave.persistenceName}.create", ${java.nameVariable(detailSlave.name)})
  } else {
    commonService.execute("${detailSlave.persistenceName}.update", ${java.nameVariable(detailSlave.name)})
  }
  <#list conjSlave.attributes as attr>
    <#if attr.type.name == detailSlave.name?replace('_obj', '')>
  ${java.nameVariable(conjSlaveEnum.codes[val?index])}${java.nameType(conjSlave.name)}.set("${modelbase.get_attribute_sql_name(attr)}", ${appbase.rename_attribute_var_name(conjSlaveEnum.codes[val?index], attr)})
    </#if>
  </#list>
  if (existing${java.nameType(conjSlaveEnum.codes[val?index])}${java.nameType(conjSlave.name)} == null) {
    commonService.execute("${conjSlave.persistenceName}.create", ${java.nameVariable(conjSlaveEnum.codes[val?index])}${java.nameType(conjSlave.name)})
  } else {
    commonService.execute("${conjSlave.persistenceName}.update", ${java.nameVariable(conjSlaveEnum.codes[val?index])}${java.nameType(conjSlave.name)})
  }

    </#list>
  </#if>
</#if>

<#--!
#### 【行列转换】模式，赋值
--->
<#if pivot != '' && appbase.is_valid_object(pivot)>

  <#assign pivotAttrIds = modelbase.get_id_attributes(pivot)>
  // ${modelbase.get_object_label(pivot)}
  SqlParams ${java.nameVariable(pivot.name)}
  <#assign firstCustomAttr = ''>
  <#-- 找到第一个自定义的属性 -->
  <#list pivot.attributes as attr>
    <#assign custom = attr.getLabelledOptions("properties")["custom"]!''>
    <#if custom?is_boolean && custom == true>
      <#assign firstCustomAttr = attr>
      <#break>
    </#if>
  </#list>
  <#assign pivotColumns = []>
  <#assign valueAttr = ''>
  <#-- 找到所有定义的行转列的字段 -->
  <#list pivot.attributes as attr>
    <#if attr.name?index_of('pivot_') == 0>
      <#assign pivotColumns = pivotColumns + [attr]>
    </#if>
  </#list>
  <#list pivotColumns as pivotColumn>
  // ${pivotColumn.getLabelledOptions('properties')[firstCustomAttr.name]}参数封装
  ${java.nameVariable(pivot.name)} = new SqlParams()
    <#list pivotAttrIds as pivotAttrId>
      <#if pivotAttrId.type.custom>
  ${java.nameVariable(pivot.name)}.set("${modelbase.get_attribute_sql_name(pivotAttrId)}", ${modelbase.get_attribute_sql_name(pivotAttrId)})
      </#if>
    </#list>
    <#list pivotColumn.getLabelledOptions('properties') as key, val>
      <#if val?string == '@'>
  ${java.nameVariable(pivot.name)}.set("${java.nameVariable(key)}", params.get("${java.nameVariable(key)}4${pivotColumn.getLabelledOptions('properties')[firstCustomAttr.name]}"))
      </#if>
    </#list>
    <#list pivot.attributes as attr>
      <#assign custom = attr.getLabelledOptions("properties")["custom"]!''>
      <#assign value = pivotColumn.getLabelledOptions('properties')[attr.name]!''>
      <#if !custom?is_boolean || !custom><#continue></#if>
      <#if value?index_of('@') == -1 && value != "">
  ${java.nameVariable(pivot.name)}.set("${modelbase.get_attribute_sql_name(attr)}", "${value}")
      </#if>
    </#list>
<@appbase.print_sqlparams_system_setters obj=pivot varprefix='' indent=2 />
  commonService.execute("${pivot.persistenceName}.delete", ${java.nameVariable(pivot.name)})
  commonService.execute("${pivot.persistenceName}.create", ${java.nameVariable(pivot.name)})
  </#list>
</#if>
<#--!
#### 【扩展转换】模式
--->
<#if meta != '' && appbase.is_valid_object(meta)>

  <#assign metaAttrIds = modelbase.get_id_attributes(meta)>
  // ${modelbase.get_object_label(meta)}
  SqlParams ${java.nameVariable(meta.name)}
  <#assign metaColumns = []>
  <#assign valueAttr = ''>
  <#-- 找到所有定义的行转列的字段 -->
  <#list meta.attributes as attr>
    <#if attr.name?index_of('meta_') == 0>
      <#assign metaColumns = metaColumns + [attr]>
    </#if>
  </#list>
  <#list metaColumns as metaColumn>
  // 【${metaColumn.getLabelledOptions('properties')['title']}】参数封装
  ${java.nameVariable(meta.name)} = new SqlParams()
    <#list meta.attributes as attr>
      <#if attr.identifiable>
  ${java.nameVariable(meta.name)}.set("${modelbase.get_attribute_sql_name(attr)}", ${modelbase.get_attribute_sql_name(attr)})
      </#if>
    </#list>
  ${java.nameVariable(meta.name)}.set("propertyName", "${metaColumn.getLabelledOptions('properties')['title']}")
  ${java.nameVariable(meta.name)}.set("propertyValue", params.get("${metaColumn.getLabelledOptions('properties')['title']}"))
<@appbase.print_sqlparams_system_setters obj=meta varprefix='' indent=2 />
  commonService.execute("${meta.persistenceName}.delete", ${java.nameVariable(meta.name)})
  commonService.execute("${meta.persistenceName}.create", ${java.nameVariable(meta.name)})
  </#list>
</#if>
<#if conjMany != ''>
  /*!
  ** 处理多个对应对象
  */
  if (${java.nameVariable(conjMany.name)}List != null) {
  <#list manys as manyObj>
    <#list manyObj.attributes as attr>
      <#assign dfltval = attr.getLabelledOptions('properties')['default']!''>
      <#if appbase.string_is_array(dfltval)>
    List<String> ${modelbase.get_attribute_sql_name(attr)}Values = []
    List<String> ${modelbase.get_attribute_sql_name(attr)}Texts = []
      </#if>
    </#list>
  </#list>
    for (ObjectMap paramsMany : ${java.nameVariable(conjMany.name)}List) {
  <#list manys as manyObj>
<@appbase.print_variant_params_getters obj=manyObj paramsName='paramsMany' label='' varprefix='' indent=6 />
  </#list>
  <#list manys as manyObj>
<@appbase.print_params_required_validations obj=manyObj label='' varprefix='' indent=6 />
  </#list>
  <#list manys as manyObj>
<@appbase.print_params_format_validations obj=manyObj indent=6 />
  </#list>
  <#list manys as manyObj>
<@appbase.print_params_value_validations obj=manyObj indent=6 />
  </#list>
    }
  }
</#if>

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
  <#if conjSlave != '' && (conjSlave == slave || detailSlave == slave)>
    <#continue>
  </#if>
  <#assign slaveAttrIds = modelbase.get_id_attributes(slave)>
  <#list slaveAttrIds as slaveAttrId>
  ret.set("${modelbase.get_attribute_sql_name(slaveAttrId)}", ${modelbase.get_attribute_sql_name(slaveAttrId)})
  </#list>
</#list>
<#list slaves as slave>
  <#if conjSlave != '' && (conjSlave == slave || detailSlave == slave)>
    <#list conjSlaveEnum.values as val>
  ret.set("${appbase.rename_object_var_name(conjSlaveEnum.codes[val?index], attrRefDetailSlave)}", ${appbase.rename_attribute_var_name(conjSlaveEnum.codes[val?index], attrRefDetailSlave)})
    </#list>
    <#break>
  </#if>
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

JsonData ret = new JsonData()
ObjectMap innerParams
ObjectMap data
try {
  commonService.beginTransaction()
  data = save(spring, params)
<#if master.isLabelled("params")>
  <#assign params = master.getLabelledOptions("params")>
  <#list params?keys as key>
  innerParams = new ObjectMap()
    <#list params[key]?keys as innerKey>
  innerParams.set("${innerKey}", "${params[key][innerKey]?replace("${", "\\${")}")
    </#list>
  params.set("${key}", innerParams)
  </#list>
  data = common.transact(spring, shell, scriptRoot, params, data)
</#if>
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


