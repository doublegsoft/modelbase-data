<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4csharp.ftl" as modelbase4csharp>
<#if license??>
${csharp.license(license)}
</#if>

namespace ${csharp.nameNamespace(app.name)}.POCO 
{

  /*!
  ** 【${modelbase.get_object_label(obj)}】
  */
  public class ${csharp.nameType(obj.name)} 
  {
<#list obj.attributes as attr>  

    /*!
    ** 【${modelbase.get_attribute_label(attr)}】
    */
    public ${modelbase4csharp.type_attribute(attr)} ${java.nameVariable(attr.name)} { get; set; }
</#list>
  }

}