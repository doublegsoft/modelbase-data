<#--找到这个值对象的所属的实体对象-->
<#list model.objects as obj>
  <#list obj.attributes as attr>
    <#if attr.type.collection && attr.type.componentType.name == value.name>
      <#assign entityObj = obj>
      <#break>
    </#if>
  </#list>
</#list>
<#if !entityObj?? && !value.isLabelled('series')>
  <#--stop "没有找到值对象【" + value.name + "】被任何实体对象的数组引用！"-->
</#if>

import java.util.List
import java.util.ArrayList
import java.util.Map

import org.springframework.context.ApplicationContext

<#if !value.isLabelled('series') && entityObj??>
import ${namespace}.${java.nameNamespace(app.name)}.model.repository.${java.nameType(entityObj.name)}Repository
</#if>
import net.doublegsoft.appbase.JsonData
import net.doublegsoft.appbase.SqlParams
import net.doublegsoft.appbase.ObjectMap
import net.doublegsoft.appbase.service.CommonService
import net.doublegsoft.appbase.util.Strings

List<ObjectMap> aggregate(ApplicationContext spring, ObjectMap params) {
  String _data_source = params.get("_data_source") == null ? "" : params.get("_data_source")
  CommonService commonService = spring.getBean("commonService" + _data_source)
  List<ObjectMap> data = commonService.many("${value.persistenceName?lower_case}.aggregate", new SqlParams().set(params))
  return data
}

List<ObjectMap> handle(ApplicationContext spring, ObjectMap params) {
  return aggregate(spring, params);
}

def spring = binding.getVariable("spring")
def params = binding.getVariable("params")

def data = aggregate(spring, params)

def retVal = new JsonData()
retVal.set('data', data)
return retVal
