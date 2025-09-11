<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/appbase.ftl" as appbase>
<#-- 主对象，mapping模式 -->
<#assign master = ''>
<#-- 从对象，mapping模式 -->
<#assign slaves = []>
<#-- 多对一模式 -->
<#assign manys = []>
<#-- 扩展模式 -->
<#assign meta = ''>
<#-- 行列转换模式 -->
<#assign pivot = ''>

<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#if obj.isLabelled('master')>
    <#assign master = obj>
  <#elseif obj.isLabelled('slave')>
    <#assign slaves = slaves + [obj]>
  <#elseif obj.isLabelled('pivot')>
    <#assign pivot = obj>
  <#elseif obj.isLabelled('meta')>
    <#assign meta = obj>
  <#elseif obj.isLabelled('many')>
    <#assign manys = manys + [obj]>
  </#if>
</#list>
<#assign masterIds = []>
<#list master.attributes as attr>
  <#assign input = attr.getLabelledOptions('properties')['input']!''>
  <#if input == 'id'>
    <#assign masterIds = masterIds + [attr]>
  </#if>
</#list>

<#global printedAttrs = {}>
<#assign existings = {}>
<#assign uri = main.uri!master.name>
<#assign action = uri?substring(uri?last_index_of("/") + 1)>
<#assign module = uri?substring(0, uri?index_of("/"))>
<#assign objname = uri?substring(uri?index_of("/") + 1)>
${module}.find${js.nameType(objname)} = async function (params) {
  // 客户端验证（必填项、有效性）
  let err = '';
<#list master.attributes as attr>
  <#if attr.getLabelledOptions('properties')['input'] == 'parameter'>
  if (!params.${modelbase.get_attribute_sql_name(attr)}) {
    err += "${attr.getLabelledOptions('properties')['title']}参数无值\n";
  }
  </#if>
</#list>
  if (err != '') throw err;
  let ret = await xhr.promise({
    url: '/api/v3/common/script/${main.uri!'TODO'}',
    params: {
<#list master.attributes as attr>
  <#if attr.getLabelledOptions('properties')['input'] == 'parameter'>
      ${modelbase.get_attribute_sql_name(attr)}: params.${modelbase.get_attribute_sql_name(attr)},
  </#if>
</#list>
      // 系统参数：修改者标识
      modifierId: window.user.userId,
    },
  });
  return ret;
};
