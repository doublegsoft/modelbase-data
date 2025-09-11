<#import "/$/modelbase.ftl" as modelbase>
<#assign attrId = modelbase.get_id_attributes(entity)[0]>
import java.util.List
import java.util.ArrayList
import java.util.Map
import java.io.File

import groovy.lang.GroovyShell
import groovy.lang.Script

import org.springframework.context.ApplicationContext

import ${namespace}.${java.nameNamespace(app.name)}.model.entity.${java.nameType(entity.name)}
import ${namespace}.${java.nameNamespace(app.name)}.model.assembler.${java.nameType(entity.name)}Assembler
import ${namespace}.${java.nameNamespace(app.name)}.model.repository.${java.nameType(entity.name)}Repository
import net.doublegsoft.appbase.dao.CommonDataAccess
import net.doublegsoft.appbase.ObjectMap
import net.doublegsoft.appbase.JsonData
import net.doublegsoft.appbase.util.Strings
import net.doublegsoft.appbase.service.GroovyService

ObjectMap clone(ApplicationContext spring, ObjectMap params) {
  ${java.nameType(entity.name)} ${java.nameVariable(entity.name)} = ${java.nameType(entity.name)}Assembler.assemble${java.nameType(entity.name)}FromFrontend(params)
  ${java.nameType(entity.name)}Repository ${java.nameVariable(entity.name)}Repository = spring.getBean(${java.nameType(entity.name)}Repository.class)

  if (Strings.isBlank(params.get("${modelbase.get_attribute_sql_name(attrId)}"))) {
    throw new Exception("没有找到${modelbase.get_attribute_label(attrId)}，请联系管理员！");
  }

  boolean readChildren = "true".equals(params.get("readChildren"))
  def obj = ${java.nameVariable(entity.name)}Repository.read${java.nameType(entity.name)}(params.get("${modelbase.get_attribute_sql_name(attrId)}"), true)
  if (obj == null) return new ObjectMap()

  ${java.nameVariable(entity.name)}.set${java.nameType(attrId.name)}(null)
  ${java.nameVariable(entity.name)}Repository.create${java.nameType(entity.name)}(${java.nameVariable(entity.name)})

  ObjectMap ret = new ObjectMap()
  ret.set('${modelbase.get_attribute_sql_name(attrId)}', ${java.nameVariable(entity.name)}.get${java.nameType(attrId.name)}())
  return ret
}

ObjectMap handle(ApplicationContext spring, ObjectMap params) {
  return clone(spring, params);
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
  data = clone(spring, params)
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