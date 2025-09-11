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
import <#if namespace??>${namespace}.</#if>${app.name}.model.repository.*;

public class ${java.nameType(entity.name)}Count {

  private static final Logger TRACER = LoggerFactory.getLogger(${java.nameType(entity.name)}Count.class);

  public List<ObjectMap> count(ApplicationContext spring, ObjectMap params) throws DomainException {
    ${java.nameType(entity.name)}Repository ${java.nameVariable(entity.name)}Repository = spring.getBean(${java.nameType(entity.name)}Repository.class);
    return ${java.nameVariable(entity.name)}Repository.aggregate${java.nameType(entity.plural)}(params);
  }

  public JsonData handle(ApplicationContext spring, ObjectMap params) {
    try {
      List<ObjectMap> data = count(spring, params);
      return new JsonData().set("data", data);
    } catch (Throwable ex) {
      TRACER.error(ex.getMessage(), ex);
      return new JsonData().error(ex.getMessage());
    }
  }

}