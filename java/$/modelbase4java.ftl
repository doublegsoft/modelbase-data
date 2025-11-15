<#--
 ### Gets type name for the attribute. And supports both collection and
 ### non-collection types.
 ### <p>
 ### And attribute type could be primitive, custom and collection.
 ###
 ### @param attr
 ###        the attribute definition
 ###
 ### @return
 ###        the programming language type name
 #-->
<#function type_attribute attr>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#return java.nameType(refObj.name)>
  <#elseif attr.constraint?? && attr.constraint.domainType?? && attr.constraint.domainType.name == "id">
    <#return "Long">
  <#elseif attr.type.name == "int" || attr.type.name == "integer">
    <#return "Integer">  
  <#elseif attr.type.name == "number">
    <#return "BigDecimal">      
  <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
    <#return "Date">  
  <#elseif attr.type.name == "json">
    <#return "String">
  <#elseif attr.type.primitive>
    <#return typebase.typename(attr.type.name, "java", "String")>
  <#elseif attr.type.collection>
    <#assign fakeAttr = {"type": attr.type.componentType}>
    <#return "List<" + type_attribute(fakeAttr) + ">">
  <#elseif attr.type.domain>
    <#assign exprDomain = attr.type.toString()>
    <#if exprDomain?index_of("&") == 0>
      <#assign refObj = model.findObjectByName(attr.type.name)>
      <#return java.nameType(refObj.name)>
    <#else>
      <#return typebase.typename(attr.type.name, "java", "String")>
    </#if>
  </#if>
  <#return typebase.typename(attr.type.name, "java", "String")>
</#function>

<#function type_attribute_primitive attr>
  <#if attr.type.custom>
    <#local refObj = model.findObjectByName(attr.type.name)>
    <#local refObjIdAttrs = modelbase.get_id_attributes(refObj)>
    <#return type_attribute_primitive(refObjIdAttrs[0])>
  <#elseif attr.constraint.domainType.name == "id">
    <#return "Long">  
  <#elseif attr.constraint.domainType.name == "uuid">
    <#return "String">    
  <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
    <#return "Date">  
  <#elseif attr.type.name == "long">
    <#return "Long">    
  <#elseif attr.type.name == "int" || attr.type.name == "integer">
    <#return "Integer">  
  <#elseif attr.type.name == "number">
    <#return "BigDecimal">    
  <#elseif attr.type.name == "json">
    <#return "String">
  <#elseif attr.type.primitive>
    <#return typebase.typename(attr.type.name, "java", "String")>
  <#elseif attr.type.collection>
    <#return "List<String>">
  <#elseif attr.type.domain>
    <#assign exprDomain = attr.type.toString()>
    <#if exprDomain?index_of("&") == 0>
      <#assign refObj = model.findObjectByName(attr.type.name)>
      <#return java.nameType(refObj.name)>
    <#else>
      <#return typebase.typename(attr.type.name, "java", "String")>
    </#if>
  </#if>
  <#return typebase.typename(attr.type.name, "java", "String")>
</#function>

<#function value_attribute_null attr>
  <#local typename = type_attribute_primitive(attr)>
  <#if typename == "String">
    <#return "\"0\"">
  <#elseif typename == "int" || typename == "integer">
    <#return "0">  
  <#elseif typename == "number">
    <#return "0.0">
  <#elseif typename == "long" || typename == "Long">
    <#return "0L">  
  <#else>
    <#return "null">  
  </#if>
</#function>

<#function singularize_coll_attr attr>
  <#if attr.getLabelledOptions("name")?? && attr.getLabelledOptions("name")["singular"]??>
    <#return java.nameVariable(attr.getLabelledOptions("name")["singular"])>
  </#if>
  <#return java.nameVariable(attr.type.componentType.name)>
</#function>

<#function get_imports obj>
  <#local ret = []>
  <#local existings = {"":""}>
  <#list obj.attributes as attr>
    <#local fullname = "">
    <#if attr.type.custom>
    <#elseif attr.type.collection>
      <#local fullname = 'java.util.List'>
      <#if !existings[fullname]??>
        <#local existings += {fullname:fullname}>
        <#local ret += [fullname]>
      </#if>
    <#elseif attr.type.name == "number">
      <#local fullname = "java.math.BigDecimal">
    <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
      <#local fullname = "java.util.Date">      
    </#if>
    <#if !existings[fullname]??>
      <#local existings += {fullname:fullname}>
      <#local ret += [fullname]>
    </#if>
  </#list>
  <#return ret>
</#function>

<#--
 ### Gets the test value from tatabase framework for the given attribute.
 ###
 ### @param attr
 ###        the attribute of an object
 ###
 ### @return
 ###        the test value for java language
 #-->
<#function test_unit_value attr>
  <#assign val = tatabase.value(attr.constraint.domainType?string, '', language)>
  <#assign typestr = attr.constraint.domainType?string>
  <#if attr.isLabelled("reference") && attr.getLabelledOptions("reference")["value"] = "id">
    <#return '"123456"'>
  <#elseif typestr == 'lmt'>
    <#return 'Timestamp.valueOf("' + val + '")'>
  <#elseif attr.name == 'state'>
    <#return '"E"'>  
  <#elseif typestr == 'id'>
    <#return 'IdGenerator.id()'>
  <#elseif typestr == 'code'>
    <#return '"000"'>
  <#elseif typestr?contains('enum')>
    <#return '"0"'>
  <#elseif typestr?contains('name')>
    <#return '"测试名称"'>
  <#elseif typestr?contains('string')>
    <#assign length = 64>
    <#if typestr?contains('(')>
      <#assign length = typestr?replace('string(', '')?replace(')', '')?number>
    </#if>
    <#if (length > modelbase.get_attribute_label(attr)?length * 2 + 6)>
      <#return '"' + tatabase.string(length / 6) + '"'>
    <#else>
      <#assign ret = ''>
      <#list 1..length as idx>
        <#assign ret = ret + '0'>
      </#list>
      <#return '"' + ret + '"'>
    </#if>
  <#elseif typestr?contains('number')>
    <#return 'new BigDecimal("5.67")'>
  <#elseif typestr?contains('integer') || typestr?contains('int')>
    <#return '5'>
  <#elseif typestr?contains('long')>
    <#return '5L'>
  <#elseif typestr?contains('bool')>
    <#return 'true'>
  <#elseif typestr == "datetime">
    <#return 'Timestamp.valueOf("' + tatabase.datetime() + '")'> 
  </#if>
  <#return 'null'>
</#function>

<#function test_sql_value attr ttbctx>d
  <#assign UUID = statics['naming.util.UUID']>
  <#assign typestr = attr.constraint.domainType?string>
  <#if typestr == 'lmt' || typestr == 'now'>
    <#return 'current_timestamp'>
  <#elseif typestr == 'id'>
    <#assign id = UUID.randomUUID()?string?upper_case>
    <#assign ttbctx = ttbctx.addObjectId(attr.parent, id)>
    <#return "'" + id + "'">
  <#elseif typestr == 'code'>
    <#return "'000'">
  <#elseif typestr?contains('enum')>
    <#return "'" + ttbctx.getValue(attr, ttbctx) + "'">
  <#elseif typestr?contains('name')>
    <#return "'测试名称'">
  <#elseif typestr?contains('string')>
    <#return "'" +  attr.text + '测试值' + "'">
  <#elseif typestr?contains('number')>
    <#return '100.55'>
  <#elseif typestr?contains('integer') || typestr?contains('int')>
    <#return ttbctx.getValue(attr, ttbctx)>
  <#elseif typestr?contains('long')>
    <#return ttbctx.getValue(attr, ttbctx)>
  <#elseif typestr?contains('&')>
    <#assign id = ttbctx.getValue(attr, ttbctx)!>
    <#if id == ''>
      <#return 'null'>
    <#else>
      <#return "'" + id + "'">
    </#if>
  <#elseif typestr?contains('bool')>
    <#return "'T'">
  </#if>
  <#return 'null'>
</#function>

<#function test_json_value attr>
  <#assign Timestamp = statics['java.sql.Timestamp']>
  <#assign Date = statics['java.sql.Date']>
  <#if attr.constraint.domainType.name?contains('enum')>
    <#return '"' + tatabase.enumcode(attr.constraint.domainType.name) + '"'>
  <#elseif attr.constraint.domainType.name == 'id' || attr.name == 'id' || attr.type.custom || attr.identifiable>
    <#local val = tatabase.number(0,100)>
    <#local val = val?substring(0, val?index_of("."))>
    <#return "\"" + val + "\"">
  <#elseif attr.constraint.domainType.name == 'json'>
    <#return '{}'>
  <#elseif attr.constraint.domainType.name == 'state'>
    <#return '"E"'>
  <#elseif attr.isLabelled("reference") && attr.getLabelledOptions("reference")["value"] == "id">
    <#return '"123456"'>  
  <#elseif attr.type.name == 'bool'>
    <#return '"true"'>
  <#elseif attr.type.name == 'number'>
    <#return '"' + tatabase.number(0,100) + '"'>
  <#elseif attr.type.name == 'integer' || attr.type.name == 'int'>
    <#return '36'>
  <#elseif attr.type.name == 'long'>
    <#return '36'>
  <#elseif attr.type.name == 'date'>
    <#return '"' + tatabase.datetime() + '"'>
  <#elseif attr.type.name == 'datetime'>
    <#return '"' + tatabase.datetime() + '"'>
  <#elseif attr.type.custom>
    <#return '"654321"'>
  <#elseif attr.type.collection>
    <#return '[]'>
  <#elseif attr.type.name == 'string'>
    <#return '"' + tatabase.string((attr.type.length!12)/4) + '"'>  
  <#else>
    <#return '"666666"'>
  </#if>
</#function>

<#function name_getter attr>
  <#return "get" + java.nameType(modelbase.get_attribute_sql_name(attr))>
</#function>

<#function name_setter attr>
  <#return "set" + java.nameType(modelbase.get_attribute_sql_name(attr))>
</#function>

<#macro print_reference_assemble attr objname attrname indent>
  <#if attr.type.custom>
    <#local refObj = model.findObjectByName(attr.type.name)>
    <#local idAttrs = modelbase.get_id_attributes(refObj)>
