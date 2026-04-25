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
 -->
<#function type_attribute attr suffix="">
  <#if attr.type.class?? && attr.type.class.name?ends_with("ObjectDefinition")>
    <#return (java.nameType(attr.type.name) + suffix)>
  <#elseif attr.type.custom>
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
    <#local fakeAttr = {"type": attr.type.componentType}>
    <#return "List<" + type_attribute(fakeAttr) + ">">
  <#elseif attr.type.domain>
    <#local exprDomain = attr.type.toString()>
    <#if exprDomain?index_of("&") == 0>
      <#local refObj = model.findObjectByName(attr.type.name)>
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
  <#elseif attr.constraint.domainType?? && attr.constraint.domainType.name == "id">
    <#return "Long">  
  <#elseif attr.constraint.domainType?? && attr.constraint.domainType.name == "uuid">
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
    <#local dot = tatabase.number(0,100)?index_of(".")>
    <#local scale = attr.type.scale>
    <#return '"' + tatabase.number(0,100)?substring(0, dot) + '"'>
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
    <#local len = attr.type.length!2>
    <#if (len >= 100)>
      <#local len = len / 10>
    <#elseif (len >= 20)>
      <#local len = len / 5>
    <#elseif (len >= 10)>  
      <#local len = 4>
    <#else>
      <#local len = 2>
    </#if>
    <#return '"' + tatabase.string(len) + '"'>  
  <#else>
    <#return '"666666"'>
  </#if>
</#function>

<#function name_getter attr prefix="">
  <#return "get" + java.nameType(modelbase.get_attribute_sql_name(attr, prefix))>
</#function>

<#function name_setter attr prefix="">
  <#return "set" + java.nameType(modelbase.get_attribute_sql_name(attr, prefix))>
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
  <#if attr.constraint.defaultValue?? && attr.constraint.defaultValue == "now">
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
  <#elseif attr.type.custom>
    <#local refObj = model.findObjectByName(attr.type.name)>
    <#local refObjIdAttr = modelbase.get_id_attributes(refObj)?first>
    <#return get_attribute_default_value(refObjIdAttr)>
  </#if>
  <#return "null">
</#function>

<#macro print_object_default_setters obj varname indent>
  <#local commentPrinted = false>
  <#list obj.attributes as attr>
    <#if attr.name == "state">
${""?left_pad(indent)}if (${varname}.get${java.nameType(attr.name)}() == null && isCreating) {
${""?left_pad(indent)}  ${varname}.set${java.nameType(attr.name)}("E");
${""?left_pad(indent)}}
    <#elseif (attr.constraint.defaultValue!"") == "now">
${""?left_pad(indent)}if (${varname}.get${java.nameType(attr.name)}() == null && isCreating) {
${""?left_pad(indent)}  ${varname}.set${java.nameType(attr.name)}(new java.sql.Timestamp(System.currentTimeMillis()));
${""?left_pad(indent)}}    
    <#elseif attr.constraint.defaultValue??>
${""?left_pad(indent)}if (${varname}.get${java.nameType(attr.name)}() == null && isCreating) {
      <#if attr.type.custom>
        <#local refObj = model.findObjectByName(attr.type.name)>
        <#local refObjIdAttr = modelbase.get_id_attributes(refObj)?first>
${""?left_pad(indent)}  ${java.nameType(refObj.name)} ${java.nameVariable(refObj.name)} = new ${java.nameType(refObj.name)}();
${""?left_pad(indent)}  ${java.nameVariable(refObj.name)}.set${java.nameType(refObjIdAttr.name)}(${get_attribute_default_value(attr)});
${""?left_pad(indent)}  ${varname}.set${java.nameType(attr.name)}(${java.nameVariable(refObj.name)});        
      <#else>
${""?left_pad(indent)}  ${varname}.set${java.nameType(attr.name)}(${get_attribute_default_value(attr)});
      </#if>
${""?left_pad(indent)}}    
    <#elseif attr.name == "last_modified_time" || attr.constraint.domainType.name == "now">
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
${""?left_pad(indent)}if (${varname}.get${java.nameType(modelbase.get_attribute_sql_name(attr))}() == null && isCreating) {
${""?left_pad(indent)}  ${varname}.set${java.nameType(modelbase.get_attribute_sql_name(attr))}("E");
${""?left_pad(indent)}}
    <#elseif (attr.constraint.defaultValue!"") == "now">
${""?left_pad(indent)}if (${varname}.get${java.nameType(modelbase.get_attribute_sql_name(attr))}() == null && isCreating) {
${""?left_pad(indent)}  ${varname}.set${java.nameType(modelbase.get_attribute_sql_name(attr))}(new java.sql.Timestamp(System.currentTimeMillis()));
${""?left_pad(indent)}}    
    <#elseif attr.constraint.domainType.name == "now">
${""?left_pad(indent)}${varname}.set${java.nameType(modelbase.get_attribute_sql_name(attr))}(new java.sql.Timestamp(System.currentTimeMillis()));    
    <#elseif attr.constraint.defaultValue??>
