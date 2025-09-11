<#--
 ###############################################################################
 ### 测试数据
 ###############################################################################
 -->
<#function get_attribute_value attr> 
  <#if attr.name == 'name'>
    <#return tatabase.string(4)>
  <#elseif attr.constraint.identifiable>
    <#assign id = UUID.randomUUID()?string?upper_case>
    <#return id>  
  <#elseif attr.type?starts_with('enum')>
    <#return tatabase.enumcode("enum" + widget.options["values"])>
  <#--  
  <#elseif (widget.id!"unknown") == "id_card_number">
${""?left_pad(indent)}'${js.nameVariable(widget.id!"unknown")}': '${tatabase.random("id_card_number", "")}',   
  <#elseif (widget.id!"unknown") == "avatar">
${""?left_pad(indent)}'${js.nameVariable(widget.id!"unknown")}': '',   
  <#elseif (widget.type!"unknown") == "image">
${""?left_pad(indent)}'${js.nameVariable(widget.id!"unknown")}': '',   
  <#elseif (widget.type!"unknown") == "mobile">  
${""?left_pad(indent)}'${js.nameVariable(widget.id!"unknown")}': '${tatabase.random("mobile", "")}',    
  <#elseif (widget.type!"unknown") == "email">  
${""?left_pad(indent)}'${js.nameVariable(widget.id!"unknown")}': '${tatabase.random("user", "")}@${tatabase.random("domain", "")}',     
  -->
  <#elseif attr.type.name == "string" && (attr.type.length > 100)>
    <#return tatabase.value("note")> 
  <#elseif attr.type.name == "number">  
    <#return tatabase.number(1, 100)>
  <#elseif attr.type.name == "date">  
    <#return tatabase.date()>
  <#elseif attr.type == "datetime">  
    <#return tatabase.date()>  
  <#else>
    <#return tatabase.string(8)>
  </#if>
</#function>

<#function test_unit_value attr> 
  <#if attr.name == 'name'>
    <#return "'" + tatabase.string(4) + "'">
  <#elseif attr.isLabelled("listable") && (attr.getLabelledOptions("listable")["level"]!"") == "image">
    <#local val = tatabase.number(1,33)>
    <#local val = val?substring(0, val?index_of("."))>
    <#return "'https://gitee.com/christiangann/tatabase-image/raw/main/1024x768/" + val?number?string["0000"] + ".jpg'">  
  <#elseif attr.constraint.domainType.name == "id">  
    <#local val = tatabase.number(0,100)>
    <#local val = val?substring(0, val?index_of("."))>
    <#return val>
  <#elseif attr.type.custom>
    <#local refObj = model.findObjectByName(attr.type.name)>
    <#local refObjIdAttr = modelbase.get_id_attributes(refObj)[0]>
    <#return get_attribute_value_as_code(refObjIdAttr)>  
  <#elseif attr.constraint.identifiable && attr.type.name == "string">
    <#assign UUID = statics['java.util.UUID']>
    <#assign id = UUID.randomUUID()?string?upper_case>
    <#return "'" + id + "'">    
  <#elseif attr.type.name?starts_with('enum')>
    <#return "'" + tatabase.enumcode("enum" + widget.options["values"]) + "'">
  <#elseif attr.type.name == "string" && (attr.type.length > 100)>
    <#return "'" + tatabase.value("note") + "'"> 
  <#elseif attr.type.name == "number">  
    <#return tatabase.number(1, 100)>
  <#elseif attr.type.name == "int" || attr.type.name == 'integer'>  
    <#return tatabase.number(1, 100) + ".toInt()">  
  <#elseif attr.type.name == "date">  
    <#return "DateFormat('yyyy-MM-dd HH:mm:ss').parse('" + tatabase.datetime() + "')">
  <#elseif attr.type.name == "datetime">  
    <#return "DateFormat('yyyy-MM-dd HH:mm:ss').parse('" + tatabase.datetime() + "')">  
  <#elseif attr.type.name == "lmt">  
    <#return 'DateTime.now()'>  
  <#else>
    <#return "'" + tatabase.string(8) + "'">
  </#if>
