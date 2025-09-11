<#import "/$/modelbase.ftl" as modelbase>
<#assign attrId = modelbase.get_id_attributes(entity)[0]>
import java.util.List
import java.util.ArrayList
import java.util.Map
import java.util.Set
import java.util.HashSet
import java.io.File

import groovy.lang.GroovyShell
import groovy.lang.Script

import org.springframework.context.ApplicationContext

import ${namespace}.${java.nameNamespace(app.name)}.model.entity.${java.nameType(entity.name)}
import ${namespace}.${java.nameNamespace(app.name)}.model.assembler.${java.nameType(entity.name)}Assembler
import ${namespace}.${java.nameNamespace(app.name)}.model.repository.${java.nameType(entity.name)}Repository
import net.doublegsoft.appbase.dao.CommonDataAccess
import net.doublegsoft.appbase.ObjectMap
import net.doublegsoft.appbase.SqlParams
import net.doublegsoft.appbase.JsonData
import net.doublegsoft.appbase.util.Strings
import net.doublegsoft.appbase.service.GroovyService
import net.doublegsoft.appbase.service.CommonService

ObjectMap enable(ApplicationContext spring, ObjectMap params) {
  String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
  CommonService commonService = spring.getBean("commonService" + _data_source)

  params.set("state", "E")
  commonService.execute("${entity.persistenceName}.update", new SqlParams().set(params))
  return params
}

ObjectMap handle(ApplicationContext spring, ObjectMap params) {
  return enable(spring, params);
}

ApplicationContext spring = binding.getVariable("spring")
ObjectMap params = binding.getVariable("params")
GroovyService groovyService = spring.getBean(GroovyService.class)

String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
CommonDataAccess commonDataAccess = spring.getBean("commonDataAccess" + _data_source)
GroovyShell shell = new GroovyShell()

String scriptRoot = groovyService.getRoot()
Script common = shell.parse(new File(scriptRoot + "/common.groovy"))

ObjectMap data = null
try {
  commonDataAccess.beginTransaction()
  data = enable(spring, params)
  data = common.transact(spring, shell, scriptRoot, params, data)
  commonDataAccess.commit()
} catch (Throwable ex) {
  commonDataAccess.rollback()
  return new JsonData().error(ex.getMessage())
}

// 返回对象
JsonData retVal = new JsonData()
retVal.set("data", data)
return retVal