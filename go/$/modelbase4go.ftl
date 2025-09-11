<#macro print_object_query_members obj processedAttrs>
  <#list obj.attributes as attr>
    <#if processedAttrs[modelbase.get_attribute_sql_name(attr)]??><#continue></#if>
    <#if attr.type.collection>
    
  /*!
  ** 【${modelbase.get_attribute_label(attr)}】
  */
  ${go.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))}  []*${java.nameType(attr.type.componentType.name)}Query
    <#else>
  
  /*!
  ** 【${modelbase.get_attribute_label(attr)}】
  */
  ${go.nameType(modelbase.get_attribute_sql_name(attr))}   *${modelbase4go.type_attribute_primitive(attr)}
  ${go.nameType(modelbase.get_attribute_sql_name(attr))}0  *${modelbase4go.type_attribute_primitive(attr)}
  ${go.nameType(modelbase.get_attribute_sql_name(attr))}1  *${modelbase4go.type_attribute_primitive(attr)}
    </#if>
    <#-- 需要集合属性作为查询条件的 -->
    <#if attr.constraint.identifiable ||
         attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum")> 
  ${go.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))} []${modelbase4go.type_attribute_primitive(attr)}
    </#if>
    <#-- 引用对象需要作为结果的 -->
    <#if attr.type.custom>
  ${go.nameType(attr.name)} *${java.nameType(attr.type.name)}Query       
    </#if>
    <#if attr.type.name == "string" && !attr.type.custom && !attr.identifiable>
  ${go.nameType(modelbase.get_attribute_sql_name(attr))}2  *${modelbase4go.type_attribute_primitive(attr)}
    </#if>
    <#local processedAttrs += {modelbase.get_attribute_sql_name(attr):attr}>
  </#list>
  <#if modelbase.get_id_attributes(obj)?size != 1><#return></#if>
  <#list obj.attributes as attr>
    <#if attr.type.custom && attr.constraint.identifiable>
      <#local refObj = model.findObjectByName(attr.type.name)>
<@print_object_query_members obj=refObj processedAttrs=processedAttrs />    
    </#if>
  </#list>  
  <#-- REFERENCE -->
  <#list obj.attributes as attr>
    <#if attr.isLabelled("reference") && attr.getLabelledOptions("reference")["value"] == "id">
      <#assign referenceName = attr.getLabelledOptions("reference")["name"]>
      <#if processedAttrs[modelbase.get_attribute_sql_name(attr)]??><#continue></#if>
      <#local processedAttrs += {attr.name:attr}>
    </#if>
  </#list>
</#macro>

<#macro print_object_query_to_map obj processedAttrs>
  <#list obj.attributes as attr>
    <#if processedAttrs[attr.name]??><#continue></#if>
    <#if attr.type.collection>
  if self.${go.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))} != nil && len(self.${go.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))}) > 0 {
    // retVal.put("${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}", ${inflector.pluralize(modelbase.get_attribute_sql_name(attr))});
  }
    <#else>
  if self.${go.nameType(modelbase.get_attribute_sql_name(attr))} != nil {
    ret["${go.nameType(modelbase.get_attribute_sql_name(attr))}"] = self.${go.nameType(modelbase.get_attribute_sql_name(attr))}
  }
  if self.${go.nameType(modelbase.get_attribute_sql_name(attr))}0 != nil {
    ret["${go.nameType(modelbase.get_attribute_sql_name(attr))}0"] = self.${go.nameType(modelbase.get_attribute_sql_name(attr))}0
  }
  if self.${go.nameType(modelbase.get_attribute_sql_name(attr))}1 != nil {
    ret["${go.nameType(modelbase.get_attribute_sql_name(attr))}1"] = self.${go.nameType(modelbase.get_attribute_sql_name(attr))}1
  }
    </#if>
    <#if attr.constraint.identifiable ||
         attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum")>
  if self.${go.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))} != nil && len(self.${go.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))}) > 0 {
    ret["${go.nameType(modelbase.get_attribute_sql_name(attr))}"] = self.${go.nameType(modelbase.get_attribute_sql_name(attr))}
  }
    </#if>
    <#if attr.type.name == "string" && !attr.type.custom && !attr.identifiable>  
  if self.${go.nameType(modelbase.get_attribute_sql_name(attr))}2 != nil {
    ret["${go.nameType(modelbase.get_attribute_sql_name(attr))}2"] = self.${go.nameType(modelbase.get_attribute_sql_name(attr))}2
  }
    </#if>    
    <#local processedAttrs += {attr.name:attr}>
  </#list>  
  <#if modelbase.get_id_attributes(obj)?size != 1><#return></#if>
  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable && attr.type.custom>
      <#local refObj = model.findObjectByName(attr.type.name)> 
<@print_object_query_to_map obj=refObj processedAttrs=processedAttrs /> 
    <#elseif attr.type.custom>
  if self.${go.nameType(attr.name)} != nil {
    ret["${go.nameType(modelbase.get_attribute_sql_name(attr))}"] = self.${go.nameType(attr.name)}.to();
  }
    </#if>
  </#list>
</#macro>