</#function>

<#function get_attribute_value_as_code attr> 
  <#if attr.name == 'name'>
    <#return "'" + tatabase.string(4) + "'">
  <#elseif attr.constraint.domainType.name == "id">  
    <#local val = tatabase.number(0,100)>
    <#local val = val?substring(0, val?index_of("."))>
    <#return val>
  <#elseif attr.type.custom>
    <#local refObj = model.findObjectByName(attr.type.name)>
    <#local refObjIdAttr = modelbase.get_id_attributes(refObj)[0]>
    <#return get_attribute_value_as_code(refObjIdAttr)>  
  <#elseif attr.constraint.identifiable && attr.type.name == "string">
    <#assign UUID = statics['java.util.UUID']>
    <#assign id = UUID.randomUUID()?string?upper_case>
    <#return "'" + id + "'">    
  <#elseif attr.type.name?starts_with('enum')>
    <#return "'" + tatabase.enumcode("enum" + widget.options["values"]) + "'">
  <#elseif attr.type.name == "string" && (attr.type.length > 100)>
    <#return "'" + tatabase.value("note") + "'"> 
  <#elseif attr.type.name == "number">  
    <#return tatabase.number(1, 100)>
  <#elseif attr.type.name == "int" || attr.type.name == 'integer'>  
    <#return tatabase.number(1, 100) + ".toInt()">  
  <#elseif attr.type.name == "date">  
    <#return "DateFormat('yyyy-MM-dd HH:mm:ss').parse('" + tatabase.datetime() + "')">
  <#elseif attr.type.name == "datetime">  
    <#return "DateFormat('yyyy-MM-dd HH:mm:ss').parse('" + tatabase.datetime() + "')">  
  <#elseif attr.type.name == "lmt">  
    <#return 'DateTime.now()'>  
  <#else>
    <#return "'" + tatabase.string(8) + "'">
  </#if>
</#function>

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
    <#return "int">  
  <#elseif type.collection>
    <#return "List<" + get_native_type_name(type.componentType) + ">">  
  <#elseif type.name == 'int' || type.name == 'integer'>
    <#return "int">    
  <#elseif type.name == 'long'>
     <#return "int">    
  <#elseif type.name == 'number'>
    <#return "double">  
  <#elseif type.name == 'date' || type.name == 'datetime' || type.name == 'time'>  
    <#return "DateTime">
  <#else>
    <#return "String">
  </#if>
</#function>

<#function get_native_type_name type>
  <#if type.custom>
    <#local refObj = model.findObjectByName(type.name)>
    <#assign refObjIdAttrs = modelbase.get_id_attributes(refObj)>
    <#if refObj.isLabelled("generated")>
      <#return type_attribute_primitive(refObjIdAttrs[0])>
    <#else>
      <#return dart.nameType(type.name)>
    </#if>  
  <#elseif type.collection>
    <#return "List<" + get_native_type_name(type.componentType) + ">">  
  <#elseif type.name == 'int' || type.name == 'integer'>
    <#return "int">    
  <#elseif type.name == 'long'>
     <#return "int">    
  <#elseif type.name == 'number'>
    <#return "double">  
  <#elseif type.name == 'date' || type.name == 'datetime' || type.name == 'time'>  
    <#return "DateTime">
  <#else>
    <#return "String">
  </#if>
</#function>

