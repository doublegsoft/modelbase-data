<#import "/$/modelbase.ftl" as modelbase>
<#assign attrId = modelbase.get_id_attributes(entity)[0]>
import java.util.List
import java.util.ArrayList
import java.util.Map
import java.io.File

import groovy.lang.GroovyShell
import groovy.lang.Script
import org.slf4j.Logger

import org.springframework.context.ApplicationContext

import ${namespace}.${java.nameNamespace(app.name)}.model.entity.${java.nameType(entity.name)}
import ${namespace}.${java.nameNamespace(app.name)}.model.assembler.${java.nameType(entity.name)}Assembler
import ${namespace}.${java.nameNamespace(app.name)}.model.repository.${java.nameType(entity.name)}Repository
import net.doublegsoft.appbase.dao.CommonDataAccess
import net.doublegsoft.appbase.ObjectMap
import net.doublegsoft.appbase.JsonData
import net.doublegsoft.appbase.SqlParams
import net.doublegsoft.appbase.util.Strings
import net.doublegsoft.appbase.service.GroovyService
import net.doublegsoft.appbase.service.CommonService

ObjectMap batch(ApplicationContext spring, ObjectMap params) {
  ${java.nameType(entity.name)}Repository ${java.nameVariable(entity.name)}Repository = spring.getBean(${java.nameType(entity.name)}Repository.class)

  String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
  CommonService commonService = (CommonService) spring.getBean('commonService' + _data_source)

  // 根据唯一字段查询
  ObjectMap unique = null
  String uniqueFieldName = params.get('_unique_field')
  if (uniqueFieldName != null) {
    String uniqueFieldValue = params.get(uniqueFieldName)
    unique = commonService.single('${entity.persistenceName}.' + ${java.nameType(entity.name)}.getPersistenceName(uniqueFieldName) + '.find', new SqlParams().set(uniqueFieldName, uniqueFieldValue))
  }  
  String uniqueExpression = params.get("_unique_expression");
  if (!Strings.isBlank(uniqueExpression)) {
    SqlParams uniqueParams = new SqlParams()
    uniqueParams.set("_and_condition", uniqueExpression)
    unique = commonService.single('${entity.persistenceName}.find', uniqueParams)
  }

  String clearValue = params.get('_clear_value')

  if (!Strings.isBlank(clearValue)) {
    List<ObjectMap> existings = commonService.many('${entity.persistenceName}.find', 
        new SqlParams().set('_and_condition', clearValue))
    for (ObjectMap existing : existings) {
      commonService.execute('${entity.persistenceName}.delete', new SqlParams().set(existing))
    }    
  }

  ObjectMap templateData = params.get("_template_data")
  params.remove("_template_data")
  if (templateData == null) templateData = new ObjectMap()

  List ${java.nameVariable(modelbase.get_object_plural(entity))} = params.get("${java.nameVariable(modelbase.get_object_plural(entity))}")
  ObjectMap ret = new ObjectMap()

  for (ObjectMap singleParams : ${java.nameVariable(modelbase.get_object_plural(entity))}) {
    singleParams = ObjectMap.templatize(singleParams, templateData)
    ${java.nameType(entity.name)} existing = null
    ${java.nameType(entity.name)} ${java.nameVariable(entity.name)} = ${java.nameType(entity.name)}Assembler.assemble${java.nameType(entity.name)}FromFrontend(singleParams)
    <#if attrId.type.custom>
  <#assign idEntity = model.findObjectByName(attrId.type.name)>
  <#assign idEntityIdAttr = modelbase.get_id_attributes(idEntity)[0]>
    if (singleParams.get("${modelbase.get_attribute_sql_name(attrId)}") != null) {
      if ((singleParams.get("${modelbase.get_attribute_sql_name(attrId)}") instanceof String) && !Strings.isBlank(params.get("${modelbase.get_attribute_sql_name(attrId)}"))) {
        existing = ${java.nameVariable(entity.name)}Repository.read${java.nameType(entity.name)}(singleParams.get("${modelbase.get_attribute_sql_name(attrId)}"))
      } else if (!Strings.isBlank(singleParams.get("${modelbase.get_attribute_sql_name(attrId)}").get("${modelbase.get_attribute_sql_name(idEntityIdAttr)}"))) {
        existing = ${java.nameVariable(entity.name)}Repository.read${java.nameType(entity.name)}(singleParams.get("${modelbase.get_attribute_sql_name(attrId)}").get("${modelbase.get_attribute_sql_name(idEntityIdAttr)}"))
      }
    }
<#else>
    if (!Strings.isBlank(singleParams.get("${modelbase.get_attribute_sql_name(attrId)}"))) {
      existing = ${java.nameVariable(entity.name)}Repository.read${java.nameType(entity.name)}(singleParams.get("${modelbase.get_attribute_sql_name(attrId)}"))
    }
</#if>
    if (unique != null) {
      singleParams.set('${modelbase.get_attribute_sql_name(attrId)}', unique.get('${modelbase.get_attribute_sql_name(attrId)}'))
    } 
    if (existing == null)
      ${java.nameVariable(entity.name)}Repository.create${java.nameType(entity.name)}(${java.nameVariable(entity.name)})
    else {
<#list entity.attributes as attr>
  <#if attr.constraint.domainType == 'json'>
      // 处理JSON类型的字段
      Map<String, Object> existing${java.nameType(attr.name)} = existing.get${java.nameType(attr.name)}()
      existing${java.nameType(attr.name)}.putAll(${java.nameVariable(entity.name)}.get${java.nameType(attr.name)}())
      ${java.nameVariable(entity.name)}.get${java.nameType(attr.name)}().putAll(existing${java.nameType(attr.name)})
  </#if>
</#list>
      ${java.nameType(entity.name)}Assembler.assemble${java.nameType(entity.name)}From${java.nameType(entity.name)}(${java.nameVariable(entity.name)}, existing)
      ${java.nameVariable(entity.name)}Repository.update${java.nameType(entity.name)}(existing, 'true' == params.get('_update_children'))
      ${java.nameVariable(entity.name)} = existing
    }
    String resultName = singleParams.get("_result_name")
    ObjectMap data = new ObjectMap()
    data.putAll(templateData)
    if (!Strings.isBlank(resultName)) {
      data.set(resultName, ${java.nameType(entity.name)}Assembler.assembleObjectMapToFrontend(${java.nameVariable(entity.name)}))
    }
    GroovyService groovyService = spring.getBean(GroovyService.class)
    GroovyShell shell = new GroovyShell()
    String scriptRoot = groovyService.getRoot()
    Script common = shell.parse(new File(scriptRoot + "/common.groovy"))
    data = common.transact(spring, shell, scriptRoot, singleParams, data)

    ret.add('${modelbase.get_attribute_sql_name(attrId)}', ${java.nameVariable(entity.name)}.get${java.nameType(attrId.name)}())
  }
  return ret;
}

ObjectMap handle(ApplicationContext spring, ObjectMap params) {
  return batch(spring, params);
}

ApplicationContext spring = binding.getVariable("spring")
ObjectMap params = binding.getVariable("params")
Logger logger = binding.getVariable("logger")
GroovyService groovyService = spring.getBean(GroovyService.class)

String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
CommonDataAccess commonDataAccess = spring.getBean("commonDataAccess" + _data_source)
GroovyShell shell = new GroovyShell()

String scriptRoot = groovyService.getRoot()
Script common = shell.parse(new File(scriptRoot + "/common.groovy"))

ObjectMap data = null
try {
  commonDataAccess.beginTransaction()
  data = batch(spring, params)
  data = common.transact(spring, shell, scriptRoot, params, data)
  commonDataAccess.commit()
} catch (Throwable ex) {
  logger.error(ex.getMessage(), ex)
  commonDataAccess.rollback()
  return new JsonData().error(ex.getMessage())
}

// 返回对象
JsonData retVal = new JsonData()
retVal.set("data", data)
return retVal