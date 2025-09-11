<#import '/$/modelbase.ftl' as modelbase>
<#assign whos = {}>
<#assign whoms = {}>
<#assign whoses = {}>
<#assign whats = {}>
<#assign wheres = {}>
<#assign whiches = {}>
<#assign labels = {}>
<#-- 缓存记录存在@reference的属性 -->
<#assign refAttrs = {}>
<#--
 ### Finds all attributes which are labelled as who, what, whom.
 -->
<#list model.objects as obj>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('whom')>
      <#if attr.type.custom>
        <#assign whoms = whoms + {attr.type.name: []}>
      <#else>
        <#if attr.isLabelled('reference')>
          <#--  <#assign whoms = whoms + {attr.getLabelledOptions('reference')['name']: []}>  -->
          <#assign whoms = whoms + {attr.name: []}>
          <#assign refAttrs = refAttrs + {attr.name: attr}>
        <#else>
          <#assign whoms = whoms + {attr.name: []}>
        </#if>
        <#assign labels = labels + {attr.name: modelbase.get_attribute_label(attr)}>
      </#if>
    <#elseif attr.isLabelled('whose')>
      <#if attr.type.custom>
        <#assign whoses = whoses + {attr.type.name: []}>
      <#else>
        <#if attr.isLabelled('reference')>
          <#assign whoses = whoses + {attr.name: []}>
          <#assign refAttrs = refAttrs + {attr.name: attr}>
        <#else>
          <#assign whoses = whoses + {attr.name: []}>
        </#if>
        <#assign labels = labels + {attr.name: modelbase.get_attribute_label(attr)}>
      </#if>
    <#elseif attr.isLabelled('who')>
      <#if attr.type.custom>
        <#assign whos = whos + {attr.type.name: []}>
      <#else>
        <#if attr.isLabelled('reference')>
          <#--  <#assign whos = whos + {attr.getLabelledOptions('reference')['name']: []}>  -->
          <#assign whos = whos + {attr.name: []}>
          <#assign refAttrs = refAttrs + {attr.name: attr}>
        <#else>
          <#assign whos = whos + {attr.name: []}>
        </#if>
        <#assign labels = labels + {attr.name: modelbase.get_attribute_label(attr)}>
      </#if>
    <#elseif attr.isLabelled('what')>
      <#if attr.type.custom>
        <#assign whats = whats + {attr.type.name: []}>
      <#elseif attr.isLabelled('reference')>
        <#assign whats = whats + {attr.name: []}>
        <#assign refAttrs = refAttrs + {attr.name: attr}>
      <#else>
        <#assign whats = whats + {attr.name: []}>
      </#if>
      <#assign labels = labels + {attr.name: modelbase.get_attribute_label(attr)}>
    <#elseif attr.isLabelled('where')>
      <#if attr.type.custom>
        <#assign wheres = wheres + {attr.type.name: []}>
      <#elseif attr.isLabelled('reference')>
        <#assign wheres = wheres + {attr.name: []}>
        <#assign refAttrs = refAttrs + {attr.name: attr}>
      <#else>
        <#assign wheres = wheres + {attr.name: []}>
      </#if>
      <#assign labels = labels + {attr.name: modelbase.get_attribute_label(attr)}>
    <#elseif attr.isLabelled('which')>
      <#if attr.type.custom>
        <#assign whiches = whiches + {attr.type.name: []}>
      <#elseif attr.isLabelled('reference')>
        <#assign whiches = whiches + {attr.name: []}>
        <#assign refAttrs = refAttrs + {attr.name: attr}>
      <#else>
        <#assign whiches = whiches + {attr.name: []}>
      </#if>
      <#assign labels = labels + {attr.name: modelbase.get_attribute_label(attr)}>
    </#if>
  </#list>
</#list>
<#list whos?keys as name>
  <#assign val = whos[name]>
  <#list model.objects as obj>
    <#list obj.attributes as attr>
      <#if !attr.isLabelled('who') && !attr.isLabelled('what') && !attr.isLabelled('whose') && !attr.isLabelled('whom') && !attr.isLabelled('which') && !attr.isLabelled('where')>
        <#continue>
      </#if>
      <#if attr.type.name == name || attr.name == name>
        <#assign val = val + [obj]>
      </#if>
    </#list>
  </#list>
  <#assign whos = whos + {name: val}>