<#-- Query对象类成员 -->
<#macro print_object_query_members obj processedAttrs>
  <#list obj.attributes as attr>
    <#if processedAttrs[modelbase.get_attribute_sql_name(attr)]??><#continue></#if>
    <#if attr.type.collection>
    
  /*!
  ** 【${modelbase.get_attribute_label(attr)}】
  */
  final List<${java.nameType(attr.type.componentType.name)}Query> ${inflector.pluralize(modelbase.get_attribute_sql_name(attr))} = [];
    <#else>
  
  /*!
  ** 【${modelbase.get_attribute_label(attr)}】
  */
  ${type_attribute_primitive(attr)}? ${modelbase.get_attribute_sql_name(attr)};
  
  ${type_attribute_primitive(attr)}? ${modelbase.get_attribute_sql_name(attr)}0;
  
  ${type_attribute_primitive(attr)}? ${modelbase.get_attribute_sql_name(attr)}1;
    </#if>
    <#if attr.constraint.identifiable ||
         attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum")>
       
  final List<${type_attribute_primitive(attr)}> ${inflector.pluralize(modelbase.get_attribute_sql_name(attr))} = [];
    </#if>
    <#-- 引用对象需要作为结果的 -->
    <#if attr.type.custom>
    
  ${java.nameType(attr.type.name)}Query? ${dart.nameVariable(attr.name)};  
    </#if>
    <#if attr.type.name == "string" && !attr.type.custom && !attr.identifiable>
  
  ${type_attribute_primitive(attr)}? ${modelbase.get_attribute_sql_name(attr)}2;
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
</#macro>

<#macro print_object_query_init obj processedAttrs>
  <#list obj.attributes as attr>
    <#if processedAttrs[modelbase.get_attribute_sql_name(attr)]??><#continue></#if>
    <#if attr.type.collection>
    <#else>
    this.${modelbase.get_attribute_sql_name(attr)},
    this.${modelbase.get_attribute_sql_name(attr)}0,
    this.${modelbase.get_attribute_sql_name(attr)}1,
    </#if>
    <#if attr.constraint.identifiable ||
         attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum")>
    </#if>
    <#-- 引用对象需要作为结果的 -->
    <#if attr.type.custom>
    this.${dart.nameVariable(attr.name)},
    </#if>
    <#if attr.type.name == "string" && !attr.type.custom && !attr.identifiable>
    this.${modelbase.get_attribute_sql_name(attr)}2,
    </#if>
    <#local processedAttrs += {modelbase.get_attribute_sql_name(attr):attr}>
  </#list>
  <#if modelbase.get_id_attributes(obj)?size != 1><#return></#if>
  <#list obj.attributes as attr>
    <#if attr.type.custom && attr.constraint.identifiable>
      <#local refObj = model.findObjectByName(attr.type.name)>
<@print_object_query_init obj=refObj processedAttrs=processedAttrs />    
    </#if>
  </#list>  
</#macro>