<#macro print_object_query_from_map obj processedAttrs>
  <#list obj.attributes as attr>
    <#if processedAttrs[attr.name]??><#continue></#if>
    <#if attr.type.collection>
  if ok {
    if self.${go.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))} == nil {
      self.${go.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))} = make([]*${go.nameType(attr.type.componentType.name)}Query, 0)
    }
  }
    <#else>
  ${modelbase.get_attribute_sql_name(attr)}, ok := data["${modelbase.get_attribute_sql_name(attr)}"]
  if ok {
    if self.${go.nameType(modelbase.get_attribute_sql_name(attr))} == nil {
      self.${go.nameType(modelbase.get_attribute_sql_name(attr))} = new(${modelbase4go.type_attribute_primitive(attr)})
    }
    *(self.${go.nameType(modelbase.get_attribute_sql_name(attr))}) = ${modelbase.get_attribute_sql_name(attr)}.(${modelbase4go.type_attribute_primitive(attr)})
  } 
  ${modelbase.get_attribute_sql_name(attr)}0, ok := data["${modelbase.get_attribute_sql_name(attr)}0"]
  if ok {
    if self.${go.nameType(modelbase.get_attribute_sql_name(attr))}0 == nil {
      self.${go.nameType(modelbase.get_attribute_sql_name(attr))}0 = new(${modelbase4go.type_attribute_primitive(attr)})
    }
    *(self.${go.nameType(modelbase.get_attribute_sql_name(attr))}0) = ${modelbase.get_attribute_sql_name(attr)}0.(${modelbase4go.type_attribute_primitive(attr)})
  } 
  ${modelbase.get_attribute_sql_name(attr)}1, ok := data["${modelbase.get_attribute_sql_name(attr)}1"]
  if ok {
    if self.${go.nameType(modelbase.get_attribute_sql_name(attr))}1 == nil {
      self.${go.nameType(modelbase.get_attribute_sql_name(attr))}1 = new(${modelbase4go.type_attribute_primitive(attr)})
    }
    *(self.${go.nameType(modelbase.get_attribute_sql_name(attr))}1) = ${modelbase.get_attribute_sql_name(attr)}1.(${modelbase4go.type_attribute_primitive(attr)})
  } 
    </#if>
    <#if attr.constraint.identifiable ||
         attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum")>
  ${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}, ok := data["${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}"]
  if ok {       
    for i := 0; i < len(${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}.([]${modelbase4go.type_attribute_primitive(attr)})); i++ {
      self.${go.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))} = append(self.${go.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))}, ${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}.([]${modelbase4go.type_attribute_primitive(attr)})[i])
    }
  }
    </#if>
    <#if attr.type.name == "string" && !attr.type.custom && !attr.identifiable>  
  ${modelbase.get_attribute_sql_name(attr)}2, ok := data["${modelbase.get_attribute_sql_name(attr)}2"]
  if ok {
    if self.${go.nameType(modelbase.get_attribute_sql_name(attr))}2 == nil {
      self.${go.nameType(modelbase.get_attribute_sql_name(attr))}2 = new(${modelbase4go.type_attribute_primitive(attr)})
    }
    *(self.${go.nameType(modelbase.get_attribute_sql_name(attr))}2) = ${modelbase.get_attribute_sql_name(attr)}2.(${modelbase4go.type_attribute_primitive(attr)})
  } 
    </#if>    
    <#local processedAttrs += {attr.name:attr}>
  </#list>  
  <#if modelbase.get_id_attributes(obj)?size != 1><#return></#if>
  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable && attr.type.custom>
      <#local refObj = model.findObjectByName(attr.type.name)> 
<@print_object_query_to_map obj=refObj processedAttrs=processedAttrs /> 
    <#elseif attr.type.custom>
  ${go.nameVariable(attr.name)}, ok := data["${go.nameVariable(attr.name)}"]  
  if ok {  
    p := new(${go.nameType(attr.type.name)}Query)
    p.from(${go.nameVariable(attr.name)}.(map[string]interface{}))
    self.${go.nameType(attr.name)} = p
  }
    </#if>
  </#list>
</#macro>

<#function type_attribute_primitive attr>
  <#local type = attr.type>
  <#if type.custom>
    <#local refObj = model.findObjectByName(type.name)>
    <#assign refObjIdAttrs = modelbase.get_id_attributes(refObj)>
    <#if refObj.isLabelled("generated")>
      <#return type_attribute_primitive(refObjIdAttrs[0])>
    <#else>
      <#return type_attribute_primitive(refObjIdAttrs[0])>
    </#if>
  <#elseif attr.constraint.domainType.name == "id">
    <#return "int64">  
  <#elseif type.collection>
    <#assign collObj = model.findObjectByName(type.componentType.name)>
    <#return "[]" + go.nameType(type.componentType.name)>  
  <#elseif type.name == 'int' || type.name == 'integer'>
    <#return "int32">    
  <#elseif type.name == 'long'>
     <#return "int64">    
  <#elseif type.name == 'number'>
    <#return "float64">  
  <#elseif type.name == 'date' || type.name == 'datetime' || type.name == 'time'>  
    <#return "time.Time">
  <#else>
    <#return "string">
  </#if>
</#function>

<#function name_attribute attr>
  <#if attr.type.custom>
    <#return attr.name>  
  </#if>
  <#return go.nameVariable(modelbase.get_attribute_sql_name(attr))>
</#function>