${""?left_pad(indent)}if (${varname}.get${java.nameType(modelbase.get_attribute_sql_name(attr))}() == null && isCreating) {
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
<#macro print_object_query_members obj processedAttrs excludingColls=false prefix="">
  <#list obj.attributes as attr>
    <#if processedAttrs[modelbase.get_attribute_sql_name(attr, prefix)]??><#continue></#if>
    <#if attr.type.collection && excludingColls == false>

  /*!
  ** 【${modelbase.get_attribute_label(attr)}】
  */
  protected final List<${java.nameType(attr.type.componentType.name)}Query> ${inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix))} = new ArrayList<>();
  
  protected final Map<String,Object> in${java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix)))} = new HashMap<>();
    <#else>
      <#local attrname = modelbase.get_attribute_sql_name(attr, prefix)>
  
  /*!
  ** 【${modelbase.get_attribute_label(attr)}】
  */
  protected ${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr, prefix)};
  
  protected ${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr, prefix)}0;
  
  protected ${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr, prefix)}1;
    </#if>
    <#-- 需要集合属性作为查询条件的 -->
    <#if attr.constraint.identifiable ||
         attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum") ||
         modelbase.is_masterless_detail_reference_attribute(attr)> 
       
  protected final List<${modelbase4java.type_attribute_primitive(attr)}> ${inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix))} = new ArrayList<>();
    </#if>
    <#-- 引用对象需要作为结果的 -->
    <#if attr.type.custom>
      <#if processedAttrs[attr.name]??><#continue></#if>
    
  protected ${java.nameType(attr.type.name)}Query ${java.nameVariable(attr.name)};       
    </#if>
    <#if attr.type.name == "string" && !attr.type.custom && !attr.identifiable>
  
  protected ${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr, prefix)}2;
    </#if>
    <#local processedAttrs += {modelbase.get_attribute_sql_name(attr, prefix):attr}>
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
  <#-- 自定义对象作为主键，也就是一对一情况，或者是属性被标记为主动加载 -->
  <#list obj.attributes as attr>
    <#if attr.type.custom && (attr.constraint.identifiable || attr.isLabelled("eager"))>
      <#local refObj = model.findObjectByName(attr.type.name)>
      <#if attr.name == refObj.name>
<@print_object_query_members obj=refObj processedAttrs=processedAttrs excludingColls=true />       
      <#else>
<@print_object_query_members obj=refObj processedAttrs=processedAttrs excludingColls=true prefix=attr.name /> 
      </#if>
    </#if>
  </#list>  
</#macro>

<#-- Query Setters and Getters -->
<#macro print_object_query_xetters obj processedAttrs prefix="">
  <#list obj.attributes as attr>
    <#if processedAttrs[modelbase.get_attribute_sql_name(attr, prefix)]??><#continue></#if>
    <#if attr.type.collection>
    
  public List<${java.nameType(attr.type.componentType.name)}Query> get${java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix)))}() {
    return ${inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix))};
  }
  
  public Map<String,Object> getIn${java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix)))}() {
    return in${java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix)))};
  }
    <#else>
    
  public ${modelbase4java.type_attribute_primitive(attr)} get${java.nameType(modelbase.get_attribute_sql_name(attr, prefix))}() {
    return ${modelbase.get_attribute_sql_name(attr, prefix)};
  }
  
  public void set${java.nameType(modelbase.get_attribute_sql_name(attr, prefix))}(${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr, prefix)}) {
    this.${modelbase.get_attribute_sql_name(attr, prefix)} = ${modelbase.get_attribute_sql_name(attr, prefix)};
  }
  
  public ${modelbase4java.type_attribute_primitive(attr)} get${java.nameType(modelbase.get_attribute_sql_name(attr, prefix))}0() {
    return ${modelbase.get_attribute_sql_name(attr, prefix)}0;
  }
  
  public void set${java.nameType(modelbase.get_attribute_sql_name(attr, prefix))}0(${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr, prefix)}0) {
    this.${modelbase.get_attribute_sql_name(attr, prefix)}0 = ${modelbase.get_attribute_sql_name(attr, prefix)}0;
  }
  
  public ${modelbase4java.type_attribute_primitive(attr)} get${java.nameType(modelbase.get_attribute_sql_name(attr, prefix))}1() {
    return ${modelbase.get_attribute_sql_name(attr, prefix)}1;
  }
  
  public void set${java.nameType(modelbase.get_attribute_sql_name(attr, prefix))}1(${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr, prefix)}1) {
    this.${modelbase.get_attribute_sql_name(attr, prefix)}1 = ${modelbase.get_attribute_sql_name(attr, prefix)}1;
  }
    </#if>
    <#if attr.constraint.identifiable ||
         attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum") ||
         modelbase.is_masterless_detail_reference_attribute(attr)>
       
  public List<${modelbase4java.type_attribute_primitive(attr)}> get${java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix)))}() {
    return ${inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix))};
  }
  
  public void add${java.nameType(modelbase.get_attribute_sql_name(attr, prefix))}(${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr, prefix)}) {
    ${inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix))}.add(${modelbase.get_attribute_sql_name(attr, prefix)});
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
  
  public ${modelbase4java.type_attribute_primitive(attr)} get${java.nameType(modelbase.get_attribute_sql_name(attr, prefix))}2() {
    return ${modelbase.get_attribute_sql_name(attr, prefix)}2;
  }
  
  public void set${java.nameType(modelbase.get_attribute_sql_name(attr, prefix))}2(${modelbase4java.type_attribute_primitive(attr)} ${modelbase.get_attribute_sql_name(attr, prefix)}2) {
    this.${modelbase.get_attribute_sql_name(attr, prefix)}2 = ${modelbase.get_attribute_sql_name(attr, prefix)}2;
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
      <#if attr.name == refObj.name>
<@print_object_query_xetters obj=refObj processedAttrs=processedAttrs /> 
      <#else>
<@print_object_query_xetters obj=refObj processedAttrs=processedAttrs prefix=attr.name /> 
      </#if>
    </#if>
  </#list>
</#macro>

<#--  -->
<#macro print_object_query_to_query obj root prefix="">
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
        // ${attr.name} FIXME ${root.name} ${refObj.name}}
          <#if attr.name == refObj.name>
    retVal.${name_setter(refObjAttr)}(${name_getter(innerAttr)}());  
          <#else>
    retVal.${name_setter(refObjAttr)}(${name_getter(innerAttr, attr.name)}());    
          </#if>
          <#local found = true>  
          <#break>    
        </#if>
      </#list>
      <#if !found>
        <#if refObjAttr.type.collection>
    retVal.${name_getter(refObjAttr)}().addAll(${name_getter(refObjAttr, attr.name)}());        
        <#else>
    retVal.${name_setter(refObjAttr)}(${name_getter(refObjAttr, attr.name)}());    
        </#if>
      </#if>
    </#list>  
    return retVal;
  }