</#list>
<#list whoses?keys as name>
  <#assign val = whoses[name]>
  <#list model.objects as obj>
    <#list obj.attributes as attr>
      <#if !attr.isLabelled('who') && !attr.isLabelled('what') && !attr.isLabelled('whose') && !attr.isLabelled('whom') && !attr.isLabelled('which') && !attr.isLabelled('where')>
        <#continue>
      </#if>
      <#if attr.type.name == name || attr.name == name>
        <#assign val = val + [obj]>
      </#if>
    </#list>
  </#list>
  <#assign whoses = whoses + {name: val}>
</#list>
<#list whats?keys as name>
  <#assign val = whats[name]>
  <#list model.objects as obj>
    <#list obj.attributes as attr>
      <#if !attr.isLabelled('who') && !attr.isLabelled('what') && !attr.isLabelled('whose') && !attr.isLabelled('whom') && !attr.isLabelled('which') && !attr.isLabelled('where')>
        <#continue>
      </#if>
      <#if attr.type.name == name || attr.name == name>
        <#assign val = val + [obj]>
      </#if>
    </#list>
  </#list>
  <#assign whats = whats + {name: val}>
</#list>
<#list whoms?keys as name>
  <#assign val = whoms[name]>
  <#list model.objects as obj>
    <#list obj.attributes as attr>
      <#if !attr.isLabelled('who') && !attr.isLabelled('what') && !attr.isLabelled('whose') && !attr.isLabelled('whom') && !attr.isLabelled('which') && !attr.isLabelled('where')>
        <#continue>
      </#if>
      <#if attr.type.name == name || attr.name == name>
        <#assign val = val + [obj]>
      </#if>
    </#list>
  </#list>
  <#assign whoms = whoms + {name: val}>
</#list>
<#list wheres?keys as name>
  <#assign val = wheres[name]>
  <#list model.objects as obj>
    <#list obj.attributes as attr>
      <#if !attr.isLabelled('who') && !attr.isLabelled('what') && !attr.isLabelled('whose') && !attr.isLabelled('whom') && !attr.isLabelled('which') && !attr.isLabelled('where')>
        <#continue>
      </#if>
      <#if attr.type.name == name || attr.name == name>
        <#assign val = val + [obj]>
      </#if>
    </#list>
  </#list>
  <#assign wheres = wheres + {name: val}>
</#list>
<#list whiches?keys as name>
  <#assign val = whiches[name]>
  <#list model.objects as obj>
    <#list obj.attributes as attr>
      <#if !attr.isLabelled('who') && !attr.isLabelled('what') && !attr.isLabelled('whose') && !attr.isLabelled('whom') && !attr.isLabelled('which') && !attr.isLabelled('where')>
        <#continue>
      </#if>
      <#if attr.type.name == name || attr.name == name>
        <#assign val = val + [obj]>
      </#if>
    </#list>
  </#list>
  <#assign whiches = whiches + {name: val}>
</#list>
<#list whos?keys as name>
  <#assign objtype = model.findObjectByName(name)!''>
  <#assign refObjs = whos[name]>
  <#assign obj_prefix = name>
  <#if refAttrs[name]??>
    <#assign obj_prefix = refAttrs[name].getLabelledOptions('reference')['name']>
  </#if>
@name(label='${modelbase.get_object_label(objtype)}')
@aggregate
@who
${obj_prefix}_aggregate<

  <#if objtype == ''>
  @root
  ${obj_prefix}: string(64)<#if (refObjs?size > 0)>,</#if>
  <#else>
  @root
  @app(name='${modelbase.get_object_module(objtype)}')
  ${obj_prefix}: &${name}(id)<#if (refObjs?size > 0)>,</#if>
  </#if>
  <#list refObjs as refObj> 

    <#assign refObjAttrId = modelbase.get_id_attributes(refObj)[0]>
    <#if refObjAttrId.type.name == name && refObj.isLabelled('entity')>
  @app(name='${modelbase.get_object_module(refObj)}')
  ${refObj.name}: &${refObj.name}(id)<#if refObj?index != refObjs?size - 1>,</#if>
    <#else>
  @app(name='${modelbase.get_object_module(refObj)}')
  ${modelbase.get_object_plural(refObj)}: &${refObj.name}(id)[]<#if refObj?index != refObjs?size - 1>,</#if>
    </#if>
  </#list>

>

</#list>
<#list whoses?keys as name>
  <#assign objtype = model.findObjectByName(name)!''>
  <#assign refObjs = whoses[name]>
  <#assign obj_prefix = name>
  <#if refAttrs[name]??>
    <#assign obj_prefix = refAttrs[name].getLabelledOptions('reference')['name']>
  </#if>
