<#import "/$/modelbase.ftl" as modelbase>
<#assign attrIds = modelbase.get_id_attributes(value)>
import java.util.List
import java.util.ArrayList
import java.util.Map
import java.io.File
import java.sql.Timestamp

import groovy.lang.GroovyShell
import groovy.lang.Script

import org.springframework.context.ApplicationContext

import ${namespace}.${java.nameNamespace(app.name)}.model.value.${java.nameType(value.name)}
import ${namespace}.${java.nameNamespace(app.name)}.model.assembler.${java.nameType(value.name)}Assembler
import net.doublegsoft.appbase.dao.CommonDataAccess
import net.doublegsoft.appbase.ObjectMap
import net.doublegsoft.appbase.JsonData
import net.doublegsoft.appbase.SqlParams
import net.doublegsoft.appbase.util.Strings
import net.doublegsoft.appbase.service.GroovyService
import net.doublegsoft.appbase.service.CommonService
import net.doublegsoft.appbase.service.ServiceException

ObjectMap merge(ApplicationContext spring, ObjectMap params) {
  String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
  CommonService commonService = (CommonService) spring.getBean('commonService' + _data_source)

  List<ObjectMap> ${java.nameVariable(value.plural)} = params.get("${java.nameVariable(value.plural)}")
  if (${java.nameVariable(value.plural)} != null) {
    for (ObjectMap row : ${java.nameVariable(value.plural)}) {
      SqlParams sqlParams = new SqlParams().set(row)
      SqlParams paramsExisting = new SqlParams()
<#list attrIds as attrId>
      String ${modelbase.get_attribute_sql_name(attrId)} = row.get("${modelbase.get_attribute_sql_name(attrId)}") 
      if (Strings.isBlank(${modelbase.get_attribute_sql_name(attrId)})) {
        throw new ServiceException("【${modelbase.get_attribute_label(attrId)}】未传入参数！")
      }
</#list>
<#list attrIds as attrId>
      paramsExisting.set("${modelbase.get_attribute_sql_name(attrId)}", ${modelbase.get_attribute_sql_name(attrId)})
</#list>
			${java.nameType(value.name)} ${java.nameVariable(value.name)} = ${java.nameType(value.name)}Assembler.assemble${java.nameType(value.name)}FromFrontend(row)
      ObjectMap existing = commonService.single("${value.persistenceName}.find", paramsExisting)
      if (existing == null) {
				commonService.execute("${value.persistenceName}.create", ${java.nameType(value.name)}Assembler.assembleSqlParams(${java.nameVariable(value.name)}))
			} else {
				commonService.execute("${value.persistenceName}.update", ${java.nameType(value.name)}Assembler.assembleSqlParams(${java.nameVariable(value.name)}))
			}
    }
    return params;
  }

  ObjectMap templateData = params.get("_template_data")
  if (templateData == null) templateData = new ObjectMap()
  params.remove("_template_data")
  params = ObjectMap.templatize(params, templateData)
  // 值对象的主键必须不能为空
<#list attrIds as attrId>
  String ${modelbase.get_attribute_sql_name(attrId)} = params.get("${modelbase.get_attribute_sql_name(attrId)}")
</#list>
<#list value.attributes as attr>
  <#if attr.type.name == 'datetime'>
  if ("now".equals(params.get("${modelbase.get_attribute_sql_name(attr)}"))) {
    params.set("${modelbase.get_attribute_sql_name(attr)}", new Timestamp(System.currentTimeMillis()));
  }
  </#if>
</#list>  
  SqlParams sqlParams = new SqlParams()
  sqlParams.set(params)
  SqlParams paramsExisting = new SqlParams()
<#list attrIds as attrId>
  paramsExisting.set("${modelbase.get_attribute_sql_name(attrId)}", ${modelbase.get_attribute_sql_name(attrId)})
</#list>
	${java.nameType(value.name)} ${java.nameVariable(value.name)} = ${java.nameType(value.name)}Assembler.assemble${java.nameType(value.name)}FromFrontend(params)
  ObjectMap existing = commonService.single("${value.persistenceName}.find", paramsExisting)
  if (existing == null) {
    commonService.execute("${value.persistenceName}.create", ${java.nameType(value.name)}Assembler.assembleSqlParams(${java.nameVariable(value.name)}))
  } else {
    commonService.execute("${value.persistenceName}.update", ${java.nameType(value.name)}Assembler.assembleSqlParams(${java.nameVariable(value.name)}))
  }

  return params
}

ObjectMap handle(ApplicationContext spring, ObjectMap params) {
  return merge(spring, params);
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
  data = merge(spring, params)
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