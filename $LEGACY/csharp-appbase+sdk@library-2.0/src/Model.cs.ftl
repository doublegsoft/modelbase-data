<#import "/$/modelbase.ftl" as modelbase>
using System;
using System.Collections.Generic;

namespace SDK 
{
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#if !obj.isLabelled('entity') && !obj.isLabelled('value') && !obj.isLabelled('conjunction')><#continue></#if>

  /// <summary>
  /// ${modelbase.get_object_label(obj)}.
  /// </summary>
  public class ${java.nameType(obj.name)}
  {

<#list obj.attributes as attr>
  <#assign typename = modelbase.get_attribute_primitive_type_name(attr)>
  <#if typename == 'Timestamp'>
    <#assign typename = 'DateTime'>
  <#elseif typename == 'BigDecimal'>
    <#assign typename = 'decimal'>
  <#elseif typename == 'Integer'>
    <#assign typename = 'int'>
  <#elseif typename == 'String'>
    <#assign typename = 'string'>
  <#elseif typename == 'Date'>
    <#assign typename = 'DateTime'>
  </#if>
    /// <summary>
    /// ${modelbase.get_attribute_label(attr)}.
    /// </summary>
    private ${typename} ${modelbase.get_attribute_sql_name(attr)};

</#list>
<#list obj.attributes as attr>
  <#assign typename = modelbase.get_attribute_primitive_type_name(attr)>
  <#if typename == 'Timestamp'>
    <#assign typename = 'DateTime'>
  <#elseif typename == 'BigDecimal'>
    <#assign typename = 'decimal'>
  <#elseif typename == 'Integer'>
    <#assign typename = 'int'>
  <#elseif typename == 'String'>
    <#assign typename = 'string'>
  <#elseif typename == 'Date'>
    <#assign typename = 'DateTime'>
  </#if>
    public ${typename} ${java.nameType(modelbase.get_attribute_sql_name(attr))}
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