${""?left_pad(indent)}${java.nameType(refObj.name)} ${java.nameVariable(refObj.name)} = new ${java.nameType(refObj.name)}();
${""?left_pad(indent)}${objname}.set${java.nameType(attr.name)}(${java.nameVariable(refObj.name)});  
    <#if idAttrs[0].type.custom>
<@print_reference_assemble attr=idAttrs[0] objname=java.nameVariable(refObj.name) attrname=attrname indent=indent />  
    <#else>
      <#assign refObjIdAttrs = modelbase.get_id_attributes(refObj)>
      <#list refObjIdAttrs as refObjIdAttr>
        <#if refObjIdAttr.type.name == objname>
          <#assign foundRefObjIdAttr = refObjIdAttr>
          <#break>
        </#if>
      </#list>
      <#if foundRefObjIdAttr??>
${""?left_pad(indent)}${java.nameVariable(refObj.name)}.set${java.nameType(foundRefObjIdAttr.name)}(${attrname});
      <#else>
${""?left_pad(indent)}${java.nameVariable(refObj.name)}.set${java.nameType(idAttrs[0].name)}(${attrname});      
      </#if>
    </#if>
  <#else>
${""?left_pad(indent)}${objname}.set${java.nameType(attr.name)}(${attrname});   
  </#if> 
</#macro>

<#macro print_hierarchy_set attr objname attrname indent>
  <#if attr.type.custom>
    <#local refObj = model.findObjectByName(attr.type.name)>
    <#local idAttrs = modelbase.get_id_attributes(refObj)>
${""?left_pad(indent)}${java.nameType(refObj.name)} ${java.nameVariable(refObj.name)} = new ${java.nameType(refObj.name)}();
${""?left_pad(indent)}${objname}.set${java.nameType(attr.name)}(${java.nameVariable(refObj.name)});  
    <#if idAttrs[0].type.custom>
<@print_reference_assemble attr=idAttrs[0] objname=java.nameVariable(refObj.name) attrname=attrname indent=indent />  
    <#else>
${""?left_pad(indent)}${java.nameVariable(refObj.name)}.set${java.nameType(idAttrs[0].name)}(${attrname});  
    </#if>
  <#else>
${""?left_pad(indent)}${objname}.set${java.nameType(attr.name)}(${attrname});    
  </#if> 
</#macro>

<#function get_attribute_default_value attr>
  <#if attr.constraint.defaultValue == "now">
    <#return "new java.sql.Timestamp(System.currentTimeMillis())">
  <#elseif attr.type.name == "int" || attr.type.name == "integer">
    <#return attr.constraint.defaultValue> 
  <#elseif attr.type.name == "long">
    <#return (attr.constraint.defaultValue!0)?string + "L">   
  <#elseif attr.type.name == "string">  
    <#if attr.constraint.defaultValue?starts_with("'") && attr.constraint.defaultValue?ends_with("'")>
      <#return "\"" + attr.constraint.defaultValue?substring(1,attr.constraint.defaultValue?length - 1)  + "\"">  
    </#if>
    <#return "\"" + attr.constraint.defaultValue + "\"">  
  </#if>
  <#return "null">
</#function>

<#macro print_object_default_setters obj varname indent>
  <#local commentPrinted = false>
  <#list obj.attributes as attr>
    <#if attr.name == "state">
${""?left_pad(indent)}if (${varname}.get${java.nameType(attr.name)}() == null) {
${""?left_pad(indent)}  ${varname}.set${java.nameType(attr.name)}("E");
${""?left_pad(indent)}}
    <#elseif attr.constraint.domainType.name == "now" || (attr.constraint.defaultValue!"") == "now">
${""?left_pad(indent)}if (${varname}.get${java.nameType(attr.name)}() == null) {
${""?left_pad(indent)}  ${varname}.set${java.nameType(attr.name)}(new java.sql.Timestamp(System.currentTimeMillis()));
${""?left_pad(indent)}}    
    <#elseif attr.constraint.defaultValue??>
${""?left_pad(indent)}if (${varname}.get${java.nameType(attr.name)}() == null) {
${""?left_pad(indent)}  ${varname}.set${java.nameType(attr.name)}(${get_attribute_default_value(attr)});
${""?left_pad(indent)}}    
    <#elseif attr.name == "last_modified_time">
${""?left_pad(indent)}${varname}.set${java.nameType(attr.name)}(new java.sql.Timestamp(System.currentTimeMillis()));
    </#if>
  </#list>
</#macro>

<#macro print_object_update_setters obj varname indent>
  <#local commentPrinted = false>
  <#list obj.attributes as attr>
    <#if attr.constraint.domainType.name == "now">
${""?left_pad(indent)}${varname}.set${java.nameType(attr.name)}(new java.sql.Timestamp(System.currentTimeMillis()));  
    </#if>
  </#list>
</#macro>

<#macro print_query_default_setters obj varname indent>
  <#list obj.attributes as attr>
    <#if attr.name == "state">
${""?left_pad(indent)}if (${varname}.get${java.nameType(modelbase.get_attribute_sql_name(attr))}() == null) {
${""?left_pad(indent)}  ${varname}.set${java.nameType(modelbase.get_attribute_sql_name(attr))}("E");
${""?left_pad(indent)}}
    <#elseif attr.constraint.domainType.name == "now" || (attr.constraint.defaultValue!"") == "now">
${""?left_pad(indent)}if (${varname}.get${java.nameType(modelbase.get_attribute_sql_name(attr))}() == null) {
${""?left_pad(indent)}  ${varname}.set${java.nameType(modelbase.get_attribute_sql_name(attr))}(new java.sql.Timestamp(System.currentTimeMillis()));
${""?left_pad(indent)}}    
    <#elseif attr.constraint.defaultValue??>
${""?left_pad(indent)}if (${varname}.get${java.nameType(modelbase.get_attribute_sql_name(attr))}() == null) {
${""?left_pad(indent)}  ${varname}.set${java.nameType(modelbase.get_attribute_sql_name(attr))}(${get_attribute_default_value(attr)});
${""?left_pad(indent)}}    
    <#elseif attr.name == "last_modified_time">
${""?left_pad(indent)}${varname}.set${java.nameType(modelbase.get_attribute_sql_name(attr))}(new java.sql.Timestamp(System.currentTimeMillis()));
    </#if>
  </#list>
</#macro>

<#macro print_query_id_setters obj varname indent>
  <#if modelbase.get_id_attributes(obj)?size != 1><#return></#if>
  <#list obj.attributes as attr>
    <#if attr.identifiable && (attr.type.name == "long" || attr.type.name == "string")>
${""?left_pad(indent)}if (${varname}.get${java.nameType(modelbase.get_attribute_sql_name(attr))}() == null) {
${""?left_pad(indent)}  ${varname}.set${java.nameType(modelbase.get_attribute_sql_name(attr))}(IdGenerator.id());
${""?left_pad(indent)}}
    </#if>
  </#list>
</#macro>

<#-- Query对象类成员 -->
<#macro print_object_query_members obj processedAttrs>
  <#list obj.attributes as attr>
    <#if processedAttrs[modelbase.get_attribute_sql_name(attr)]??><#continue></#if>
    <#if attr.type.collection>
    
  /*!
  ** 【${modelbase.get_attribute_label(attr)}】
  */
  protected final List<${java.nameType(attr.type.componentType.name)}Query> ${inflector.pluralize(modelbase.get_attribute_sql_name(attr))} = new ArrayList<>();
  
  protected final Map<String,Object> in${java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))} = new HashMap<>();
    <#else>
  
  /*!
  ** 【${modelbase.get_attribute_label(attr)}】
  */
  protected ${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)};
  
  protected ${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)}0;
  
  protected ${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)}1;
    </#if>
    <#-- 需要集合属性作为查询条件的 -->
    <#if attr.constraint.identifiable ||
         attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum") ||
         modelbase.is_masterless_detail_reference_attribute(attr)> 
       
  protected final List<${modelbase4java.type_attribute_primitive(attr)}> ${inflector.pluralize(modelbase.get_attribute_sql_name(attr))} = new ArrayList<>();
    </#if>
    <#-- 引用对象需要作为结果的 -->
    <#if attr.type.custom>
      <#if processedAttrs[attr.name]??><#continue></#if>
    
  protected ${java.nameType(attr.type.name)}Query ${java.nameVariable(attr.name)};       
    </#if>
    <#if attr.type.name == "string" && !attr.type.custom && !attr.identifiable>
  
  protected ${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)}2;
    </#if>
    <#local processedAttrs += {modelbase.get_attribute_sql_name(attr):attr}>
    <#local processedAttrs += {attr.name:attr}>
  </#list>
  <#-- REFERENCE -->
  <#list obj.attributes as attr>
    <#if attr.isLabelled("reference") && attr.getLabelledOptions("reference")["value"] == "id">
      <#assign referenceName = attr.getLabelledOptions("reference")["name"]>
      <#if processedAttrs[java.nameVariable(referenceName)]??><#continue></#if>
      <#local processedAttrs += {referenceName:attr}>
      
  protected AbstractQuery ${java.nameVariable(referenceName)};
    </#if>
  </#list>
  <#if modelbase.get_id_attributes(obj)?size != 1><#return></#if>
  <#list obj.attributes as attr>
    <#if attr.type.custom && attr.constraint.identifiable>
      <#local refObj = model.findObjectByName(attr.type.name)>
<@print_object_query_members obj=refObj processedAttrs=processedAttrs />    
    </#if>
  </#list>  
</#macro>

