  /**
   * 保存多个【${modelbase.get_object_label(obj)}】数据。
   */
  @Override
  @Transactional(rollbackFor = Throwable.class)
  public void save${inflector.pluralize(typename)}(List<${typename}Query> queries) throws ServiceException { 
    for (${typename}Query query : queries) {
<#if (groupUniqueAttrs?size > 0) && idAttrs?size == 1>
  <#assign idAttr = idAttrs[0]>
      if (query.get${java.nameType(modelbase.get_attribute_sql_name(idAttr))}() == null) {
        ${typename}Query params = new ${typename}Query();
        params.setLimit(-1);
  <#list groupUniqueAttrs as attr>
        params.set${java.nameType(modelbase.get_attribute_sql_name(attr))}(query.get${java.nameType(modelbase.get_attribute_sql_name(attr))}());
  </#list>   
        Pagination<${typename}Query> existing = find${inflector.pluralize(typename)}(params);
        if (existing.getTotal() > 0) {
          query.set${java.nameType(modelbase.get_attribute_sql_name(idAttr))}(existing.getData().get(0).get${java.nameType(modelbase.get_attribute_sql_name(idAttr))}());
        }
      } 
</#if>     
      save${typename}(query);
    }
  }
  
  /**
   * 保存单个【${modelbase.get_object_label(obj)}】数据。
   */
  @Override
  @Transactional(rollbackFor = Throwable.class)
  public ${typename}Query save${typename}(${typename}Query query) throws ServiceException {
    if (query == null) {
      return null;
    }
    boolean existing = true;
    try {
<#--------------------->
<#-- 主要对象的保存操作 -->
<#--------------------->  
<#if obj.persistenceName??>
  <#if idAttrs?size == 1>
    <#----------------------------------------------------------------------------------------------->
    <#-- TODO: 实体对象的保存，允许实体对象中外键关联对象，在保存这个实体对象（创建关系）时也同时保存关联的实体对象 -->
    <#----------------------------------------------------------------------------------------------->
    <#-- 实体对象的保存 -->
<@modelbase4java.print_object_entity_save obj=obj indent=6 />
  <#else>    
    <#----------------------------------------------------------------------------------------->
    <#-- 值体对象的保存，允许值域对象中主键关联对象，在保存这个值域对象（创建关系）时也同时保存关联的实体对象 -->
    <#----------------------------------------------------------------------------------------->
    <#list idAttrs as idAttr>
      <#assign refObj = model.findObjectByName(idAttr.type.name)>
      <#assign refObjIdAttr = refObj.getIdentifiableAttribute()>
      if (query.get${java.nameType(idAttr.name)}() != null) {
        ${java.nameVariable(refObj.name)}Service.save${java.nameType(refObj.name)}(query.get${java.nameType(idAttr.name)}());
        query.${modelbase4java.name_setter(idAttr)}(query.get${java.nameType(idAttr.name)}().${modelbase4java.name_getter(refObjIdAttr)}());
      }
    </#list>  
    <#-- 值域对象的保存 -->
<@modelbase4java.print_object_value_save obj=obj indent=6 />    
  </#if>
<#elseif obj.isLabelled("pivot")>  
  <#if obj.getLabelledOptions("pivot")["master"]??>
    <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#-- 行列对象的保存 -->
<@modelbase4java.print_object_entity_save obj=masterObj indent=6 proxy=obj />  
  </#if> 
</#if>        
<#--------------------->
<#-- 扩展对象的保存操作 -->
<#--------------------->    
<@modelbase4java.print_object_extension_save obj=obj indent=6 />     
<#-------------------------->
<#--       元型扩展        -->
<#-------------------------->
<#if obj.isLabelled("meta")>
<@modelbase4java.print_object_meta_save obj=obj indent=6 />   
</#if>
<#-------------------------->
<#--       行列扩展        -->
<#-------------------------->
<#if obj.isLabelled("pivot")>
<@modelbase4java.print_object_pivot_save obj=obj indent=6 />   
</#if>
<#-------------------------->
<#--    主键引用的基表部分   -->
<#-------------------------->
<#if idAttrs?size == 1> 
<@modelbase4java.print_object_one2one_save obj=obj indent=6/> 
</#if>
<#-------------------------->
<#-- 通用：集合对象类型的属性 -->
<#-------------------------->
<@modelbase4java.print_object_one2many_save obj=obj indent=6 /> 
<@modelbase4java.print_object_many2many_save obj=obj indent=6 /> 
<#list model.objects as innerObj>
  <#list innerObj.attributes as attr>
    <#if modelbase.has_observer_for_attribute(innerObj, attr) && 
         attr.type.componentType.name == obj.name>
<@modelbase4java.print_attribute_observer_update obj=innerObj attr=attr indent=6 />        
    </#if>
  </#list>
</#list>
      transact(query);
    } catch (Throwable cause) {
      throw new ServiceException(500, cause);
    }
    return query;
  }