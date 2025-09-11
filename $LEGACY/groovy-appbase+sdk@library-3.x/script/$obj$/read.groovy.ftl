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
import java.sql.Timestamp;

import net.doublegsoft.appbase.service.CommonService
import net.doublegsoft.appbase.JsonData
import net.doublegsoft.appbase.ObjectMap
import net.doublegsoft.appbase.SqlParams
import net.doublegsoft.appbase.util.Strings
import org.springframework.context.ApplicationContext

ObjectMap read(ApplicationContext spring, ObjectMap params) {
  CommonService commonService = spring.getBean("commonService")
  ObjectMap ret = new ObjectMap()
  String modifierId = params.get("modifierId")
  /*!
  ** 授权验证
  */
  if (Strings.isBlank(modifierId)) {
    throw new ServiceException(401, "未授权的访问！")
  }
  ObjectMap currentUser = commonService.single("tn_sam_usr.find", new SqlParams().set("userId", params.get("modifierId")))
  if (currentUser == null) {
    throw new ServiceException(401, "未检索到授权用户！")
  }

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
<#--!
#### 列出所有对象的可用于唯一标识对象的字段。
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
  /*!
  ** 业务参数
  */
<#global printedAttrs = {}>
<#assign objsAndBizuniques = {}>
<#list master.attributes as attr>
  <#if attr.getLabelledOptions('properties')['businessUnique']!false == true>
    <#if !objsAndBizuniques[attr.parent.name]??>
      <#assign objsAndBizuniques = objsAndBizuniques + {attr.parent.name: []}>
    </#if>
    <#assign bizuniques = objsAndBizuniques[attr.parent.name]>
    <#assign bizuniques = objsAndBizuniques[attr.parent.name] + [attr]>
    <#assign objsAndBizuniques = objsAndBizuniques + {attr.parent.name: bizuniques}>
  </#if>
  <#assign input = attr.getLabelledOptions('properties')['input']!''>
  <#assign dfltval = attr.getLabelledOptions('properties')['default']!''>
  <#if printedAttrs[modelbase.get_attribute_sql_name(attr)]??><#continue></#if>
  <#if attr.constraint.identifiable ||
       attr.getLabelledOptions('properties')['businessUnique']!false == true ||
       input == 'sequence'>
    <#if input == 'constant' && dfltval?starts_with('=')>
  String ${modelbase.get_attribute_sql_name(attr)} = params.get("${java.nameVariable(dfltval?substring(1))}")
    <#else>
  String ${modelbase.get_attribute_sql_name(attr)} = params.get("${modelbase.get_attribute_sql_name(attr)}")
    </#if>
    <#assign printedAttrs = printedAttrs + {modelbase.get_attribute_sql_name(attr): attr}>
  </#if>
</#list>
<#assign implicitBizuniques = appbase.get_implicit_bizunique_attributes(master)>
<#list implicitBizuniques as attr>
  String ${modelbase.get_attribute_sql_name(attr)} = params.get("${modelbase.get_attribute_sql_name(attr)}")
</#list>
<#list slaves as slave>
  <#if conjSlave != '' && (conjSlave == slave || detailSlave == slave)><#continue></#if>
  <#list slave.attributes as attr>
    <#if attr.getLabelledOptions('properties')['businessUnique']!false == true>
      <#if !objsAndBizuniques[attr.parent.name]??>
        <#assign objsAndBizuniques = objsAndBizuniques + {attr.parent.name: []}>
      </#if>
      <#assign bizuniques = objsAndBizuniques[attr.parent.name]>
      <#assign bizuniques = objsAndBizuniques[attr.parent.name] + [attr]>
      <#assign objsAndBizuniques = objsAndBizuniques + {attr.parent.name: bizuniques}>
    </#if>
    <#assign input = attr.getLabelledOptions('properties')['input']!''>
    <#assign dfltval = attr.getLabelledOptions('properties')['default']!''>
    <#if printedAttrs[modelbase.get_attribute_sql_name(attr)]??><#continue></#if>
    <#if attr.constraint.identifiable ||
         attr.getLabelledOptions('properties')['businessUnique']!false == true ||
         input == 'sequence'>
      <#if input == 'constant' && dfltval?starts_with('=')>
        <#if !printedAttrs[dfltval?substring(1)]??>
  String ${dfltval?substring(1)} = params.get("${dfltval?substring(1)}">
        </#if>
  String ${modelbase.get_attribute_sql_name(attr)} = ${java.nameVariable(dfltval?substring(1))}
  if (Strings.isBlank(${modelbase.get_attribute_sql_name(attr)})) {
    ${modelbase.get_attribute_sql_name(attr)} = params.get("${modelbase.get_attribute_sql_name(attr)}")
    ${java.nameVariable(dfltval?substring(1))} = ${modelbase.get_attribute_sql_name(attr)}
  }
      <#else>
  String ${modelbase.get_attribute_sql_name(attr)} = params.get("${modelbase.get_attribute_sql_name(attr)}")
      </#if>
      <#assign printedAttrs = printedAttrs + {modelbase.get_attribute_sql_name(attr): attr}>
    </#if>
  </#list>
</#list>

<#--!
#### 变量有效性验证，变量的值来源于客户端的传参。
####
#### 规则：
####
#### 1. 标识参数
#### 2. 业务唯一参数
####
--->
  boolean hasValidParams = false
<#list printedAttrs?values as attr>
  <#if !attr.constraint.identifiable><#continue></#if>
  if (!Strings.isBlank(${modelbase.get_attribute_sql_name(attr)})) {
    hasValidParams = true
  }
</#list>
<#list objsAndBizuniques?values as bizuniques>
  if (
    <#list bizuniques as attr>
      !Strings.isBlank(${modelbase.get_attribute_sql_name(attr)}) &&
    </#list>
      true) {
    hasValidParams = true
  }
</#list>
<#if (implicitBizuniques?size > 0)>
  if (
    <#list implicitBizuniques as attr>
      !Strings.isBlank(${modelbase.get_attribute_sql_name(attr)}) &&
    </#list>
      true) {
    hasValidParams = true
  }
</#if>
<#list printedAttrs?values as attr>
  <#assign input = attr.getLabelledOptions('properties')['input']!''>
  <#if input != 'sequence'><#continue></#if>
  if (!Strings.isBlank(${modelbase.get_attribute_sql_name(attr)})) {
    hasValidParams = true
  }
</#list>
  if (!hasValidParams) {
    throw new ServiceException(400, "未传入必要的查询参数")
  }
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
  ObjectMap existing${java.nameType(master.name)}
<#list slaves as slave>
  <#if conjSlave != '' && (conjSlave == slave || detailSlave == slave)><#continue></#if>
  ObjectMap existing${java.nameType(slave.name)}
</#list>
  /*!
  ** 通过系统标识查询【${modelbase.get_object_label(master)}】
  */
  if (
<#list masterAttrIds as attrId>
      !Strings.isBlank(${modelbase.get_attribute_sql_name(attrId)}) &&
</#list>
      true) {
    existing${java.nameType(master.name)} = commonService.single("${master.persistenceName}.find", new SqlParams()
<#list masterAttrIds as attrId>
        .set("${modelbase.get_attribute_sql_name(attrId)}", ${modelbase.get_attribute_sql_name(attrId)})
</#list>
    )
  }
<#if objsAndBizuniques[master.name]?? && objsAndBizuniques[master.name]?size != 0>
  /*!
  ** 通过业务标识查询【${modelbase.get_object_label(master)}】
  */
  if (existing${java.nameType(master.name)} == null &&
  <#list master.attributes as attr>
    <#if !attr.getLabelledOptions('properties')['businessUnique']!false == true><#continue></#if>
      !Strings.isBlank(${modelbase.get_attribute_sql_name(attr)}) &&
  </#list>
      true) {
    existing${java.nameType(master.name)} = commonService.single("${master.persistenceName}.find", new SqlParams()
  <#list master.attributes as attr>
    <#if !attr.getLabelledOptions('properties')['businessUnique']!false == true><#continue></#if>
        .set("${modelbase.get_attribute_sql_name(attr)}", ${modelbase.get_attribute_sql_name(attr)})
  </#list>
    )
  }
</#if>
  if (existing${java.nameType(master.name)} == null) {
    throw new ServiceException(404, "没有找到相关信息")
  }
<#list slaves as slave>
  <#if conjSlave != '' && (conjSlave == slave || detailSlave == slave)><#continue></#if>
  /*!
  ** 通过系统标识查询【${modelbase.get_object_label(slave)}】
  */
  if (
  <#list modelbase.get_id_attributes(slave) as attrId>
      !Strings.isBlank(${modelbase.get_attribute_sql_name(attrId)}) &&
  </#list>
      true) {
    existing${java.nameType(slave.name)} = commonService.single("${slave.persistenceName}.find", new SqlParams()
  <#list modelbase.get_id_attributes(slave) as attrId>
        .set("${modelbase.get_attribute_sql_name(attrId)}", ${modelbase.get_attribute_sql_name(attrId)})
  </#list>
    )
  }
  <#if objsAndBizuniques[slave.name]?? && objsAndBizuniques[slave.name]?size != 0>
  /*!
  ** 通过业务标识查询【${modelbase.get_object_label(slave)}】
  */
  if (existing${java.nameType(slave.name)} == null &&
    <#list slave.attributes as attr>
     <#if !attr.getLabelledOptions('properties')['businessUnique']!false == true><#continue></#if>
      !Strings.isBlank(${modelbase.get_attribute_sql_name(attr)}) &&
    </#list>
      true) {
    existing${java.nameType(slave.name)} = commonService.single("${slave.persistenceName}.find", new SqlParams()
    <#list slave.attributes as attr>
      <#if !attr.getLabelledOptions('properties')['businessUnique']!false == true><#continue></#if>
        .set("${modelbase.get_attribute_sql_name(attr)}", ${modelbase.get_attribute_sql_name(attr)})
    </#list>
    )
    if (existing${java.nameType(slave.name)} == null) {
      throw new ServiceException(404, "无法找到满足条件的【${modelbase.get_object_label(slave)}】数据。")
    }
  }
  if (existing${java.nameType(master.name)} == null) {
    <#assign slaveAttrId = modelbase.get_id_attributes(slave)[0]>
    ${modelbase.get_attribute_sql_name(masterAttrIds[0])} = existing${java.nameType(slave.name)}.get("${modelbase.get_attribute_sql_name(slaveAttrId)}")
    existing${java.nameType(master.name)} = commonService.single("${master.persistenceName}.find", new SqlParams()
<#list masterAttrIds as attrId>
        .set("${modelbase.get_attribute_sql_name(attrId)}", ${modelbase.get_attribute_sql_name(attrId)})
</#list>
    )
  }
  </#if>
</#list>
<#if conjSlave != ''>
  List<ObjectMap> ${java.nameVariable(conjSlave.name)}List = commonService.many("${conjSlave.persistenceName}.find", new SqlParams()
  <#list conjSlave.attributes as attr>
    <#if modelbase.is_attribute_system(attr)><#continue></#if>
    <#assign dfltval = attr.getLabelledOptions("properties")['default']!''>
    <#if attr.name == attrRefDetailSlave.name || appbase.string_is_array(dfltval)><#continue></#if>
    .set("${modelbase.get_attribute_sql_name(attr)}", ${modelbase.get_attribute_sql_name(attr)})
  </#list>
  )
  for (${java.nameVariable(conjSlave.name)} : ${java.nameVariable(conjSlave.name)}List) {
  <#list detailSlave.attributes as attr>
    <#assign input = attr.getLabelledOptions("properties")['input']!'none'>
    <#if input == 'none'><#continue></#if>
    <#if modelbase.is_attribute_system(attr)><#continue></#if>
    Object ${modelbase.get_attribute_sql_name(attr)} = ${java.nameVariable(conjSlave.name)}.get("${modelbase.get_attribute_sql_name(attr)}")
  </#list>
  <#list conjSlave.attributes as attr>
    <#if modelbase.is_attribute_system(attr)><#continue></#if>
    <#assign input = attr.getLabelledOptions("properties")['input']!'none'>
    <#assign dfltval = attr.getLabelledOptions("properties")['default']!''>
    <#if input == 'none'><#continue></#if>
    <#if !appbase.string_is_array(dfltval)><#continue></#if>
    <#list conjSlaveEnum.values as val>
      <#if val?index == 0>
    if ("${val}".equals(${modelbase.get_attribute_sql_name(attr)})) {
      <#else>
    } else if ("${val}".equals(${modelbase.get_attribute_sql_name(attr)})) {
      </#if>
      <#list detailSlave.attributes as attrDetailSlave>
        <#assign inputDetailSlave = attrDetailSlave.getLabelledOptions("properties")['input']!'none'>
        <#if modelbase.is_attribute_system(attrDetailSlave)><#continue></#if>
        <#if inputDetailSlave == 'none'><#continue></#if>
      existing${java.nameType(master.name)}.set("${java.nameVariable(conjSlaveEnum.codes[val?index])}${java.nameType(modelbase.get_attribute_sql_name(attrDetailSlave))}", ${modelbase.get_attribute_sql_name(attrDetailSlave)})
      </#list>
    </#list>
    }
  </#list>
  }
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
<#-- 开始列出代码 -->
<#if conjMany != ''>
  <#-- 连接对象的参数定义 -->
  <#assign attrIds = modelbase.get_id_attributes(conjMany)>
  <#assign detailManyAttrIds = modelbase.get_id_attributes(detailMany)>
  <#list attrIds as attrId>
    <#if existingAttrIds[modelbase.get_attribute_sql_name(attrId)]??><#continue></#if>
      <#assign existingAttrIds = existingAttrIds + {modelbase.get_attribute_sql_name(attrId): attrId}>
  </#list>
  SqlParams ${java.nameVariable(conjMany.name)} = new SqlParams()
  SqlParams ${java.nameVariable(detailMany.name)} = new SqlParams()
<@appbase.print_sqlparams_attribute_setters obj=conjMany indent=2 />

  ObjectMap existing${java.nameType(detailMany.name)} = null
  ObjectMap existing${java.nameType(conjMany.name)} = null

  // 查询已经存在的
  <#list conjMany.attributes as attr>
    <#if attr.type.name == detailMany.name>
      <#-- 关联属性关联到明细对象时，则忽略此参数 -->
  ${java.nameVariable(conjMany.name)}.set("${modelbase.get_attribute_sql_name(attr)}", null)
    </#if>
  </#list>
  existing${java.nameType(conjMany.name)} = commonService.single("${conjMany.persistenceName}.find", ${java.nameVariable(conjMany.name)})
  if (existing${java.nameType(conjMany.name)} != null) {
  <#list conjMany.attributes as attr>
    <#if attr.type.name == detailMany.name>
    ${modelbase.get_attribute_sql_name(attr)} = existing${java.nameType(conjMany.name)}.get("${modelbase.get_attribute_sql_name(detailManyAttrIds[0])}")
    existing${java.nameType(detailMany.name)} = commonService.single("${detailMany.persistenceName}.find", new SqlParams().set("${modelbase.get_attribute_sql_name(detailManyAttrIds[0])}", ${modelbase.get_attribute_sql_name(attr)}))
    </#if>
  </#list>
  }
</#if>
<#--!
#### 【行列转换】模式，赋值
--->
<#if pivot != ''>

  <#assign pivotAttrIds = modelbase.get_id_attributes(pivot)>
  // ${modelbase.get_object_label(pivot)}
  SqlParams ${java.nameVariable(pivot.name)} = new SqlParams()
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
  <#list pivotAttrIds as pivotAttrId>
    <#if pivotAttrId.type.custom>
  ${java.nameVariable(pivot.name)}.set("${modelbase.get_attribute_sql_name(pivotAttrId)}", ${modelbase.get_attribute_sql_name(pivotAttrId)})
    </#if>
  </#list>
  List<ObjectMap> ${java.nameVariable(pivot.name)}List = commonService.many("${pivot.persistenceName}.find", ${java.nameVariable(pivot.name)})
  ObjectMap existing${java.nameType(pivot.name)} = new ObjectMap()
  for (ObjectMap ${java.nameVariable(pivot.name)}Item : ${java.nameVariable(pivot.name)}List) {
  <#list pivotColumns as pivotColumn>
    <#list pivot.attributes as attr>
      <#assign custom = attr.getLabelledOptions("properties")["custom"]!''>
      <#assign value = pivotColumn.getLabelledOptions('properties')[attr.name]!''>
      <#if !custom?is_boolean || !custom><#continue></#if>
      <#if value?index_of('@') == -1 && value != "">
        <#assign valueAttr = attr>
          <#break>
      </#if>
    </#list>
    <#list pivotColumn.getLabelledOptions('properties') as key, val>
      <#if val?string == '@'>
    if ("${pivotColumn.getLabelledOptions('properties')[firstCustomAttr.name]}".equals(${java.nameVariable(pivot.name)}Item.get("${modelbase.get_attribute_sql_name(valueAttr)}"))) {
      existing${java.nameType(pivot.name)}.set("${pivotColumn.getLabelledOptions('properties')[firstCustomAttr.name]}", ${java.nameVariable(pivot.name)}Item.get("${java.nameVariable(key)}"))
    }
      </#if>
    </#list>
  </#list>
  }
</#if>
<#--!
#### 【扩展转换】模式
--->
<#if meta != ''>

  <#assign metaAttrIds = modelbase.get_id_attributes(meta)>
  // ${modelbase.get_object_label(meta)}
  <#assign metaColumns = []>
  <#assign valueAttr = ''>
  <#-- 找到所有定义的行转列的字段 -->
  <#list meta.attributes as attr>
    <#if attr.name?index_of('meta_') == 0>
      <#assign metaColumns = metaColumns + [attr]>
    </#if>
  </#list>
  ${java.nameVariable(meta.name)} = new SqlParams()
  <#list meta.attributes as attr>
    <#if attr.identifiable>
  ${java.nameVariable(meta.name)}.set("${modelbase.get_attribute_sql_name(attr)}", ${modelbase.get_attribute_sql_name(attr)})
    </#if>
  </#list>
  List<ObjectMap> ${java.nameVariable(meta.name)}List = commonService.many("${meta.persistenceName}.find", ${java.nameVariable(meta.name)})
  ObjectMap existing${java.nameType(meta.name)} = new ObjectMap()
  for (ObjectMap ${java.nameVariable(meta.name)}Item : ${java.nameVariable(meta.name)}List) {
    existing${java.nameType(meta.name)}.set(${java.nameVariable(meta.name)}Item.get("propertyName"), ${java.nameVariable(meta.name)}Item.get("propertyValue"))
  }
</#if>
<#--!
#### 返回值。
####
#### 规则：返回数据原则是系统生成的业务数据，包括：标识，自动编码
####
--->
<#list slaves as slave>
  <#if conjSlave != '' && (conjSlave == slave || detailSlave == slave)><#continue></#if>
  if (existing${java.nameType(slave.name)} != null) {
    existing${java.nameType(master.name)}.merge(existing${java.nameType(slave.name)})
  }
</#list>
<#list manys as many>
  if (existing${java.nameType(many.name)} != null) {
    existing${java.nameType(master.name)}.merge(existing${java.nameType(many.name)})
  }
</#list>
<#if meta != ''>
  if (existing${java.nameType(meta.name)} != null) {
    existing${java.nameType(master.name)}.merge(existing${java.nameType(meta.name)})
  }
</#if>
<#if pivot != ''>
  if (existing${java.nameType(pivot.name)} != null) {
    existing${java.nameType(master.name)}.merge(existing${java.nameType(pivot.name)})
  }
</#if>
  ret.merge(existing${java.nameType(master.name)})
  return ret
}

ApplicationContext spring = binding.getVariable("spring")
ObjectMap params = binding.getVariable("params")
GroovyShell shell = new GroovyShell()

String scriptRoot = groovyService.getRoot()
Script common = shell.parse(new File(scriptRoot + "/common.groovy"))
CommonService commonService = spring.getBean("commonService")

ObjectMap innerParams
JsonData ret = new JsonData()
ObjectMap data
try {
  commonService.beginTransaction()
  data = read(spring, params)
<#if master.isLabelled("params")>
  <#assign params = master.getLabelledOptions("params")>
  <#list params?keys as key>
  innerParams = new ObjectMap()
    <#list params[key]?keys as innerKey>
  innerParams.set("${innerKey}", "${params[key][innerKey]?replace("${", "\\${")}")
    </#list>
  params.set("${key}", innerParams)
  </#list>
  data = common.conjunct(spring, shell, scriptRoot, params, data)
  data = common.hierarchize(spring, shell, scriptRoot, params, data)
</#if>
  ret.set("data", data)
  commonService.commit()
} catch (Throwable cause) {
  ret.error(500, cause.getMessage())
  commonService.rollback()
}

return ret