<#macro print_object_query_equal obj processedAttrs>
  <#list obj.attributes as attr>
    <#if processedAttrs[modelbase.get_attribute_sql_name(attr)]??><#continue></#if>
    <#if attr.type.collection>
    <#else>
      <#if attr.type.name == 'date' || attr.type.name == 'datetime'>  
    if (${modelbase.get_attribute_sql_name(attr)} == null && other.${modelbase.get_attribute_sql_name(attr)} != null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)} != null && other.${modelbase.get_attribute_sql_name(attr)} == null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)} != null && other.${modelbase.get_attribute_sql_name(attr)} != null && !${modelbase.get_attribute_sql_name(attr)}!.isAtSameMomentAs(other.${modelbase.get_attribute_sql_name(attr)}!)) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)}0 == null && other.${modelbase.get_attribute_sql_name(attr)}0 != null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)}0 != null && other.${modelbase.get_attribute_sql_name(attr)}0 == null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)}0 != null && other.${modelbase.get_attribute_sql_name(attr)}0 != null && !${modelbase.get_attribute_sql_name(attr)}0!.isAtSameMomentAs(other.${modelbase.get_attribute_sql_name(attr)}0!)) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)}1 == null && other.${modelbase.get_attribute_sql_name(attr)}1 != null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)}1 != null && other.${modelbase.get_attribute_sql_name(attr)}1 == null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)}1 != null && other.${modelbase.get_attribute_sql_name(attr)}1 != null && !${modelbase.get_attribute_sql_name(attr)}1!.isAtSameMomentAs(other.${modelbase.get_attribute_sql_name(attr)}1!)) {
      return false;
    }
      <#else>
    if (${modelbase.get_attribute_sql_name(attr)} == null && other.${modelbase.get_attribute_sql_name(attr)} != null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)} != null && other.${modelbase.get_attribute_sql_name(attr)} == null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)} != other.${modelbase.get_attribute_sql_name(attr)}) {
      return false;
    }   
    if (${modelbase.get_attribute_sql_name(attr)}0 == null && other.${modelbase.get_attribute_sql_name(attr)}0 != null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)}0 != null && other.${modelbase.get_attribute_sql_name(attr)}0 == null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)}0 != other.${modelbase.get_attribute_sql_name(attr)}0) {
      return false;
    }   
    if (${modelbase.get_attribute_sql_name(attr)}1 == null && other.${modelbase.get_attribute_sql_name(attr)}1 != null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)}1 != null && other.${modelbase.get_attribute_sql_name(attr)}1 == null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)}1 != other.${modelbase.get_attribute_sql_name(attr)}1) {
      return false;
    }   
      </#if>
      <#if attr.type.name == "string" && !attr.identifiable>
    if (${modelbase.get_attribute_sql_name(attr)}2 == null && other.${modelbase.get_attribute_sql_name(attr)}2 != null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)}2 != null && other.${modelbase.get_attribute_sql_name(attr)}2 == null) {
      return false;
    }
    if (${modelbase.get_attribute_sql_name(attr)}2 != other.${modelbase.get_attribute_sql_name(attr)}2) {
      return false;
    }     
      </#if>  
    </#if>
    <#local processedAttrs += {modelbase.get_attribute_sql_name(attr):attr}>
  </#list>
  <#if modelbase.get_id_attributes(obj)?size != 1><#return></#if>
  <#list obj.attributes as attr>
    <#if attr.type.custom && attr.constraint.identifiable>
      <#local refObj = model.findObjectByName(attr.type.name)>
<@print_object_query_equal obj=refObj processedAttrs=processedAttrs />    
    </#if>
  </#list>  
</#macro>

