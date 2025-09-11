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
import net.doublegsoft.appbase.Pagination;
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
public class ${java.nameType(value.name)}Get {

  private static final Logger TRACER = LoggerFactory.getLogger(${java.nameType(value.name)}Get.class);

  public JsonData handle(ApplicationContext spring, ObjectMap params) throws DomainException {
    Integer start = params.get("start");
    Integer limit = params.get("limit");

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

    try {
      CommonService commonService = (CommonService) spring.getBean("commonService");
      Pagination page = commonService.paginate("${value.persistenceName}.find", start, limit, new SqlParams().set(params));
      JsonData retVal = new JsonData();
      if (paging)
        retVal.set(page);
      else
        retVal.set("data", page.getData());
      return retVal;
    } catch (Throwable ex) {
      TRACER.error(ex.getMessage(), ex);
      return new JsonData().error(ex.getMessage());
    }
  }

}