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

<#assign attrWhatId = ''>
<#assign attrWhatType = ''>
<#assign implicitReferences = modelbase.get_object_implicit_references(value)>
<#list implicitReferences as implicitReferenceName, implicitReference>
  <#list implicitReference as value, attr>
    <#if value == 'id'>
      <#assign attrWhatId = attr>
    <#elseif value == 'type'>
      <#assign attrWhatType = attr>
    </#if>
  </#list>
</#list>
ObjectMap remove(ApplicationContext spring, ObjectMap params) {
  String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
  CommonService commonService = spring.getBean("commonService" + _data_source)

  List<String> referenceIds = new ArrayList<>()

  <#if attrWhatId?string != '' >
  Object item = params.get("${modelbase.get_attribute_sql_name(attrWhatId)}")
  if (List.isAssignableFrom(item.getClass())) {
    referenceIds.addAll((List) item)
  } else {
    referenceIds.add(item)
  }
  </#if>

  SqlParams sqlParams = new SqlParams();
  sqlParams.set(params)

  commonService.execute("${value.persistenceName}.delete", sqlParams)
  for (String referenceId : referenceIds) {
<#if attrWhatId?string != '' >
    sqlParams.set("${modelbase.get_attribute_sql_name(attrWhatId)}", referenceId)
    commonService.execute("${value.persistenceName}.delete", sqlParams)
</#if>
  }
  return params
}

ObjectMap handle(ApplicationContext spring, ObjectMap params) {
  return remove(spring, params)
}

ApplicationContext spring = binding.getVariable("spring")
ObjectMap params = binding.getVariable("params")
GroovyService groovyService = spring.getBean(GroovyService.class)

String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
CommonDataAccess commonDataAccess = spring.getBean("commonDataAccess" + _data_source)
GroovyShell shell = new GroovyShell()

String scriptRoot = groovyService.getRoot()
Script common = shell.parse(new File(scriptRoot + "/common.groovy"))

ObjectMap data
try {
  commonDataAccess.beginTransaction()
  data = remove(spring, params)
  data = common.transact(spring, shell, scriptRoot, params, data)
  commonDataAccess.commit()
} catch (Throwable cause) {
  commonDataAccess.rollback()
  return new JsonData().error(cause.getMessage())
} 

return new JsonData().set(data)