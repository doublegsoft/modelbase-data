<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.defaults.usecase;

import java.util.ArrayList;
import java.util.List;
import net.doublegsoft.appbase.JsonData;
import net.doublegsoft.appbase.ObjectMap;
import net.doublegsoft.appbase.SqlParams;
import net.doublegsoft.appbase.dao.CommonDataAccess;
import net.doublegsoft.appbase.service.CommonService;
import net.doublegsoft.appbase.service.RepositoryService;
import net.doublegsoft.appbase.service.ServiceException;
import net.doublegsoft.appbase.ddd.DomainException;
import net.doublegsoft.appbase.util.Strings;
import org.springframework.context.ApplicationContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import <#if namespace??>${namespace}.</#if>${app.name}.model.value.*;
<#if modelbase.has_entity_object(app.name, model)>
import <#if namespace??>${namespace}.</#if>${app.name}.model.entity.*;
import <#if namespace??>${namespace}.</#if>${app.name}.model.assembler.*;
import <#if namespace??>${namespace}.</#if>${app.name}.model.repository.*;
</#if>

<#assign attrWhatId = ''>
<#assign attrWhatType = ''>
<#assign implicitReferences = modelbase.get_object_implicit_references(value)>
<#list implicitReferences as implicitReferenceName, implicitReference>
  <#list implicitReference as value, attr>
    <#assign role = attr.getLabelledOptions('reference')['role']!>
    <#if value == 'id'>
      <#assign attrWhatId = attr>
    <#elseif value == 'type'>
      <#assign attrWhatType = attr>
    </#if>
  </#list>
</#list>
<#--找到这个值对象的所属的实体对象-->
<#list model.objects as obj>
  <#if obj.isLabelled('aggregate')><#continue></#if>
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
public class ${java.nameType(value.name)}Add {

  private static final Logger TRACER = LoggerFactory.getLogger(${java.nameType(value.name)}Add.class);

  public void add(ApplicationContext spring, ObjectMap params) throws DomainException {
    try {
      CommonService commonService = (CommonService) spring.getBean("commonService");
      RepositoryService repositoryService = (RepositoryService) spring.getBean(RepositoryService.class);
      List<Object> referenceIds = new ArrayList<>();
<#if attrWhatId?string != '' >
      Object item = params.get("${modelbase.get_attribute_sql_name(attrWhatId)}");
      if (List.class.isAssignableFrom(item.getClass())) {
        referenceIds.addAll((List) item);
      } else {
        referenceIds.add(item);
      }
</#if>

      SqlParams sqlParams = new SqlParams();
      sqlParams.set(params);
<#if attrWhatId?string != '' >
      for (Object referenceId : referenceIds) {
        sqlParams.set("${modelbase.get_attribute_sql_name(attrWhatId)}", referenceId);
        commonService.execute("${value.persistenceName}.create", sqlParams);
      }
<#else>
      commonService.execute("${value.persistenceName}.create", sqlParams);
</#if>
<#assign implicitReferences = modelbase.get_object_implicit_references(value)>
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
        String usecase = params.get("save${java.nameType(implicitReferenceName)}");
        repositoryService.handleUsecase(usecase, params.get("${java.nameVariable(implicitReferenceName)}"));
      }
</#list>
    } catch (ServiceException ex) {
      throw new DomainException(ex);
    }
  }

  public JsonData handle(ApplicationContext spring, ObjectMap params) {
    CommonService commonService = (CommonService) spring.getBean("commonService");
    try {
      commonService.beginTransaction();
      add(spring, params);
      commonService.commit();
      return new JsonData();
    } catch (Throwable ex) {
      commonService.rollback();
      TRACER.error(ex.getMessage(), ex);
      return new JsonData().error(ex.getMessage());
    }
  }

}