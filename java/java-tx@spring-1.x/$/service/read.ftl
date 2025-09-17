<#--
 ### 完整对象的读取：
 ###    包括一对一扩展的读取，集合子属性的读取 
 -->

  /**
   * 读取一个【${modelbase.get_object_label(obj)}】对象。
   */
  @Override
  public ${typename}Query read${typename}(${typename}Query query) throws ServiceException {
<#if obj.isLabelled("pivot")>  
<@modelbase4java.print_object_pivot_read obj=obj indent=4 />    
<#elseif obj.isLabelled("meta")>
<@modelbase4java.print_object_meta_read obj=obj indent=4 />  
<#elseif obj.persistenceName??>
<@modelbase4java.print_object_persistence_read obj=obj indent=4 />
</#if>
<#if obj.isLabelled("extension")>
<@modelbase4java.print_object_extension_read obj=obj indent=4 />
</#if> 
<#if idAttrs?size == 1 && idAttrs[0].type.custom>
<@modelbase4java.print_object_o2o_read obj=obj root=obj indent=4 />   
</#if> 
<#------------------------->
<#-- 通用：含有集合对象属性 -->    
<#------------------------->
<#list obj.attributes as attr>
  <#if !attr.type.collection><#continue></#if>
  <#assign collObj = model.findObjectByName(attr.type.componentType.name)>
    ${java.nameType(attr.type.componentType.name)}Query ${modelbase4java.singularize_coll_attr(attr)}Query = new ${java.nameType(attr.type.componentType.name)}Query();
  <#list collObj.attributes as collObjAttr>
    <#if obj.name == collObjAttr.type.name>
    ${modelbase4java.singularize_coll_attr(attr)}Query.set${java.nameType(modelbase.get_attribute_sql_name(collObjAttr))}(query.get${java.nameType(modelbase.get_attribute_sql_name(idAttrs[0]))}());    
    </#if>
  </#list>
    // 封装关联的【${modelbase.get_object_label(collObj)}】集合数据  
    List<Map<String,Object>> ${java.nameVariable(attr.name)} = ${java.nameVariable(attr.type.componentType.name)}DataAccess.select${java.nameType(attr.type.componentType.name)}(${modelbase4java.singularize_coll_attr(attr)}Query);
    for (Map<String,Object> row : ${java.nameVariable(attr.name)}) {
      retVal.get${java.nameType(attr.name)}().add(${java.nameType(collObj.name)}QueryAssembler.assemble${java.nameType(collObj.name)}Query(row));
    }
  <#-- TODO:  -->  
  <#-- 规则1：如果集合对象是值域对象，则需要查找下一级的非父对象的引用对象的集合 -->
  <#-- 规则2（可能有BUG）：如果集合对象是实体对象，则需要通过属性中conjunction的定义，查找关联的实体对象集合 -->
  <#if collObj.isLabelled("value")>
    <#list collObj.attributes as collObjAttr>
      <#if !collObjAttr.type.custom || collObjAttr.type.name == obj.name><#continue></#if>
      <#assign collObjAttrRefObj = model.findObjectByName(collObjAttr.type.name)>
      <#assign collObjAttrRefObjIdAttr = modelbase.get_id_attributes(collObjAttrRefObj)[0]>
    // 封装关联中明细的【${modelbase.get_object_label(collObjAttrRefObj)}】数据  
    Set<${modelbase4java.type_attribute(collObjAttrRefObjIdAttr)}> ${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Ids = new HashSet<>();
    for (Map<String,Object> row : ${java.nameVariable(attr.name)}) {
      ${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Ids.add((${modelbase4java.type_attribute(collObjAttrRefObjIdAttr)})row.get("${modelbase.get_attribute_sql_name(collObjAttrRefObjIdAttr)}"));
    }
    ${java.nameType(collObjAttrRefObj.name)}Query ${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Query = new ${java.nameType(collObjAttrRefObj.name)}Query();
    ${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Query.setLimit(-1);
    ${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Query.get${java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(collObjAttrRefObjIdAttr)))}().addAll(${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Ids);
    Pagination<${java.nameType(collObjAttrRefObj.name)}Query> ${java.nameVariable(attr.name)}${java.nameType(modelbase.get_object_plural(obj))} = ${java.nameVariable(collObjAttrRefObj.name)}Service.find${java.nameType(modelbase.get_object_plural(collObjAttrRefObj))}(${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Query);
    for (${java.nameType(collObjAttrRefObj.name)}Query row : ${java.nameVariable(attr.name)}${java.nameType(modelbase.get_object_plural(obj))}.getData()) {
      for (${java.nameType(collObj.name)}Query innerRow : retVal.get${java.nameType(attr.name)}()) {
        if (innerRow.get${java.nameType(modelbase.get_attribute_sql_name(collObjAttrRefObjIdAttr))}().equals(row.get${java.nameType(modelbase.get_attribute_sql_name(collObjAttrRefObjIdAttr))}())) {
          innerRow.set${java.nameType(collObjAttr.name)}(row);
          break;
        }
      }
    }
    </#list>
  <#elseif collObj.isLabelled("entity")>
  </#if> 
</#list>
    hierarchize(retVal, query);
<#-- REFERENCE -->    
<#list obj.attributes as attr>
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