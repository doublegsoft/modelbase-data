<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.httpc.payload;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;

<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#assign label = modelbase.get_object_label(obj)>
/**
 * ${label}对象封装。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since 1.0.0
 */
public class ${java.nameType(obj.name)} implements Serializable {

  private static final long serialVersionUID = -1L;

<#list obj.attributes as attr>

  private <#if attr.type.collection || attr.type.name == 'json'>final </#if>${modelbase.type_attribute(attr)} ${java.nameVariable(attr.name)}<#if defaultValue?? && defaultValue != ''> = ${defaultValue}</#if>;

</#list>
<#assign implicitReferences = modelbase.get_object_implicit_references(obj)>
<#list implicitReferences as implicitReferenceName, implicitReference>
  private Object ${js.nameVariable(implicitReferenceName)};

</#list>
<#list obj.attributes as attr>
  public ${modelbase.type_attribute(attr)} get${java.nameType(attr.name)}() {
    return ${java.nameVariable(attr.name)};
  }

  <#if attr.constraint.identifiable && attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#assign refObjIdAttr = modelbase.get_id_attributes(refObj)[0]>
  public void set${java.nameType(attr.name)}(${modelbase.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)}) {
    ${java.nameType(refObj.name)} ${java.nameVariable(refObj.name)} = new ${java.nameType(refObj.name)}();
    ${java.nameVariable(refObj.name)}.setId(${modelbase.get_attribute_sql_name(attr)});
    this.${java.nameVariable(attr.name)} = ${java.nameVariable(refObj.name)};
  }

  </#if>
  <#if !attr.type.collection && attr.type.name != 'json'>
  public void set${java.nameType(attr.name)}(${modelbase.type_attribute(attr)} ${java.nameVariable(attr.name)}) {
    this.${java.nameVariable(attr.name)} = ${java.nameVariable(attr.name)};
  }

  </#if>
</#list>
<#list implicitReferences as implicitReferenceName, implicitReference>
  public Object get${js.nameType(implicitReferenceName)}() {
    return ${js.nameVariable(implicitReferenceName)};
  }

  public void set${js.nameType(implicitReferenceName)}(Object ${js.nameVariable(implicitReferenceName)}) {
    this.${js.nameVariable(implicitReferenceName)} = ${js.nameVariable(implicitReferenceName)};
  }

</#list>
}
