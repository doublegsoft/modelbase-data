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
  
  @Override
  @Transactional(rollbackFor = Throwable.class)
  public ${typename}Query save${typename}(${typename}Query query) throws ServiceException {
    if (query == null) {
      return null;
    }
    ValidationResult res = ${varname}Validation.validate(query);
    if (!res.isValid()) {
      throw new ServiceException(res.getCode(), res.getMessage());
    }
    try {
<#--------------------->
<#-- 主要对象的保存操作 -->
<#--------------------->  
<#if obj.isLabelled("pivot")>    
<#-- 行列对象的保存 -->
<@modelbase4java.print_object_entity_save obj=obj indent=6 />  
<#elseif idAttrs?size == 1> 
<#-- 实体对象的保存 -->     
<@modelbase4java.print_object_entity_save obj=obj indent=6 />
<#else>     
<#-- 值体对象的保存 -->    
<@modelbase4java.print_object_value_save obj=obj indent=6 />    
</#if>      
<#--------------------->
<#-- 扩展对象的保存操作 -->
<#--------------------->    
<#list extObjs as extObjName, extRefAttr>
  <#assign extObj = model.findObjectByName(extObjName)>
  <#assign extObjIdAttr = modelbase.get_id_attributes(extObj)[0]>
      /*!
      ** 保存【${modelbase.get_object_label(extObj)}】作为一对一显式扩展对象
      */
      ${java.nameType(extObj.name)}Query ${java.nameVariable(extObj.name)}Query = new ${java.nameType(extObj.name)}Query();
      ${java.nameVariable(extObj.name)}Query.set${java.nameType(modelbase.get_attribute_sql_name(extObjIdAttr))}(${modelbase.get_attribute_sql_name(idAttrs[0])}); 
      ${java.nameVariable(extObj.name)}Query.set${java.nameType(modelbase.get_attribute_sql_name(extRefAttr))}(Safe.safe(${modelbase.get_attribute_sql_name(idAttrs[0])}, ${modelbase4java.type_attribute_primitive(extRefAttr)}.class));
  <#list obj.attributes as attr>
    <#list extObj.attributes as extObjAttr>
      <#if attr.name == extObjAttr.name && !attr.constraint.identifiable>
      ${java.nameVariable(extObj.name)}Query.set${java.nameType(modelbase.get_attribute_sql_name(extObjAttr))}(query.get${java.nameType(modelbase.get_attribute_sql_name(attr))}());    
        <#break>
      </#if>
    </#list>
  </#list>
  <#list extObj.attributes as extObjAttr>
    <#-- 扩展类型本身引用主实体类型 （比较重要）-->
    <#if extObjAttr.type.name == obj.name>
      ${java.nameVariable(extObj.name)}Query.set${java.nameType(modelbase.get_attribute_sql_name(extObjAttr))}(query.get${java.nameType(modelbase.get_attribute_sql_name(idAttrs[0]))}());    
      <#break>
    </#if>
  </#list>
      ${java.nameType(extObj.name)} ${java.nameVariable(extObj.name)} = ${java.nameType(extObj.name)}Assembler.assemble${java.nameType(extObj.name)}FromQuery(${java.nameVariable(extObj.name)}Query);
      if (!existing) {
        ${java.nameVariable(extObj.name)}DataAccess.insert${java.nameType(extObj.name)}(${java.nameVariable(extObj.name)});
      } else {
        ${java.nameVariable(extObj.name)}DataAccess.updatePartial${java.nameType(extObj.name)}(${java.nameVariable(extObj.name)});
      }
</#list>
<#-------------------------->
<#--       元型扩展        -->
<#-------------------------->
<#if obj.isLabelled("meta")>
  <#list obj.attributes as attr>
    <#if !attr.isLabelled("redefined")><#continue></#if>
      if (query.${modelbase4java.name_getter(attr)}() != null) {
        ${java.nameType(obj.name)}MetaQuery ${java.nameVariable(attr.name)}Query = new ${java.nameType(obj.name)}MetaQuery();
        ${java.nameVariable(attr.name)}Query.${modelbase4java.name_setter(idAttrs[0])}(${modelbase.get_attribute_sql_name(idAttrs[0])});
        ${java.nameVariable(attr.name)}Query.setPropertyName("${java.nameVariable(attr.name)}");
        if (${java.nameVariable(obj.name)}MetaDataAccess.select${java.nameType(obj.name)}Meta(${java.nameVariable(attr.name)}Query).size() == 0) {
          ${java.nameVariable(attr.name)}Query.setPropertyValue(Strings.format(query.${modelbase4java.name_getter(attr)}()));
          ${java.nameVariable(obj.name)}MetaDataAccess.insert${java.nameType(obj.name)}Meta(${java.nameType(obj.name)}MetaAssembler.assemble${java.nameType(obj.name)}MetaFromQuery(${java.nameVariable(attr.name)}Query));
        } else {
          ${java.nameVariable(attr.name)}Query.setPropertyValue(Strings.format(query.${modelbase4java.name_getter(attr)}().toString()));
          ${java.nameVariable(obj.name)}MetaDataAccess.update${java.nameType(obj.name)}Meta(${java.nameType(obj.name)}MetaAssembler.assemble${java.nameType(obj.name)}MetaFromQuery(${java.nameVariable(attr.name)}Query));
        }
      }
  </#list>
</#if>
<#-------------------------->
<#--       行列扩展        -->
<#-------------------------->
<#if obj.isLabelled("pivot")>
  <#if obj.getLabelledOptions("pivot")["master"]??>
    <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#assign idAttrs = modelbase.get_id_attributes(masterObj)>
  </#if>  
  <#assign detailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
  <#assign keyAttr = model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("pivot")["key"])>
  <#assign valueAttr = model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("pivot")["value"])>
  <#list obj.attributes as attr>
    <#if !attr.isLabelled("redefined")><#continue></#if>
    <#-- 在没有master的情况下，属性可以和detail的属性重合 -->
    <#assign existInDetail = false>
    <#list detailObj.attributes as detailAttr>
      <#if attr.name == detailAttr.name>
        <#assign existInDetail = true>
      </#if>
    </#list>
    <#if existInDetail><#continue></#if>
      if (query.${modelbase4java.name_getter(attr)}() != null) {
        ${java.nameType(detailObj.name)}Query ${java.nameVariable(attr.name)}Query = new ${java.nameType(detailObj.name)}Query();
    <#if obj.getLabelledOptions("pivot")["master"]??>    
        ${java.nameVariable(attr.name)}Query.${modelbase4java.name_setter(idAttrs[0])}(${modelbase.get_attribute_sql_name(idAttrs[0])});
    <#else>
      <#list obj.attributes as innerAttr>
        <#list detailObj.attributes as detailAttr>
          <#if innerAttr.name == detailAttr.name>
        ${java.nameVariable(attr.name)}Query.${modelbase4java.name_setter(innerAttr)}(query.${modelbase4java.name_getter(innerAttr)}());
          </#if>
        </#list>      
      </#list>
    </#if>   
        ${java.nameVariable(attr.name)}Query.${modelbase4java.name_setter(keyAttr)}("${java.nameVariable(attr.name)}");
        ${java.nameVariable(attr.name)}Query.${modelbase4java.name_setter(valueAttr)}(Strings.format(query.${modelbase4java.name_getter(attr)}()));
        if (!existing) {
          ${java.nameVariable(detailObj.name)}Service.create${java.nameType(detailObj.name)}(${java.nameVariable(attr.name)}Query);
        } else {
          ${java.nameVariable(detailObj.name)}Service.update${java.nameType(detailObj.name)}(${java.nameVariable(attr.name)}Query);
        }
      }
  </#list>
</#if>
<#-------------------------->
<#--    主键引用的基表部分   -->
<#-------------------------->
<#if idAttrs?size == 1> 
<@modelbase4java.print_object_query_save obj=obj /> 
</#if>
<#-------------------------->
<#-- 通用：集合对象类型的属性 -->
<#-------------------------->
<#list obj.attributes as attr>
  <#if !attr.type.collection><#continue></#if>
  <#assign collObj = model.findObjectByName(attr.type.componentType.name)>
  <#assign collObjIdAttrs = modelbase.get_id_attributes(collObj)>
  <#list collObjIdAttrs as idAttr> 
    <#-- 找到本身对象以外的另一个对象的引用 -->
    <#if idAttr.type.name != obj.name && idAttr.type.custom>
      <#assign collObjIdAttr = idAttr>
      <#break>
    </#if>
  </#list>
  <#if !collObjIdAttr??>
    <#assign collObjIdAttr = collObjIdAttrs[0]>
  </#if>
  <#assign one2many = false>
  <#list collObj.attributes as collObjAttr>
    <#if collObjAttr.type.name == obj.name>
      <#assign one2many = true>
      <#break>
    </#if>
  </#list>
  <#if one2many>
      /*!
      ** 直接关联的【${modelbase.get_object_label(collObj)}】作为一对多显式扩展对象
      */
      List<${java.nameType(attr.type.componentType.name)}Query> ${java.nameVariable(attr.name)} = query.get${java.nameType(attr.name)}();
<#--     
      ${java.nameType(attr.type.componentType.name)} ${modelbase4java.singularize_coll_attr(attr)} = new ${java.nameType(attr.type.componentType.name)}();
  <#list obj.attributes as innerAttr>
    <#list collObj.attributes as collObjAttr>
      <#if innerAttr.name == collObjAttr.name>
      ${modelbase4java.singularize_coll_attr(attr)}.set${java.nameType(innerAttr.name)}(query.get${java.nameType(modelbase.get_attribute_sql_name(innerAttr))}());    
      </#if>
    </#list>
  </#list>
      ${java.nameVariable(attr.type.componentType.name)}DataAccess.disable${java.nameType(attr.type.componentType.name)}(${modelbase4java.singularize_coll_attr(attr)});
-->      
      // 查询已经存在的
      ${java.nameType(collObj.name)}Query existing${java.nameType(collObj.name)}Query = new ${java.nameType(collObj.name)}Query();
      existing${java.nameType(collObj.name)}Query.set${java.nameType(modelbase.get_attribute_sql_name(idAttrs[0]))}(${modelbase.get_attribute_sql_name(idAttrs[0])});
    <#list collObj.attributes as collObjAttr>
      <#if collObjAttr.name == "state">
      existing${java.nameType(collObj.name)}Query.setState("E");
      </#if>
    </#list>   
      List<Map<String,Object>> existing${java.nameType(collObj.name)}Rows = ${java.nameVariable(collObj.name)}DataAccess.select${java.nameType(collObj.name)}(existing${java.nameType(collObj.name)}Query);
      // 去掉不存在的
    <#if (collObjIdAttrs?size > 1)>      
      for (Map<String,Object> row : existing${java.nameType(collObj.name)}Rows) {
        boolean found = false;
        for (${java.nameType(collObj.name)}Query rowQuery : ${java.nameVariable(attr.name)}) {
          if (rowQuery.get${java.nameType(modelbase.get_attribute_sql_name(collObjIdAttr))}().equals(row.get("${modelbase.get_attribute_sql_name(collObjIdAttr)}"))) {
            found = true;
            break;
          }
        }
        if (!found) {
      <#assign noState = false>    
      <#list collObj.attributes as collObjAttr>
        <#if collObjAttr.name == "state">
          ${java.nameVariable(collObj.name)}Service.disable${java.nameType(collObj.name)}(${java.nameType(collObj.name)}QueryAssembler.assemble${java.nameType(collObj.name)}Query(row));
          <#assign noState = true>
          <#break>
        </#if>
      </#list>
      <#if !noState>
          ${java.nameVariable(collObj.name)}Service.delete${java.nameType(collObj.name)}(${java.nameType(collObj.name)}QueryAssembler.assemble${java.nameType(collObj.name)}Query(row));
      </#if>
        }
      }
    </#if>  
      for (${java.nameType(collObj.name)}Query row : ${java.nameVariable(attr.name)}) {  
        row.set${java.nameType(modelbase.get_attribute_sql_name(idAttrs[0]))}(${modelbase.get_attribute_sql_name(idAttrs[0])});
    <#list collObj.attributes as collObjAttr>
      <#if collObjAttr.name == "state">
        row.setState("E");
      </#if>
    </#list>          
    <#if collObj.name == obj.name><#-- 树结构定义的对象，含有children属性的情况 -->
        save${java.nameType(collObj.name)}(row);
    <#else>
        ${java.nameVariable(collObj.name)}Service.save${java.nameType(collObj.name)}(row);
    </#if>    
      }
      <#-- TODO: 当集合对象是值域对象时，它所关联的其他引用对象，也存在【新增】的可能性 -->
  <#else>
    <#-- FIXME: 间接关联 暂时全面废止 --> 
    <#assign conjObj = model.findObjectByName(attr.getLabelledOptions("conjunction")["name"])>
      /*!
      ** 间接关联的【${modelbase.get_object_label(conjObj)}】作为一对多显式扩展对象
      */
      List<${java.nameType(attr.type.componentType.name)}Query> ${java.nameVariable(attr.name)} = query.get${java.nameType(attr.name)}();
      // 删除已有的【${modelbase.get_object_label(conjObj)}】数据
      ${java.nameType(conjObj.name)} ${java.nameVariable(conjObj.name)} = new ${java.nameType(conjObj.name)}();
    <#list conjObj.attributes as conjObjAttr>
      <#if conjObjAttr.type.name == obj.name>
      ${java.nameVariable(conjObj.name)}.set${java.nameType(conjObjAttr.name)}(${varname});  
        <#break>
      </#if>
    </#list>
      // ${java.nameVariable(attr.getLabelledOptions("conjunction")["name"])}DataAccess.disable${java.nameType(conjObj.name)}(${java.nameVariable(conjObj.name)});
      // 创建新的【${modelbase.get_object_label(conjObj)}】数据
      for (${java.nameType(attr.type.componentType.name)}Query row : ${java.nameVariable(attr.name)}) {
        ${java.nameType(conjObj.name)} conj = new ${java.nameType(conjObj.name)}();
    <#list conjObj.attributes as conjObjAttr>
      <#if conjObjAttr.type.name == obj.name>
        conj.set${java.nameType(conjObjAttr.name)}(${varname});
      <#elseif conjObjAttr.type.name == collObj.name>
        <#assign collObjIdAttr = modelbase.get_id_attributes(collObj)[0]>
        ${java.nameType(collObj.name)} conj${java.nameType(collObj.name)} = new ${java.nameType(collObj.name)}();
        conj${java.nameType(collObj.name)}.setId(row.${modelbase4java.name_getter(collObjIdAttr)}());
        conj.set${java.nameType(conjObjAttr.name)}(conj${java.nameType(collObj.name)});
<@modelbase4java.print_object_default_setters obj=conjObj varname="conj" indent=8 />     
        ${java.nameVariable(conjObj.name)}DataAccess.insert${java.nameType(conjObj.name)}(conj); 
      </#if>
    </#list>  
      }
  </#if>  
</#list>
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