<#-- Query Setters and Getters -->
<#macro print_object_query_xetters obj processedAttrs>
  <#list obj.attributes as attr>
    <#if processedAttrs[modelbase.get_attribute_sql_name(attr)]??><#continue></#if>
    <#if attr.type.collection>
    
  public List<${java.nameType(attr.type.componentType.name)}Query> get${java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))}() {
    return ${inflector.pluralize(modelbase.get_attribute_sql_name(attr))};
  }
  
  public Map<String,Object> getIn${java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))}() {
    return in${java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))};
  }
    <#else>
    
  public ${modelbase4java.type_attribute_primitive(attr)} get${java.nameType(modelbase.get_attribute_sql_name(attr))}() {
    return ${modelbase.get_attribute_sql_name(attr)};
  }
  
  public void set${java.nameType(modelbase.get_attribute_sql_name(attr))}(${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)}) {
    this.${modelbase.get_attribute_sql_name(attr)} = ${modelbase.get_attribute_sql_name(attr)};
  }
  
  public ${modelbase4java.type_attribute_primitive(attr)} get${java.nameType(modelbase.get_attribute_sql_name(attr))}0() {
    return ${modelbase.get_attribute_sql_name(attr)}0;
  }
  
  public void set${java.nameType(modelbase.get_attribute_sql_name(attr))}0(${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)}0) {
    this.${modelbase.get_attribute_sql_name(attr)}0 = ${modelbase.get_attribute_sql_name(attr)}0;
  }
  
  public ${modelbase4java.type_attribute_primitive(attr)} get${java.nameType(modelbase.get_attribute_sql_name(attr))}1() {
    return ${modelbase.get_attribute_sql_name(attr)}1;
  }
  
  public void set${java.nameType(modelbase.get_attribute_sql_name(attr))}1(${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)}1) {
    this.${modelbase.get_attribute_sql_name(attr)}1 = ${modelbase.get_attribute_sql_name(attr)}1;
  }
    </#if>
    <#if attr.constraint.identifiable ||
         attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum") ||
         modelbase.is_masterless_detail_reference_attribute(attr)>
       
  public List<${modelbase4java.type_attribute_primitive(attr)}> get${java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))}() {
    return ${inflector.pluralize(modelbase.get_attribute_sql_name(attr))};
  }
  
  public void add${java.nameType(modelbase.get_attribute_sql_name(attr))}(${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)}) {
    ${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}.add(${modelbase.get_attribute_sql_name(attr)});
  }
    </#if>
    <#-- 引用对象需要作为结果的 -->
    <#if attr.type.custom>
      <#if processedAttrs[attr.name]??><#continue></#if>
      
  public ${java.nameType(attr.type.name)}Query get${java.nameType(attr.name)}() {
    return this.${java.nameVariable(attr.name)};
  };       
  
  public void set${java.nameType(attr.name)}(${java.nameType(attr.type.name)}Query ${java.nameVariable(attr.name)}) {
    this.${java.nameVariable(attr.name)} = ${java.nameVariable(attr.name)};
  }
    </#if>
    <#if attr.type.name == "string" && !attr.type.custom && !attr.identifiable>  
  
  public ${modelbase4java.type_attribute_primitive(attr)} get${java.nameType(modelbase.get_attribute_sql_name(attr))}2() {
    return ${modelbase.get_attribute_sql_name(attr)}2;
  }
  
  public void set${java.nameType(modelbase.get_attribute_sql_name(attr))}2(${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)}2) {
    this.${modelbase.get_attribute_sql_name(attr)}2 = ${modelbase.get_attribute_sql_name(attr)}2;
  }
    </#if>    
    <#local processedAttrs += {modelbase.get_attribute_sql_name(attr):attr}>
    <#local processedAttrs += {attr.name:attr}>
  </#list>
  <#-- REFERENCE -->
  <#list obj.attributes as attr>
    <#if attr.isLabelled("reference") && attr.getLabelledOptions("reference")["value"] == "id">
      <#assign referenceName = attr.getLabelledOptions("reference")["name"]>
      <#if processedAttrs[java.nameVariable(referenceName)]??><#continue></#if>
      <#local processedAttrs += {referenceName:attr}>
      
  public AbstractQuery get${java.nameType(referenceName)}() {
    return ${java.nameVariable(referenceName)};
  }
  
  public void set${java.nameType(referenceName)}(AbstractQuery ${java.nameVariable(referenceName)}) {
    this.${java.nameVariable(referenceName)} = ${java.nameVariable(referenceName)};
  }
    </#if>
  </#list>
  <#if modelbase.get_id_attributes(obj)?size != 1><#return></#if>
  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable && attr.type.custom>
      <#local refObj = model.findObjectByName(attr.type.name)> 
<@print_object_query_xetters obj=refObj processedAttrs=processedAttrs /> 
    </#if>
  </#list>
</#macro>

<#--  -->
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
        <#if refObjAttr.type.collection>
    retVal.${name_getter(refObjAttr)}().addAll(${name_getter(refObjAttr)}());        
        <#else>  
    retVal.${name_setter(refObjAttr)}(${name_getter(refObjAttr)}());    
        </#if>
      </#if>
    </#list>  
    return retVal;
  }
<@print_object_query_to_query obj=refObj root=root />    
  </#list>  
</#macro>

<#macro print_object_query_to_map obj processedAttrs>
  <#list obj.attributes as attr>
    <#if processedAttrs[attr.name]??><#continue></#if>
    <#if attr.type.collection>
    if (!${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}.isEmpty()) {
      retVal.put("${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}", ${inflector.pluralize(modelbase.get_attribute_sql_name(attr))});
    }
    <#else>
      <#local attrtype = modelbase4java.type_attribute_primitive(attr)>
      <#if attrtype == "Long">
    if (${modelbase.get_attribute_sql_name(attr)} != null) {
      retVal.put("${modelbase.get_attribute_sql_name(attr)}", Safe.safeString(${modelbase.get_attribute_sql_name(attr)}));
    }
    if (${modelbase.get_attribute_sql_name(attr)}0 != null) {
      retVal.put("${modelbase.get_attribute_sql_name(attr)}0", Safe.safeString(${modelbase.get_attribute_sql_name(attr)}0));
    }
    if (${modelbase.get_attribute_sql_name(attr)}1 != null) {
      retVal.put("${modelbase.get_attribute_sql_name(attr)}1", Safe.safeString(${modelbase.get_attribute_sql_name(attr)}1));
    }  
      <#else>
    if (${modelbase.get_attribute_sql_name(attr)} != null) {
      retVal.put("${modelbase.get_attribute_sql_name(attr)}", ${modelbase.get_attribute_sql_name(attr)});
    }
    if (${modelbase.get_attribute_sql_name(attr)}0 != null) {
      retVal.put("${modelbase.get_attribute_sql_name(attr)}0", ${modelbase.get_attribute_sql_name(attr)}0);
    }
    if (${modelbase.get_attribute_sql_name(attr)}1 != null) {
      retVal.put("${modelbase.get_attribute_sql_name(attr)}1", ${modelbase.get_attribute_sql_name(attr)}1);
    }
      </#if>
    </#if>
    <#if attr.constraint.identifiable ||
         attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum")>
    if (!${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}.isEmpty()) {
      retVal.put("${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}", ${inflector.pluralize(modelbase.get_attribute_sql_name(attr))});
    }
    </#if>
    <#if attr.type.name == "string" && !attr.type.custom && !attr.identifiable>  
    if (${modelbase.get_attribute_sql_name(attr)}2 != null) {
      retVal.put("${modelbase.get_attribute_sql_name(attr)}2", ${modelbase.get_attribute_sql_name(attr)}2);
    }
    </#if>    
    <#local processedAttrs += {attr.name:attr}>
  </#list>  
  <#-- 值体对象 -->
  <#if modelbase.get_id_attributes(obj)?size != 1>
    <#list obj.attributes as attr>
      <#if attr.type.custom>
    if (${java.nameVariable(attr.name)} != null) {
      retVal.put("${java.nameVariable(attr.name)}", ${java.nameVariable(attr.name)}.toMap());
    }
      </#if>
    </#list>
    <#-- 注意此处的返回 -->
    <#return>
  </#if>
  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable && attr.type.custom>
      <#local refObj = model.findObjectByName(attr.type.name)> 
<@print_object_query_to_map obj=refObj processedAttrs=processedAttrs /> 
    if (${java.nameVariable(attr.name)} != null) {
      retVal.put("${java.nameVariable(attr.name)}", ${java.nameVariable(attr.name)}.toMap());
    }
    <#elseif attr.type.custom>
    if (${java.nameVariable(attr.name)} != null) {
      retVal.put("${java.nameVariable(attr.name)}", ${java.nameVariable(attr.name)}.toMap());
    }
    </#if>
  </#list>
</#macro>

<#macro print_object_one2one_save obj indent>
  <#list obj.attributes as attr>
    <#if !attr.type.custom || !attr.constraint.identifiable><#continue></#if>
    <#assign refObj = model.findObjectByName(attr.type.name)>
${""?left_pad(indent)}/*!
${""?left_pad(indent)}** 保存主键引用的【${modelbase.get_object_label(refObj)}】对象
${""?left_pad(indent)}*/
${""?left_pad(indent)}${java.nameType(refObj.name)}Query ${java.nameVariable(attr.name)}${java.nameType(refObj.name)}Query = query.to${java.nameType(refObj.name)}Query();
${""?left_pad(indent)}${java.nameVariable(refObj.name)}Service.save${java.nameType(refObj.name)}(${java.nameVariable(attr.name)}${java.nameType(refObj.name)}Query);   
<@print_object_one2one_save obj=refObj indent=indent />         
  </#list>
</#macro>

<#----------------------------------------------------------------------------->
<#--                                   PIVOT                                 -->
<#----------------------------------------------------------------------------->