<#macro print_object_query_from obj processedAttrs>
  <#list obj.attributes as attr>
    <#if processedAttrs[modelbase.get_attribute_sql_name(attr)]??><#continue></#if>
    <#if attr.type.collection>
    <#else>
      <#if attr.type.name == 'date' || attr.type.name == 'datetime' || attr.type.name == 'time'>  
    if (map['${modelbase.get_attribute_sql_name(attr)}'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)} = Safe.safeDateTime(map['${modelbase.get_attribute_sql_name(attr)}']);
    }
    if (map['${modelbase.get_attribute_sql_name(attr)}0'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)}0 = Safe.safeDateTime(map['${modelbase.get_attribute_sql_name(attr)}0']);
    }
    if (map['${modelbase.get_attribute_sql_name(attr)}1'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)}1 = Safe.safeDateTime(map['${modelbase.get_attribute_sql_name(attr)}1']);
    }
      <#elseif attr.constraint.domainType.name == "id" || attr.type.custom>  
    if (map['${modelbase.get_attribute_sql_name(attr)}'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)} = Safe.safeInt(map['${modelbase.get_attribute_sql_name(attr)}']);
    }
    if (map['${modelbase.get_attribute_sql_name(attr)}0'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)}0 = Safe.safeInt(map['${modelbase.get_attribute_sql_name(attr)}0']);
    }
    if (map['${modelbase.get_attribute_sql_name(attr)}1'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)}1 = Safe.safeInt(map['${modelbase.get_attribute_sql_name(attr)}1']);
    }  
      <#elseif attr.type.name == "int" || attr.type.name == "integer" || attr.type.name == "long">  
    if (map['${modelbase.get_attribute_sql_name(attr)}'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)} = Safe.safeInt(map['${modelbase.get_attribute_sql_name(attr)}']);
    }
    if (map['${modelbase.get_attribute_sql_name(attr)}0'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)}0 = Safe.safeInt(map['${modelbase.get_attribute_sql_name(attr)}0']);
    }
    if (map['${modelbase.get_attribute_sql_name(attr)}1'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)}1 = Safe.safeInt(map['${modelbase.get_attribute_sql_name(attr)}1']);
    }  
      <#elseif attr.type.name == "number">  
    if (map['${modelbase.get_attribute_sql_name(attr)}'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)} = Safe.safeDouble(map['${modelbase.get_attribute_sql_name(attr)}']);
    }
    if (map['${modelbase.get_attribute_sql_name(attr)}0'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)}0 = Safe.safeDouble(map['${modelbase.get_attribute_sql_name(attr)}0']);
    }
    if (map['${modelbase.get_attribute_sql_name(attr)}1'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)}1 = Safe.safeDouble(map['${modelbase.get_attribute_sql_name(attr)}1']);
    }  
      <#else>
    if (map['${modelbase.get_attribute_sql_name(attr)}'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)} = map['${modelbase.get_attribute_sql_name(attr)}'];
    }
    if (map['${modelbase.get_attribute_sql_name(attr)}0'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)}0 = map['${modelbase.get_attribute_sql_name(attr)}0'];
    }
    if (map['${modelbase.get_attribute_sql_name(attr)}1'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)}1 = map['${modelbase.get_attribute_sql_name(attr)}1'];
    }      
      </#if>
    </#if>
    <#if attr.constraint.identifiable ||
         attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum")>
    if (map['${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}'] != null) {
      retVal.${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}.clear();
      retVal.${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}.addAll(map['${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}'] as Iterable<${modelbase4dart.type_attribute_primitive(attr)}>);
    }        
    </#if>
    <#-- 引用对象需要作为结果的 -->
    <#if attr.type.custom>
    if (map['${dart.nameVariable(attr.name)}'] != null) {
      retVal.${dart.nameVariable(attr.name)} = ${dart.nameType(attr.type.name)}Query.from(map['${dart.nameVariable(attr.name)}']);
    }
    </#if>
    <#if attr.type.name == "string" && !attr.type.custom && !attr.identifiable>
    if (map['${modelbase.get_attribute_sql_name(attr)}2'] != null) {
      retVal.${modelbase.get_attribute_sql_name(attr)}2 = map['${modelbase.get_attribute_sql_name(attr)}2'];
    }   
    </#if>
    <#local processedAttrs += {modelbase.get_attribute_sql_name(attr):attr}>
  </#list>
  <#if modelbase.get_id_attributes(obj)?size != 1><#return></#if>
  <#list obj.attributes as attr>
    <#if attr.type.custom && attr.constraint.identifiable>
      <#local refObj = model.findObjectByName(attr.type.name)>
<@print_object_query_from obj=refObj processedAttrs=processedAttrs />    
    </#if>
  </#list>  
</#macro>

