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
  </#if>  
</#if>
    hierarchize(retVal.getData(), query);
    return retVal;
  }