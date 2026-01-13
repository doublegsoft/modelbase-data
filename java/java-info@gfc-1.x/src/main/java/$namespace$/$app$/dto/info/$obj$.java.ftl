<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
package ${namespace}.${app.name}.dto.info;

import java.io.Serializable;
import java.util.ArrayList;
<#list modelbase4java.get_imports(obj)?sort as imp>
import ${imp};
</#list>

/*!
** 【${modelbase.get_object_label(obj)}】
*/
public class ${java.nameType(obj.name)} implements Serializable {

  private static long serialVersionNumber = -1L;
<#list obj.attributes as attr>  
  <#if attr.type.collection><#continue></#if>

  /*!
  ** 【${modelbase.get_attribute_label(attr)}】
  */
  protected ${modelbase4java.type_attribute_primitive(attr)} ${java.nameVariable(modelbase.get_attribute_sql_name(attr))};
</#list>
<#list obj.attributes as attr>  
  <#if attr.type.collection><#continue></#if>

  public ${modelbase4java.type_attribute_primitive(attr)} get${java.nameType(modelbase.get_attribute_sql_name(attr))}() {
    return ${java.nameVariable(modelbase.get_attribute_sql_name(attr))};
  }

  public void set${java.nameType(modelbase.get_attribute_sql_name(attr))}(${modelbase4java.type_attribute_primitive(attr)} ${java.nameVariable(modelbase.get_attribute_sql_name(attr))}) {
    this.${java.nameVariable(modelbase.get_attribute_sql_name(attr))} = ${java.nameVariable(modelbase.get_attribute_sql_name(attr))};
  }
</#list>
<#if idAttrs?size == 1>
  <#assign idAttr = modelbase.get_id_attributes(obj)[0]>
  
  @Override
  public String toString() {
    if (get${java.nameType(idAttr.name)}() != null) {
      return get${java.nameType(idAttr.name)}().toString();
    }
    return null; 
  }
  
  public ${modelbase4java.type_attribute_primitive(idAttr)} toId() {
    if (get${java.nameType(idAttr.name)}() != null) {
  <#if idAttr.type.custom>
      return get${java.nameType(idAttr.name)}().toId();
  <#else>  
      return get${java.nameType(idAttr.name)}();
  </#if>    
    }
    return null; 
  }
</#if>
}