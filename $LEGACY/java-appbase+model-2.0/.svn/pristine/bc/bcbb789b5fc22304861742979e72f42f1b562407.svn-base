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

import <#if namespace??>${namespace}.</#if>${app.name}.model.entity.*;
import <#if namespace??>${namespace}.</#if>${app.name}.model.assembler.*;
import <#if namespace??>${namespace}.</#if>${app.name}.model.repository.*;

public class ${java.nameType(entity.name)}Save {

  private static final Logger TRACER = LoggerFactory.getLogger(${java.nameType(entity.name)}Save.class);

  public ${java.nameType(entity.name)} save(ApplicationContext spring, ObjectMap params) throws DomainException {
    ${java.nameType(entity.name)} ${java.nameVariable(entity.name)} = ${java.nameType(entity.name)}Assembler.assemble${java.nameType(entity.name)}FromFrontend(params);
    ${java.nameType(entity.name)}Repository ${java.nameVariable(entity.name)}Repository = spring.getBean(${java.nameType(entity.name)}Repository.class);
    RepositoryService repositoryService = spring.getBean(RepositoryService.class);

    boolean updateChildren = "true".equals(params.get("updateChildren"));
    if (${java.nameVariable(entity.name)}.hasNullId())
      ${java.nameVariable(entity.name)}Repository.create${java.nameType(entity.name)}(${java.nameVariable(entity.name)});
    else
      ${java.nameVariable(entity.name)}Repository.update${java.nameType(entity.name)}(${java.nameVariable(entity.name)}, updateChildren);

<#assign implicitReferences = modelbase.get_object_implicit_references(entity)>
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
    try {
      if (params.containsKey("save${java.nameType(implicitReferenceName)}")) {
        String usecase = params.get("save${java.nameType(implicitReferenceName)}");
        repositoryService.handleUsecase(usecase, params.get("${java.nameVariable(implicitReferenceName)}"));
      }
      if (params.containsKey("merge${java.nameType(implicitReferenceName)}")) {
        String usecase = params.get("merge${java.nameType(implicitReferenceName)}");
        repositoryService.handleUsecase(usecase, params.get("${java.nameVariable(implicitReferenceName)}"));
      }
      if (params.containsKey("delete${java.nameType(implicitReferenceName)}")) {
        String usecase = params.get("delete${java.nameType(implicitReferenceName)}");
        repositoryService.handleUsecase(usecase, params.get("${java.nameVariable(implicitReferenceName)}"));
      }
    } catch (ServiceException ex) {
      throw new DomainException(ex);
    }
</#list>
    return ${java.nameVariable(entity.name)};
  }

  public JsonData handle(ApplicationContext spring, ObjectMap params) {
    CommonService commonService = (CommonService) spring.getBean("commonService");
    try {
      commonService.beginTransaction();
      ${java.nameType(entity.name)} ${java.nameVariable(entity.name)} = save(spring, params);
      commonService.commit();
      return new JsonData().set("data", ${java.nameVariable(entity.name)});
    } catch (Throwable ex) {
      commonService.rollback();
      return new JsonData().error(ex.getMessage());
    }
  }

}