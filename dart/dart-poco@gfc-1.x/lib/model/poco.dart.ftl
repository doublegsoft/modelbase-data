<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>

<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  
///
/// 【${modelbase.get_object_label(obj)}】
///
class ${dart.nameType(obj.name)} {
  <#list obj.attributes as attr>  
  
  ///
  /// 【${modelbase.get_attribute_label(attr)}】
  ///
    <#if attr.type.collection>
  ${modelbase4dart.get_native_type_name(attr.type)} ${modelbase.get_attribute_sql_name(attr)} = [];    
    <#elseif attr.isLabelled("redefined")>
  ${modelbase4dart.get_native_type_name(attr.type)}? ${modelbase.get_attribute_sql_name(attr)};
    <#elseif attr.type.custom>
      <#assign refObj = model.findObjectByName(attr.type.name)>
      <#assign refObjIdAttrs = modelbase.get_id_attributes(refObj)>
  ${modelbase4dart.get_native_type_name(refObjIdAttrs[0].type)}? ${modelbase.get_attribute_sql_name(attr)};  
    <#elseif attr.constraint.domainType.name == "id">
  int? ${modelbase.get_attribute_sql_name(attr)};    
    <#else>
  ${modelbase4dart.get_native_type_name(attr.type)}? ${modelbase.get_attribute_sql_name(attr)};
    </#if>
  </#list>
  
  ${dart.nameType(obj.name)}({
  <#list obj.attributes as attr>  
    <#if !attr.type.collection>
    this.${modelbase.get_attribute_sql_name(attr)},
    </#if>
  </#list> 
  });
}  
</#list>