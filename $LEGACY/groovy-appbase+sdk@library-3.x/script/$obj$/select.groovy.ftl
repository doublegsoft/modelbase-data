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
<#global printedAttrs = {}>
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

List<ObjectMap> find(ApplicationContext spring, ObjectMap params) {
  CommonService commonService = spring.getBean("commonService")

  String modifierId = params.get("modifierId")
  // 当前用户
  if (Strings.isBlank(modifierId)) {
    throw new ServiceException(401, "未授权的访问！")
  }
  ObjectMap currentUser = commonService.single("tn_sam_usr.find", new SqlParams().set("userId", params.get("modifierId")))
  if (currentUser == null) {
    throw new ServiceException(401, "未检索到授权用户！")
  }

<#list master.attributes as attr>
  <#assign input = attr.getLabelledOptions('properties')['input']!'none'>
  <#assign dfltval = attr.getLabelledOptions('properties')['default']!''>
  <#if input == 'parameter'>
  String ${modelbase.get_attribute_sql_name(attr)} = params.get("${modelbase.get_attribute_sql_name(attr)}")
  <#elseif input == 'constant'>
  String ${modelbase.get_attribute_sql_name(attr)} = "${dfltval}"
  </#if>
</#list>

<#list master.attributes as attr>
  <#assign input = attr.getLabelledOptions('properties')['input']!'none'>
  <#assign title = attr.getLabelledOptions('properties')['title']!''>
  <#if input == 'parameter'>
  if (Strings.isBlank(${modelbase.get_attribute_sql_name(attr)})) {
    throw new ServiceException(400, "未传入${title}的参数值")
  }
  </#if>
</#list>

  Integer start = params.get("start")
  Integer limit = params.get("limit")

  SqlParams sqlParams = new SqlParams().set(params)
<#list master.attributes as attr>
  <#assign input = attr.getLabelledOptions('properties')['input']!'none'>
  <#if input == 'parameter'>
  sqlParams.set("${modelbase.get_attribute_sql_name(attr)}", ${modelbase.get_attribute_sql_name(attr)})
  <#elseif input == 'constant'>
  sqlParams.set("${modelbase.get_attribute_sql_name(attr)}", ${modelbase.get_attribute_sql_name(attr)})
  </#if>
</#list>

<#if master.isLabelled("params")>
  <#assign params = master.getLabelledOptions("params")>
  <#list params as key, val>
  sqlParams.set("${key}", "${val?replace('\n', '')?replace('  ', '')}")
  </#list>
</#if>

  List<ObjectMap> ret
  if (start == null && limit == null) {
    ret = commonService.many("${master.persistenceName}.find", sqlParams)
  } else {
    start = start == null ? 0 : start
    limit = limit == null ? -1 : limit
    ret = commonService.paginate("${master.persistenceName}.find", start, limit, sqlParams).getData()
  }
  /*!
  ** 去掉无用的字段
  */
  for (ObjectMap item : ret) {
<#list master.attributes as attr>
  <#assign input = attr.getLabelledOptions('properties')['input']!'none'>
  <#if input == 'none'>
    item.remove("${modelbase.get_attribute_sql_name(attr)}")
  </#if>
</#list>
  }
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
List<ObjectMap> data
List items
try {
  commonService.beginTransaction()
  data = find(spring, params)
  data = common.conjunct(spring, shell, scriptRoot, params, data)
  data = common.hierarchize(spring, shell, scriptRoot, params, data)
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