<#macro print_object_query_to obj processedAttrs>
  <#list obj.attributes as attr>
    <#if processedAttrs[modelbase.get_attribute_sql_name(attr)]??><#continue></#if>
    <#if attr.type.collection>
    <#else>
      <#if attr.type.name == 'date' || attr.type.name == 'datetime'>  
    if (${modelbase.get_attribute_sql_name(attr)} != null) {
      retVal['${modelbase.get_attribute_sql_name(attr)}'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(${modelbase.get_attribute_sql_name(attr)}!);
    }
    if (${modelbase.get_attribute_sql_name(attr)}0 != null) {
      retVal['${modelbase.get_attribute_sql_name(attr)}0'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(${modelbase.get_attribute_sql_name(attr)}0!);
    }
    if (${modelbase.get_attribute_sql_name(attr)}1 != null) {
      retVal['${modelbase.get_attribute_sql_name(attr)}1'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(${modelbase.get_attribute_sql_name(attr)}1!);
    }
      <#else>
    if (${modelbase.get_attribute_sql_name(attr)} != null) {
      retVal['${modelbase.get_attribute_sql_name(attr)}'] = ${modelbase.get_attribute_sql_name(attr)}!;
    }
    if (${modelbase.get_attribute_sql_name(attr)}0 != null) {
      retVal['${modelbase.get_attribute_sql_name(attr)}0'] = ${modelbase.get_attribute_sql_name(attr)}0!;
    }
    if (${modelbase.get_attribute_sql_name(attr)}1 != null) {
      retVal['${modelbase.get_attribute_sql_name(attr)}1'] = ${modelbase.get_attribute_sql_name(attr)}1!;
    }   
      </#if>
    </#if>
    <#if attr.constraint.identifiable ||
         attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum")>
    </#if>
    <#if attr.type.name == "string" && !attr.type.custom && !attr.identifiable>
    if (${modelbase.get_attribute_sql_name(attr)}2 != null) {
      retVal['${modelbase.get_attribute_sql_name(attr)}2'] = ${modelbase.get_attribute_sql_name(attr)}2!;
    }  
    </#if>
    <#local processedAttrs += {modelbase.get_attribute_sql_name(attr):attr}>
  </#list>
  <#if modelbase.get_id_attributes(obj)?size != 1><#return></#if>
  <#list obj.attributes as attr>
    <#if attr.type.custom && attr.constraint.identifiable>
      <#local refObj = model.findObjectByName(attr.type.name)>
<@print_object_query_to obj=refObj processedAttrs=processedAttrs />    
    </#if>
  </#list>  
</#macro>

<#macro print_object_query_sql obj>
  <#list obj.attributes as attr>
    <#if !attr.persistenceName??><#continue></#if>
    <#if attr.type.collection>
    <#else>
      <#if attr.type.name == 'date' || attr.type.name == 'datetime'>  
    if (${modelbase.get_attribute_sql_name(attr)} != null) {
      retVal['${attr.persistenceName}'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(${modelbase.get_attribute_sql_name(attr)}!);
    }
      <#else>
    if (${modelbase.get_attribute_sql_name(attr)} != null) {
      retVal['${attr.persistenceName}'] = ${modelbase.get_attribute_sql_name(attr)}!;
    }
      </#if>
    </#if>
    <#if attr.constraint.identifiable ||
         attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum")>
    </#if>
  </#list>
</#macro>

<#macro print_object_query_to_query obj root>
  <#if modelbase.get_id_attributes(obj)?size != 1><#return></#if>
  <#list obj.attributes as attr>
    <#if !(attr.type.custom && attr.constraint.identifiable)><#continue></#if>
    <#local refObj = model.findObjectByName(attr.type.name)>   
      
  public ${java.nameType(refObj.name)}Query to${java.nameType(refObj.name)}Query() {
    ${java.nameType(refObj.name)}Query retVal = new ${java.nameType(refObj.name)}Query();
    <#list refObj.attributes as refObjAttr>
      <#local found = false>
      <#list root.attributes as innerAttr>
        <#if refObjAttr.name == innerAttr.name>
    retVal.${name_setter(refObjAttr)}(${name_getter(innerAttr)}());  
          <#local found = true>  
          <#break>    
        </#if>
      </#list>
      <#if !found>
    retVal.${name_setter(refObjAttr)}(${name_getter(refObjAttr)}());    
      </#if>
    </#list>  
    return retVal;
  }
<@print_object_query_to_query obj=refObj root=root />    
  </#list>  
</#macro>

<#function get_attribute_display_string varname attr>
  <#if attr.type.name == "date" || attr.type.name == "datetime">
    <#return "Safe.safeString(" + varname + "." + modelbase.get_attribute_sql_name(attr) + ", convert: (date) => DateFormat('yyyy-MM-dd').format(date))">
  <#elseif attr.type.name == "int" | attr.type.name == "integer" || attr.type.name == "long">
    <#return "Safe.safeString(" + varname + "." + modelbase.get_attribute_sql_name(attr) + ")">
  </#if>
  <#return varname + "." + modelbase.get_attribute_sql_name(attr) + "??''">
</#function>

