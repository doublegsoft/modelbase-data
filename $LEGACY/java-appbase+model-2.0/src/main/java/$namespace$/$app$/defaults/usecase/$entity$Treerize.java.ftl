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
import net.doublegsoft.appbase.service.ServiceException;
import net.doublegsoft.appbase.util.Strings;
import net.doublegsoft.appbase.util.Datasets;
import org.springframework.context.ApplicationContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import <#if namespace??>${namespace}.</#if>${app.name}.model.entity.*;
import <#if namespace??>${namespace}.</#if>${app.name}.model.repository.*;

public class ${java.nameType(entity.name)}Treerize {

  private static final Logger TRACER = LoggerFactory.getLogger(${java.nameType(entity.name)}Treerize.class);

  public JsonData handle(ApplicationContext spring, ObjectMap params) {
    CommonService commonService = (CommonService) spring.getBean("commonService");
    String fieldId = params.get("fieldId");
    String fieldParentId = params.get("fieldParentId");
    try {
      List<ObjectMap> data = commonService.all("${entity.persistenceName}.find", new SqlParams().set(params));
      List<ObjectMap> treerizedData = Datasets.treerize(data, new ArrayList<ObjectMap>(), fieldId, fieldParentId);
      return new JsonData().set("data", treerizedData);
    } catch (Throwable ex) {
      TRACER.error(ex.getMessage(), ex);
      return new JsonData().error(ex.getMessage());
    }
  }

}