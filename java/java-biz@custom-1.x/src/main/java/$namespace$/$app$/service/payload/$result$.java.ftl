<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#assign obj = result>
package ${namespace}.${java.nameNamespace(app.name)}.service.payload;

import java.util.*;
import java.math.*;

public class ${java.nameType(obj.name)} implements java.io.Serializable {

  private static long serialVersionNumber = -1L;
<#list obj.attributes as attr>  

  /*!
  ** 【${modelbase.get_attribute_label(attr)}】
  */
  <#if attr.type.collection>
  protected ${modelbase4java.type_attribute(attr)} ${java.nameVariable(attr.name)} = new ArrayList<>();
  <#else>
  protected ${modelbase4java.type_attribute(attr)} ${java.nameVariable(attr.name)};
  </#if>
</#list>
<#list obj.attributes as attr>  

  public ${modelbase4java.type_attribute(attr)} get${java.nameType(attr.name)}() {
    return ${java.nameVariable(attr.name)};
  }
  
  public void set${java.nameType(attr.name)}(${modelbase4java.type_attribute(attr)} ${java.nameVariable(attr.name)}) {
    this.${java.nameVariable(attr.name)} = ${java.nameVariable(attr.name)};
  }
</#list>
}