<#--
 ### 完整对象的查找：
 ###
 ###
 -->
  /**
   * 查找多个【${modelbase.get_object_label(obj)}】对象。
   */
  @Override
  public Pagination<${typename}Query> find${inflector.pluralize(typename)}(${typename}Query query) throws ServiceException {
    Pagination<${typename}Query> retVal = new Pagination<>();
    List<Map<String,Object>> results;
    long total = 0;
<#if obj.persistenceName??>
<@modelbase4java.print_object_persistence_find obj=obj indent=4 />
<#elseif obj.isLabelled("pivot")>
  <#assign detailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
  <#if obj.getLabelledOptions("pivot")["master"]??>
    <#assign masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    ${java.nameType(masterObj.name)}Query ${java.nameVariable(masterObj.name)}Query = new ${java.nameType(masterObj.name)}Query();
<@modelbase4java.print_object_persistence_find obj=masterObj indent=4 proxy=obj />
  <#else>
    ${java.nameType(detailObj.name)}Query ${java.nameVariable(detailObj.name)}Query = new ${java.nameType(detailObj.name)}Query();
    ${java.nameVariable(detailObj.name)}Query.setLimit(query.getLimit());
    ${java.nameVariable(detailObj.name)}Query.setStart(query.getStart());
    <#list idAttrs as idAttr>
    ${java.nameVariable(detailObj.name)}Query.getColumnList().add("${modelbase.get_attribute_sql_name(idAttr)}");
    </#list>
    results = ${java.nameVariable(detailObj.name)}DataAccess.selectDistinctOf${java.nameType(detailObj.name)}(${java.nameVariable(detailObj.name)}Query);
    for (Map<String,Object> result : results) {
    <#list idAttrs as idAttr>  
      ${modelbase4java.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)} = (${modelbase4java.type_attribute_primitive(idAttr)}) result.get("${modelbase.get_attribute_sql_name(idAttr)}");
      ${java.nameVariable(detailObj.name)}Query.add${java.nameType(idAttr.name)}(${modelbase.get_attribute_sql_name(idAttr)});
    </#list>  
    }
    results = ${java.nameVariable(detailObj.name)}DataAccess.select${java.nameType(detailObj.name)}(${java.nameVariable(detailObj.name)}Query);
    List<List<Map<String,Object>>> groups = Datasets.group(results<#list idAttrs as idAttr><#if idAttrs?size != 0>, </#if>"${modelbase.get_attribute_sql_name(idAttr)}"</#list>);
    for (List<Map<String,Object>> group : groups) {
      ${typename}Query q = new ${typename}Query();
      assemble${typename}Query(q, group);
      retVal.getData().add(q);
    }
    retVal.setTotal(retVal.getData().size());
  </#if>  
</#if>
    hierarchize(retVal.getData(), query);
    return retVal;
  }
  
  @Override
  public ${typename}Query get${typename}(${typename}Query query) throws ServiceException {
    Pagination<${typename}Query> page = find${inflector.pluralize(typename)}(query);
    if (page.getTotal() == 0) {
      return null;
    }
    return page.getData().get(0);
  }
  