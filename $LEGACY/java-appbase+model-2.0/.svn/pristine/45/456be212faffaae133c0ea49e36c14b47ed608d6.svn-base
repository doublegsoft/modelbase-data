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
import net.doublegsoft.appbase.ddd.DomainException;
import net.doublegsoft.appbase.util.Strings;
import net.doublegsoft.appbase.util.Datasets;
import org.springframework.context.ApplicationContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import <#if namespace??>${namespace}.</#if>${app.name}.model.entity.*;
import <#if namespace??>${namespace}.</#if>${app.name}.model.repository.*;

<#assign attrId = modelbase.get_id_attributes(entity)[0]>
public class ${java.nameType(entity.name)}Read {

  private static final Logger TRACER = LoggerFactory.getLogger(${java.nameType(entity.name)}Read.class);

  public JsonData handle(ApplicationContext spring, ObjectMap params) {
    try {
      if (Strings.isBlank(params.get("${modelbase.get_attribute_sql_name(attrId)}"))) {
        return new JsonData().error("没有找到${modelbase.get_attribute_label(attrId)}，请联系管理员！");
      }
      ${java.nameType(entity.name)}Repository ${java.nameVariable(entity.name)}Repository = spring.getBean(${java.nameType(entity.name)}Repository.class);
      RepositoryService repositoryService = spring.getBean(RepositoryService.class);

      boolean readChildren = "true".equals(params.get("readChildren"));
      ${java.nameType(entity.name)} ${java.nameVariable(entity.name)} = ${java.nameVariable(entity.name)}Repository.read${java.nameType(entity.name)}(params.get("${modelbase.get_attribute_sql_name(attrId)}"), readChildren);

<#assign implicitReferences = modelbase.get_object_implicit_references(entity)>
<#if implicitReferences?size != 0>
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
      if ("true".equals(params.get("get${java.nameType(implicitReferenceName)}")) && ${java.nameVariable(entity.name)}.get${java.nameType(modelbase.get_attribute_sql_name(attrRefId))}() != null) {
        ${java.nameVariable(entity.name)}.set${js.nameType(implicitReferenceName)}(repositoryService.readObject(${java.nameVariable(entity.name)}.get${java.nameType(attrRefId.name)}(), ${java.nameVariable(entity.name)}.get${java.nameType(attrRefType.name)}()));
      }
  </#list>
</#if>
      return new JsonData().set("data", ${java.nameVariable(entity.name)});
    } catch (Throwable ex) {
      TRACER.error(ex.getMessage(), ex);
      return new JsonData().error(ex.getMessage());
    }
  }
}