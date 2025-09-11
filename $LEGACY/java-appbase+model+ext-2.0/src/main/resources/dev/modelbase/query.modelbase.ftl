<#import '/$/modelbase.ftl' as modelbase>
<#assign expressionParsers = statics['com.doublegsoft.apiml.ModelExpressionParsers']>
<#-- explicit query -->
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#if !obj.isLabelled('queries')><#continue></#if>
  <#list obj.getLabelledOptions('queries')?keys as queryName>
    <#assign expressionParser = expressionParsers.newCQRSAPIModelExpressionParser(obj)>
    <#assign apiModel = expressionParser.parse(obj.getLabelledOptions('queries')[queryName], model)>
    <#assign queryAttrs = apiModel.getAttributes()>
@name(label='${modelbase.get_object_label(obj)}${queryName}查询条件')
@query
${apiModel.name}_query<
    <#list queryAttrs as attr>
      <#if !attr??><#continue></#if>

  @name(label='${modelbase.get_attribute_label(attr)}')
  @persistence(name='${attr.persistenceName}', query='=')
  ${attr.name}: ${attr.type.name}<#if attr?index != queryAttrs?size - 1>,</#if>
    </#list>
>

  </#list>
</#list>
<#-- implicit query -->
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#if !obj.isLabelled('entity')><#continue></#if>
  <#assign queryAttrs = []>
  <#list obj.attributes as attr>
    <#assign query = attr.getLabelledOptions('persistence')['query']!>
    <#if query == ''><#continue></#if>
    <#assign expressionParser = expressionParsers.newCQRSQueryExprModelExpressionParser(attr)>
    <#assign apiModel = expressionParser.parse(query, model)>
    <#assign comparators = apiModel.listComparators()>
    <#list comparators as comparator>
      <#assign queryAttrs = queryAttrs + [{'comparator': comparator, 'attribute': apiModel.getAttribute(comparator), 'alias': apiModel.getAttribute(comparator).name}]>
    </#list>
  </#list>
  <#if queryAttrs?size == 0><#continue></#if>
@name(label='${modelbase.get_object_label(obj)}查询条件对象')
@query(sqlId='${obj.persistenceName?lower_case}.query')
${obj.name}_query<
  <#list queryAttrs as queryAttr>
    <#if queryAttr.attribute.class.simpleName == 'AttributeGroupDefinition'>
      <#-- AttributeGroupDefinition -->
      <#assign attrGroup = queryAttr.attribute>
  @name(label='${modelbase.get_attribute_label(attrGroup.attributes[0])}')
  @persistence(name='${attrGroup.attributes[0].persistenceName}', query='${queryAttr.comparator}')
  ${attrGroup.attributes[0].name}: ${attrGroup.attributes[0].type.name}<#if queryAttr?index != queryAttrs?size - 1>,</#if>
  
      <#continue>
    </#if>
    <#if queryAttr.attribute.type.collection>
      <#assign customType = queryAttr.attribute.type.componentType>
      <#assign customTypeIdAttrs = modelbase.get_id_attributes(customType.objectDefinition)>
  @name(label='${modelbase.get_attribute_label(queryAttr.attribute)}')
  @persistence(name='${customTypeIdAttrs[0].persistenceName}', query='${queryAttr.attribute.getLabelledOptions('persistence')['query']!'='}')
  ${queryAttr.attribute.name}_${customTypeIdAttrs[0].name}: ${customTypeIdAttrs[0].type.name}[]<#if queryAttr?index != queryAttrs?size - 1>,</#if>
    <#elseif queryAttr.attribute.type.custom>
      <#assign customType = queryAttr.attribute.type>
      <#assign customTypeIdAttrs = modelbase.get_id_attributes(customType.objectDefinition)>
  @name(label='${modelbase.get_attribute_label(queryAttr.attribute)}')
  @persistence(name='${queryAttr.attribute.persistenceName}', query='${queryAttr.comparator}')
      <#if queryAttr.comparator == '[]'>
  ${queryAttr.alias}: ${customTypeIdAttrs[0].type.name}[]<#if queryAttr?index != queryAttrs?size - 1>,</#if>
      <#else>
  ${queryAttr.attribute.name}_${customTypeIdAttrs[0].name}: ${customTypeIdAttrs[0].type.name}<#if queryAttr?index != queryAttrs?size - 1>,</#if>
      </#if>
    <#else>
  @name(label='${modelbase.get_attribute_label(queryAttr.attribute)}')
  @persistence(name='${queryAttr.attribute.persistenceName}', query='${queryAttr.comparator}')
  ${queryAttr.alias}: ${queryAttr.attribute.type.name}<#if queryAttr.comparator == '[]'>[]</#if><#if queryAttr?index != queryAttrs?size - 1>,</#if>
    </#if>

  </#list>
>

</#list>
@name(label='占位查询定义')
@query
@placeholder
placeholder_query<
>