<#macro print_object_pivot_save obj indent>
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
${""?left_pad(indent)}if (query.${modelbase4java.name_getter(attr)}() != null) {
${""?left_pad(indent)}  ${java.nameType(detailObj.name)}Query ${java.nameVariable(attr.name)}Query = new ${java.nameType(detailObj.name)}Query();
    <#-- detail对象的默认值设置，包含对主键的设值 -->       
      <#assign innerVarName = java.nameVariable(attr.name) + "Query">
<@print_query_id_setters obj=detailObj varname=innerVarName  indent=indent+2 />     
${""?left_pad(indent)}  ${java.nameType(detailObj.name)}Query.setDefaultValues(${java.nameVariable(attr.name)}Query);  
    <#if obj.getLabelledOptions("pivot")["master"]??>    
${""?left_pad(indent)}  ${java.nameVariable(attr.name)}Query.${modelbase4java.name_setter(idAttrs[0])}(${modelbase.get_attribute_sql_name(idAttrs[0])});
    <#else>
      <#list obj.attributes as innerAttr>
        <#list detailObj.attributes as detailAttr>
          <#if innerAttr.name == detailAttr.name>
${""?left_pad(indent)}  ${java.nameVariable(attr.name)}Query.${modelbase4java.name_setter(innerAttr)}(query.${modelbase4java.name_getter(innerAttr)}());
          </#if>
        </#list>      
      </#list>
    </#if>   
${""?left_pad(indent)}  ${java.nameVariable(attr.name)}Query.${modelbase4java.name_setter(keyAttr)}("${java.nameVariable(attr.name)}");
${""?left_pad(indent)}  ${java.nameVariable(attr.name)}Query.${modelbase4java.name_setter(valueAttr)}(Strings.format(query.${modelbase4java.name_getter(attr)}()));
${""?left_pad(indent)}  ${java.nameVariable(detailObj.name)}Service.save${java.nameType(detailObj.name)}(${java.nameVariable(attr.name)}Query);
${""?left_pad(indent)}}
  </#list>
</#macro>

<#macro print_object_pivot_create obj indent>
</#macro>

<#macro print_object_pivot_modify obj indent>
</#macro>

<#macro print_object_pivot_read obj indent>
  <#if obj.getLabelledOptions("pivot")["master"]??>
    <#local masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
  </#if>
  <#local detailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
  <#local keyAttr = model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("pivot")["key"])>
  <#local valueAttr = model.findAttributeByNames(detailObj.name, obj.getLabelledOptions("pivot")["value"])>
  <#-- master -->
  <#if masterObj??>
    <#local idAttrs = modelbase.get_id_attributes(masterObj)>
${""?left_pad(indent)}${java.nameType(masterObj.name)}Query ${java.nameVariable(masterObj.name)}Query = new ${java.nameType(masterObj.name)}Query();
    <#list idAttrs as idAttr>
${""?left_pad(indent)}${java.nameVariable(masterObj.name)}Query.${modelbase4java.name_setter(idAttr)}(query.${modelbase4java.name_getter(idAttr)}());
    </#list>
    <#-- 原始对象的读取操作 -->    
<@print_object_persistence_read obj=masterObj indent=indent proxy=obj />
${""?left_pad(indent)}retVal = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(result);  
  <#else>
${""?left_pad(indent)}retVal = new ${java.nameType(obj.name)}Query();
  </#if>  
  <#-- detail -->
${""?left_pad(indent)}${java.nameType(detailObj.name)}Query ${java.nameVariable(detailObj.name)}Query = new ${java.nameType(detailObj.name)}Query();
  <#if masterObj??>
${""?left_pad(indent)}${java.nameVariable(detailObj.name)}Query.${name_setter(idAttrs[0])}(query.${name_getter(idAttrs[0])}());
  <#else>
    <#list detailObj.attributes as detailObjAttr>
      <#list obj.attributes as attr>
        <#if detailObjAttr.name == attr.name>
${""?left_pad(indent)}${java.nameVariable(detailObj.name)}Query.${modelbase4java.name_setter(detailObjAttr)}(query.${modelbase4java.name_getter(detailObjAttr)}());
        </#if>
      </#list>
    </#list>
  </#if>
${""?left_pad(indent)}List<Map<String,Object>> items = ${java.nameVariable(detailObj.name)}DataAccess.select${java.nameType(detailObj.name)}(${java.nameVariable(detailObj.name)}Query);
${""?left_pad(indent)}assemble${java.nameType(obj.name)}Query(retVal, items);
</#macro>

<#macro print_object_pivot_delete obj indent>
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
${""?left_pad(indent)}if (query.${modelbase4java.name_getter(attr)}() != null) {
${""?left_pad(indent)}  ${java.nameType(detailObj.name)}Query ${java.nameVariable(attr.name)}Query = new ${java.nameType(detailObj.name)}Query();
    <#-- detail对象的默认值设置，包含对主键的设值 -->       
      <#assign innerVarName = java.nameVariable(attr.name) + "Query">
<@print_query_id_setters obj=detailObj varname=innerVarName  indent=indent+2 />     
${""?left_pad(indent)}  ${java.nameType(detailObj.name)}Query.setDefaultValues(${java.nameVariable(attr.name)}Query);  
    <#if obj.getLabelledOptions("pivot")["master"]??>    
${""?left_pad(indent)}  ${java.nameVariable(attr.name)}Query.${modelbase4java.name_setter(idAttrs[0])}(${modelbase.get_attribute_sql_name(idAttrs[0])});
    <#else>
      <#list obj.attributes as innerAttr>
        <#list detailObj.attributes as detailAttr>
          <#if innerAttr.name == detailAttr.name>
${""?left_pad(indent)}  ${java.nameVariable(attr.name)}Query.${modelbase4java.name_setter(innerAttr)}(query.${modelbase4java.name_getter(innerAttr)}());
          </#if>
        </#list>      
      </#list>
    </#if>   
${""?left_pad(indent)}  ${java.nameVariable(attr.name)}Query.${modelbase4java.name_setter(keyAttr)}("${java.nameVariable(attr.name)}");
${""?left_pad(indent)}  ${java.nameVariable(attr.name)}Query.${modelbase4java.name_setter(valueAttr)}(Strings.format(query.${modelbase4java.name_getter(attr)}()));
${""?left_pad(indent)}  ${java.nameVariable(detailObj.name)}Service.save${java.nameType(detailObj.name)}(${java.nameVariable(attr.name)}Query);
${""?left_pad(indent)}}
  </#list>
</#macro>

<#macro print_object_pivot_disable obj indent>
</#macro>

<#macro print_object_pivot_assemble obj indent>
${""?left_pad(indent)}for (Map<String,Object> result : results) {
  <#list obj.attributes as attr>
    <#if !attr.isLabelled("redefined")><#continue></#if>
    <#local isOrigAttr = false>
    <#list detailObj.attributes as detailAttr>
      <#if detailAttr.name == attr.name>
        <#if attr.type.name == "datetime">
${""?left_pad(indent)}  query.${modelbase4java.name_setter(attr)}(Safe.safe(result.get("${modelbase.get_attribute_sql_name(attr)}"), Timestamp.class));        
        <#else>
${""?left_pad(indent)}  query.${modelbase4java.name_setter(attr)}(Safe.safe(result.get("${modelbase.get_attribute_sql_name(attr)}"), ${modelbase4java.type_attribute_primitive(attr)}.class));
        </#if>
        <#local isOrigAttr = true>
        <#break>
      </#if>
    </#list>  
    <#if isOrigAttr><#continue></#if>
${""?left_pad(indent)}  if ("${java.nameVariable(attr.name)}".equals(result.get("${modelbase.get_attribute_sql_name(keyAttr)}"))) {
${""?left_pad(indent)}    query.set${java.nameType(attr.name)}(Safe.safe(result.get("${modelbase.get_attribute_sql_name(valueAttr)}"), ${modelbase4java.type_attribute_primitive(attr)}.class));
${""?left_pad(indent)}  }
  </#list>
${""?left_pad(indent)}}
</#macro>

<#----------------------------------------------------------------------------->
<#--                                    META                                 -->
<#----------------------------------------------------------------------------->

<#macro print_object_meta_save obj indent>
  <#local idAttrs = modelbase.get_id_attributes(obj)>
  <#list obj.attributes as attr>
    <#if !attr.isLabelled("redefined")><#continue></#if>
${""?left_pad(indent)}if (query.${modelbase4java.name_getter(attr)}() != null) {
${""?left_pad(indent)}  ${java.nameType(obj.name)}MetaQuery ${java.nameVariable(attr.name)}Query = new ${java.nameType(obj.name)}MetaQuery();
${""?left_pad(indent)}  ${java.nameVariable(attr.name)}Query.${modelbase4java.name_setter(idAttrs[0])}(${modelbase.get_attribute_sql_name(idAttrs[0])});
${""?left_pad(indent)}  ${java.nameVariable(attr.name)}Query.setPropertyName("${java.nameVariable(attr.name)}");
${""?left_pad(indent)}  if (${java.nameVariable(obj.name)}MetaDataAccess.select${java.nameType(obj.name)}Meta(${java.nameVariable(attr.name)}Query).size() == 0) {
${""?left_pad(indent)}    ${java.nameVariable(attr.name)}Query.setPropertyValue(Strings.format(query.${modelbase4java.name_getter(attr)}()));
${""?left_pad(indent)}    ${java.nameVariable(obj.name)}MetaDataAccess.insert${java.nameType(obj.name)}Meta(${java.nameType(obj.name)}MetaAssembler.assemble${java.nameType(obj.name)}MetaFromQuery(${java.nameVariable(attr.name)}Query));
${""?left_pad(indent)}  } else {
${""?left_pad(indent)}    ${java.nameVariable(attr.name)}Query.setPropertyValue(Strings.format(query.${modelbase4java.name_getter(attr)}().toString()));
${""?left_pad(indent)}    ${java.nameVariable(obj.name)}MetaDataAccess.update${java.nameType(obj.name)}Meta(${java.nameType(obj.name)}MetaAssembler.assemble${java.nameType(obj.name)}MetaFromQuery(${java.nameVariable(attr.name)}Query));
${""?left_pad(indent)}  }
${""?left_pad(indent)}}
  </#list>
</#macro>

<#macro print_object_extension_save obj indent>
  <#local extObjs = modelbase.get_extension_objects(obj)>
  <#local idAttrs = modelbase.get_id_attributes(obj)>
  <#list extObjs as extObjName, extRefAttr>
    <#local extObj = model.findObjectByName(extObjName)>
    <#local extObjIdAttr = modelbase.get_id_attributes(extObj)[0]>