<@print_object_query_to_query obj=refObj root=root prefix=attr.name/>    
  </#list>  
</#macro>

<#macro print_object_query_to_map obj processedAttrs prefix="">
  <#list obj.attributes as attr>
    <#if processedAttrs[attr.name]??><#continue></#if>
    <#if attr.type.collection>
    if (!${inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix))}.isEmpty()) {
      retVal.put("${inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix))}", ${inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix))});
    }
    <#else>
      <#local attrtype = modelbase4java.type_attribute_primitive(attr)>
      <#if attrtype == "Long">
    if (${modelbase.get_attribute_sql_name(attr, prefix)} != null) {
      retVal.put("${modelbase.get_attribute_sql_name(attr, prefix)}", ${modelbase.get_attribute_sql_name(attr, prefix)});
    }
    if (${modelbase.get_attribute_sql_name(attr, prefix)}0 != null) {
      retVal.put("${modelbase.get_attribute_sql_name(attr, prefix)}0", ${modelbase.get_attribute_sql_name(attr, prefix)}0);
    }
    if (${modelbase.get_attribute_sql_name(attr, prefix)}1 != null) {
      retVal.put("${modelbase.get_attribute_sql_name(attr, prefix)}1", ${modelbase.get_attribute_sql_name(attr, prefix)}1);
    }  
      <#else>
    if (${modelbase.get_attribute_sql_name(attr, prefix)} != null) {
      retVal.put("${modelbase.get_attribute_sql_name(attr, prefix)}", ${modelbase.get_attribute_sql_name(attr, prefix)});
    }
    if (${modelbase.get_attribute_sql_name(attr, prefix)}0 != null) {
      retVal.put("${modelbase.get_attribute_sql_name(attr, prefix)}0", ${modelbase.get_attribute_sql_name(attr, prefix)}0);
    }
    if (${modelbase.get_attribute_sql_name(attr, prefix)}1 != null) {
      retVal.put("${modelbase.get_attribute_sql_name(attr, prefix)}1", ${modelbase.get_attribute_sql_name(attr, prefix)}1);
    }
      </#if>
    </#if>
    <#if attr.constraint.identifiable ||
         attr.type.custom ||
         attr.constraint.domainType.name?starts_with("enum")>
    if (!${inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix))}.isEmpty()) {
      retVal.put("${inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix))}", ${inflector.pluralize(modelbase.get_attribute_sql_name(attr, prefix))});
    }
    </#if>
    <#if attr.type.name == "string" && !attr.type.custom && !attr.identifiable>  
    if (${modelbase.get_attribute_sql_name(attr, prefix)}2 != null) {
      retVal.put("${modelbase.get_attribute_sql_name(attr, prefix)}2", ${modelbase.get_attribute_sql_name(attr, prefix)}2);
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
      <#if attr.name == refObj.name>
<@print_object_query_to_map obj=refObj processedAttrs=processedAttrs /> 
      <#else>
<@print_object_query_to_map obj=refObj processedAttrs=processedAttrs prefix=attr.name /> 
      </#if>
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
    <#local collAttr = modelbase.get_attribute_collection_attribute(attr)>
${""?left_pad(indent)}/*!
${""?left_pad(indent)}** 直接关联的【${modelbase.get_object_label(collObj)}】作为一对多显式扩展对象
${""?left_pad(indent)}*/
${""?left_pad(indent)}List<${java.nameType(attr.type.componentType.name)}Query> ${java.nameVariable(attr.name)} = query.get${java.nameType(attr.name)}();
${""?left_pad(indent)}// 查询已经存在的
${""?left_pad(indent)}${java.nameType(collObj.name)}Query existing${java.nameType(collObj.name)}Query = new ${java.nameType(collObj.name)}Query();
${""?left_pad(indent)}existing${java.nameType(collObj.name)}Query.set${java.nameType(modelbase.get_attribute_sql_name(collAttr))}(${modelbase.get_attribute_sql_name(idAttrs[0])});
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
${""?left_pad(indent)}    ${java.nameVariable(collObj.name)}Service.disable${java.nameType(collObj.name)}(${java.nameType(collObj.name)}QueryAssembler.assemble${java.nameType(collObj.name)}Query(row));
          <#local noState = true>
          <#break>
        </#if>
      </#list>
      <#if !noState>
${""?left_pad(indent)}    ${java.nameVariable(collObj.name)}Service.delete${java.nameType(collObj.name)}(${java.nameType(collObj.name)}QueryAssembler.assemble${java.nameType(collObj.name)}Query(row));
      </#if>
${""?left_pad(indent)}  }
${""?left_pad(indent)}}
    </#if>  
