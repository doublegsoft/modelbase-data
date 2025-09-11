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
import net.doublegsoft.appbase.service.CommonService
import net.doublegsoft.appbase.service.GroovyService
import net.doublegsoft.appbase.util.Datasets
import net.doublegsoft.appbase.util.Strings

List<ObjectMap> treerize(ApplicationContext spring, ObjectMap params) {
  def fieldId = params.get("_field_id")
  def fieldParentId = params.get("_field_parent_id")

  String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
  def commonService = spring.getBean("commonService" + _data_source);

  def data = commonService.all("${entity.persistenceName}.find", new SqlParams().set(params))

  // 拼音转换
  if (params.containsKey("_field_pinyin")) {
    List<String> fields = params.get("_field_pinyin");
    for (ObjectMap item : data) {
      for (String field : fields) {
        if (!Strings.isBlank(item.get(field))) {
          item.set(field + "Pinyin", Strings.pinyin(item.get(field)));
        }
      }
    }
  }

  def treerizedData = Datasets.treerize(data, new ArrayList<ObjectMap>(), fieldId, fieldParentId)
  return treerizedData
}

List<ObjectMap> handle(ApplicationContext spring, ObjectMap params) {
  return treerize(spring, params)
}

def spring = binding.getVariable("spring")
def params = binding.getVariable("params")
GroovyService groovyService = spring.getBean(GroovyService.class)
GroovyShell shell = new GroovyShell()

String scriptRoot = groovyService.getRoot()
Script common = shell.parse(new File(scriptRoot + "/common.groovy"))

def data = treerize(spring, params)

data = common.conjunct(spring, shell, scriptRoot, params, data)

def retVal = new JsonData()
retVal.set("data", data)
return retVal
