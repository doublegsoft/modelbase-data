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
import net.doublegsoft.appbase.Pagination;
import net.doublegsoft.appbase.dao.CommonDataAccess;
import net.doublegsoft.appbase.service.CommonService;
import net.doublegsoft.appbase.service.RepositoryService;
import net.doublegsoft.appbase.service.ServiceException;
import net.doublegsoft.appbase.util.Strings;
import net.doublegsoft.appbase.util.Datasets;
import org.springframework.context.ApplicationContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import <#if namespace??>${namespace}.</#if>${app.name}.model.entity.*;
import <#if namespace??>${namespace}.</#if>${app.name}.model.repository.*;

public class ${java.nameType(entity.name)}Paginate {

  private static final Logger TRACER = LoggerFactory.getLogger(${java.nameType(entity.name)}Paginate.class);

  public JsonData handle(ApplicationContext spring, ObjectMap params) {
    try {
      Integer start = params.get("start");
      Integer limit = params.get("limit");

      CommonService commonService = spring.getBean(CommonService.class);
      RepositoryService repositoryService = spring.getBean(RepositoryService.class);

      Pagination<ObjectMap> pagination = commonService.paginate("${entity.persistenceName}.find", start, limit, new SqlParams().set(params));

<#assign implicitReferences = modelbase.get_object_implicit_references(entity)>
<#if implicitReferences?size != 0>
      List<ObjectMap> items = new ArrayList();
      items.addAll(pagination.getData());
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
        for (ObjectMap item : pagination.getData()) {
          if (item.get("${modelbase.get_attribute_sql_name(attrRefId)}") != null) {
            groupingIds.add(item.get("${modelbase.get_attribute_sql_name(attrRefType)}"), item.get("${modelbase.get_attribute_sql_name(attrRefId)}"));
          }
        }
        for (Map.Entry<String, Object> entry : groupingIds.entrySet()) {
          String group = entry.getKey();
          List<ObjectMap> rows = repositoryService.findObjectsByIds((List)entry.getValue(), group);
          items = Datasets.conjunct(items, "${modelbase.get_attribute_sql_name(attrRefId)}", rows, Strings.nameVariable(group.substring(group.lastIndexOf(".") + 1)) + "Id", "${java.nameVariable(implicitReferenceName)}");
        }
      }
  </#list>
      pagination.getData().clear();
      pagination.getData().addAll(items);
</#if>
      return new JsonData().set(pagination);
    } catch (Throwable ex) {
      TRACER.error(ex.getMessage(), ex);
      return new JsonData().error(ex.getMessage());
    }
  }

}