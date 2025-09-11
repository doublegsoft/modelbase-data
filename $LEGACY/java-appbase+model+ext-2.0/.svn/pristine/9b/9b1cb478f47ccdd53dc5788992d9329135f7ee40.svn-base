<#import '/$/modelbase.ftl' as modelbase>
<#assign expressionParsers = statics['com.doublegsoft.apiml.ModelExpressionParsers']>
<#-- explicit query -->
<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#if !obj.isLabelled('commands')><#continue></#if>
  <#list obj.getLabelledOptions('commands')?keys as commandName>
    <#assign expressionParser = expressionParsers.newCQRSAPIModelExpressionParser(obj)>
    <#assign apiModel = expressionParser.parse(obj.getLabelledOptions('commands')[commandName], model)>
    <#assign commandAttrs = apiModel.getAttributes()>
@name(label='${modelbase.get_object_label(obj)}${commandName}指令')
@command(event='${apiModel.event}')
${apiModel.name}_command<
    <#list commandAttrs as attr>
      <#if !attr??><#continue></#if>

  @name(label='${modelbase.get_attribute_label(attr)}')
  @persistence(name='${attr.persistenceName}')
  ${attr.name}: ${attr.type.name}<#if attr?index != commandAttrs?size - 1>,</#if>
    </#list>
>

  </#list>
</#list>