${""?left_pad(indent)}/*!
${""?left_pad(indent)}** 保存【${modelbase.get_object_label(extObj)}】作为一对一显式扩展对象
${""?left_pad(indent)}*/
${""?left_pad(indent)}${java.nameType(extObj.name)}Query ${java.nameVariable(extObj.name)}Query = new ${java.nameType(extObj.name)}Query();
${""?left_pad(indent)}${java.nameVariable(extObj.name)}Query.set${java.nameType(modelbase.get_attribute_sql_name(extObjIdAttr))}(${modelbase.get_attribute_sql_name(idAttrs[0])}); 
${""?left_pad(indent)}${java.nameVariable(extObj.name)}Query.set${java.nameType(modelbase.get_attribute_sql_name(extRefAttr))}(Safe.safe(${modelbase.get_attribute_sql_name(idAttrs[0])}, ${modelbase4java.type_attribute_primitive(extRefAttr)}.class));
    <#list obj.attributes as attr>
      <#list extObj.attributes as extObjAttr>
        <#if attr.name == extObjAttr.name && !attr.constraint.identifiable>
${""?left_pad(indent)}${java.nameVariable(extObj.name)}Query.set${java.nameType(modelbase.get_attribute_sql_name(extObjAttr))}(query.get${java.nameType(modelbase.get_attribute_sql_name(attr))}());    
          <#break>
        </#if>
      </#list>
    </#list>
    <#list extObj.attributes as extObjAttr>
    <#-- 扩展类型本身引用主实体类型 （比较重要）-->
      <#if extObjAttr.type.name == obj.name>
${""?left_pad(indent)}${java.nameVariable(extObj.name)}Query.set${java.nameType(modelbase.get_attribute_sql_name(extObjAttr))}(query.get${java.nameType(modelbase.get_attribute_sql_name(idAttrs[0]))}());    
        <#break>
      </#if>
    </#list>
${""?left_pad(indent)}${java.nameType(extObj.name)} ${java.nameVariable(extObj.name)} = ${java.nameType(extObj.name)}Assembler.assemble${java.nameType(extObj.name)}FromQuery(${java.nameVariable(extObj.name)}Query);
${""?left_pad(indent)}if (!existing) {
${""?left_pad(indent)}  ${java.nameVariable(extObj.name)}DataAccess.insert${java.nameType(extObj.name)}(${java.nameVariable(extObj.name)});
${""?left_pad(indent)}} else {
${""?left_pad(indent)}  ${java.nameVariable(extObj.name)}DataAccess.updatePartial${java.nameType(extObj.name)}(${java.nameVariable(extObj.name)});
${""?left_pad(indent)}}
  </#list>
</#macro>

<#macro print_object_one2many_save obj indent>
  <#local idAttrs = modelbase.get_id_attributes(obj)>
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
    <#if !one2many><#continue></#if>
${""?left_pad(indent)}/*!
${""?left_pad(indent)}** 直接关联的【${modelbase.get_object_label(collObj)}】作为一对多显式扩展对象
${""?left_pad(indent)}*/
${""?left_pad(indent)}List<${java.nameType(attr.type.componentType.name)}Query> ${java.nameVariable(attr.name)} = query.get${java.nameType(attr.name)}();    
${""?left_pad(indent)}// 查询已经存在的
${""?left_pad(indent)}${java.nameType(collObj.name)}Query existing${java.nameType(collObj.name)}Query = new ${java.nameType(collObj.name)}Query();
${""?left_pad(indent)}existing${java.nameType(collObj.name)}Query.set${java.nameType(modelbase.get_attribute_sql_name(idAttrs[0]))}(${modelbase.get_attribute_sql_name(idAttrs[0])});
    <#list collObj.attributes as collObjAttr>
      <#if collObjAttr.name == "state">
${""?left_pad(indent)}existing${java.nameType(collObj.name)}Query.setState("E");
      </#if>
    </#list>
${""?left_pad(indent)}List<Map<String,Object>> existing${java.nameType(collObj.name)}Rows = ${java.nameVariable(collObj.name)}DataAccess.select${java.nameType(collObj.name)}(existing${java.nameType(collObj.name)}Query);
${""?left_pad(indent)}// 去掉不存在的
    <#if (collObjIdAttrs?size > 1)>      
${""?left_pad(indent)}for (Map<String,Object> row : existing${java.nameType(collObj.name)}Rows) {
${""?left_pad(indent)}  boolean found = false;
${""?left_pad(indent)}  for (${java.nameType(collObj.name)}Query rowQuery : ${java.nameVariable(attr.name)}) {
${""?left_pad(indent)}    if (rowQuery.get${java.nameType(modelbase.get_attribute_sql_name(collObjIdAttr))}().equals(row.get("${modelbase.get_attribute_sql_name(collObjIdAttr)}"))) {
${""?left_pad(indent)}      found = true;
${""?left_pad(indent)}      break;
${""?left_pad(indent)}    }
${""?left_pad(indent)}  }
${""?left_pad(indent)}  if (!found) {
      <#local noState = false>    
      <#list collObj.attributes as collObjAttr>
        <#if collObjAttr.name == "state">
        ${java.nameVariable(collObj.name)}Service.disable${java.nameType(collObj.name)}(${java.nameType(collObj.name)}QueryAssembler.assemble${java.nameType(collObj.name)}Query(row));
          <#local noState = true>
          <#break>
        </#if>
      </#list>
      <#if !noState>
${""?left_pad(indent)}    ${java.nameVariable(collObj.name)}Service.delete${java.nameType(collObj.name)}(${java.nameType(collObj.name)}QueryAssembler.assemble${java.nameType(collObj.name)}Query(row));
      </#if>
${""?left_pad(indent)}    }
${""?left_pad(indent)}  }
    </#if>  
${""?left_pad(indent)}for (${java.nameType(collObj.name)}Query row : ${java.nameVariable(attr.name)}) {  
${""?left_pad(indent)}  row.set${java.nameType(modelbase.get_attribute_sql_name(idAttrs[0]))}(${modelbase.get_attribute_sql_name(idAttrs[0])});
    <#list collObj.attributes as collObjAttr>
      <#if collObjAttr.name == "state">
${""?left_pad(indent)}  row.setState("E");
      </#if>
    </#list>          
    <#if collObj.name == obj.name><#-- 树结构定义的对象，含有children属性的情况 -->
${""?left_pad(indent)}  save${java.nameType(collObj.name)}(row);
    <#else>
${""?left_pad(indent)}  ${java.nameVariable(collObj.name)}Service.save${java.nameType(collObj.name)}(row);
    </#if>    
${""?left_pad(indent)}}
    <#-- TODO: 当集合对象是值域对象时，它所关联的其他引用对象，也存在【新增】的可能性 -->
  </#list>
</#macro>

<#macro print_object_many2many_save obj indent>
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
    <#if one2many><#continue></#if>
    <#-- FIXME: 间接关联 暂时全面废止 --> 
    <#local conjObj = model.findObjectByName(attr.getLabelledOptions("conjunction")["name"])>
${""?left_pad(indent)}/*!
${""?left_pad(indent)}** 间接关联的【${modelbase.get_object_label(conjObj)}】作为一对多显式扩展对象
${""?left_pad(indent)}*/
${""?left_pad(indent)}List<${java.nameType(attr.type.componentType.name)}Query> ${java.nameVariable(attr.name)} = query.get${java.nameType(attr.name)}();
${""?left_pad(indent)}// 删除已有的【${modelbase.get_object_label(conjObj)}】数据
${""?left_pad(indent)}${java.nameType(conjObj.name)} ${java.nameVariable(conjObj.name)} = new ${java.nameType(conjObj.name)}();
    <#list conjObj.attributes as conjObjAttr>
      <#if conjObjAttr.type.name == obj.name>
${""?left_pad(indent)}${java.nameVariable(conjObj.name)}.set${java.nameType(conjObjAttr.name)}(${java.nameVariable(obj.name)});  
        <#break>
      </#if>
    </#list>
${""?left_pad(indent)}// ${java.nameVariable(attr.getLabelledOptions("conjunction")["name"])}DataAccess.disable${java.nameType(conjObj.name)}(${java.nameVariable(conjObj.name)});
${""?left_pad(indent)}// 创建新的【${modelbase.get_object_label(conjObj)}】数据
${""?left_pad(indent)}for (${java.nameType(attr.type.componentType.name)}Query row : ${java.nameVariable(attr.name)}) {
${""?left_pad(indent)}  ${java.nameType(conjObj.name)} conj = new ${java.nameType(conjObj.name)}();
    <#list conjObj.attributes as conjObjAttr>
      <#if conjObjAttr.type.name == obj.name>
${""?left_pad(indent)}  conj.set${java.nameType(conjObjAttr.name)}(${java.nameVariable(obj.name)});
      <#elseif conjObjAttr.type.name == collObj.name>
        <#local collObjIdAttr = modelbase.get_id_attributes(collObj)[0]>
${""?left_pad(indent)}  ${java.nameType(collObj.name)} conj${java.nameType(collObj.name)} = new ${java.nameType(collObj.name)}();
${""?left_pad(indent)}  conj${java.nameType(collObj.name)}.setId(row.${modelbase4java.name_getter(collObjIdAttr)}());
${""?left_pad(indent)}  conj.set${java.nameType(conjObjAttr.name)}(conj${java.nameType(collObj.name)});
<@modelbase4java.print_object_default_setters obj=conjObj varname="conj" indent=8 />     
${""?left_pad(indent)}  ${java.nameVariable(conjObj.name)}DataAccess.insert${java.nameType(conjObj.name)}(conj); 
      </#if>
    </#list>  
${""?left_pad(indent)}}
  </#list>
</#macro>

<#macro print_object_one2one_members obj existings>
  <#local existingDaos = {}>
  <#local existingServices = {}>
  <#list obj.attributes as attr>
    <#if !attr.type.custom || !attr.constraint.identifiable><#continue></#if>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#if !existings[refObj.name]??>
      <#local existings += {refObj.name: refObj}>
  @Autowired  
  ${java.nameType(refObj.name)}DataAccess ${java.nameVariable(refObj.name)}DataAccess;
      
  @Autowired  
  ${java.nameType(refObj.name)}Service ${java.nameVariable(refObj.name)}Service;
    </#if>
<@print_object_one2one_members obj=refObj existings=existings/>         
  </#list>
