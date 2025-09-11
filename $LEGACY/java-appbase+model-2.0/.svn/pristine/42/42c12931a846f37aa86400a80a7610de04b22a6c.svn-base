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
import net.doublegsoft.appbase.ddd.DomainException;
import net.doublegsoft.appbase.util.Strings;
import org.springframework.context.ApplicationContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import <#if namespace??>${namespace}.</#if>${app.name}.model.entity.*;
import <#if namespace??>${namespace}.</#if>${app.name}.model.assembler.*;
import <#if namespace??>${namespace}.</#if>${app.name}.model.repository.*;

<#assign attrId = modelbase.get_id_attributes(entity)[0]>
public class ${java.nameType(entity.name)}Merge {

  private static final Logger TRACER = LoggerFactory.getLogger(${java.nameType(entity.name)}Merge.class);

  public ${java.nameType(entity.name)} merge(ApplicationContext spring, ObjectMap params) throws DomainException {
    ${java.nameType(entity.name)} ${java.nameVariable(entity.name)} = ${java.nameType(entity.name)}Assembler.assemble${java.nameType(entity.name)}FromFrontend(params);
    ${java.nameType(entity.name)}Repository ${java.nameVariable(entity.name)}Repository = spring.getBean(${java.nameType(entity.name)}Repository.class);

    ${java.nameType(entity.name)} existing = ${java.nameVariable(entity.name)}Repository.read${java.nameType(entity.name)}(params.get("${modelbase.get_attribute_sql_name(attrId)}"));

    if (existing == null)
      ${java.nameVariable(entity.name)}Repository.create${java.nameType(entity.name)}(${java.nameVariable(entity.name)});
    else {
      ${java.nameType(entity.name)}Assembler.assemble${java.nameType(entity.name)}From${java.nameType(entity.name)}(${java.nameVariable(entity.name)}, existing);
      ${java.nameVariable(entity.name)}Repository.update${java.nameType(entity.name)}(${java.nameVariable(entity.name)}, false);
    }
    return ${java.nameVariable(entity.name)};
  }

  public JsonData handle(ApplicationContext spring, ObjectMap params) {
    CommonService commonService = (CommonService) spring.getBean("commonService");
    try {
      commonService.beginTransaction();
      ${java.nameType(entity.name)} ${java.nameVariable(entity.name)} = merge(spring, params);
      commonService.commit();
      return new JsonData().set("data", ${java.nameVariable(entity.name)});
    } catch (Throwable ex) {
      commonService.rollback();
      return new JsonData().error(ex.getMessage());
    }
  }

}