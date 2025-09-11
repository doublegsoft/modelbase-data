<#import "/$/modelbase.ftl" as modelbase>

namespace SDK 
{
<#list model.objects as obj>
  <#if !obj.isLabelled('entity') && !obj.isLabelled('value') && !obj.isLabelled('conjunction')><#continue></#if>

  class ${java.nameType(obj.name)}
  {

<#list obj.attributes as attr>
    /// <summary>
    /// ${modelbase.get_attribute_label(attr)}.
    /// </summary>
    private ${modelbase.get_attribute_primitive_type_name(attr)} ${modelbase.get_attribute_sql_name(attr)};

</#list>
<#list obj.attributes as attr>
    public ${modelbase.get_attribute_primitive_type_name(attr)} ${java.nameType(modelbase.get_attribute_sql_name(attr))}
    {
      get
      {
        return ${modelbase.get_attribute_sql_name(attr)};
      }

      set
      {
        ${modelbase.get_attribute_sql_name(attr)} = value;
      }
    }
    
</#list>
  }

</#list>  
}