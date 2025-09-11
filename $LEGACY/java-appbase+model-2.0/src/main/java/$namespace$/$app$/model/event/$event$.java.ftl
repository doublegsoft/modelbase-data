<#import '/$/appbase.ftl' as appbase>
<#import '/$/paradigm-internal.ftl' as internal>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.model.event;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.math.BigDecimal;
import java.io.Serializable;
import java.io.InputStream;

import net.doublegsoft.appbase.ddd.Event;

<#list appbase.get_deps(model) as dep>
  <#if appbase.has_value(model, dep)>
import <#if namespace??>${namespace}.</#if>${dep}.event.*;
  </#if>
  <#if appbase.has_entity(model, dep)>
import <#if namespace??>${namespace}.</#if>${dep}.event.*;
  </#if>
</#list>

/**
 * ${event.text!'TODO'}事件对象封装。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">甘果</a>
 *
 * @since 1.0.0
 */
public class ${java.nameType(event.name)} implements Event, Serializable {

  private static final long serialVersionUID = -1L;

<#list event.attributes as attr>
  /**
   * ${attr.text!'TODO'}.
   */
  private <#if attr.type.collection>final </#if>${internal.type_attribute(attr)} ${java.nameVariable(attr.name)}<#if attr.type.collection> = new ArrayList<>()</#if>;

</#list>
<#list event.attributes as attr>
  public ${internal.type_attribute(attr)} get${java.nameType(attr.name)}() {
    return ${java.nameVariable(attr.name)};
  }

  <#if !attr.type.collection>
  public void set${java.nameType(attr.name)}(${internal.type_attribute(attr)} ${java.nameVariable(attr.name)}) {
    this.${java.nameVariable(attr.name)} = ${java.nameVariable(attr.name)};
  }

  </#if>
</#list>

}