</#macro>

<#macro print_object_one2many_members obj existings>
  <#list obj.attributes as attr>
    <#if !attr.type.collection><#continue></#if>
    <#if !existings[attr.type.componentType.name]??>
      <#assign existings = existings + {attr.type.componentType.name:""}>
      
  @Autowired
  ${java.nameType(attr.type.componentType.name)}DataAccess ${java.nameVariable(attr.type.componentType.name)}DataAccess;

  @Autowired
  ${java.nameType(attr.type.componentType.name)}Service ${java.nameVariable(attr.type.componentType.name)}Service;
    </#if>
    <#assign collObj = model.findObjectByName(attr.type.componentType.name)>
    <#if collObj.isLabelled("value")>
      <#list collObj.attributes as collObjAttr>
        <#if !collObjAttr.type.custom || collObjAttr.type.name == obj.name><#continue></#if>
        <#assign collObjAttrRefObj = model.findObjectByName(collObjAttr.type.name)>
        <#if !existings[collObjAttrRefObj.name]??>
      
  @Autowired
  ${java.nameType(collObjAttrRefObj.name)}Service ${java.nameVariable(collObjAttrRefObj.name)}Service;
        </#if>
      </#list>
    </#if>
    <#if attr.isLabelled("conjunction") && !existings[attr.getLabelledOptions("conjunction")["name"]]??>
      <#assign conjname = attr.getLabelledOptions("conjunction")["name"]>
      <#assign existings += {conjname:""}>
    
  @Autowired
  ${java.nameType(conjname)}DataAccess ${java.nameVariable(conjname)}DataAccess;
  
  @Autowired
  ${java.nameType(conjname)}Service ${java.nameVariable(conjname)}Service;
    </#if>
  </#list> 
</#macro>

<#macro print_find_by_unique_name attrs>
<#list attrs as attr><#if attr?index != 0>And</#if>${java.nameType(attr.name)}</#list></#macro>

<#macro print_find_by_unique_parameters attrs>
<#list attrs as attr><#if attr?index != 0>,</#if>${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr)}</#list></#macro>

<#macro print_pom_dependencies deps indent>
  <#list deps as dep>
    <#if dep == "cachec@redis">
${""?left_pad(indent)}<dependency>
${""?left_pad(indent)}  <groupId>redis.clients</groupId>
${""?left_pad(indent)}  <artifactId>jedis</artifactId>
${""?left_pad(indent)}  <version>4.3.1</version>
${""?left_pad(indent)}</dependency>  
    <#elseif dep == "httpc@okhttp">
${""?left_pad(indent)}<dependency>
${""?left_pad(indent)}  <groupId>com.squareup.okhttp3</groupId>
${""?left_pad(indent)}  <artifactId>okhttp</artifactId>
${""?left_pad(indent)}  <version>3.14.2</version>
${""?left_pad(indent)}</dependency>      
    </#if>
  </#list>
</#macro>

<#--------------------->
<#-- 实体对象的保存操作 -->
<#--------------------->
<#macro print_object_entity_save obj indent proxy="">
  <#local idAttrs = modelbase.get_id_attributes(obj)>
${""?left_pad(indent)}${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])} = query.get${java.nameType(modelbase.get_attribute_sql_name(idAttrs[0]))}();
${""?left_pad(indent)}if (Strings.isBlank(${modelbase.get_attribute_sql_name(idAttrs[0])})) {
${""?left_pad(indent)}  ${modelbase.get_attribute_sql_name(idAttrs[0])} = IdGenerator.id();
${""?left_pad(indent)}  query.${modelbase4java.name_setter(idAttrs[0])}(${modelbase.get_attribute_sql_name(idAttrs[0])});
${""?left_pad(indent)}  existing = false;
${""?left_pad(indent)}}         
${""?left_pad(indent)}if (existing) {
${""?left_pad(indent)}  // 在传入了主键的情况下，也需要检查传入主键的有效性
${""?left_pad(indent)}  existing = ${java.nameVariable(obj.name)}DataAccess.isExisting${java.nameType(obj.name)}(${modelbase.get_attribute_sql_name(idAttrs[0])});
${""?left_pad(indent)}}
  <#if proxy?string != "" && proxy.name != obj.name>
${""?left_pad(indent)}${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query.to${java.nameType(obj.name)}Query());  
  <#else>
${""?left_pad(indent)}${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query);
  </#if>
${""?left_pad(indent)}if (!existing) {
<@print_object_default_setters obj=obj varname=java.nameVariable(obj.name) indent=8 /> 
${""?left_pad(indent)}  ${java.nameVariable(obj.name)}DataAccess.insert${java.nameType(obj.name)}(${java.nameVariable(obj.name)});
${""?left_pad(indent)}} else {
<@print_object_update_setters obj=obj varname=java.nameVariable(obj.name) indent=8 /> 
${""?left_pad(indent)}  ${java.nameVariable(obj.name)}DataAccess.updatePartial${java.nameType(obj.name)}(${java.nameVariable(obj.name)});      
${""?left_pad(indent)}}
</#macro>

<#macro print_object_entity_create obj indent>
  <#if obj.isLabelled("pivot") && obj.getLabelledOptions("pivot")["master"]??>
    <#local masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#local obj = masterObj>
  </#if>
  <#if !masterObj??><#return></#if>
  <#local idAttrs = modelbase.get_id_attributes(obj)>
${""?left_pad(indent)}${modelbase4java.type_attribute_primitive(idAttrs[0])} ${modelbase.get_attribute_sql_name(idAttrs[0])} = IdGenerator.id();
  <#if masterObj??>
${""?left_pad(indent)}${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query.to${java.nameType(obj.name)}Query());  
  <#else>
${""?left_pad(indent)}query.${name_setter(idAttrs[0])}(${modelbase.get_attribute_sql_name(idAttrs[0])});
${""?left_pad(indent)}${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query);
  </#if>
<@print_object_default_setters obj=obj varname=java.nameVariable(obj.name) indent=indent /> 
${""?left_pad(indent)}${java.nameVariable(obj.name)}DataAccess.insert${java.nameType(obj.name)}(${java.nameVariable(obj.name)});
</#macro>

<#macro print_object_entity_update obj indent>
  <#if obj.isLabelled("pivot") && obj.getLabelledOptions("pivot")["master"]??>
    <#local masterObj = model.findObjectByName(obj.getLabelledOptions("pivot")["master"])>
    <#local obj = masterObj>
  </#if>
  <#if !masterObj??><#return></#if>
  <#local idAttrs = modelbase.get_id_attributes(obj)>
  <#if masterObj??>
${""?left_pad(indent)}${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query.to${java.nameType(obj.name)}Query());  
  <#else>
${""?left_pad(indent)}${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query);
  </#if>
  <#list obj.attributes as attr>
    <#if attr.constraint.domainType.name == 'now'>
${""?left_pad(indent)}${java.nameVariable(obj.name)}.${name_setter(attr)}(new Timestamp(System.currentTimeMillis()));
    </#if>
  </#list>
${""?left_pad(indent)}${java.nameVariable(obj.name)}DataAccess.updatePartial${java.nameType(obj.name)}(${java.nameVariable(obj.name)});
</#macro>

<#--------------------->
<#-- 值体对象的保存操作 -->
<#--------------------->
<#macro print_object_value_save obj indent>       
${""?left_pad(indent)}existing = ${java.nameVariable(obj.name)}DataAccess.isExisting${java.nameType(obj.name)}(query);
${""?left_pad(indent)}${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query);
${""?left_pad(indent)}if (!existing) {
<@print_object_default_setters obj=obj varname=java.nameVariable(obj.name) indent=8 /> 
${""?left_pad(indent)}  ${java.nameVariable(obj.name)}DataAccess.insert${java.nameType(obj.name)}(${java.nameVariable(obj.name)});
${""?left_pad(indent)}} else {
<@print_object_update_setters obj=obj varname=java.nameVariable(obj.name) indent=8 />   
${""?left_pad(indent)}  ${java.nameVariable(obj.name)}DataAccess.update${java.nameType(obj.name)}(${java.nameVariable(obj.name)});      
${""?left_pad(indent)}}
</#macro>

<#macro print_object_value_create obj indent>       
${""?left_pad(indent)}${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query);
<@print_object_default_setters obj=obj varname=java.nameVariable(obj.name) indent=indent /> 
${""?left_pad(indent)}${java.nameVariable(obj.name)}DataAccess.insert${java.nameType(obj.name)}(${java.nameVariable(obj.name)});
</#macro>

<#macro print_object_value_update obj indent>       
${""?left_pad(indent)}${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query);
  <#list obj.attributes as attr>
    <#if attr.constraint.domainType.name == 'now'>
${""?left_pad(indent)}${java.nameVariable(obj.name)}.${name_setter(attr)}(new Timestamp(System.currentTimeMillis()));
    </#if>
  </#list>
${""?left_pad(indent)}${java.nameVariable(obj.name)}DataAccess.updatePartial${java.nameType(obj.name)}(${java.nameVariable(obj.name)});
</#macro>

<#--------------------->
<#-- 实体对象的读取操作 -->
<#--------------------->
<#macro print_object_persistence_read obj indent proxy="">
  <#local idAttrs = modelbase.get_id_attributes(obj)>
${""?left_pad(indent)}try {
  <#if proxy?string != "" && proxy.name != obj.name>
${""?left_pad(indent)}  results = ${java.nameVariable(obj.name)}DataAccess.select${java.nameType(obj.name)}(query.to${java.nameType(obj.name)}Query());
  <#else>
${""?left_pad(indent)}  results = ${java.nameVariable(obj.name)}DataAccess.select${java.nameType(obj.name)}(query);  
  </#if>
${""?left_pad(indent)}} catch (Throwable cause) {
${""?left_pad(indent)}  throw new ServiceException(500, cause);
${""?left_pad(indent)}}
${""?left_pad(indent)}if (results == null || results.size() == 0) {
${""?left_pad(indent)}  throw new ServiceException(404, "没有找到【${modelbase.get_object_label(obj)}】对象实例。");
${""?left_pad(indent)}}
${""?left_pad(indent)}if (results.size() > 1) {
${""?left_pad(indent)}  throw new ServiceException(400, "找到多个【${modelbase.get_object_label(obj)}】对象实例，请检查查询条件。");
${""?left_pad(indent)}}
${""?left_pad(indent)}result = results.get(0);
  <#if proxy?string == "">
  <#-- 说明不是衍生对象，采用原始的可持久化的对象 -->  
