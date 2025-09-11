<#import '/$/modelbase.ftl' as modelbase>
import java.util.List
import java.util.ArrayList
import java.util.Map
import java.io.File

import groovy.lang.GroovyShell
import groovy.lang.Script

import org.springframework.context.ApplicationContext

import ${namespace}.${java.nameNamespace(app.name)}.model.value.*
import net.doublegsoft.appbase.JsonData
import net.doublegsoft.appbase.ObjectMap
import net.doublegsoft.appbase.SqlParams
import net.doublegsoft.appbase.dao.CommonDataAccess
import net.doublegsoft.appbase.service.CommonService
import net.doublegsoft.appbase.service.GroovyService
import net.doublegsoft.appbase.util.Strings

ObjectMap reorder(ApplicationContext spring, ObjectMap params) {
  String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
  CommonService commonService = spring.getBean("commonService" + _data_source)

  SqlParams sqlParams = new SqlParams().set(params)

  ObjectMap found = commonService.single("${value.persistenceName}.update", sqlParams)

  if (found == null) return params

  Number oldPosition
  Number newPosition
  String orderKey
  for (Map.Entry entry : params.entrySet()) {
    String key = entry.getKey()
    Object value = entry.getValue()
    if (key.indexOf('^') == 0) {
      orderKey = key.substring(1)
      oldPosition = found.get(orderKey)
      newPosition = value
      sqlParams.set(orderKey, value)
      break
    }
  }

  if (oldPosition != null) {
    Number offset
    if (newPosition.intValue() > oldPosition.intValue()) {
      // 新位置大于原位置，大于原位置且小于等于新位置的都减1
      // 3 => 7: 4,5,6,7 -1
      sqlParams.set(orderKey + '0', oldPosition + 1)
      sqlParams.set(orderKey + '1', newPosition)
      offset = -1
    } else if (newPosition.intValue() < oldPosition.intValue()) {
      // 新位置小于原位置，小于原位置且大于等于新位置的都加1
      // 7 => 3: 3,4,5,6 +1
      sqlParams.set(orderKey + '0', newPosition)
      sqlParams.set(orderKey + '1', oldPosition - 1)
      offset = 1
    }
    List<ObjectMap> items = commonService.many("${value.persistenceName}.update", sqlParams)
    for (ObjectMap item : items) {
      Number position = item.get(orderKey)
      item.set(orderKey, position + offset)
      commonService.execute("${value.persistenceName}.update", new SqlParams().set(item))
    }
  }

  commonService.execute("${value.persistenceName}.update", sqlParams)

  return params
}

ObjectMap handle(ApplicationContext spring, ObjectMap params) {
  return reorder(spring, params)
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
  
  data = reorder(spring, params)
  data = common.transact(spring, shell, scriptRoot, params, data)
  
  commonDataAccess.commit()
} catch (Throwable cause) {
  commonDataAccess.rollback()
  return new JsonData().error(cause.getMessage())
} 

return new JsonData().set(data)