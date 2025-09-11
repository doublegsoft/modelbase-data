<#import '/$/modelbase.ftl' as modelbase>
import java.util.List
import java.util.ArrayList
import java.util.Map
import java.io.File
import java.sql.Timestamp

import groovy.lang.GroovyShell
import groovy.lang.Script

import org.springframework.context.ApplicationContext

import ${namespace}.${java.nameNamespace(app.name)}.model.value.*
import ${namespace}.${java.nameNamespace(app.name)}.model.assembler.${java.nameType(value.name)}Assembler
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

ObjectMap add(ApplicationContext spring, ObjectMap params) {
  String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
  CommonService commonService = spring.getBean("commonService" + _data_source)

  List<ObjectMap> ${java.nameVariable(value.plural)} = params.get("${java.nameVariable(value.plural)}")
  if (${java.nameVariable(value.plural)} != null) {
    for (ObjectMap row : ${java.nameVariable(value.plural)}) {
    	${java.nameType(value.name)} ${java.nameVariable(value.name)} = ${java.nameType(value.name)}Assembler.assemble${java.nameType(value.name)}FromFrontend(row)
      commonService.execute("${value.persistenceName}.create", ${java.nameType(value.name)}Assembler.assembleSqlParams(${java.nameVariable(value.name)}))
    }
    return params;
  }

  List<Object> referenceIds = new ArrayList<>()
  <#if attrWhatId?string != '' >
  Object item = params.get("${modelbase.get_attribute_sql_name(attrWhatId)}")
  if (List.class.isAssignableFrom(item.getClass())) {
    referenceIds.addAll((List) item)
  } else {
    referenceIds.add(item)
  }
  </#if>
<#list value.attributes as attr>
  <#if attr.type.name == 'datetime'>
  if ("now".equals(params.get("${modelbase.get_attribute_sql_name(attr)}"))) {
    params.set("${modelbase.get_attribute_sql_name(attr)}", new Timestamp(System.currentTimeMillis()));
  }
  </#if>
</#list>  
  SqlParams sqlParams = new SqlParams();
  sqlParams.set(params)

  for (String referenceId : referenceIds) {
<#if attrWhatId?string != '' >
    sqlParams.set("${modelbase.get_attribute_sql_name(attrWhatId)}", referenceId)
    commonService.execute("${value.persistenceName}.create", sqlParams)
</#if>
  }

  // no reference attributes
  if (referenceIds.isEmpty()) {
    commonService.execute("${value.persistenceName}.create", new SqlParams().set(params))
  }

<#assign implicitReferences = modelbase.get_object_implicit_references(value)>
<#if implicitReferences?size != 0>
  GroovyShell shell = new GroovyShell()
</#if>
<#list implicitReferences as implicitReferenceName, implicitReference>
  <#assign attrRefId = ''>
  <#assign attrRefType = ''>
  <#list implicitReference as val, attr>
    <#if val == 'type'>
      <#assign attrRefType = attr>
    <#elseif val == 'id'>
      <#assign attrRefId = attr>
    </#if>
  </#list>
  if (params.containsKey("save${java.nameType(implicitReferenceName)}")) {
    String usecase = params.get("save${java.nameType(implicitReferenceName)}")
    def another = shell.parse(new File('./script/' + usecase + '.groovy'))
    another.handle(spring, params.get("${java.nameVariable(implicitReferenceName)}"))
  }
</#list>

  return params
}

ObjectMap handle(ApplicationContext spring, ObjectMap params) {
  return add(spring, params)
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
  data = add(spring, params)
  data = common.transact(spring, shell, scriptRoot, params, data)
  
  commonDataAccess.commit()
} catch (Throwable cause) {
  commonDataAccess.rollback()
  return new JsonData().error(cause.getMessage())
} 

return new JsonData().set(data)