${""?left_pad(indent)}retVal = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(result);  
  </#if>
</#macro>


<#--------------------->
<#-- 元型扩展的读取操作 -->
<#--------------------->
<#macro print_object_meta_read obj indent>
<@print_object_persistence_read obj=obj indent=indent />
  <#local idAttr = modelbase.get_id_attributes(obj)[0]>
${""?left_pad(indent)}${java.nameType(obj.name)}MetaQuery metaQuery = new ${java.nameType(obj.name)}MetaQuery();
${""?left_pad(indent)}metaQuery.${name_setter(idAttr)}(query.${name_getter(idAttr)}());
${""?left_pad(indent)}List<Map<String,Object>> metas = ${java.nameVariable(obj.name)}MetaDataAccess.select${java.nameType(obj.name)}Meta(metaQuery);
${""?left_pad(indent)}for (Map<String,Object> meta : metas) {
  <#list obj.attributes as attr>
    <#if !attr.isLabelled("redefined")><#continue></#if>
${""?left_pad(indent)}  if ("${java.nameVariable(attr.name)}".equals(meta.get("propertyName"))) {
${""?left_pad(indent)}    retVal.set${java.nameType(attr.name)}(Safe.safe(meta.get("propertyValue"), ${modelbase4java.type_attribute_primitive(attr)}.class));
${""?left_pad(indent)}  }
  </#list>
${""?left_pad(indent)}}
</#macro>

<#--------------------->
<#-- 灵活扩展的读取操作 -->
<#--------------------->
<#macro print_object_extension_read obj indent>
  <#local idAttrs = modelbase.get_id_attributes(obj)>
  <#local extObjs = modelbase.get_extension_objects(obj)>
  <#list extObjs as extObjName, extRefAttr>
    <#assign extObj = extRefAttr.parent>
${""?left_pad(indent)}${java.nameType(extObjName)}Query ${java.nameVariable(extObjName)}Query = new ${java.nameType(extObjName)}Query();
${""?left_pad(indent)}${java.nameVariable(extObjName)}Query.set${java.nameType(modelbase.get_attribute_sql_name(extRefAttr))}(Safe.safe(query.get${java.nameType(modelbase.get_attribute_sql_name(idAttrs[0]))}(), ${modelbase4java.type_attribute_primitive(extRefAttr)}.class));
${""?left_pad(indent)}try {
${""?left_pad(indent)}  results = ${java.nameVariable(extObjName)}DataAccess.select${java.nameType(extObjName)}(${java.nameVariable(extObjName)}Query);
${""?left_pad(indent)}  if (results.size() == 1) {
${""?left_pad(indent)}    result = results.get(0);
${""?left_pad(indent)}    ${java.nameVariable(extObjName)}Query = ${java.nameType(extObjName)}QueryAssembler.assemble${java.nameType(extObjName)}Query(result);
    <#list obj.attributes as attr>
      <#list extObj.attributes as extObjAttr>
        <#if modelbase.get_attribute_sql_name(attr) == modelbase.get_attribute_sql_name(extObjAttr) && !attr.identifiable>
${""?left_pad(indent)}    retVal.set${java.nameType(modelbase.get_attribute_sql_name(attr))}(${java.nameVariable(extObjName)}Query.get${java.nameType(modelbase.get_attribute_sql_name(attr))}());   
        <#break>
      </#if>
    </#list>
  </#list>    
${""?left_pad(indent)}  }
${""?left_pad(indent)}} catch (Throwable cause) {
${""?left_pad(indent)}  throw new ServiceException(500, cause);
${""?left_pad(indent)}}
  </#list> 
</#macro>

<#--------------------->
<#-- 主键引用的读取操作 -->
<#--------------------->
<#macro print_object_one2one_read obj root indent>
  <#local rootObjIdAttr = modelbase.get_id_attributes(root)[0]>
  <#local idAttr = modelbase.get_id_attributes(obj)[0]>
  <#local refObj = model.findObjectByName(idAttr.type.name)>
  <#local refObjIdAttr = modelbase.get_id_attributes(refObj)[0]>
${""?left_pad(indent)}${java.nameType(refObj.name)}Query ${java.nameVariable(refObj.name)}Query = new ${java.nameType(refObj.name)}Query();
${""?left_pad(indent)}${java.nameVariable(refObj.name)}Query.${modelbase4java.name_setter(refObjIdAttr)}(query.${modelbase4java.name_getter(rootObjIdAttr)}());
${""?left_pad(indent)}try {
${""?left_pad(indent)}  results = ${java.nameVariable(refObj.name)}DataAccess.select${java.nameType(refObj.name)}(${java.nameVariable(refObj.name)}Query);
${""?left_pad(indent)}  if (results.size() == 1) {
${""?left_pad(indent)}    result = results.get(0);
${""?left_pad(indent)}    ${java.nameVariable(refObj.name)}Query = ${java.nameType(refObj.name)}QueryAssembler.assemble${java.nameType(refObj.name)}Query(result);
  <#list refObj.attributes as refObjAttr>
    <#if refObjAttr.identifiable><#continue></#if>
    <#local found = false>
    <#list root.attributes as attr>
      <#if attr.name == refObjAttr.name>
        <#local found = true>
        <#break>
      </#if>
    </#list>
    <#if !found>
      <#if refObjAttr.type.collection>
${""?left_pad(indent)}    retVal.get${java.nameType(modelbase.get_attribute_sql_name(refObjAttr))}().addAll(${java.nameVariable(refObj.name)}Query.get${java.nameType(modelbase.get_attribute_sql_name(refObjAttr))}());       
      <#else>
${""?left_pad(indent)}    retVal.set${java.nameType(modelbase.get_attribute_sql_name(refObjAttr))}(${java.nameVariable(refObj.name)}Query.get${java.nameType(modelbase.get_attribute_sql_name(refObjAttr))}());     
      </#if>
    </#if>
  </#list>    
${""?left_pad(indent)}  }
${""?left_pad(indent)}} catch (Throwable cause) {
${""?left_pad(indent)}  throw new ServiceException(500, cause);
${""?left_pad(indent)}}
  <#if refObjIdAttr.type.custom>
<@print_object_one2one_read obj=refObj root=root indent=indent />  
  </#if>
</#macro>

<#---------------------------->
<#-- 含有集合对象属性的读取操作 -->    
<#---------------------------->
<#macro print_object_one2many_read obj indent>
  <#local idAttrs = modelbase.get_id_attributes(obj)>
  <#list obj.attributes as attr>
    <#if !attr.type.collection><#continue></#if>
    <#local collObj = model.findObjectByName(attr.type.componentType.name)>
    <#local collObjIdAttrs = modelbase.get_id_attributes(collObj)>
    <#if collObjIdAttrs?size == 1><#continue></#if>
${""?left_pad(indent)}${java.nameType(attr.type.componentType.name)}Query ${modelbase4java.singularize_coll_attr(attr)}Query = new ${java.nameType(attr.type.componentType.name)}Query();
    <#list collObj.attributes as collObjAttr>
      <#if obj.name == collObjAttr.type.name>
${""?left_pad(indent)}${modelbase4java.singularize_coll_attr(attr)}Query.set${java.nameType(modelbase.get_attribute_sql_name(collObjAttr))}(query.get${java.nameType(modelbase.get_attribute_sql_name(idAttrs[0]))}());    
      </#if>
    </#list>
${""?left_pad(indent)}// 封装关联的【${modelbase.get_object_label(collObj)}】集合数据  
${""?left_pad(indent)}List<Map<String,Object>> ${java.nameVariable(attr.name)} = ${java.nameVariable(attr.type.componentType.name)}DataAccess.select${java.nameType(attr.type.componentType.name)}(${modelbase4java.singularize_coll_attr(attr)}Query);
${""?left_pad(indent)}for (Map<String,Object> row : ${java.nameVariable(attr.name)}) {
${""?left_pad(indent)}  retVal.get${java.nameType(attr.name)}().add(${java.nameType(collObj.name)}QueryAssembler.assemble${java.nameType(collObj.name)}Query(row));
${""?left_pad(indent)}}
    <#-- TODO:  -->  
    <#-- 规则1：如果集合对象是值域对象，则需要查找下一级的非父对象的引用对象的集合 -->
    <#-- 规则2（可能有BUG）：如果集合对象是实体对象，则需要通过属性中conjunction的定义，查找关联的实体对象集合 -->
    <#list collObj.attributes as collObjAttr>
      <#if !collObjAttr.type.custom || collObjAttr.type.name == obj.name><#continue></#if>
      <#assign collObjAttrRefObj = model.findObjectByName(collObjAttr.type.name)>
      <#assign collObjAttrRefObjIdAttr = modelbase.get_id_attributes(collObjAttrRefObj)[0]>
