<#import '/$/appbase.ftl' as appbase>
<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.model.event;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.math.BigDecimal;
import java.io.Serializable;
import java.io.InputStream;

import net.doublegsoft.appbase.ddd.Event;

<#list imports as imp>
import ${imp}.model.entity.*;
</#list>

import <#if namespace??>${namespace}.</#if>${app.name}.model.entity.*;
<#if modelbase.has_value_object(app.name, model)>
import <#if namespace??>${namespace}.</#if>${app.name}.model.value.*;
</#if>

/**
 * ${modelbase.get_object_label(entity)!'TODO'}事件对象封装。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">甘果</a>
 *
 * @since 1.0.0
 */
public class ${java.nameType(entity.name)}CreatedEvent implements Event<${java.nameType(entity.name)}>, Serializable {

  private static final long serialVersionUID = -1L;
  
  private static final String EVENT_NAME = "${parentApplication}/${app.name}/${entity.name}/created";
  
  private final java.util.Date occurredTime = new java.util.Date();

  private ${java.nameType(entity.name)} ${java.nameVariable(entity.name)};
  
  public ${java.nameType(entity.name)} get${java.nameType(entity.name)}() {
    return ${java.nameVariable(entity.name)};
  }

  public void set${java.nameType(entity.name)}(${java.nameType(entity.name)} ${java.nameVariable(entity.name)}) {
    this.${java.nameVariable(entity.name)} = ${java.nameVariable(entity.name)};
  }
  
  @Override
  public String getEventName() {
  	return EVENT_NAME;
  }
  
  @Override
  public java.util.Date getOccurredTime() {
  	return occurredTime;
  }
  
  @Override
  public ${java.nameType(entity.name)} getData() {
  	return get${java.nameType(entity.name)}();
  }

}
