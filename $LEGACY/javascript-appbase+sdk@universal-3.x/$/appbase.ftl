
<#macro print_params_required_validations obj indent>
  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable><#continue></#if>
    <#assign nullable = attr.getConstraint().isNullable()>
    <#assign input = attr.getLabelledOptions('properties')['input']!''>
    <#if nullable == true && input != 'parameter'><#continue></#if>
    <#if obj.isLabelled('meta') || obj.isLabelled('pivot')>
${''?left_pad(indent)}if (!data['${attr.getLabelledOptions('properties')['title']}']) {
    <#else>
${''?left_pad(indent)}if (!data.${modelbase.get_attribute_sql_name(attr)}) {
    </#if>
    <#if input == 'parameter'>
${''?left_pad(indent)}  err += "${attr.getLabelledOptions('properties')['title']}参数无值\n";
    <#else>
${''?left_pad(indent)}  err += "${attr.getLabelledOptions('properties')['title']}必须填写\n";
    </#if>
${''?left_pad(indent)}}
  </#list>
</#macro>

<#macro print_params_format_validations obj indent>
  <#list obj.attributes as attr>
    <#assign format = attr.getLabelledOptions('properties')['format']!''>
    <#assign input = attr.getLabelledOptions('properties')['input']!'text'>
    <#if (input == 'text' || input == 'number') && format !=''>
      <#if obj.isLabelled('meta') || obj.isLabelled('pivot')>
${''?left_pad(indent)}if (data["${attr.getLabelledOptions('properties')['title']}"] && /${format}/.test(data["${attr.getLabelledOptions('properties')['title']}"])) {
${''?left_pad(indent)}  err += "${attr.getLabelledOptions('properties')['title']}格式不正确！\n"
${''?left_pad(indent)}}
      <#else>
${''?left_pad(indent)}if (data.${modelbase.get_attribute_sql_name(attr)} && /${format}/.test(data.${modelbase.get_attribute_sql_name(attr)})) {
${''?left_pad(indent)}  err += "${modelbase.get_attribute_label(attr)}格式不正确！\n"
${''?left_pad(indent)}}
      </#if>
    </#if>
  </#list>
</#macro>

<#--!
#### 打印从参数获取值的变量声明。
--->
<#macro print_variant_params_getters obj indent>
  <#list obj.attributes as attr>
    <#if attr.name == 'modifier_id' ||
         attr.name == 'modifier_type' ||
         attr.name == 'last_modified_time' ||
         attr.name == 'state'><#continue></#if>
    <#if printedAttrs[modelbase.get_attribute_sql_name(attr)]??><#continue></#if>
    <#global printedAttrs = printedAttrs + {modelbase.get_attribute_sql_name(attr): attr}>
    <#assign input = attr.getLabelledOptions('properties')['input']!''>
    <#assign dfltval = attr.getLabelledOptions('properties')['default']!''>
    <#if input == 'none' || input == 'constant'><#continue></#if>
    <#if obj.isLabelled('pivot')>
      <#if attr.name?starts_with('pivot_')>
${''?left_pad(indent)}// ${modelbase.get_attribute_label(attr)}
${''?left_pad(indent)}"${attr.getLabelledOptions('properties')['title']}": data["${attr.getLabelledOptions('properties')['title']}"],
      </#if>
    <#elseif obj.isLabelled('meta')>
      <#if attr.name?starts_with('meta_')>
${''?left_pad(indent)}// ${modelbase.get_attribute_label(attr)}
${''?left_pad(indent)}"${attr.getLabelledOptions('properties')['title']}": data["${attr.getLabelledOptions('properties')['title']}"],
      </#if>
    <#elseif input == 'sequence'>
${''?left_pad(indent)}// 需要系统赋值的自增【${modelbase.get_attribute_label(attr)}】
${''?left_pad(indent)}${modelbase.get_attribute_sql_name(attr)}: data.${modelbase.get_attribute_sql_name(attr)},
    <#elseif input == 'parameter'>
${''?left_pad(indent)}// 系统内部传递的【${modelbase.get_attribute_label(attr)}】参数，用户无法修改的
${''?left_pad(indent)}${modelbase.get_attribute_sql_name(attr)}: data.${modelbase.get_attribute_sql_name(attr)},
    <#else>
${''?left_pad(indent)}// ${modelbase.get_attribute_label(attr)}
${''?left_pad(indent)}${modelbase.get_attribute_sql_name(attr)}: data.${modelbase.get_attribute_sql_name(attr)},
    </#if>
  </#list>
</#macro>