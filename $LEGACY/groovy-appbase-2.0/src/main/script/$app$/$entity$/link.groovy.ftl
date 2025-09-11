<#import '/$/modelbase.ftl' as modelbase>
import java.util.List
import java.util.ArrayList
import java.util.Map
import java.io.File

import groovy.lang.GroovyShell
import groovy.lang.Script

import org.springframework.context.ApplicationContext

import ${namespace}.${java.nameNamespace(app.name)}.model.repository.${java.nameType(entity.name)}Repository
import ${namespace}.${java.nameNamespace(app.name)}.model.value.*
import net.doublegsoft.appbase.JsonData
import net.doublegsoft.appbase.ObjectMap
import net.doublegsoft.appbase.SqlParams
import net.doublegsoft.appbase.dao.CommonDataAccess
import net.doublegsoft.appbase.service.CommonService
import net.doublegsoft.appbase.service.GroovyService
import net.doublegsoft.appbase.util.Strings

ObjectMap link(ApplicationContext spring, ObjectMap params) {
  String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
  CommonService commonService = spring.getBean("commonService" + _data_source)
  <#list entity.attributes as attr>
    <#if attr.getLabelledOptions('persistence')['conjunction']??>
      <#assign conjObj = model.findObjectByName(attr.getLabelledOptions('persistence')['conjunction'])>
      <#list conjObj.attributes as conjObjAttr>
        <#if conjObjAttr.type.name == entity.name || !conjObjAttr.type.custom><#continue></#if>

  if (params.containsKey('${conjObj.name}')) {
    ObjectMap innerParams = params.get('${conjObj.name}')
    SqlParams sqlParams = new SqlParams().set(innerParams)
    if (innerParams.containsKey('${modelbase.get_attribute_sql_name(conjObjAttr)}s')) {
      commonService.execute('${conjObj.persistenceName}.delete', sqlParams)
      List<String> ${modelbase.get_attribute_sql_name(conjObjAttr)}s = innerParams.get('${modelbase.get_attribute_sql_name(conjObjAttr)}s')
      for (String ${modelbase.get_attribute_sql_name(conjObjAttr)} : ${modelbase.get_attribute_sql_name(conjObjAttr)}s) {
        sqlParams.set('${modelbase.get_attribute_sql_name(conjObjAttr)}', ${modelbase.get_attribute_sql_name(conjObjAttr)})
        commonService.execute('${conjObj.persistenceName}.create', sqlParams)
      }
    } else {
      commonService.execute('${conjObj.persistenceName}.create', sqlParams)
    }
  }
      </#list>
    </#if>
  </#list>  

  return params
}

ObjectMap handle(ApplicationContext spring, ObjectMap params) {
  return link(spring, params)
}

ApplicationContext spring = binding.getVariable("spring")
ObjectMap params = binding.getVariable("params")

String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
CommonDataAccess commonDataAccess = spring.getBean("commonDataAccess" + _data_source)

ObjectMap data 
try {
  commonDataAccess.beginTransaction()
  data = link(spring, params)
  commonDataAccess.commit()
} catch (Throwable cause) {
  commonDataAccess.rollback()
  return new JsonData().error(cause.getMessage())
} 

return new JsonData().set(data)