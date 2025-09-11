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
import net.doublegsoft.appbase.Pagination
import net.doublegsoft.appbase.service.CommonService
import net.doublegsoft.appbase.service.RepositoryService
import net.doublegsoft.appbase.service.GroovyService
import net.doublegsoft.appbase.util.Strings
import net.doublegsoft.appbase.util.Datasets

<#assign attrWhatId = ''>
<#assign attrWhatType = ''>
<#assign implicitReferences = modelbase.get_object_implicit_references(value)>
<#list implicitReferences as implicitReferenceName, implicitReference>
  <#list implicitReference as value, attr>
    <#assign role = attr.getLabelledOptions('reference')['role']!>
    <#if value == 'id' && role == 'what'>
      <#assign attrWhatId = attr>
    <#elseif value == 'type' && role == 'what'>
      <#assign attrWhatType = attr>
    </#if>
  </#list>
</#list>

Pagination get(ApplicationContext spring, ObjectMap params) {
  def start = params.get("start")
  def limit = params.get("limit")

  boolean paging = false;
  if (start == null) {
    start = 0;
  } else {
    paging = true;
  }
  if (limit == null) {
    limit = -1;
  } else {
    paging = true;
  }

  <#if attrWhatId?string != '' >
  Object ${modelbase.get_attribute_sql_name(attrWhatId)} = params.get("${modelbase.get_attribute_sql_name(attrWhatId)}")
  String ${modelbase.get_attribute_sql_name(attrWhatType)} = params.get("${modelbase.get_attribute_sql_name(attrWhatType)}")

  if (Strings.isBlank(${modelbase.get_attribute_sql_name(attrWhatType)}) || ${modelbase.get_attribute_sql_name(attrWhatId)} != null) {
    return new JsonData().error("没有任何对值对象的查询条件，请联系管理员！")
  }

  params.set("${modelbase.get_attribute_sql_name(attrWhatId)}", ${modelbase.get_attribute_sql_name(attrWhatId)})
  params.set("${modelbase.get_attribute_sql_name(attrWhatType)}", ${modelbase.get_attribute_sql_name(attrWhatType)})
  </#if>

  RepositoryService repositoryService = spring.getBean("repositoryService")

  String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
  CommonService commonService = spring.getBean("commonService" + _data_source)
  Pagination pagination = commonService.paginate("${value.persistenceName}.find", start, limit, new SqlParams().set(params))

  List<ObjectMap> items = new ArrayList()
  items.addAll(pagination.getData())
  <#assign implicitReferences = modelbase.get_object_implicit_references(value)>
  <#if implicitReferences?size != 0>
  ObjectMap groupingIds = null
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
  if (params.get("get${java.nameType(implicitReferenceName)}") == "true") {
    groupingIds = new ObjectMap()
    for (ObjectMap item : items) {
      if (item.get("${modelbase.get_attribute_sql_name(attrRefId)}") != null) {
        groupingIds.add(item.get("${modelbase.get_attribute_sql_name(attrRefType)}"), item.get("${modelbase.get_attribute_sql_name(attrRefId)}"))
      }
    }
    for (Map.Entry<String, Object> entry : groupingIds.entrySet()) {
      String group = entry.getKey();
      List<ObjectMap> rows = repositoryService.findObjectsByIds(entry.getValue(), group);
      items = Datasets.conjunct(items, "${modelbase.get_attribute_sql_name(attrRefId)}", rows, Strings.nameVariable(group.substring(group.lastIndexOf(".") + 1)) + "Id", "${java.nameVariable(implicitReferenceName)}");
    }
  }
    </#list>
  </#if>
  pagination.getData().clear()
  pagination.getData().addAll(items)
  return pagination
}

Pagination handle(ApplicationContext spring, ObjectMap params) {
  return get(spring, params)
} 

ApplicationContext spring = binding.getVariable("spring")
ObjectMap params = binding.getVariable("params")
GroovyService groovyService = spring.getBean(GroovyService.class)
GroovyShell shell = new GroovyShell()

def pagination = get(spring, params)

def start = params.get("start")
def limit = params.get("limit")
boolean paging = false;
if (start == null) {
  start = 0;
} else {
  paging = true;
}
if (limit == null) {
  limit = -1;
} else {
  paging = true;
}

String scriptRoot = groovyService.getRoot()
Script common = shell.parse(new File(scriptRoot + "/common.groovy"))

<#-- 被动引用，指该实体不知道被谁引用了，但是也能指定引用了本实体的操作 -->
// 被动引用的用例操作
List<ObjectMap> items = new ArrayList()
items.addAll(pagination.getData())

items = common.conjunct(spring, shell, scriptRoot, params, items)

pagination.getData().clear()
pagination.getData().addAll(items)

JsonData retVal = new JsonData()
if (paging)
  retVal.set(pagination)
else
  retVal.set("data", pagination.getData())
return retVal