<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
package ${namespace}.${app.name}.poco;

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
<#if idAttrs?size == 1>  
  
  public static final ${java.nameType(obj.name)} NULL = new ${java.nameType(obj.name)}() {

  <#if idAttrs[0].type.custom>
    public ${java.nameType(idAttrs[0].type.name)} get${java.nameType(idAttrs[0].name)}() {
      return ${java.nameType(idAttrs[0].type.name)}.NULL;
    }
  <#else>
    public ${modelbase4java.type_attribute_primitive(idAttrs[0])} get${java.nameType(idAttrs[0].name)}() {
      return ${modelbase4java.value_attribute_null(idAttrs[0])};
    }
  </#if>  

  };
</#if>  
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