@name(label='${modelbase.get_object_label(objtype)}')
@aggregate
@who
${obj_prefix}_aggregate<

  <#if objtype == ''>
  @root
  ${obj_prefix}: string(64)<#if (refObjs?size > 0)>,</#if>
  <#else>
  @root
  @app(name='${modelbase.get_object_module(objtype)}')
  ${obj_prefix}: &${name}(id)<#if (refObjs?size > 0)>,</#if>
  </#if>
  <#list refObjs as refObj> 

    <#assign refObjAttrId = modelbase.get_id_attributes(refObj)[0]>
    <#if refObjAttrId.type.name == name && refObj.isLabelled('entity')>
  @app(name='${modelbase.get_object_module(refObj)}')
  ${refObj.name}: &${refObj.name}(id)<#if refObj?index != refObjs?size - 1>,</#if>
    <#else>
  @app(name='${modelbase.get_object_module(refObj)}')
  ${modelbase.get_object_plural(refObj)}: &${refObj.name}(id)[]<#if refObj?index != refObjs?size - 1>,</#if>
    </#if>
  </#list>

>

</#list>
<#list whoms?keys as name>
  <#assign objtype = model.findObjectByName(name)!''>
  <#assign refObjs = whoms[name]>
@name(label='${modelbase.get_object_label(objtype)}')
@aggregate
@who
${name}_aggregate<

  <#if objtype == ''>
  @root
  ${name}: string(64)<#if (refObjs?size > 0)>,</#if>
  <#else>
  @root
  @app(name='${modelbase.get_object_module(objtype)}')
  ${name}: &${name}(id)<#if (refObjs?size > 0)>,</#if>
  </#if>
  <#list refObjs as refObj> 

    <#assign refObjAttrId = modelbase.get_id_attributes(refObj)[0]>
    <#if refObjAttrId.type.name == name>
  @app(name='${modelbase.get_object_module(refObj)}')
  ${refObj.name}: &${refObj.name}(id)<#if refObj?index != refObjs?size - 1>,</#if>
    <#else>
  @app(name='${modelbase.get_object_module(refObj)}')
  ${modelbase.get_object_plural(refObj)}: &${refObj.name}(id)[]<#if refObj?index != refObjs?size - 1>,</#if>
    </#if>
  </#list>

>

</#list>
<#list whats?keys as name>
  <#assign objtype = model.findObjectByName(name)!''>
  <#assign refObjs = whats[name]>
  <#if objtype == ''><#continue></#if>
@name(label='${modelbase.get_object_label(objtype)}')
@aggregate
@what
${name}_aggregate<

  <#if objtype == ''>
  @root
  ${name}: string(64)<#if (refObjs?size > 0)>,</#if>
  <#else>
  @root
  @app(name='${modelbase.get_object_module(objtype)}')
  ${name}: &${name}(id)<#if (refObjs?size > 0)>,</#if>
  </#if>
  <#list refObjs as refObj> 

    <#assign refObjAttrId = modelbase.get_id_attributes(refObj)[0]>
    <#if refObjAttrId.type.name == name>
  @app(name='${modelbase.get_object_module(refObj)}')
  ${refObj.name}: &${refObj.name}(id)<#if refObj?index != refObjs?size - 1>,</#if>
    <#else>
  @app(name='${modelbase.get_object_module(refObj)}')
  ${modelbase.get_object_plural(refObj)}: &${refObj.name}(id)[]<#if refObj?index != refObjs?size - 1>,</#if>
    </#if>
  </#list>
  
>

</#list>
<#list wheres?keys as name>
  <#assign objtype = model.findObjectByName(name)!''>
  <#assign refObjs = wheres[name]>
  <#if objtype == ''><#continue></#if>
@name(label='${modelbase.get_object_label(objtype)}')
@aggregate
@where
${name}_aggregate<

  <#if objtype == ''>
  @root
  ${name}: string(64)<#if (refObjs?size > 0)>,</#if>
  <#else>
  @root
  @app(name='${modelbase.get_object_module(objtype)}')
  ${name}: &${name}(id)<#if (refObjs?size > 0)>,</#if>
  </#if>
  <#list refObjs as refObj> 

    <#assign refObjAttrId = modelbase.get_id_attributes(refObj)[0]>
    <#if refObjAttrId.type.name == name>
  @app(name='${modelbase.get_object_module(refObj)}')
  ${refObj.name}: &${refObj.name}(id)<#if refObj?index != refObjs?size - 1>,</#if>
    <#else>
  @app(name='${modelbase.get_object_module(refObj)}')
  ${modelbase.get_object_plural(refObj)}: &${refObj.name}(id)[]<#if refObj?index != refObjs?size - 1>,</#if>
    </#if>
  </#list>
  
>

</#list>