${""?left_pad(indent)}for (${java.nameType(collObj.name)}Query row : ${java.nameVariable(attr.name)}) {  
${""?left_pad(indent)}  row.set${java.nameType(modelbase.get_attribute_sql_name(collAttr))}(${modelbase.get_attribute_sql_name(idAttrs[0])});
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

<#-- TODO: 从数据库查出集合后比较，再决定哪些删除，哪些添加，同时还存在重新关联对象的保存操作 -->
<#macro print_object_many2many_save obj indent>
  <#local idAttr = modelbase.get_id_attributes(obj)?first>
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
    <#-- 排除一对多的情况，集合对象的属性中有一个是对象本身，则属于一对多 -->
    <#assign one2many = false>
    <#list collObj.attributes as collObjAttr>
      <#if collObjAttr.type.name == obj.name>
        <#assign one2many = true>
        <#break>
      </#if>
    </#list>
    <#if one2many><#continue></#if>
    <#-- 值域对象，也可能是多对多的关系，看@conjunction的定义 -->
    <#-- 关联对象 -->
    <#local conjObj = model.findObjectByName(attr.getLabelledOptions("conjunction")["name"])>
    <#-- 关联对象引用目标对象 -->
    <#local conjRefObj = model.findObjectByName(attr.type.componentType.name)>
    <#-- 关联对象引用目标对象的主键属性 -->
    <#local conjRefObjIdAttr = modelbase.get_id_attributes(conjRefObj)?first>
    <#-- 关联对象中引用本体的属性 -->
    <#if attr.getLabelledOptions("conjunction")["attribute"]??>
      <#assign conjObjRefAttr = model.findAttributeByNames(conjRefObj.name, attr.getLabelledOptions("conjunction")["attribute"])>
    <#else>
      <#list conjObj.attributes as conjObjAttr>
        <#if conjObjAttr.type.name == obj.name>
          <#assign conjObjRefAttr = conjObjAttr>
          <#break>
        </#if>
      </#list>  
    </#if>
${""?left_pad(indent)}/*!
${""?left_pad(indent)}**********************************************************************************
${""?left_pad(indent)}** 间接关联的【${modelbase.get_object_label(conjObj)}】作为一对多显式扩展对象
${""?left_pad(indent)}**********************************************************************************
${""?left_pad(indent)}*/
${""?left_pad(indent)}// 查询已经存在的【${modelbase.get_object_label(conjObj)}】数据
${""?left_pad(indent)}${java.nameType(conjObj.name)}Query existing${java.nameType(conjObj.name)}Query = new ${java.nameType(conjObj.name)}Query();
${""?left_pad(indent)}existing${java.nameType(conjObj.name)}Query.${name_setter(idAttr)}(${modelbase.get_attribute_sql_name(idAttr)});
${""?left_pad(indent)}List<Map<String,Object>> existing${java.nameType(conjObj.name)}Rows = ${java.nameVariable(conjObj.name)}DataAccess.select${java.nameType(conjObj.name)}(existing${java.nameType(conjObj.name)}Query);
${""?left_pad(indent)}List<${java.nameType(collObj.name)}Query> creating${java.nameType(collObj.name)}List = new ArrayList<>();
${""?left_pad(indent)}List<${java.nameType(collObj.name)}Query> inserting${java.nameType(collObj.name)}List = new ArrayList<>();
${""?left_pad(indent)}List<${java.nameType(collObj.name)}Query> deleting${java.nameType(collObj.name)}List = new ArrayList<>();
${""?left_pad(indent)}List<${java.nameType(attr.type.componentType.name)}Query> ${java.nameVariable(attr.name)} = query.get${java.nameType(attr.name)}();
${""?left_pad(indent)}for (${java.nameType(attr.type.componentType.name)}Query row : ${java.nameVariable(attr.name)}) {
${""?left_pad(indent)}  if (row.${name_getter(conjRefObjIdAttr)}() == null) {
${""?left_pad(indent)}    creating${java.nameType(collObj.name)}List.add(row);
${""?left_pad(indent)}    continue;
${""?left_pad(indent)}  }
${""?left_pad(indent)}  boolean found = false;
${""?left_pad(indent)}  for (Map<String,Object> existingRow : existing${java.nameType(conjObj.name)}Rows) {
${""?left_pad(indent)}    if (row.${name_getter(conjRefObjIdAttr)}().equals(existingRow.get("${modelbase.get_attribute_sql_name(conjObjRefAttr)}"))) {
${""?left_pad(indent)}      found = true;
${""?left_pad(indent)}      break;
${""?left_pad(indent)}    }
${""?left_pad(indent)}  }
${""?left_pad(indent)}  if (!found) {
${""?left_pad(indent)}    inserting${java.nameType(collObj.name)}List.add(row);
${""?left_pad(indent)}  } 
${""?left_pad(indent)}}
${""?left_pad(indent)}for (Map<String,Object> existingRow : existing${java.nameType(conjObj.name)}Rows) {
${""?left_pad(indent)}  boolean found = false;
${""?left_pad(indent)}  for (${java.nameType(attr.type.componentType.name)}Query row : ${java.nameVariable(attr.name)}) {
${""?left_pad(indent)}    if (row.${name_getter(conjRefObjIdAttr)}() == null ||
${""?left_pad(indent)}        row.${name_getter(conjRefObjIdAttr)}().equals(existingRow.get("${modelbase.get_attribute_sql_name(conjObjRefAttr)}"))) {
${""?left_pad(indent)}      found = true;
${""?left_pad(indent)}      break;
${""?left_pad(indent)}    }
${""?left_pad(indent)}  }
${""?left_pad(indent)}  if (!found) {
${""?left_pad(indent)}    ${java.nameType(attr.type.componentType.name)}Query deletingRow = new ${java.nameType(attr.type.componentType.name)}Query();
${""?left_pad(indent)}    deletingRow.${name_setter(conjRefObjIdAttr)}(Safe.safe(existingRow.get("${modelbase.get_attribute_sql_name(conjRefObjIdAttr)}"), ${modelbase4java.type_attribute_primitive(conjRefObjIdAttr)}.class));
${""?left_pad(indent)}    deleting${java.nameType(collObj.name)}List.add(deletingRow);
${""?left_pad(indent)}  } 
${""?left_pad(indent)}}
${""?left_pad(indent)}// 删除不存在的【${modelbase.get_object_label(conjObj)}】数据
${""?left_pad(indent)}if (!deleting${java.nameType(collObj.name)}List.isEmpty()) {
${""?left_pad(indent)}  ${java.nameType(conjObj.name)} deleting${java.nameType(conjObj.name)} = new ${java.nameType(conjObj.name)}();
${""?left_pad(indent)}  deleting${java.nameType(conjObj.name)}.set${java.nameType(conjObjRefAttr.name)}(${java.nameVariable(obj.name)});
${""?left_pad(indent)}  for (${java.nameType(attr.type.componentType.name)}Query row : deleting${java.nameType(collObj.name)}List) {
${""?left_pad(indent)}    ${java.nameType(attr.type.componentType.name)} ${java.nameVariable(attr.type.componentType.name)} = new ${java.nameType(attr.type.componentType.name)}();
${""?left_pad(indent)}    ${java.nameVariable(attr.type.componentType.name)}.set${java.nameType(conjRefObjIdAttr.name)}(row.${name_getter(conjRefObjIdAttr)}());
    <#list conjObj.attributes as conjObjAttr>
      <#if conjObjAttr.type.name == attr.type.componentType.name>
${""?left_pad(indent)}    deleting${java.nameType(conjObj.name)}.set${java.nameType(conjObjAttr.name)}(${java.nameVariable(attr.type.componentType.name)});
        <#break>
      </#if>
    </#list>
${""?left_pad(indent)}    ${java.nameVariable(attr.getLabelledOptions("conjunction")["name"])}DataAccess.disable${java.nameType(conjObj.name)}(deleting${java.nameType(conjObj.name)});
${""?left_pad(indent)}  }
${""?left_pad(indent)}}
${""?left_pad(indent)}// 创建新的【${modelbase.get_object_label(conjObj)}】数据并且建立关联关系
${""?left_pad(indent)}for (${java.nameType(attr.type.componentType.name)}Query row : creating${java.nameType(collObj.name)}List) {
${""?left_pad(indent)}  ${java.nameVariable(attr.type.componentType.name)}Service.save${java.nameType(attr.type.componentType.name)}(row);
${""?left_pad(indent)}  inserting${java.nameType(collObj.name)}List.add(row);
${""?left_pad(indent)}}
${""?left_pad(indent)}// 已经存在的【${modelbase.get_object_label(conjObj)}】数据建立关联关系
${""?left_pad(indent)}for (${java.nameType(attr.type.componentType.name)}Query row : inserting${java.nameType(collObj.name)}List) {
${""?left_pad(indent)}  ${java.nameType(conjObj.name)} conj = new ${java.nameType(conjObj.name)}();
    <#list conjObj.attributes as conjObjAttr>
      <#if conjObjAttr.type.name == obj.name>
${""?left_pad(indent)}  conj.set${java.nameType(conjObjAttr.name)}(${java.nameVariable(obj.name)});
      <#elseif conjObjAttr.type.name == collObj.name>
        <#local collObjIdAttr = modelbase.get_id_attributes(collObj)[0]>
${""?left_pad(indent)}  ${java.nameType(collObj.name)} conj${java.nameType(collObj.name)} = new ${java.nameType(collObj.name)}();
${""?left_pad(indent)}  conj${java.nameType(collObj.name)}.setId(row.${modelbase4java.name_getter(collObjIdAttr)}());
${""?left_pad(indent)}  conj.set${java.nameType(conjObjAttr.name)}(conj${java.nameType(collObj.name)});
      <#else>
      <#-- 允许值域对象作为连接对象，而值域对象存在其他属性，可能被其他实体对象携带，因为存在扩展模式 -->
        <#if modelbase.is_attribute_transient(conjObjAttr.name, obj)>
${""?left_pad(indent)}  conj.set${java.nameType(conjObjAttr.name)}(${java.nameVariable(obj.name)}.get${java.nameType(conjObjAttr.name)}());
        </#if>
        <#if modelbase.is_attribute_transient(conjObjAttr.name, collObj)>
${""?left_pad(indent)}  conj.set${java.nameType(conjObjAttr.name)}(row.get${java.nameType(conjObjAttr.name)}());
        </#if>
      </#if>
    </#list>
${""?left_pad(indent)}  ${java.nameType(conjObj.name)}.setDefaultValues(conj);   
${""?left_pad(indent)}  ${java.nameVariable(conjObj.name)}DataAccess.insert${java.nameType(conjObj.name)}(conj);     
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

<#--
 ### 生成处理“一对多”集合属性所需的依赖注入成员变量（@Autowired）。
 ### <p>
 ### 该宏遍历当前对象的所有集合属性，根据子对象的类型，自动生成所需的 DataAccess (DAO) 
 ### 和 Service 成员变量。它通过 `existings` 参数维护一个已注入列表，防止重复注入。
 ###
 ### 逻辑流程 (Logic Flow):
 ### 1. 初始化: 复制已存在的注入列表，用于当前作用域的去重检查。
 ### 2. 遍历属性: 仅处理集合类型 (Collection) 属性。
 ### 3. 注入子对象服务 (Direct Injection):
 ###    - 如果子对象类型尚未注入，生成对应的 DataAccess 和 Service 字段。
 ### 4. 注入孙级对象服务 (Deep Injection for Value Objects):
 ###    - 如果子对象被标记为 "value" (值对象/复合结构)，则进一步扫描子对象的属性。
 ###    - 如果子对象引用了其他实体 (孙级)，且该实体不是当前父对象本身，则注入孙级实体的 Service。
 ###      (场景：Order -> OrderItem(Value) -> Product，需注入 ProductService 以便校验或获取价格)。
 ### 5. 注入中间表服务 (Conjunction Injection):
 ###    - 如果属性标记为 "conjunction" (多对多)，则注入中间表的 DataAccess 和 Service。
 ### 6. 更新状态: 将本轮新增的注入项更新回 `existings` 变量。
 ###
 ### @param obj
 ###        当前父对象定义 (ObjectDefinition)
 ### @param existings
 ###        一个 Map，记录了已经生成过的变量名，用于去重
 -->
<#macro print_object_one2many_members obj existings>
  <#local existingObjs = {} + existings>
  <#list obj.attributes as attr>
    <#if !attr.type.collection><#continue></#if>
    <#if !existingObjs[attr.type.componentType.name]??>
      <#local existingObjs += {attr.type.componentType.name:""}>
      
  @Autowired // ${attr.type.componentType.name}
  ${java.nameType(attr.type.componentType.name)}DataAccess ${java.nameVariable(attr.type.componentType.name)}DataAccess;

  @Autowired
  ${java.nameType(attr.type.componentType.name)}Service ${java.nameVariable(attr.type.componentType.name)}Service;
    </#if>
    <#local collObj = model.findObjectByName(attr.type.componentType.name)>
    <#if modelbase.is_object_value(collObj)>
      <#list collObj.attributes as collObjAttr>
        <#if !collObjAttr.type.custom || collObjAttr.type.name == obj.name><#continue></#if>
        <#local collObjAttrRefObj = model.findObjectByName(collObjAttr.type.name)>
        <#if !existings[collObjAttrRefObj.name]??>
          <#local existings += {collObjAttrRefObj.name: collObjAttrRefObj}>
      
  @Autowired 
  ${java.nameType(collObjAttrRefObj.name)}Service ${java.nameVariable(collObjAttrRefObj.name)}Service;
        </#if>
      </#list>
    </#if>
    <#if attr.isLabelled("conjunction") && !existings[attr.getLabelledOptions("conjunction")["name"]]??>
      <#local conjname = attr.getLabelledOptions("conjunction")["name"]>
      <#local existingObjs += {conjname:""}>
    
  @Autowired
  ${java.nameType(conjname)}DataAccess ${java.nameVariable(conjname)}DataAccess;
  
  @Autowired
  ${java.nameType(conjname)}Service ${java.nameVariable(conjname)}Service;
    </#if>
  </#list> 
  <#assign existings = existingObjs>
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
  <#local objname = obj.name>
  <#-------------------------------------->
  <#-- 有可能是代理对象，类似于Pivot这种情况 -->
  <#-------------------------------------->
  <#if proxy != ""><#local objname = proxy.name></#if>
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
${""?left_pad(indent)}${java.nameType(objname)}Query.setDefaultValues(query, !existing);  
${""?left_pad(indent)}ValidationResult res = ${java.nameVariable(objname)}Validation.validate(query, !existing);
${""?left_pad(indent)}if (!res.isValid()) {
${""?left_pad(indent)}  throw new ServiceException(res.getCode(), res.getMessage());
${""?left_pad(indent)}}
  <#if proxy?string != "" && proxy.name != obj.name>
${""?left_pad(indent)}${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query.to${java.nameType(obj.name)}Query());  
  <#else>
${""?left_pad(indent)}${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query);
  </#if>
${""?left_pad(indent)}if (!existing) {
${""?left_pad(indent)}  ${java.nameVariable(obj.name)}DataAccess.insert${java.nameType(obj.name)}(${java.nameVariable(obj.name)});
${""?left_pad(indent)}} else {
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
${""?left_pad(indent)}${java.nameType(obj.name)}.setDefaultValues(${java.nameVariable(obj.name)});
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
${""?left_pad(indent)}${java.nameType(obj.name)}Query.setDefaultValues(query, !existing);
${""?left_pad(indent)}ValidationResult res = ${java.nameVariable(obj.name)}Validation.validate(query, !existing);
${""?left_pad(indent)}if (!res.isValid()) {
${""?left_pad(indent)}  throw new ServiceException(res.getCode(), res.getMessage());
${""?left_pad(indent)}}
${""?left_pad(indent)}${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query);
${""?left_pad(indent)}if (!existing) {
${""?left_pad(indent)}  ${java.nameVariable(obj.name)}DataAccess.insert${java.nameType(obj.name)}(${java.nameVariable(obj.name)});
${""?left_pad(indent)}} else {
${""?left_pad(indent)}  ${java.nameVariable(obj.name)}DataAccess.update${java.nameType(obj.name)}(${java.nameVariable(obj.name)});      
${""?left_pad(indent)}}
</#macro>

<#macro print_object_value_create obj indent>       
${""?left_pad(indent)}${java.nameType(obj.name)} ${java.nameVariable(obj.name)} = ${java.nameType(obj.name)}Assembler.assemble${java.nameType(obj.name)}FromQuery(query);
${""?left_pad(indent)}${java.nameType(obj.name)}.setDefaultValues(${java.nameVariable(obj.name)});
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
${""?left_pad(indent)}    result = results.get(0); // hello
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
${""?left_pad(indent)}    retVal.set${java.nameType(modelbase.get_attribute_sql_name(refObjAttr, rootObjIdAttr.name))}(${java.nameVariable(refObj.name)}Query.get${java.nameType(modelbase.get_attribute_sql_name(refObjAttr))}());     
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

<#--
 ### 生成一对多（One-to-Many）关联属性的读取逻辑。
 ### <p>
 ### 该宏负责根据父对象的 ID，查询并装配其下的子对象集合。
 ### 它包含两种装配策略以及针对嵌套依赖的性能优化。
 ###
 ### 逻辑流程 (Logic Flow):
 ### 1. 过滤 (Filter): 仅处理集合属性，且跳过标记为 'conjunction' (多对多中间表) 的属性。
 ### 2. 构建查询 (Query Setup): 创建子对象的 Query 对象，并将父对象的 ID 设置为子对象的查询条件 (外键关联)。
 ### 3. 初步装配 (Initial Assembly):
 ###    - 如果子对象是【单主键实体】: 循环调用子服务的 `read` 方法 (保证获取完整的领域实体，但有 N+1 风险)。
 ###    - 如果子对象是【复合主键/值对象】: 直接使用 `Assembler` 将 SQL 结果集转换为对象 (轻量高效)。
 ### 4. 深度抓取 (Deep Fetch - N+1 Optimization):
 ###    - 针对子对象中引用的【孙级对象】(自定义类型且非父对象本身)。
 ###    - 收集所有 ID 进行一次批量查询 (Batch Select)。
 ###    - 在内存中将孙级对象回填到子对象中 (In-Memory Join)。
 ###
 ### @param obj
 ###        父对象定义 (ObjectDefinition)
 ### @param indent
 ###        生成代码的缩进级别
 -->
<#macro print_object_one2many_read obj indent>
  <#local idAttrs = modelbase.get_id_attributes(obj)>
  <#list obj.attributes as attr>
    <#if !attr.type.collection><#continue></#if>
    <#if attr.isLabelled("conjunction")><#continue></#if>
    <#local collObj = model.findObjectByName(attr.type.componentType.name)>
    <#local collObjIdAttrs = modelbase.get_id_attributes(collObj)>
${""?left_pad(indent)}${java.nameType(attr.type.componentType.name)}Query ${modelbase4java.singularize_coll_attr(attr)}Query = new ${java.nameType(attr.type.componentType.name)}Query();
    <#------------------------------------------->
    <#-- 设置外键关联：子对象.parentId = 父对象.id -->
    <#------------------------------------------->
    <#list collObj.attributes as collObjAttr>
      <#if obj.name == collObjAttr.type.name>
${""?left_pad(indent)}${modelbase4java.singularize_coll_attr(attr)}Query.set${java.nameType(modelbase.get_attribute_sql_name(collObjAttr))}(query.get${java.nameType(modelbase.get_attribute_sql_name(idAttrs[0]))}());    
      </#if>
    </#list>
${""?left_pad(indent)}// 封装关联的【${modelbase.get_object_label(collObj)}】集合数据
${""?left_pad(indent)}List<Map<String,Object>> ${java.nameVariable(attr.name)} = ${java.nameVariable(attr.type.componentType.name)}DataAccess.select${java.nameType(attr.type.componentType.name)}(${modelbase4java.singularize_coll_attr(attr)}Query);
${""?left_pad(indent)}for (Map<String,Object> row : ${java.nameVariable(attr.name)}) {
    <#if collObjIdAttrs?size == 1>
${""?left_pad(indent)}  ${java.nameType(collObj.name)}Query readQuery = new ${java.nameType(collObj.name)}Query();
${""?left_pad(indent)}  readQuery.${modelbase4java.name_setter(collObjIdAttrs[0])}((${modelbase4java.type_attribute_primitive(collObjIdAttrs[0])})row.get("${modelbase.get_attribute_sql_name(collObjIdAttrs[0])}"));
${""?left_pad(indent)}  retVal.get${java.nameType(attr.name)}().add(${java.nameVariable(collObj.name)}Service.read${java.nameType(collObj.name)}(readQuery));    
    <#elseif (collObjIdAttrs?size > 1)>
${""?left_pad(indent)}  retVal.get${java.nameType(attr.name)}().add(${java.nameType(collObj.name)}QueryAssembler.assemble${java.nameType(collObj.name)}Query(row));
    </#if>
${""?left_pad(indent)}}
    <#----------------------------------------->
    <#-- [Deep Fetch] 开始处理深层嵌套引用的抓取 -->
    <#----------------------------------------->
    <#list collObj.attributes as collObjAttr>
      <#if collObjAttr.type.custom && collObjAttr.type.name != obj.name>
        <#local collObjAttrRefObj = model.findObjectByName(collObjAttr.type.name)>
        <#local collObjAttrRefObjIdAttr = modelbase.get_id_attributes(collObjAttrRefObj)[0]>
${""?left_pad(indent)}// 封装关联中明细的【${modelbase.get_object_label(collObjAttrRefObj)}】数据  
${""?left_pad(indent)}Set<${modelbase4java.type_attribute(collObjAttrRefObjIdAttr)}> ${java.nameVariable(collObjAttr.name)}Ids = new HashSet<>();
${""?left_pad(indent)}for (Map<String,Object> row : ${java.nameVariable(attr.name)}) {
${""?left_pad(indent)}  ${java.nameVariable(collObjAttr.name)}Ids.add((${modelbase4java.type_attribute(collObjAttrRefObjIdAttr)})row.get("${modelbase.get_attribute_sql_name(collObjAttrRefObjIdAttr)}"));
${""?left_pad(indent)}}
${""?left_pad(indent)}${java.nameType(collObjAttrRefObj.name)}Query ${java.nameVariable(collObjAttr.name)}Query = new ${java.nameType(collObjAttrRefObj.name)}Query();
${""?left_pad(indent)}${java.nameVariable(collObjAttr.name)}Query.setLimit(-1);
${""?left_pad(indent)}${java.nameVariable(collObjAttr.name)}Query.get${java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(collObjAttrRefObjIdAttr)))}().addAll(${java.nameVariable(collObjAttr.name)}Ids);
${""?left_pad(indent)}Pagination<${java.nameType(collObjAttrRefObj.name)}Query> ${java.nameVariable(collObjAttr.name)}${java.nameType(modelbase.get_object_plural(obj))} = ${java.nameVariable(collObjAttrRefObj.name)}Service.find${java.nameType(modelbase.get_object_plural(collObjAttrRefObj))}(${java.nameVariable(collObjAttr.name)}Query);
${""?left_pad(indent)}for (${java.nameType(collObjAttrRefObj.name)}Query row : ${java.nameVariable(collObjAttr.name)}${java.nameType(modelbase.get_object_plural(obj))}.getData()) {
${""?left_pad(indent)}  for (${java.nameType(collObj.name)}Query innerRow : retVal.get${java.nameType(attr.name)}()) {
${""?left_pad(indent)}    if (innerRow.get${java.nameType(modelbase.get_attribute_sql_name(collObjAttr))}().equals(row.get${java.nameType(modelbase.get_attribute_sql_name(collObjAttrRefObjIdAttr))}())) {
${""?left_pad(indent)}      innerRow.set${java.nameType(collObjAttr.name)}(row);
${""?left_pad(indent)}      break;
${""?left_pad(indent)}    }
${""?left_pad(indent)}  }
${""?left_pad(indent)}}
      </#if>
    </#list>
  </#list>
</#macro>

<#macro print_object_many2many_read obj indent>
  <#local idAttrs = modelbase.get_id_attributes(obj)>
  <#list obj.attributes as attr>
    <#if !attr.type.collection><#continue></#if>
    <#if !attr.isLabelled("conjunction")><#continue></#if>
    <#local conjObj = model.findObjectByName(attr.getLabelledOptions("conjunction")["name"])>
    <#local collObj = model.findObjectByName(attr.type.componentType.name)>
    <#local collObjIdAttrs = modelbase.get_id_attributes(collObj)>
    <#if collObjIdAttrs?size == 1><#continue></#if>
${""?left_pad(indent)}${java.nameType(attr.type.componentType.name)}Query ${modelbase4java.singularize_coll_attr(attr)}Query = new ${java.nameType(attr.type.componentType.name)}Query();
    <#list collObj.attributes as collObjAttr>
      <#if obj.name == collObjAttr.type.name>
${""?left_pad(indent)}${modelbase4java.singularize_coll_attr(attr)}Query.set${java.nameType(modelbase.get_attribute_sql_name(collObjAttr))}(query.get${java.nameType(modelbase.get_attribute_sql_name(idAttrs[0]))}());    
      </#if>
    </#list>
${""?left_pad(indent)}// 封装关联的【${modelbase.get_object_label(collObj)}】集合数据 world
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