${""?left_pad(indent)}// 封装关联中明细的【${modelbase.get_object_label(collObjAttrRefObj)}】数据  
${""?left_pad(indent)}Set<${modelbase4java.type_attribute(collObjAttrRefObjIdAttr)}> ${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Ids = new HashSet<>();
${""?left_pad(indent)}for (Map<String,Object> row : ${java.nameVariable(attr.name)}) {
${""?left_pad(indent)}  ${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Ids.add((${modelbase4java.type_attribute(collObjAttrRefObjIdAttr)})row.get("${modelbase.get_attribute_sql_name(collObjAttrRefObjIdAttr)}"));
${""?left_pad(indent)}}
${""?left_pad(indent)}${java.nameType(collObjAttrRefObj.name)}Query ${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Query = new ${java.nameType(collObjAttrRefObj.name)}Query();
${""?left_pad(indent)}${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Query.setLimit(-1);
${""?left_pad(indent)}${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Query.get${java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(collObjAttrRefObjIdAttr)))}().addAll(${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Ids);
${""?left_pad(indent)}Pagination<${java.nameType(collObjAttrRefObj.name)}Query> ${java.nameVariable(attr.name)}${java.nameType(modelbase.get_object_plural(obj))} = ${java.nameVariable(collObjAttrRefObj.name)}Service.find${java.nameType(modelbase.get_object_plural(collObjAttrRefObj))}(${java.nameVariable(attr.name)}${java.nameType(collObjAttrRefObj.name)}Query);
${""?left_pad(indent)}for (${java.nameType(collObjAttrRefObj.name)}Query row : ${java.nameVariable(attr.name)}${java.nameType(modelbase.get_object_plural(obj))}.getData()) {
${""?left_pad(indent)}  for (${java.nameType(collObj.name)}Query innerRow : retVal.get${java.nameType(attr.name)}()) {
${""?left_pad(indent)}    if (innerRow.get${java.nameType(modelbase.get_attribute_sql_name(collObjAttrRefObjIdAttr))}().equals(row.get${java.nameType(modelbase.get_attribute_sql_name(collObjAttrRefObjIdAttr))}())) {
${""?left_pad(indent)}      innerRow.set${java.nameType(collObjAttr.name)}(row);
${""?left_pad(indent)}      break;
${""?left_pad(indent)}    }
${""?left_pad(indent)}  }
${""?left_pad(indent)}}
    </#list>
  </#list>
</#macro>

<#macro print_object_many2many_read obj indent>
  <#local idAttrs = modelbase.get_id_attributes(obj)>
  <#list obj.attributes as attr>
    <#if !attr.type.collection><#continue></#if>
    <#local collObj = model.findObjectByName(attr.type.componentType.name)>
    <#local collObjIdAttrs = modelbase.get_id_attributes(collObj)>
    <#if (collObjIdAttrs?size != 1)><#continue></#if>
${""?left_pad(indent)}${java.nameType(attr.type.componentType.name)}Query ${modelbase4java.singularize_coll_attr(attr)}Query = new ${java.nameType(attr.type.componentType.name)}Query();
    <#list collObj.attributes as collObjAttr>
      <#if obj.name == collObjAttr.type.name>
${""?left_pad(indent)}${modelbase4java.singularize_coll_attr(attr)}Query.set${java.nameType(modelbase.get_attribute_sql_name(collObjAttr))}(query.get${java.nameType(modelbase.get_attribute_sql_name(idAttrs[0]))}());    
      </#if>
    </#list>
${""?left_pad(indent)}// 封装关联的【${modelbase.get_object_label(collObj)}】集合数据  
${""?left_pad(indent)}List<Map<String,Object>> ${java.nameVariable(attr.name)} = ${java.nameVariable(attr.type.componentType.name)}DataAccess.select${java.nameType(attr.type.componentType.name)}(${modelbase4java.singularize_coll_attr(attr)}Query);
${""?left_pad(indent)}for (Map<String,Object> row : ${java.nameVariable(attr.name)}) {
${""?left_pad(indent)}  retVal.get${java.nameType(attr.name)}().add(${java.nameType(collObj.name)}QueryAssembler.assemble${java.nameType(collObj.name)}Query(row));
${""?left_pad(indent)}}
  </#list>
</#macro>

<#macro print_object_persistence_find obj indent proxy="">
  <#local varname = java.nameVariable(obj.name)>
  <#local typename = java.nameType(obj.name)>
  <#if proxy?string == "">
    <#local queryname = "query">
  <#else>  
    <#local queryname = java.nameVariable(obj.name) + "Query">
  </#if>
${""?left_pad(indent)}try {    
${""?left_pad(indent)}  if (${queryname}.getLimit() == -1) {
${""?left_pad(indent)}    results = ${varname}DataAccess.select${typename}(${queryname});
${""?left_pad(indent)}  } else {
${""?left_pad(indent)}    RowBounds rowBounds = new RowBounds(${queryname}.getStart(), ${queryname}.getLimit());
${""?left_pad(indent)}    results = ${varname}DataAccess.select${typename}(${queryname}, rowBounds);
${""?left_pad(indent)}  }
${""?left_pad(indent)}  total = ${varname}DataAccess.selectCountOf${typename}(${queryname});
${""?left_pad(indent)}} catch (Throwable cause) {
${""?left_pad(indent)}  throw new ServiceException(500, cause);
${""?left_pad(indent)}}
${""?left_pad(indent)}retVal.setTotal(total);
${""?left_pad(indent)}for (Map<String,Object> res : results) {
  <#if proxy?string == "">
${""?left_pad(indent)}  retVal.getData().add(${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(res));
  <#else>
${""?left_pad(indent)}  retVal.getData().add(${java.nameType(proxy.name)}QueryAssembler.assemble${java.nameType(proxy.name)}Query(res));
  </#if>
${""?left_pad(indent)}}
</#macro>

<#--------------------------------------->
<#-- 通用：集合属性的添加操作，触发观察者改变 -->
<#--------------------------------------->
<#macro print_attribute_observer_update obj attr indent>
  <#assign obAttr = modelbase.get_observer_for_attribute(obj, attr)>
  <#assign operator = obAttr.getLabelledOptions("observer")["operator"]>
  <#assign attrexpr = obAttr.getLabelledOptions("observer")["attribute"]>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  <#assign collObj = model.findObjectByName(attr.type.componentType.name)>
  <#assign collObjIdAttrs = modelbase.get_id_attributes(collObj)>
  <#assign collTargetAttr = attr.directRelationship.targetAttribute>
  <#if operator != "count">
    <#assign observableAttr = modelbase.get_observable_attribute(obj, attrexpr)>
  </#if>  
  <#if obAttr.type.custom>
    <#assign obAttrTypeObj = model.findObjectByName(obAttr.type.name)>
    <#assign objAttrTypeObjIdAttrs = modelbase.get_id_attributes(obAttrTypeObj)>
  </#if>
  <#if operator == "count">
${""?left_pad(indent)}if (query.${modelbase4java.name_getter(collObjIdAttrs[0])}() == null) {
${""?left_pad(indent)}  ${java.nameType(collObj.name)}Query ${java.nameVariable(collObj.name)}Query = new ${java.nameType(collObj.name)}Query();
${""?left_pad(indent)}  ${java.nameVariable(collObj.name)}Query.${modelbase4java.name_setter(idAttrs[0])}(query.${modelbase4java.name_getter(idAttrs[0])}());
${""?left_pad(indent)}  long total = ${java.nameVariable(collObj.name)}DataAccess.selectCountOf${java.nameType(collObj.name)}(${java.nameVariable(collObj.name)}Query);
${""?left_pad(indent)}  ${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = new ${java.nameType(obj.name)}();
${""?left_pad(indent)}  ${java.nameVariable(obj.name)}.set${java.nameType(idAttrs[0].name)}(query.${modelbase4java.name_getter(idAttrs[0])}());
${""?left_pad(indent)}  ${java.nameVariable(obj.name)}.set${java.nameType(obAttr.name)}(total);
${""?left_pad(indent)}  ${java.nameVariable(obj.name)}DataAccess.updatePartial${java.nameType(obj.name)}(${java.nameVariable(obj.name)});
${""?left_pad(indent)}}
  <#elseif operator == "max">
${""?left_pad(indent)}${java.nameType(obAttrTypeObj.name)}Query max${java.nameType(obAttr.name)} =  ${java.nameVariable(collObj.name)}DataAccess.selectMax${java.nameType(observableAttr.name)}(query);
${""?left_pad(indent)}${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = new ${java.nameType(obj.name)}();
${""?left_pad(indent)}${java.nameVariable(obj.name)}.set${java.nameType(idAttrs[0].name)}(query.${modelbase4java.name_getter(idAttrs[0])}());
${""?left_pad(indent)}if (max${java.nameType(obAttr.name)} != null) {
${""?left_pad(indent)}  ${java.nameVariable(obj.name)}.set${java.nameType(obAttr.name)}(${java.nameType(obAttrTypeObj.name)}Assembler.assemble${java.nameType(obAttrTypeObj.name)}FromQuery(max${java.nameType(obAttr.name)}));
${""?left_pad(indent)}} else {
${""?left_pad(indent)}  ${java.nameVariable(obj.name)}.set${java.nameType(obAttr.name)}(${java.nameType(obAttrTypeObj.name)}.NULL);
${""?left_pad(indent)}}
${""?left_pad(indent)}${java.nameVariable(obj.name)}DataAccess.updatePartial${java.nameType(obj.name)}(${java.nameVariable(obj.name)});
  <#elseif operator == "min">
${""?left_pad(indent)}Map<String,Object> min${java.nameType(obAttr.name)} =  ${java.nameVariable(collObj.name)}DataAccess.selectMin${java.nameType(observableAttr.name)}(query);
${""?left_pad(indent)}${java.nameType(obAttrTypeObj.name)}Query min${java.nameType(obAttr.name)} =  ${java.nameVariable(collObj.name)}DataAccess.selectMin${java.nameType(observableAttr.name)}(query);
${""?left_pad(indent)}${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = new ${java.nameType(obj.name)}();
${""?left_pad(indent)}${java.nameVariable(obj.name)}.set${java.nameType(idAttrs[0].name)}(query.${modelbase4java.name_getter(idAttrs[0])}());
${""?left_pad(indent)}if (min${java.nameType(obAttr.name)} != null) {
${""?left_pad(indent)}  ${java.nameVariable(obj.name)}.set${java.nameType(obAttr.name)}(${java.nameType(obAttrTypeObj.name)}Assembler.assemble${java.nameType(obAttrTypeObj.name)}FromQuery(min${java.nameType(obAttr.name)}));
${""?left_pad(indent)}} else {
${""?left_pad(indent)}  ${java.nameVariable(obj.name)}.set${java.nameType(obAttr.name)}(${java.nameType(obAttrTypeObj.name)}.NULL);
${""?left_pad(indent)}}
${""?left_pad(indent)}${java.nameVariable(obj.name)}DataAccess.updatePartial${java.nameType(obj.name)}(${java.nameVariable(obj.name)});
  </#if>  
</#macro>