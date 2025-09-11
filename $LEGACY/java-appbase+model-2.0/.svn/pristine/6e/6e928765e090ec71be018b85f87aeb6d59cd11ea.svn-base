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
import net.doublegsoft.appbase.ddd.DomainException;
import net.doublegsoft.appbase.util.Strings;
import org.springframework.context.ApplicationContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import <#if namespace??>${namespace}.</#if>${app.name}.model.entity.*;
import <#if namespace??>${namespace}.</#if>${app.name}.model.repository.*;

<#-- 准备数据 -->
<#assign attrId = modelbase.get_id_attributes(entity)[0]>
<#assign attrRefs = []>
<#list entity.attributes as attr>
  <#if attr.type.collection>
    <#assign componentType = attr.type.componentType>
    <#if componentType.custom>
      <#assign attrRefs = attrRefs + [attr]>
    </#if>
  </#if>
</#list>
public class ${java.nameType(entity.name)}Delete {

  private static final Logger TRACER = LoggerFactory.getLogger(${java.nameType(entity.name)}Delete.class);

  public void delete(ApplicationContext spring, ObjectMap params) throws DomainException {
    try {
      if (Strings.isBlank(params.get("${modelbase.get_attribute_sql_name(attrId)}"))) {
        throw new RuntimeException("数据标识没有传入，请联系管理员！");
      }

      CommonService commonService = (CommonService) spring.getBean("commonService");
      SqlParams sqlParams = new SqlParams();
      sqlParams.set(params);
  
    commonService.execute("${entity.persistenceName}.delete", sqlParams);
  <#list attrRefs as attrRef>
    <#assign attrRefObj = model.findObjectByName(attrRef.type.componentType.name)>
      if ("true".equals(params.get("remove${js.nameType(attrRef.name)}"))) {
        commonService.execute("${attrRefObj.persistenceName}.delete", sqlParams);
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
      delete(spring, params);
      commonService.commit();
    } catch (Throwable ex) {
      commonService.rollback();
      TRACER.error(ex.getMessage(), ex);
      return new JsonData().error(ex.getMessage());
    }

    // 返回对象
    JsonData retVal = new JsonData();
    return retVal;
  }

}