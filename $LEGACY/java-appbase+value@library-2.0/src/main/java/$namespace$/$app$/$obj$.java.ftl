<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name};

<#assign attrsNotHavingDefault = []>
<#assign attrsHavingDefault = []>
<#list obj.attributes as attr>
  <#if attr.constraint.defaultValue??>
    <#assign attrsHavingDefault = attrsHavingDefault + [attr]>
  <#else>
    <#assign attrsNotHavingDefault = attrsNotHavingDefault + [attr]>
  </#if>
</#list>
public class ${java.nameType(obj.name)} {
<#list obj.attributes as attr>

  protected ${modelbase.type_attribute(attr)} ${java.nameVariable(attr.name)};
</#list>

  public ${java.nameType(obj.name)}() {
    
  }

  public ${java.nameType(obj.name)}(Map<String, Object> obj) {
    if (obj == null) {
      return;
    }
<#list obj.attributes as attr>
  <#if attr.type.primitive>
    this.${java.nameVariable(attr.name)} = (${modelbase.type_attribute(attr)}) Safe.safe${modelbase.type_attribute(attr)}(obj.get("${java.nameVariable(attr.name)}"));
  <#else>
    this.${java.nameVariable(attr.name)} = new ${modelbase.type_attribute(attr)}((Map<String, Object>) obj.get("${java.nameVariable(attr.name)}"));
  </#if>
</#list>
  }

  public ${java.nameType(obj.name)}(<#list attrsNotHavingDefault as attr><#if attr?index != 0>, </#if>${modelbase.type_attribute(attr)} ${java.nameVariable(attr.name)}</#list>) {
<#if attrsHavingDefault?size == 0>
  <#list obj.attributes as attr>
    this.${java.nameVariable(attr.name)} = ${java.nameVariable(attr.name)};
  </#list>
<#else>
    this(<#list attrsNotHavingDefault as attr>${java.nameVariable(attr.name)}, </#list><#list attrsHavingDefault as attr><#if attr?index != 0>, </#if>null</#list>);  
</#if>
  }
<#if attrsHavingDefault?size != 0>

  public ${java.nameType(obj.name)}(<#list attrsNotHavingDefault as attr>${modelbase.type_attribute(attr)} ${java.nameVariable(attr.name)}, </#list><#list attrsHavingDefault as attr><#if attr?index != 0>, </#if>${modelbase.type_attribute(attr)} ${java.nameVariable(attr.name)}</#list>) {
  <#list obj.attributes as attr>
    this.${java.nameVariable(attr.name)} = ${java.nameVariable(attr.name)};
  </#list>
  }
</#if>  

  public ${java.nameType(obj.name)} increment(${java.nameType(obj.name)} ${java.nameVariable(obj.name)}) {
    return this;
  }
<#list obj.attributes as attr>

  public ${modelbase.type_attribute(attr)} ${java.nameVariable(attr.name)}() {
    return ${java.nameVariable(attr.name)};
  }

  public ${java.nameType(obj.name)} ${java.nameVariable(attr.name)}(${modelbase.type_attribute(attr)} ${java.nameVariable(attr.name)}) {
    this.${java.nameVariable(attr.name)} = ${java.nameVariable(attr.name)};
    return this;
  }
</#list>
}