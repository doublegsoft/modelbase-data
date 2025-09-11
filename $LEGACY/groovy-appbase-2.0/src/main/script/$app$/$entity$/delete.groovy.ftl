<#import '/$/modelbase.ftl' as modelbase>
import java.util.List
import java.util.ArrayList
import java.util.Map
import java.io.File

import groovy.lang.GroovyShell
import groovy.lang.Script

import org.springframework.context.ApplicationContext

import net.doublegsoft.appbase.JsonData
import net.doublegsoft.appbase.ObjectMap
import net.doublegsoft.appbase.SqlParams
import net.doublegsoft.appbase.dao.CommonDataAccess
import net.doublegsoft.appbase.service.CommonService
import net.doublegsoft.appbase.service.GroovyService
import net.doublegsoft.appbase.util.Strings

<#-- 准备数据 -->
<#assign attrId = modelbase.get_id_attributes(entity)[0]>
<#assign attrRefs = []>
<#list entity.attributes as attr>
  <#if attr.type.collection>
    <#assign componentType = attr.type.componentType>
    <#if componentType.custom>
      <#assign attrRefs = attrRefs + [attr]>
    </#if>
  </#if>
</#list>
ObjectMap delete(ApplicationContext spring, ObjectMap params) {
  if (Strings.isBlank(params.get("${modelbase.get_attribute_sql_name(attrId)}"))) {
    throw new RuntimeException("数据标识没有传入，请联系管理员！")
  }

  String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
  CommonService commonService = spring.getBean("commonService" + _data_source)
  SqlParams sqlParams = new SqlParams();
  sqlParams.set(params)
  
  commonService.execute("${entity.persistenceName}.delete", sqlParams)
  <#list attrRefs as attrRef>
    <#assign attrRefObj = model.findObjectByName(attrRef.type.componentType.name)>
  if (params.get("_remove_${attrRef.name}") == "true") {
    <#if attrRef.getLabelledOptions('persistence')['conjunction']??>
      <#assign conjObj = model.findObjectByName(attrRef.getLabelledOptions('persistence')['conjunction'])>
    commonService.execute("${conjObj.persistenceName}.delete", sqlParams);
    <#else>
    commonService.execute("${attrRefObj.persistenceName}.delete", sqlParams);
    </#if>
  }
  </#list>
  return params
}

ObjectMap handle(ApplicationContext spring, ObjectMap params) {
  return delete(spring, params)
}

ApplicationContext spring = binding.getVariable("spring")
ObjectMap params = binding.getVariable("params")
GroovyService groovyService = spring.getBean(GroovyService.class)
String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
CommonDataAccess commonDataAccess = spring.getBean("commonDataAccess" + _data_source)
GroovyShell shell = new GroovyShell()

String scriptRoot = groovyService.getRoot()
Script common = shell.parse(new File(scriptRoot + "/common.groovy"))

try {
  commonDataAccess.beginTransaction()
  ObjectMap data = delete(spring, params)
  data = common.transact(spring, shell, scriptRoot, params, data)
  commonDataAccess.commit()
} catch (Throwable cause) {
  commonDataAccess.rollback()
  return new JsonData().error(cause.getMessage())
} 

return new JsonData()