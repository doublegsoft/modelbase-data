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

ObjectMap update(ApplicationContext spring, ObjectMap params) {
  String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
  CommonService commonService = spring.getBean("commonService" + _data_source)
  
  commonService.execute("${entity.persistenceName}.update", new SqlParams().set(params))

  return params
}

ObjectMap handle(ApplicationContext spring, ObjectMap params) {
  return update(spring, params)
}

ApplicationContext spring = binding.getVariable("spring")
ObjectMap params = binding.getVariable("params")

String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
CommonDataAccess commonDataAccess = spring.getBean("commonDataAccess" + _data_source)

ObjectMap data 
try {
  commonDataAccess.beginTransaction()
  data = update(spring, params)
  commonDataAccess.commit()
} catch (Throwable cause) {
  commonDataAccess.rollback()
  return new JsonData().error(cause.getMessage())
} 

return new JsonData().set(data)