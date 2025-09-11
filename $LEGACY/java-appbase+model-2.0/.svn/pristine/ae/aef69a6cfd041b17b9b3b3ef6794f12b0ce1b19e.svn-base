<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.defaults.usecase;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import net.doublegsoft.appbase.JsonData;
import net.doublegsoft.appbase.ObjectMap;
import net.doublegsoft.appbase.SqlParams;
import net.doublegsoft.appbase.dao.CommonDataAccess;
import net.doublegsoft.appbase.service.CommonService;
import net.doublegsoft.appbase.service.RepositoryService;
import net.doublegsoft.appbase.service.ServiceException;
import net.doublegsoft.appbase.ddd.DomainException;
import net.doublegsoft.appbase.util.Strings;
import net.doublegsoft.appbase.util.Datasets;
import org.springframework.context.ApplicationContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import <#if namespace??>${namespace}.</#if>${app.name}.model.entity.*;
import <#if namespace??>${namespace}.</#if>${app.name}.model.repository.*;

<#assign attrId = modelbase.get_id_attributes(entity)[0]>
public class ${java.nameType(entity.name)}Find {

  private static final Logger TRACER = LoggerFactory.getLogger(${java.nameType(entity.name)}Find.class);

  public JsonData handle(ApplicationContext spring, ObjectMap params) {
    try {
      ${java.nameType(entity.name)}Repository ${java.nameVariable(entity.name)}Repository = spring.getBean(${java.nameType(entity.name)}Repository.class);
      RepositoryService repositoryService = spring.getBean(RepositoryService.class);

      List<ObjectMap> ${java.nameVariable(modelbase.get_object_plural(entity))} = ${java.nameVariable(entity.name)}Repository.findObjectMapsBy(params);

<#assign implicitReferences = modelbase.get_object_implicit_references(entity)>
<#if implicitReferences?size != 0>
      ObjectMap groupingIds = null;
  <#list implicitReferences as implicitReferenceName, implicitReference>
    <#assign attrRefId = ''>
    <#assign attrRefType = ''>
    <#list implicitReference as value, attr>
      <#if value == 'type'>
        <#assign attrRefType = attr>
      <#elseif value == 'id'>
        <#assign attrRefId = attr>
      </#if>
    </#list>
      if ("true".equals(params.get("get${java.nameType(implicitReferenceName)}"))) {
        groupingIds = new ObjectMap();
        for (ObjectMap item : ${java.nameVariable(modelbase.get_object_plural(entity))}) {
          if (item.get("${modelbase.get_attribute_sql_name(attrRefId)}") != null) {
            groupingIds.add(item.get("${modelbase.get_attribute_sql_name(attrRefType)}"), item.get("${modelbase.get_attribute_sql_name(attrRefId)}"));
          }
        }
        for (Map.Entry<String, Object> entry : groupingIds.entrySet()) {
          String group = entry.getKey();
          List<ObjectMap> rows = repositoryService.findObjectsByIds((List)entry.getValue(), group);
          ${java.nameVariable(modelbase.get_object_plural(entity))} = Datasets.conjunct(${java.nameVariable(modelbase.get_object_plural(entity))}, "${modelbase.get_attribute_sql_name(attrRefId)}", rows, Strings.nameVariable(group.substring(group.lastIndexOf(".") + 1)) + "Id", "${java.nameVariable(implicitReferenceName)}");
        }
      }
  </#list>
</#if>
<#-- 多对多聚合查询函数 -->
<#list entity.attributes as attr>
  <#assign conjObjName = attr.getLabelledOptions('persistence')['conjunction']!>
  <#if conjObjName == ''><#continue></#if>
  <#assign conjObj = model.findObjectByName(attr.getLabelledOptions('persistence')['conjunction'])>
  <#assign refObj = model.findObjectByName(attr.type.componentType.name)>
      if ("true".equals(params.get("aggregate${java.nameType(refObj.name)}"))) {
        List<ObjectMap> rows = ${java.nameVariable(entity.name)}Repository.aggregate${java.nameType(refObj.plural)}(params);
        ${java.nameVariable(modelbase.get_object_plural(entity))} = Datasets.conjunct(${java.nameVariable(modelbase.get_object_plural(entity))}, "${modelbase.get_attribute_sql_name(attrId)}", rows, "${modelbase.get_attribute_sql_name(attrId)}");
      }        
</#list>

      return new JsonData().set("data", ${java.nameVariable(modelbase.get_object_plural(entity))});
    } catch (Throwable ex) {
      TRACER.error(ex.getMessage(), ex);
      return new JsonData().error(ex.getMessage());
    }
  }

}