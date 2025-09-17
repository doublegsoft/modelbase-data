<#--
 ### 完整对象的读取：
 ###    包括一对一扩展的读取，集合子属性的读取 
 -->

  /**
   * 读取一个【${modelbase.get_object_label(obj)}】对象。
   */
  @Override
  public ${typename}Query read${typename}(${typename}Query query) throws ServiceException {
<#if obj.persistenceName?? && !obj.isLabelled("meta") && !obj.isLabelled("extension")>
  <#-- 因为meta和extension是继承了原始对象的所有标签 -->
<@modelbase4java.print_object_persistence_read obj=obj indent=4 />    
<#elseif obj.isLabelled("pivot")>  
<@modelbase4java.print_object_pivot_read obj=obj indent=4 />    
<#elseif obj.isLabelled("meta")>
<@modelbase4java.print_object_meta_read obj=obj indent=4 />  
<#elseif obj.isLabelled("extension")>
<@modelbase4java.print_object_extension_read obj=obj indent=4 />
</#if> 
<#if idAttrs?size == 1 && idAttrs[0].type.custom>
<@modelbase4java.print_object_one2one_read obj=obj root=obj indent=4 />   
</#if>
<@modelbase4java.print_object_one2many_read obj=obj indent=4 /> 
<@modelbase4java.print_object_many2many_read obj=obj indent=4 /> 
    hierarchize(retVal, query);
<#-- REFERENCE -->    
<#list obj.attributes as attr>
  <#if modelbase.is_attribute_system(attr)><#continue></#if>
  <#if attr.isLabelled("reference") && attr.getLabelledOptions("reference")["value"] == "id">
    <#assign referenceName = attr.getLabelledOptions("reference")["name"]>
    <#if !modelbase.get_reference_type_attribute(obj, referenceName)??><#continue></#if>
    <#assign refTypeAttr = modelbase.get_reference_type_attribute(obj, referenceName)>
    ${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)} = retVal.get${java.nameType(modelbase.get_attribute_sql_name(attr))}();
    ${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(refTypeAttr)} = retVal.get${java.nameType(modelbase.get_attribute_sql_name(refTypeAttr))}();
    retVal.set${java.nameType(referenceName)}(referenceService.readReference(${modelbase.get_attribute_sql_name(attr)}, ${modelbase.get_attribute_sql_name(refTypeAttr)}));  
  </#if>
</#list>    
    return retVal;
  } 

  public ${typename}Query read${typename}(<@modelbase4java.print_find_by_unique_parameters attrs=idAttrs />) throws ServiceException {
    ${typename}Query query = new ${typename}Query();
    <#list idAttrs as idAttr>
    query.${modelbase4java.name_setter(idAttr)}(${modelbase.get_attribute_sql_name(idAttr)});
    </#list>
    return read${typename}(query);
  }