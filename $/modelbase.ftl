<#function get_extension_objects obj>
  <#if !obj.isLabelled("extension")><#return {}></#if>
  <#local objsexpr = obj.getLabelledOptions("extension")["objects"]>
  <#local objexprs = objsexpr?split(";")>
  <#local ret = {}>
  <#list objexprs as objexpr>
    <#local objname = objexpr?substring(0,objexpr?index_of("("))>
    <#local attrname = objexpr?substring(objexpr?index_of("(")+1,objexpr?index_of(")"))>
    <#local extAttr = model.findAttributeByNames(objname,attrname)>
    <#local ret += {objname:extAttr}>
  </#list>
  <#return ret>
</#function>

<#--
 ### Gets programming language type name according to the given type.
 ### <p>
 ### And supports both collection and non-collection types.
 ###
 ### @param type
 ###      the type defined in jcommon-metabean framework
 ###
 ### @return
 ###      the programming language type name
 ###
 ### @see com.doublegsoft.jcommons.metabean.type.ObjectType
 #-->
<#function get_type_name type>
  <#if type.collection>
    <#return 'List<' + get_type_name(type.componentType) + '>'>
  </#if>
  <#if type.primitive>
    <#return typebase.typename(type, language, 'String')>
  <#elseif type.custom>
    <#return naming.nameType(type.name)>
  </#if>
  <#return 'String'>
</#function>

<#--
 ### Gets programming language primitive type name with respect to the given attribute.
 ### And if the attribute type is custom type, returns the identifiable attribute
 ### primitive type.
 ### <p>
 ### And supports both collection and non-collection types.
 ###
 ### @param attr
 ###        the attribute definition
 ###
 ### @return the programming language primitive type name
 ###
 ### @see com.doublegsoft.jcommons.metabean.type.ObjectType
 #-->
<#function get_attribute_primitive_type_name attr>
  <#assign type = attr.type>
  <#if type.collection>
    <#return 'List<' + get_type_name(type.componentType) + '>'>
  </#if>
  <#if type.primitive>
    <#return typebase.typename(type, language, 'String')>
  <#elseif type.custom>
    <#assign refObj = model.findObjectByName(type.name)!>
    <#assign refIdAttrs = get_id_attributes(refObj)>
    <#return typebase.typename(refIdAttrs[0].type, language, 'String')>
  </#if>
  <#return 'String'>
</#function>

<#--
 ### Gets sql alias name applied in sql statement.
 ###
 ### @param attr
 ###        the attribute definition
 ###
 ### @return the sql alias name for the attribute
 #-->
<#function get_attribute_sql_name attr>
  <#if attr == ''><#return 'UNKNOWN'></#if>
  <#local naming = java>
  <#if attr.name == 'id'>
    <#return naming.nameVariable(attr.parent.name) + 'Id'>
  </#if>
  <#if attr.type.custom && model??>
    <#assign refObj = model.findObjectByName(attr.type.name)!''>
    <#assign refObjIdAttrs = get_id_attributes(refObj)>
    <#if refObjIdAttrs?size == 0><#return naming.nameVariable(attr.type.name) + 'Id'></#if>
    <#if refObjIdAttrs[0].name?starts_with(refObj.name)>
      <#if refObjIdAttrs[0].name == refObj.name>
        <#return naming.nameVariable(refObjIdAttrs[0].name) + "Id">
      <#else>
        <#return naming.nameVariable(refObjIdAttrs[0].name)>
      </#if>
    </#if>
    <#assign alias = naming.nameVariable(refObj.name) + naming.nameType(refObjIdAttrs[0].name)>
    <#if alias?lower_case?index_of(naming.nameVariable(attr.name)?lower_case) != -1>
      <#return alias>
    <#else>
      <#return naming.nameVariable(attr.name) + naming.nameType(refObj.name) + naming.nameType(refObjIdAttrs[0].name)>
    </#if>
  </#if>
  <#if attr.name == 'code'>
    <#return naming.nameVariable(attr.parent.name) + 'Code'>
  </#if>
  <#if attr.name == 'name'>
    <#return naming.nameVariable(attr.parent.name) + 'Name'>
  </#if>
  <#if attr.name == 'type'>
    <#return naming.nameVariable(attr.parent.name) + 'Type'>
  </#if>
  <#if attr.name == 'text'>
    <#return naming.nameVariable(attr.parent.name) + 'Text'>
  </#if>
  <#if attr.name == 'group'>
    <#return naming.nameVariable(attr.parent.name) + 'Group'>
  </#if>
  <#if attr.type.primitive>
    <#return naming.nameVariable(attr.name)>
  </#if>
  <#return naming.nameVariable(attr.name)>
</#function>

<#--
 ### Gets html dom attribute name applied in dom statement.
 ###
 ### @param attr
 ###        the attribute definition
 ###
 ### @return the sql alias name for the attribute
 #-->
<#function get_attribute_html_name attr>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#assign refObjIdAttrs = get_id_attributes(refObj)>
    <#assign alias = refObj.name?replace('_', '-') + '-' + refObjIdAttrs[0].name?replace('_', '-')>
    <#if alias?lower_case?index_of(attr.name?replace('_', '-')) != -1>
      <#return alias>
    <#else>
      <#return attr.name?replace('_', '-') + refObj.name?replace('_', '-') + refObjIdAttrs[0].name?replace('_', '-')>
    </#if>
  </#if>
  <#if attr.name == 'id'>
    <#return attr.parent.name?replace('_', '-') + '-id'>
  </#if>
  <#if attr.name == 'code'>
    <#return attr.parent.name?replace('_', '-') + '-code'>
  </#if>
  <#if attr.name == 'name'>
    <#return attr.parent.name?replace('_', '-') + '-name'>
  </#if>
  <#if attr.name == 'type'>
    <#return attr.parent.name?replace('_', '-') + '-type'>
  </#if>
  <#if attr.name == 'text'>
    <#return attr.parent.name?replace('_', '-') + '-text'>
  </#if>
  <#if attr.name == 'group'>
    <#return attr.parent.name?replace('_', '-') + '-group'>
  </#if>
  <#if attr.type.primitive>
    <#return attr.name?replace('_', '-')>
  </#if>
  <#return attr.name?replace('_', '-')>
</#function>

<#--
 ### Gets sql alias name applied in sql statement for POSTGRESQL database.
 ###
 ### @see #get_attribute_sql_name
 #-->
<#function get_attribute_sql_name_postgresql attr>
  <#local ret = get_attribute_sql_name(attr)>
  <#return "\"" + ret + "\"">
</#function>

<#function get_attribute_sql_name_mysql attr>
  <#local ret = get_attribute_sql_name(attr)>
  <#return "`" + ret + "`">
</#function>

<#--
 ### Gets plain name for the attribute with its object name. 
 ### <p>
 ### And the name convention is the same to modelbase syntax.
 ###
 ### @param attr
 ###        the attribute definition
 ###
 ### @return the plain name for attribute with its object name
 #-->
<#function get_attribute_sql_plain_name attr>
  <#if attr.name == 'id'>
    <#return attr.parent.name + '_id'>
  </#if>
  <#if attr.name == 'code'>
    <#return attr.parent.name + '_code'>
  </#if>
  <#if attr.name == 'name'>
    <#return attr.parent.name + '_name'>
  </#if>
  <#if attr.name == 'type'>
    <#return attr.parent.name + '_type'>
  </#if>
  <#if attr.name == 'text'>
    <#return attr.parent.name + '_text'>
  </#if>
  <#if attr.type.primitive>
    <#return attr.name>
  </#if>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#assign refObjIdAttrs = get_id_attributes(refObj)>
    <#assign alias = refObj.name + '_' + refObjIdAttrs[0].name>
    <#if alias?lower_case?index_of(attr.name?lower_case) != -1>
      <#return alias>
    <#else>
      <#return attr.name + '_' + refObj.name + '_' + refObjIdAttrs[0].name>
    </#if>
  </#if>
  <#return attr.name>
</#function>

<#function get_object_sql_alias obj>
  <#assign lastIndex = obj.persistenceName?last_index_of('_')>
  <#if lastIndex == -1>
    <#return obj.persistenceName>
  </#if>
  <#local ret = obj.persistenceName?substring(lastIndex + 1)>
  <#if ret == "check">
    <#return "chk">
  </#if>
  <#return ret>
</#function>

<#function get_attribute_sql_initial_var attr>
  <#assign ret = get_attribute_sql_name(attr)>
  <#if attr.type.name == 'now' || attr.name == 'last_modified_time'>
    <#return 'current_timestamp'>
  <#elseif attr.type.name == 'state' || attr.name == 'state'>
    <#return "'E'">
  <#elseif attr.name == 'ordinal_position' || attr.name == 'sequence'>
    <#return "'0'">
  </#if>
  <#return '${' + ret + '}'>
</#function>

<#function get_attribute_sql_var attr>
  <#assign ret = get_attribute_sql_name(attr)>
  <#if attr.name == 'last_modified_time'>
    <#return 'current_timestamp'>
  </#if>
  <#return '${' + ret + '}'>
</#function>

<#--
 ### Gets json value for attribute.
 ###
 ### @param attr
 ###        the attribute definition
 ###
 ### @return the json value
 #-->
<#function get_attribute_json_value attr>
  <#assign Timestamp = statics['java.sql.Timestamp']>
  <#assign Date = statics['java.sql.Date']>
  <#if attr.constraint.domainType.name?contains('enum')>
    <#return '"' + tatabase.enumcode(attr.constraint.domainType.name) + '"'>
  <#elseif attr.constraint.domainType.name == 'id'>
    <#local val = tatabase.number(0,100)>
    <#local val = val?substring(0, val?index_of("."))>
    <#return val>
  <#elseif attr.constraint.domainType.name == 'json'>
    <#return '{}'>
  <#elseif attr.constraint.domainType.name == 'state'>
    <#return '"E"'>
  <#elseif attr.type.name == 'string'>
    <#return '"' + tatabase.string((attr.type.length!12)/4) + '"'>
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
  <#else>
    <#return '"123456"'>
  </#if>
</#function>

<#--
 ### Gets the implicit references defined in object definition.
 ###
 ### @since 20200504
 #-->
<#function get_object_implicit_references obj>
  <#local ret = {}>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('reference')>
      <#local name = attr.getLabelledOptions('reference')['name']>
      <#local value = attr.getLabelledOptions('reference')['value']>
      <#if !ret[name]??>
        <#local ret = ret + {name: {value: attr}}>
      <#else>
        <#local ref = ret[name]>
        <#local ref = ref + {value: attr}>
        <#local ret = ret + {name: ref}>
      </#if>
    </#if>
  </#list>
  <#return ret>
</#function>

<#function get_object_implicit_reference_as_argument implicitReference>
  <#local ret = ''>
  <#list implicitReference as value, attr>
    <#if ret != ''><#local ret = ret + ', '></#if>
    <#local ret = ret + 'String ' + get_attribute_sql_name(attr)>
  </#list>
  <#return ret>
</#function>

<#function get_object_implicit_reference_as_list_argument implicitReference>
  <#local ret = ''>
  <#list implicitReference as value, attr>
    <#if ret != ''><#local ret = ret + ', '></#if>
    <#local ret = ret + 'List<' + get_attribute_sql_name(attr) + '>'>
  </#list>
  <#return ret>
</#function>

<#--
 ### Gets type name for the object.
 ### <p>
 ### And Pays attention to the different naming between entity and value object.
 ###
 ### @param obj
 ###        the object definition
 ###
 ### @return
 ###        the programming language type name
 #-->
<#function type_object obj>
  <#if obj.isLabelled('entity')>
    <#return naming.nameType(obj.name)>
  <#elseif obj.isLabelled('value')>
    <#return naming.nameType(obj.alias)>
  </#if>
  <#return naming.nameType(obj.name)>
</#function>

<#--
 ### Converts array to  matrix.
 -->
<#function array_to_matrix arr cols>
  <#assign ret = []>
  <#assign row = []>
  <#list arr as item>
    <#if row?size == cols>
      <#assign ret = ret + [row]>
      <#assign row = []>
    </#if>
    <#assign row = row + [item]>
  </#list>
  <#if row?size != 0>
    <#assign ret = ret + [row]>
  </#if>
  <#return ret>
</#function>

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
    <#if language == 'objc'>
      <#return type_object(refObj) + '*'>
    </#if>
    <#return type_object(refObj)>
  <#elseif attr.type.name == 'json'>
    <#if language == 'java'>
      <#return 'Map<String, Object>'>
    <#elseif language == 'objc'>
      <#return 'NSString*'>
    </#if>
  <#elseif attr.type.primitive>
    <#return typebase.typename(attr.type.name, language, 'String')>
  <#elseif attr.type.collection>
    <#assign fakeAttr = {'type': attr.type.componentType}>
    <#if language == 'java'>
      <#return 'List<' + type_attribute(fakeAttr) + '>'>
    <#elseif language == 'objc'>
      <#return 'NSArray<' + type_attribute(fakeAttr) + '>*'>
    </#if>
  <#elseif attr.type.domain>
    <#assign exprDomain = attr.type.toString()>
    <#if exprDomain?index_of('&') == 0>
      <#assign refObj = model.findObjectByName(attr.type.name)>
      <#return type_object(refObj)>
    <#else>
      <#return typebase.typename(attr.type.name, language, 'String')>
    </#if>
  </#if>
  <#return typebase.typename(attr.type.name, language, 'String')>
</#function>

<#function type_attribute_primitive attr>
  <#if attr.type.primitive>
    <#return typebase.typename(attr.type.name, language, 'String')>
  <#elseif attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#return type_attribute_primitive(attr.directRelationship.targetAttribute)>
  <#elseif attr.type.domain>
    <#assign exprDomain = attr.type.toString()>
    <#if exprDomain?index_of('&') == 0>
      <#assign refObj = model.findObjectByName(attr.type.name)>
      <#return type_object(refObj)>
    <#else>
      <#return typebase.typename(attr.type.name, language, 'String')>
    </#if>
  </#if>
  <#stop attr.parent.name + '[' + attr.name + ']是集合函数，如果作为关联属性的基本类型，请检查模型。'>
</#function>

<#function name_variable any>
  <#if type.collection>
    <#return 'List<' + get_type_name(type.componentType) + '>'>
  </#if>
  <#if type.primitive>
    <#return typebase.typename(type, language, 'String')>
  <#elseif type.custom>
    <#return naming.nameType(type.name)>
  </#if>
</#function>

<#--
 ### Gets the named value from labelled options of the attribute.
 ### <pre>
 ### e.g. @xml(name='hello')
 ### </pre>
 ###
 ### @param attr
 ###        the attribute
 ###
 ### @param label
 ###        the label annotation, <pre>@xml</pre>
 ###
 ### @param name
 ###        the name defined in label properties
 ###
 ### @return
 ###        the named value if found, otherwise returns empty string
 #-->
<#function get_attribute_label_value attr label name>
  <#if !attr.isLabelled(label)>
    <#return ''>
  </#if>
  <#if attr.getLabelledOptions(label)[name]??>
    <#return attr.getLabelledOptions(label)[name]>
  </#if>
  <#return ''>
</#function>

<#--
 ### Gets the named value from labelled options of the object.
 ### <pre>
 ### e.g. @xml(name='hello')
 ### </pre>
 ###
 ### @param obj
 ###      the object
 ###
 ### @param label
 ###      the label annotation, <pre>@xml</pre>
 ###
 ### @param name
 ###      the name defined in label properties
 ###
 ### @return
 ###      the named value if found, otherwise returns empty string
 #-->
<#function get_object_label_value obj label name>
  <#if !obj.isLabelled(label)>
    <#return ''>
  </#if>
  <#if obj.getLabelledOptions(label)[name]??>
    <#return obj.getLabelledOptions(label)[name]>
  </#if>
  <#return ''>
</#function>

<#--
 ### TODO
 ###
 ### Gets the similar attribute in target object to the base attribute.
 ### <p>
 ### And could be labelled like below:
 ### <pre>
 ### @source(object='hello', attribute='world')
 ### </pre>
 ###
 ### @param base
 ###      the base attribute
 ###
 ### @param target
 ###      the label annotation, <pre>@xml</pre>
 ###
 ### @return
 ###      the similar attribute in target object
 #-->
<#function get_similar_attribute base target>
  <#assign objname = get_attribute_label_value(base, 'source', 'object')>
  <#assign attrname = get_attribute_label_value(base, 'source', 'attribute')>
  <#list target.attributes as attr>
    <#if attr.name?lower_case == base.name?lower_case>
      <#-- attribute name equals -->
      <#return attr>
    <#elseif attr.name?lower_case == attrname?lower_case>
      <#-- labelled value comparasion -->
      <#return attr>
    </#if>
  </#list>
  <#-- never return anything -->
</#function>

<#--
 ### Gets the single reference of the given attribute.
 ###
 ###
 #-->
<#function get_single_reference attr model>
  <#if !attr.type??>
    <#return null>
  </#if>
  <#assign typename = ''>
  <#if attr.type.class.name == 'com.doublegsoft.jcommons.metabean.type.CustomType'>
    <#assign typename = attr.type.name>
  </#if>
  <#if typename == ''>
    <#return null>
  </#if>
  <#assign ret = model.findObjectByName(typename)>
  <#return ret>
</#function>

<#--
 ### Gets the select sql api model expression with respect to the object definition.
 ###
 ### @param object
 ###        the object to generate sql api model
 ###
 ### @param model
 ###        the model definition
 ###
 ### @return the sql api model expression
 #-->
<#function get_attribute_default_value attr>
  <#if attr.type.collection>
    <#return 'new ArrayList<>()'>
  </#if>
  <#if attr.type.name == 'json'>
    <#return 'new HashMap<>()'>
  </#if>
  <#if attr.type.primitive && attr.constraint.defaultValue??>
    <#return get_language_default_value(attr.type, attr.constraint.defaultValue)>
  </#if>
  <#return ''>
</#function>

<#function get_language_default_value type defaultValue>
  <#assign val = defaultValue>
  <#if val?index_of("'") == 0>
    <#assign val = val?substring(1, val?length - 1)>
  </#if>
  <#if type.name == 'string'>
    <#return '"' + val + '"'>
  </#if>
  <#if type.name == 'now' || type.name == 'lmt'>
    <#return 'new Timestamp(System.currentMillisecond())'>
  </#if>
  <#if type.name == 'int' || type.name == 'integer'>
    <#return val>
  </#if>
  <#if type.name == 'long'>
    <#return 'val' + 'L'>
  </#if>
  <#if type.name == 'number'>
    <#return 'new BigDecimal("' + val + '")'>
  </#if>
  <#if type.name == 'bool'>
    <#return val>
  </#if>
  <#return 'null'>
</#function>

<#function get_command_attribute_default_value attr>
  <#assign command = attr.getParent()>
  <#assign objPersistenceName = command.getLabelledOptions('command')['object']!>
  <#assign attrPersistenceName = attr.getPersistenceName()!>
  <#if objPersistenceName == '' || attrPersistenceName == ''>
    <#return get_attribute_default_value(attr)>
  </#if>
  <#assign persistedAttr = model.findAttributeByPersistenceNames(objPersistenceName, attrPersistenceName)!>
  <#if persistedAttr == ''>
    <#return ''>
  </#if>
  <#return get_attribute_default_value(persistedAttr)>
</#function>

<#function get_query_attribute_default_value attr>
  <#assign query = attr.getParent()>
  <#assign objPersistenceName = query.getLabelledOptions('query')['object']!>
  <#assign attrPersistenceName = attr.getPersistenceName()!>
  <#if objPersistenceName == '' || attrPersistenceName == ''>
    <#return get_attribute_default_value(attr)>
  </#if>
  <#assign persistedAttr = model.findAttributeByPersistenceNames(objPersistenceName, attrPersistenceName)!>
  <#if persistedAttr == ''>
    <#return ''>
  </#if>
  <#return get_attribute_default_value(persistedAttr)>
</#function>

<#--
 ### Gets the select sql api model expression with respect to the object definition.
 ###
 ### @param object
 ###        the object to generate sql api model
 ###
 ### @param model
 ###        the model definition
 ###
 ### @return the sql api model expression
 #-->
<#function get_find_sql_api_model obj model>
  <#assign existing = {}>
  <#assign ret = 'find@' + obj.persistenceName?lower_case + '.query('>
  <#assign ret = ret + obj.persistenceName>
  <#list obj.attributes as attr>
    <#if attr.type.custom && attr.persistenceName??>
      <#assign other = model.findObjectByName(attr.type.name)>
      <#assign ret = ret + ' + ' + other.persistenceName?lower_case>
    </#if>
  </#list>
  <#-- 查询条件 -->
  <#assign ret = get_filter_sql_api_model(obj, ret)>
  <#list obj.attributes as attr>
    <#if attr.type.custom && attr.persistenceName??>
      <#assign other = model.findObjectByName(attr.type.name)>
      <#assign ret = get_filter_sql_api_model(other, ret)>
    </#if>
  </#list>
  <#-- 排序字段 -->
  <#list obj.attributes as attr>
    <#if attr.isLabelled('order')>
      <#assign ret = ret + ' ! ' + attr.persistenceName>
      <#if attr.getLabelledOptions('order')['asc']??>
        <#assign ret = ret + '^'>
      </#if>
      <#break>
    </#if>
  </#list>
  <#assign ret = ret + ')'>
  <#return ret>
</#function>

<#function get_filter_sql_api_model obj sqlExpr>
  <#assign ret = sqlExpr>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('query') && attr.persistenceName??>
      <#assign operator = attr.getLabelledOptions('query')['operator']!'='>
      <#if ret?contains(attr.persistenceName + operator)><#continue></#if>
      <#if !ret?contains('?')>
        <#assign ret = ret + ' ? ' + attr.persistenceName + operator>
      <#else>
        <#assign ret = ret + ', ' + attr.persistenceName + operator>
      </#if>
    </#if>
  </#list>
  <#return ret>
</#function>

<#--
 ### Checks the attribute is value attribute for its parent object.
 ###
 ### @param attr
 ###      the attribute
 ###
 ### @return
 ###      if yes return {@code true}, return {@code false}
 #-->
<#function is_value attr model>
  <#assign typename = attr.type.name>
  <#if model.findObjectByName(typename)??>
    <#assign found = model.findObjectByName(typename)>
    <#return found.isLabelled('value')>
  </#if>
  <#return false>
</#function>

<#--
 ### Checks the attribute is dictionary attribute for its parent object.
 ###
 ### @param attr
 ###      the attribute
 ###
 ### @return
 ###      if yes return {@code true}, return {@code false}
 #-->
<#function is_dictionary attr model>
  <#assign typename = attr.type.name>
  <#if model.findObjectByName(typename)??>
    <#assign found = model.findObjectByName(typename)>
    <#return found.isLabelled('dictionary')>
  </#if>
  <#return false>
</#function>

<#function is_enum attr model>
  <#assign typename = attr.type.name>
  <#if model.findObjectByName(typename)??>
    <#assign found = model.findObjectByName(typename)>
    <#return found.isLabelled('enum')>
  </#if>
  <#return false>
</#function>

<#function is_constant attr model>
  <#assign typename = attr.type.name>
  <#if model.findObjectByName(typename)??>
    <#assign found = model.findObjectByName(typename)>
    <#return found.isLabelled('constant')>
  </#if>
  <#return false>
</#function>

<#--
 ### Checks the attribute is parent object attribute for its parent object.
 ###
 ### @param attr
 ###      the attribute
 ###
 ### @return
 ###      if yes return {@code true}, return {@code false}
 #-->
<#function is_parent attr model>
  <#assign typename = attr.type.name>
  <#if model.findObjectByName(typename)??>
    <#assign found = model.findObjectByName(typename)>
    <#return found.name == attr.parent.name>
  </#if>
  <#return false>
</#function>

<#--
 ### Checks the attribute is base object attribute for its parent object.
 ###
 ### @param attr
 ###      the attribute
 ###
 ### @return
 ###      if yes return {@code true}, return {@code false}
 #-->
<#function is_base attr model>
  <#assign typename = attr.type.name>
  <#if model.findObjectByName(typename)??>
    <#assign found = model.findObjectByName(typename)>
    <#return found.isLabelled('base')>
  </#if>
  <#return false>
</#function>

<#--
 ### Checks the attribute is extension object attribute for its parent object.
 ###
 ### @param attr
 ###      the attribute
 ###
 ### @return
 ###      if yes return {@code true}, return {@code false}
 #-->
<#function is_extension attr model>
  <#assign typename = attr.type.name>
  <#if model.findObjectByName(typename)??>
    <#assign found = model.findObjectByName(typename)>
    <#return found.isLabelled('extension')>
  </#if>
  <#return false>
</#function>

<#--
 ### Gets the object getter statement.
 ###
 ### @param {string} getter_var
 ###      the object variable name to get
 ###
 ### @param {attribute} getter
 ###      the attribute to get
 ###
 ### @return the getter statement
 #-->
<#function get_object_get getter_var getter>
  <#return getter_var + '.get' + naming.nameType(getter.name) + '()'>
</#function>

<#--
 ### Gets the hash getter statement.
 ###
 ### @param {string} getter_var
 ###      the object variable name to get
 ###
 ### @param {attribute} getter
 ###      the attribute to get
 ###
 ### @return the getter statement
 #-->
<#function get_hash_get getter_var getter>
  <#return getter_var + '.get("' + naming.nameVariable(getter.name) + '")'>
</#function>

<#--
 ### Infers value conversion for setter and getter.
 ###
 ### @param setter
 ###      the attribute of setter
 ###
 ### @param getter
 ###      the attribute of getter
 ###
 ### @param getter_stmt
 ###      the getter statement
 ###
 ### @return
 ###      the conversion statement or null
 #-->
<#function infer_value_conversion setter getter getter_stmt>
  <#if setter.type.name == setter.type.name>
    <#return getter_stmt>
  <#elseif setter.type.custom>
    <#-- if custom type: not support in normal development design pattern -->
  <#elseif setter.type.name == 'string'>
    <#-- set(string) -->
    <#if getter.type.name == 'datetime'>
      <#return datetime_to_string(getter_stmt)>
    <#elseif getter.type.name == 'date'>
      <#return date_to_string(getter_stmt)>
    <#elseif getter.type.name == 'time'>
      <#--TODO: IMPLEMENT IT-->
    <#elseif getter.type.name == 'number'>
      <#return number_to_string(getter_stmt)>
    <#elseif getter.type.name == 'integer' || getter.type.name == 'int'>
      <#return integer_to_string(getter_stmt)>
    <#elseif getter.type.name == 'long'>
      <#return long_to_string(getter_stmt)>
    </#if>
  <#elseif setter.type.name == 'datetime'>
    <#-- set(datetime) -->
    <#if getter.type.name == 'string'>
      <#return string_to_datetime(getter_stmt)>
    </#if>
    <#if getter.type.name == 'long'>
      <#return long_to_datetime(getter_stmt)>
    </#if>
  <#elseif setter.type.name == 'date'>
    <#-- set(date) -->
    <#if getter.type.name == 'string'>
      <#return string_to_date(getter_stmt)>
    </#if>
    <#if getter.type.name == 'long'>
      <#return long_to_date(getter_stmt)>
    </#if>
  <#elseif setter.type.name == 'time'>
    <#--TODO: IMPLEMENT IT-->
  <#elseif setter.type.name == 'number'>
    <#if getter.type.name == 'string'>
      <#return string_to_number(getter_stmt)>
    </#if>
  <#elseif setter.type.name == 'integer' || setter.type.name == 'int'>
    <#-- set(integer) -->
    <#if getter.type.name == 'string'>
      <#return string_to_integer(getter_stmt)>
    </#if>
    <#if getter.type.name == 'long'>
      <#return long_to_integer(getter_stmt)>
    </#if>
  <#elseif setter.type.name == 'long'>
    <#-- set(long) -->
    <#if getter.type.name == 'string'>
      <#return string_to_long(getter_stmt)>
    </#if>
    <#if getter.type.name == 'integer' || getter.type.name == 'int'>
      <#return integer_to_long(getter_stmt)>
    </#if>
  </#if>
  <#return 'null'>
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
    <#if get_attribute_label(attr)?? && (length > get_attribute_label(attr)?length * 2 + 6)>
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

<#--#######################################-->
<#-- type value conversion utility functions. -->
<#--#######################################-->
<#function string_to_date varname>
  <#return 'Safe.safeDate(' + varname + ')'>
</#function>

<#function string_to_datetime varname>
  <#return 'Safe.safeTimestamp(' + varname + ')'>
</#function>

<#function string_to_number varname>
  <#return 'Safe.safeBigDecimal(' + varname + ')'>
</#function>

<#function string_to_integer varname>
  <#return 'Safe.safeInteger(' + varname + ')'>
</#function>

<#function string_to_long varname>
  <#return 'Safe.safeLong(' + varname + ')'>
</#function>

<#function date_to_string varname>
  <#return 'Safe.safeString(' + varname + ')'>
</#function>

<#function datetime_to_string varname>
  <#return 'Safe.safeString(' + varname + ')'>
</#function>

<#function number_to_string varname>
  <#return 'Safe.safeString(' + varname + ')'>
</#function>

<#function integer_to_string varname>
  <#return 'Safe.safeString(' + varname + ')'>
</#function>

<#function integer_to_long varname>
  <#return 'Safe.safeLong(' + varname + ')'>
</#function>

<#function long_to_string varname>
  <#return 'Safe.safeString(' + varname + ')'>
</#function>

<#function long_to_integer varname>
  <#return 'Safe.safeInteger(' + varname + ')'>
</#function>

<#function long_to_date varname>
  <#return 'Safe.safeDate(' + varname + ')'>
</#function>

<#function long_to_timestamp varname>
  <#return 'Safe.safeTimestamp(' + varname + ')'>
</#function>

<#--#######################################-->
<#-- number alrithmetic utility functions. -->
<#--#######################################-->
<#function number_add attr var num>
  <#if attr.type.name == 'number'>
    <#return var + ' = ' + var + '.add(new BigDecimal(' + num + '))'>
  <#elseif attr.type.name == 'long' || attr.type.name == 'integer' || attr.type.name == 'int'>
    <#return var + ' = ' + var + ' + ' + num>
  </#if>
  <#return ''>
</#function>

<#function number_subtract attr var num>
  <#if attr.type.name == 'number'>
    <#return var + ' = ' + var + '.subtract(new BigDecimal(' + num + '))'>
  <#elseif attr.type.name == 'long' || attr.type.name == 'integer' || attr.type.name == 'int'>
    <#return var + ' = ' + var + ' - ' + num>
  </#if>
  <#return ''>
</#function>

<#function number_multiply attr var num>
  <#if attr.type.name == 'number'>
    <#return var + ' = ' + var + '.multiply(new BigDecimal(' + num + '))'>
  <#elseif attr.type.name == 'long' || attr.type.name == 'integer'>
    <#return var + ' = ' + var + ' * ' + num>
  </#if>
  <#return ''>
</#function>

<#function number_divide attr var num>
  <#if attr.type.name == 'number'>
    <#return var + ' = ' + var + '.devide(new BigDecimal(' + num + '))'>
  <#elseif attr.type.name == 'long' || attr.type.name == 'integer' || attr.type.name == 'int'>
    <#return var + ' = ' + var + ' / ' + num>
  </#if>
  <#return ''>
</#function>

<#function number_assign attr var num>
  <#if attr.type.name == 'number'>
    <#return var + ' = ' + 'new BigDecimal(' + num + ')'>
  <#elseif attr.type.name == 'integer' || attr.type.name == 'int'>
    <#return var + ' = ' + num>
  <#elseif attr.type.name == 'long'>
    <#return var + ' = ' + num + 'L'>
  </#if>
  <#return ''>
</#function>

<#--
 ### Gets identifiable attributes of the any object.
 ### <p>
 ### And supports multiple identities.
 ###
 ### @param {object} obj
 ###      the object definition
 ###
 ### @return the identifiable attributes of object
 #-->
<#function get_id_attributes obj>
  <#local ret = []>
  <#list obj.attributes as attr>
    <#if attr.identifiable>
      <#local ret = ret + [attr]>
    </#if>
  </#list>
  <#if obj.isLabelled("pivot")>
    <#if !obj.getLabelledOptions("pivot")["master"]??>   
      <#local detailObj = model.findObjectByName(obj.getLabelledOptions("pivot")["detail"])>
      <#list obj.attributes as attr>
        <#list detailObj.attributes as detailAttr>
          <#if attr.name == detailAttr.name>
            <#local ret += [attr]>
            <#break>
          </#if>
        </#list>
      </#list>
    </#if>
  </#if>
  <#return ret>
</#function>

<#--
 ### Gets unique attributes of the any object.
 ### <p>
 ### And supports multiple identities.
 ###
 ### @param {object} obj
 ###      the object definition
 ###
 ### @return the unique attributes of object
 ###
 ### @deprecated
 #-->
<#function group_unique_attributes obj>
  <#local ret = []>
  <#-- TODO: 组合唯一 -->
  <#local groupUniqueAttrs = get_group_unique_attributes(obj)>
  <#if groupUniqueAttrs?size != 0>
    <#local ret = ret + [groupUniqueAttrs]>
  </#if>
  <#list obj.attributes as attr>
    <#if attr.constraint.unique>
      <#local ret = ret + [[attr]]>
    </#if>
  </#list>
  <#return ret>
</#function>

<#-- 
 ### 在对象数据中，组合表示单行数据的唯一性。
 ###
 ### @persistence(name="tn_abc_bcd" uniques="a,b")
 -->
<#function get_group_unique_attributes obj>
  <#if !obj.getLabelledOptions("persistence")["uniques"]??><#return []></#if>
  <#local str = obj.getLabelledOptions("persistence")["uniques"]>
  <#local strs = str?split(",")>
  <#local ret = []>
  <#list strs as s>
    <#local attr = model.findAttributeByNames(obj.name, s)>
    <#local ret += [attr]>
  </#list>
  <#return ret>
</#function>

<#--
 ### Gets identifiable attributes of the any object.
 ### <p>
 ### And supports multiple identities.
 ###
 ### @param {attribute} srcAttr
 ###        the source attribute
 ###
 ### @param {object} tgtObj
 ###        the target object in which find the reference attribute
 ###
 ### @return the found reference attribute or null
 #-->
<#function get_reference_attribute srcAttr tgtObj>
  <#if srcAttr.directRelationship?? && srcAttr.directRelationship.directTarget.name == tgtObj.name>
    <#return srcAttr.directRelationship.targetAttribute>
  </#if>
  <#return null>
</#function>

<#function get_reference_type_attribute obj name>
  <#list obj.attributes as attr>
    <#if attr.isLabelled("reference") && 
         attr.getLabelledOptions("reference")["name"] == name && 
         attr.getLabelledOptions("reference")["value"] == "type">
      <#return attr>
    </#if>     
  </#list>
</#function>

<#--
 ### Gets the arguments statement with the given attributes array.
 ### <p>
 ### And the arguments statement is applied in method invocation. like:
 ### <pre>
 ###   hello(world1, world2)
 ### </pre>
 ###
 ### @param {array} attrs
 ###      the attributes array
 ###
 ### @return the statement string
 #-->
<#function get_attributes_as_arguments attrs>
  <#assign ret = ''>
  <#list attrs as attr>
    <#if ret != ''>
      <#assign ret = ret + ', '>
    </#if>
    <#assign single = naming.nameVariable(attr.name)>
    <#assign ret = ret + single>
  </#list>
  <#return ret>
</#function>

<#function get_attributes_as_arguments2 attrs>
  <#assign ret = ''>
  <#list attrs as attr>
    <#if !attr.persistenceName??><#continue></#if>
    <#if ret != ''>
      <#assign ret = ret + ', '>
    </#if>
    <#assign single = naming.nameVariable(attr.persistenceName) + 'Ref'>
    <#assign ret = ret + single>
  </#list>
  <#return ret>
</#function>

<#--
 ### Gets the parameters statement with the given attributes array.
 ### <p>
 ### And the parameters statement is applied in method definition. like:
 ### <pre>
 ###   void hello(string world1, string world2)
 ### </pre>
 ###
 ### @param {array} attrs
 ###      the attributes array
 ###
 ### @return the statement string
 #-->
<#function get_attributes_as_parameters attrs>
  <#assign ret = ''>
  <#list attrs as attr>
    <#if ret != ''>
      <#assign ret = ret + ', '>
    </#if>
    <#if attr.type.custom>
      <#assign idAttrRef = get_id_attributes(attr.directRelationship.directTarget)[0]>
      <#assign single = typebase.typename(idAttrRef.type.name, language, 'String') + ' ' + naming.nameVariable(attr.name)>
    <#else>
      <#assign single = typebase.typename(attr.type.name, language, 'String') + ' ' + naming.nameVariable(attr.name)>
    </#if>
    <#assign ret = ret + single>
  </#list>
  <#return ret>
</#function>

<#function get_attributes_as_primitive_parameters attrs>
  <#assign ret = ''>
  <#list attrs as attr>
    <#if ret != ''>
      <#assign ret = ret + ', '>
    </#if>
    <#assign single = get_attribute_primitive_type_name(attr) + ' ' + naming.nameVariable(attr.name)>
    <#assign ret = ret + single>
  </#list>
  <#return ret>
</#function>

<#function get_attributes_as_sql_name_arguments attrs>
  <#assign ret = ''>
  <#list attrs as attr>
    <#if ret != ''>
      <#assign ret = ret + ', '>
    </#if>
    <#assign single = get_attribute_sql_name(attr)>
    <#assign ret = ret + single>
  </#list>
  <#return ret>
</#function>

<#function is_source_in_target source target>
  <#list target.attributes as attr>
    <#if attr.type.name == source.name>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#function get_conjunction ref1 ref2 model>
  <#list model.objects as obj>
    <#local count = 0>
    <#list obj.attributes as attr>
      <#if attr.type.name == ref1.name || attr.type.name == ref2.name>
        <#local count = count + 1>
      </#if>
    </#list>
    <#if count == 2 && obj.isLabelled('conjunction')>
      <#return obj>
    </#if>
  </#list>
</#function>

<#--
 ### Gets the attribute which its type is the destination object type.
 ###
 ### @param {array} attrs
 ###      the attributes array
 ###
 ### @param {object} dest
 ###      the desination object definition
 ###
 ### @return the statement string
 #-->
<#function match_custom_type_attribute attrs dest>
  <#list attrs as attr>
    <#if attr.type.name == dest.name>
      <#return attr>
    </#if>
  </#list>
</#function>

<#function match_attribute_object attr objs>
  <#list objs as obj>
    <#if obj.name == attr.type.name>
      <#return obj>
    </#if>
  </#list>
</#function>

<#function get_dependencies model>
  <#return []>
</#function>

<#function level_object_attributes obj>
  <#local image = []>
  <#local avatar = []>
  <#local accent = []>
  <#local primary = []>
  <#local secondary = []>
  <#local tertiary = []>
  <#local quaternary = []>
  <#local quinary = []>
  <#local senary = []>
  <#local septenary = []>
  <#local octanary = []>
  <#local nonary = []>
  <#local denary = []>
  <#local startDate = []>
  <#local dueDate = []>
  <#local startTime = []>
  <#local dueTime = []>
  <#list obj.attributes as attr>
    <#if (attr.getLabelledOptions("listable")["level"]!"") == "image">
      <#local image += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"") == "avatar">
      <#local avatar += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"") == "accent">
      <#local accent += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"") == "primary">
      <#local primary += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"") == "secondary">
      <#local secondary += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"") == "tertiary">
      <#local tertiary += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"") == "quaternary">
      <#local quaternary += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"") == "quinary">
      <#local quinary += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"") == "senary">
      <#local senary += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"") == "septanary">
      <#local septenary += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"") == "cotanary">
      <#local octanary += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"") == "nonary">
      <#local nonary += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"") == "denary">
      <#local denary += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"")?contains("startDate")>
      <#local startDate += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"")?contains("dueDate")>
      <#local dueDate += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"")?contains("startTime")>
      <#local startTime += [attr]>
    </#if>
    <#if (attr.getLabelledOptions("listable")["level"]!"")?contains("dueTime")>
      <#local dueTime += [attr]>
    </#if>
  </#list>
  <#local ret = {
    "image":image,
    "avatar":avatar,
    "accent":accent,
    "primary":primary,
    "secondary":secondary,
    "tertiary":tertiary,
    "quaternary":quaternary,
    "quinary":quinary,
    "senary":senary,
    "septenary":septenary,
    "octanary":octanary,
    "nonary":nonary,
    "denary":denary,
    "startDate":startDate,
    "dueDate":dueDate,
    "startTime":startTime,
    "dueTime":dueTime
  }>
  <#return ret>
</#function>

<#function get_object_name_attribute obj>
  <#list obj.attributes as attr>
    <#if attr.getLabelledOptions('name')['level']!'' == 'primary'>
      <#return attr>
    </#if>
  </#list>
  <#list obj.attributes as attr>
    <#if attr.name == 'text'>
      <#return attr>
    </#if>
  </#list>
  <#list obj.attributes as attr>
    <#if attr.name == 'name'>
      <#return attr>
    </#if>
  </#list>
</#function>

<#function has_value_object module model>
  <#list model.objects as obj>
    <#if obj.isLabelled('value') && !obj.isLabelled('generated')>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#function has_entity_object module model>
  <#list model.objects as obj>
    <#if obj.isLabelled('entity')>
      <#return true>
    </#if>
    <#if obj.isLabelled('constant')>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#function is_relative_to_target source target>
  <#list source.attributes as attr>
    <#if attr.type.custom && attr.type.name == target.name>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#function is_masterless_detail_reference_attribute attr>
  <#local obj = attr.parent>
  <#list model.objects as o>
    <#if o.isLabelled("pivot") && 
         !o.getLabelledOptions("pivot")["master"]?? &&
         o.getLabelledOptions("pivot")["detail"] == obj.name>
      <#list o.attributes as oattr>
        <#if oattr.name == attr.name && !is_attribute_system(oattr)>
          <#return true>
        </#if>  
      </#list>  
    </#if>  
  </#list>
  <#return false>
</#function>

<#function get_masterless_detail_reference obj>
  <#list model.objects as o>
    <#if o.isLabelled("pivot") && 
         !o.getLabelledOptions("pivot")["master"]?? &&
         o.getLabelledOptions("pivot")["detail"] == obj.name>
      <#return o>
    </#if>  
  </#list>
</#function>

<#function get_masterless_detail_id_attributes obj refObj>
  <#local ret = []>
  <#list refObj.attributes as attr>
    <#list obj.attributes as oattr>
      <#if attr.name == oattr.name>
        <#local ret += [attr]>
      </#if>
    </#list>
  </#list>
  <#return ret>
</#function>

<#function is_attribute_reference_id attr owner>
  <#if !attr.name?ends_with("_id")><#return false></#if>
  <#local strs = attr.name?split("_")>
  <#if strs?size != 2><#return false></#if>
  <#list owner.attributes as att>
    <#if att.name == strs[0] + '_type'>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#function is_attribute_reference_type attr owner>
  <#if !attr.name?ends_with("_type")><#return false></#if>
  <#local strs = attr.name?split("_")>
  <#if strs?size != 2><#return false></#if>
  <#list owner.attributes as att>
    <#if att.name == strs[0] + '_id'>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#function get_reference_attributes obj>
  <#local ret = {}>
  <#list obj.attributes as attr>
    <#if is_attribute_system(attr)><#continue></#if>
    <#if is_attribute_reference_id(attr, obj)>
      <#local ret = ret + {"refid": attr}>
      <#local ret = ret + {"name": attr.name?substring(0, attr.name?last_index_of("_"))}>
    </#if>
    <#if is_attribute_reference_type(attr, obj)>
      <#local ret = ret + {"reftype": attr}>
    </#if>
  </#list>
  <#return ret>
</#function>

<#function get_direct_attribute source target>
  <#local ret = {}>
  <#list source.attributes as attr>
    <#if attr.type.name == target.name>
      <#local ret = ret + {"attr": attr}>
    </#if>
  </#list>
  <#return ret>
</#function>

<#--
 ### Gets the attribute which its type is not the destination object type and is another
 ### custom type.
 ### <p>
 ### It is used to find another object in many-to-many (conjunction) style.
 ###
 ### @param {array} attrs
 ###      the attributes array
 ###
 ### @param {object} dest
 ###      the desination object definition
 ###
 ### @return the statement string
 #-->
<#function get_custom_another_attribute attrs dest>
  <#list attrs as attr>
    <#if attr.type.custom && attr.type.name?string != dest.name>
      <#return attr>
    </#if>
  </#list>
</#function>

<#--
 ### Gets the reference object of an attribute.
 -->
<#function get_reference_object attr model>
  <#if !attr.type??>
    <#return null>
  </#if>
  <#assign typename = ''>
  <#if attr.type.collection>
    <#assign typename = attr.type.componentType.name>
  <#elseif attr.type.custom>
    <#assign typename = attr.type.name>
  </#if>
  <#if typename == ''>
    <#return null>
  </#if>
  <#return model.findObjectByName(typename)>
</#function>

<#--
 ### Gets a labelled option value of an object.
 ### <p>
 ### Example:
 ### <pre>
 ###   @entity(role='configuration')
 ###   configuration<
 ###   >
 ### </pre>
 ### <p>
 ### Usage:
 ### <pre>
 ###   ${modelbase.get_object_labelled_option(obj, 'entity', 'role')!'default'}
 ### </pre>
 ###
 ### @since 2.0
 -->
<#function get_object_labelled_option obj label option>
  <#local ret = obj.getLabelledOptions(label)[option]!>
  <#if ret != ''>
    <#return ret>
  </#if>
</#function>

<#function get_attribute_labelled_option attr label option>
  <#local ret = attr.getLabelledOptions(label)[option]!>
  <#if ret != ''>
    <#return ret>
  </#if>
</#function>

<#function get_object_extension obj>
  <#return obj.getLabelledOptions('entity')['extension']!>
</#function>

<#function get_object_persistence_text obj>
  <#local ret = obj.getLabelledOptions('persistence')['text']!>
  <#if ret != ''>
    <#return ret>
  </#if>
  <#local ret = obj.getLabelledOptions('name')['label']!>
  <#return ret>
</#function>

<#function get_attribute_persistence_text attr>
  <#local ret = attr.getLabelledOptions('persistence')['text']!>
  <#if ret != ''>
    <#return ret>
  </#if>
  <#local ret = attr.getLabelledOptions('name')['label']!>
  <#return ret>
</#function>

<#--
 ### Gets the label of an object.
 ### <p>
 ### Priority:
 ### <pre>
 ###   @name(label='人员', singular='user', plural='users')
 ###   user<
 ###   >
 ### </pre>
 -->
<#function get_object_label obj>
  <#local ret = obj.getLabelledOptions('name')['label']!>
  <#if ret == ''>
    <#local ret = obj.getLabelledOptions('persistence')['text']!>
  </#if>
  <#return ret>
</#function>

<#function get_object_singular obj>
  <#local ret = obj.getLabelledOptions('name')['singular']!>
  <#return ret>
</#function>

<#function get_object_plural obj>
  <#local ret = obj.getLabelledOptions('name')['plural']!''>
  <#if ret == ''>
    <#local ret = obj.plural>
  </#if>
  <#if ret != ''>
    <#return ret>
  </#if>
  <#return inflector.pluralize(obj.name)>  
</#function>

<#function get_attribute_singular attr>
  <#if attr.getLabelledOptions('name')['singular']??>
    <#return attr.getLabelledOptions('name')['singular']>
  </#if>
  <#if attr.type.collection>
    <#return attr.type.componentType.name>
  </#if>
  <#return attr.name>
</#function>

<#function is_attribute_system attr>
  <#if attr.name == 'state'><#return true></#if>
  <#if attr.name == 'last_modified_time'><#return true></#if>
  <#if attr.name == 'created_time'><#return true></#if>
  <#if attr.name == 'modifier_id'><#return true></#if>
  <#if attr.name == 'modifier_type'><#return true></#if>
  <#if attr.isLabelled('reference')><#return true></#if>
  <#return false>
</#function>

<#function is_attribute_avatar attr>
  <#if attr.name == "avatar" || attr.type.name == "avatar" || attr.isLabelled("avatar")>
    <#return true>
  </#if>
  <#return false>
</#function>

<#function is_attribute_cover attr>
  <#if attr.name == "cover" || attr.type.name == "cover" || attr.isLabelled("cover")>
    <#return true>
  </#if>
  <#return false>
</#function>

<#function is_attribute_image attr>
  <#assign level = attr.getLabelledOptions("listable")["level"]!"">
  <#return level == "image">
</#function>

<#function is_attribute_primary attr>
  <#assign level = attr.getLabelledOptions("listable")["level"]!"">
  <#return level == "primary">
</#function>

<#function is_attribute_number attr>
  <#if attr.type.name == "int" || 
       attr.type.name == "integer" || 
       attr.type.name == "long" || 
       attr.type.name == "number" || 
       attr.type.name == "decimal">
    <#return true>
  </#if>
  <#return false>       
</#function>

<#function is_attribute_date attr>
  <#if attr.type.name == "date" || 
       attr.type.name == "datetime">
    <#return true>
  </#if>
  <#return false>       
</#function>

<#function is_attribute_enum attr>
  <#return attr.constraint.domainType.name?starts_with("enum")>
</#function>

<#function has_attribute_avatar obj>
  <#list obj.attributes as attr>
    <#if attr.name == "avatar" || attr.type.name == "avatar" || attr.isLabelled("avatar")>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#function has_attribute_cover obj>
  <#list obj.attributes as attr>
    <#if attr.name == "cover" || attr.type.name == "cover" || attr.isLabelled("cover")>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#function has_attribute_image obj>
  <#list obj.attributes as attr>
    <#if attr.name == "image" || attr.type.name == "image" || attr.isLabelled("image")>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#function get_object_primary obj>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('primary')>
      <#return attr>
    </#if>
  </#list>
</#function>

<#function get_object_secondary obj>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('secondary')>
      <#return attr>
    </#if>
  </#list>
</#function>

<#function get_object_tertiary obj>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('tertiary')>
      <#return attr>
    </#if>
  </#list>
</#function>

<#function get_object_quaternary obj>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('quaternary')>
      <#return attr>
    </#if>
  </#list>
</#function>

<#function get_object_quinary obj>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('quinary')>
      <#return attr>
    </#if>
  </#list>
</#function>

<#function get_object_image obj>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('image')>
      <#return attr>
    </#if>
  </#list>
</#function>

<#function get_object_avatar obj>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('avatar')>
      <#return attr>
    </#if>
  </#list>
</#function>

<#function get_object_when obj>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('when')>
      <#return attr>
    </#if>
  </#list>
</#function>

<#function get_object_whose obj>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('whose')>
      <#return attr>
    </#if>
  </#list>
</#function>

<#function get_object_who obj>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('who')>
      <#return attr>
    </#if>
  </#list>
</#function>

<#function get_object_whom obj>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('whom')>
      <#return attr>
    </#if>
  </#list>
</#function>

<#function get_object_status obj>
  <#list obj.attributes as attr>
    <#if attr.name == 'status'>
      <#return attr>
    </#if>
  </#list>
</#function>

<#function get_aggregate_root obj>
  <#list obj.attributes as attr>
    <#if attr.isLabelled('root')>
      <#return attr>
    </#if>
  </#list>
</#function>

<#function get_object_module obj>
  <#if obj.isLabelled("module")>
    <#if obj.getLabelledOptions("module")["name"]??>
      <#return obj.getLabelledOptions("module")["name"]>
    </#if>
  </#if>
  <#if obj.isLabelled('persistence')>
    <#local strs = obj.getLabelledOptions('persistence')['name']?split('_')>
    <#if strs?size == 1> 
      <#return strs[0]>
    <#else>  
  	  <#return strs[1]>
  	</#if>
  </#if>
  <#if obj.persistenceName??>
    <#local strs = obj.persistenceName?split('_')>
    <#if strs?size == 1> 
      <#return strs[0]>
    <#else>  
      <#return strs[1]>
    </#if>
  </#if>
  <#return 'UNKNOWN'>
</#function>

<#--
 ### Gets the singular name of an object.
 ### <p>
 ### Priority:
 ### <pre>
 ###   @name(label='人员', singular='user', plural='users')
 ###   student<
 ###     
 ###     @name(label='注册课程', singular='register_course')
 ###     register_courses: &student_course(course)[] 
 ###   >
 ### </pre>
 -->
<#function get_attribute_singular attr>
  <#local ret = attr.getLabelledOptions('name')['singular']!>
  <#if ret != ''>
    <#return ret>
  </#if>
  <#if attr.type.collection>
    <#return attr.type.componentType.name>
  </#if>
  <#return attr.name>
</#function>

<#function get_attribute_plural attr>
  <#local ret = attr.getLabelledOptions('name')['plural']!>
  <#if ret != ''>
    <#return ret>
  </#if>
  <#--  <#if attr.type.collection>
    <#return attr.name>
  </#if>
  <#stop attr.parent.name + '【' + attr.name + '】不是数组类型且没有定义复数名称'>   -->
  <#if attr.name == "status">
    <#return "statuses">
  </#if>
  <#return attr.name + "s">
</#function>

<#function get_attribute_plural_as_primitive attr>
  <#local ret = attr.getLabelledOptions('name')['plural']!>
  <#if ret != ''>
    <#return ret>
  </#if>
  <#--  <#if attr.type.collection>
    <#return attr.name>
  </#if>
  <#stop attr.parent.name + '【' + attr.name + '】不是数组类型且没有定义复数名称'>   -->
  <#if attr.name == "status">
    <#return "statuses">
  </#if>
  <#return get_attribute_sql_name(attr) + "s">
</#function>

<#--
 ### Gets the label of an attribute.
 ### <p>
 ### Example:
 ### <pre>
 ###   @name(label='人员', singular='user', plural='users')
 ###   user<
 ###     @name(label='用户名')
 ###     username: string
 ###  >
 ### </pre>
 -->
<#function get_attribute_label attr>
  <#assign ret = attr.getLabelledOptions('name')['label']!''>
  <#if ret == ''>
    <#assign ret = attr.getLabelledOptions('persistence')['text']!>
  </#if>
  <#return ret?replace('标识','')>
</#function>

<#function get_labelled_attribute obj label>
  <#list obj.attributes as attr>
    <#if attr.isLabelled(label)>
      <#return attr>
    </#if>
  </#list>
</#function>

<#--
 ### 
 ### <p>
 ### Example:
 ### <pre>

 ### </pre>
 -->
<#function get_o2o_attribute obj refTypeName>
  <#list obj.attributes as attr>
    <#if attr.type.custom && attr.type.name == refTypeName>
      <#return attr>
    </#if>
  </#list>
  <#assign error = '【' + obj.name + '】对象中未找到单一引用类型【' + refTypeName + '】的属性'>
  <#stop error>
</#function>

<#function get_o2m_attribute obj conjObj refTypeName>
  <#list conjObj.attributes as conjAttr>
    <#if attr.type.custom && attr.type.name == refTypeName>
      <#return attr>
    </#if>
  </#list>
  <#assign error = '【' + obj.name + '】对象中未找到单一引用类型【' + refTypeName + '】的属性'>
  <#stop error>
</#function>

<#function get_attribute_conjunction_name attr>
  <#return get_attribute_labelled_option(attr, 'persistence', 'conjunction')!>
</#function>

<#--
 ### Gets all references of an object, and groups them as one-to-one
 ### and one-to-many groups.
 ###
 ### SPECS:
 ###   1. o2m: cascade (treelike) entity
 ###   2. o2m: master + details = master + values
 ###   3. o2o: detail + master = master + value = master + master
 ###   4. m2m: master + conjunctions + masters = master + conjunctions + values
 -->
<#function group_object_references object model>
  <#local ret = {}>

  <#-- 实体访问库集合 -->
  <#local anyRefObjs = {}>

  <#local o2mRefAttrs = []>
  <#local o2mRefObjs = []>
  <#local o2mConjObjs = []>

  <#local o2oRefAttrs = []>
  <#local o2oRefObjs = []>

  <#-- 直接引用匹配 -->
  <#list object.attributes as attr>
    <#if attr.type.collection>
      <#local refObj = model.findObjectByName(attr.type.componentType.name)>
      <#local o2mRefAttrs  = o2mRefAttrs + [attr]>
      <#local o2mRefObjs   = o2mRefObjs + [refObj]>
      <#local o2mConjObjs  = o2mConjObjs + [model.findObjectByName(get_attribute_conjunction_name(attr))!]>
      <#local anyRefObjs = anyRefObjs + {refObj.name: refObj}>
    <#elseif attr.type.custom>
      <#local refObj = model.findObjectByName(attr.type.name)>
      <#local o2oRefAttrs = o2oRefAttrs + [attr]>
      <#local o2oRefObjs = o2oRefObjs + [refObj]>
      <#local anyRefObjs = anyRefObjs + {refObj.name: refObj}>
    </#if>
  </#list>

  <#local ret = ret + {'o2oRefAttrs': o2oRefAttrs}>
  <#local ret = ret + {'o2oRefObjs': o2oRefObjs}>

  <#local ret = ret + {'o2mRefAttrs': o2mRefAttrs}>
  <#local ret = ret + {'o2mRefObjs': o2mRefObjs}>
  <#local ret = ret + {'o2mConjObjs': o2mConjObjs}>

  <#local ret = ret + {'anyRefObjs': anyRefObjs}>
  <#return ret>
</#function>

<#--
 ### Gets the widget type in form.
 ### 
 ### @param attr
 ###        the attribute
 ###
 ### @return the widget type
 -->
<#function get_form_widget attr>
  <#if attr.constraint.identifiable>
    <#return 'hidden'>
  <#elseif attr.type.custom>
    <#return 'select'>
  <#elseif attr.type.name == 'enum'>
    <#return 'select'>
  <#elseif attr.type.name == 'date'>
    <#return 'date'>
  <#elseif attr.type.name == 'time'>
    <#return 'time'>
  <#elseif attr.type.name == 'bool'>
    <#return 'switch'>
  <#elseif attr.type.name == 'datetime'>
    <#return 'datetime'>
  <#elseif attr.constraint.domainType.toString()?index_of('enum') == 0>
    <#return 'select'>
  <#elseif attr.constraint.domainType.name?index_of('bool') == 0>
    <#return 'check'>
  <#elseif attr.type.name == 'string' && (attr.type.length >= 1000)>
    <#return 'longtext'>
  <#elseif attr.type.collection>
    <#return 'checklist'>
  <#else>
    <#return 'text'>
  </#if>
  <#return ''>
</#function>

<#--
 ### Gets the widget type in query.
 ### 
 ### @param attr
 ###        the attribute
 ###
 ### @return the widget type
 -->
<#function get_query_widget attr>
  <#if attr.constraint.domainType.name?index_of('enum') == 0 || attr.constraint.domainType.name?index_of('bool') == 0>
    <#return 'check'>
  </#if>
  <#return get_form_widget(attr)>
</#function>

<#--
 ### Gets the widget type in table cell.
 ### 
 ### @param attr
 ###        the attribute
 ###
 ### @return the widget type
 -->
<#function get_cell_widget attr>
  <#if attr.type.custom>
    <#return 'link'>
  <#else>
    <#return 'text'>
  </#if>
</#function>

<#function get_form_widget_count formWidgetModel>
  <#local ret = 0>
  <#list formWidgetModel.widgetModels as widgetModel>
    <#if widgetModel.class.simpleName == 'GroupingWidgetModel'>
      <#local ret = ret + widgetModel.primitiveWidgetModels?size>
    <#else>
      <#local ret = ret + 1>
    </#if>
  </#list>
  <#return ret>
</#function>

<#function url_to_page_name url>
  <#if !url??><#return "unnamed"></#if>
  <#if url?index_of("?") != -1>
    <#local url = url?substring(0, url?index_of("?"))>
  </#if>
  <#local strs = url?split('/')>
  <#local ret = ''>
  <#list strs as str>
    <#if (str?index < 2)><#continue></#if>
    <#if ret != ''><#local ret = ret + '_'></#if>
    <#local ret = ret + str>
  </#list>
  <#if ret == ''>
    <#local ret = url?replace("/", "_")>
  </#if>
  <#return ret>
</#function>

<#function url_to_page_url(url)>
  <#local strs = url?split('/')>
  <#local ret = ''>
  <#list strs as str>
    <#if (str?index < 1)><#continue></#if>
    <#if ret != ''><#local ret = ret + '/'></#if>
    <#local ret = ret + str>
  </#list>
  <#return ret>
</#function>

<#macro indent_formatted_text text indent>
  <#assign lines = text?split("\n")>
  <#list lines as line>
${''?left_pad(indent)}${line}
  </#list>
</#macro>

<#function get_field_name field>
  <#if field.name??>
    <#-- FIXME: CONVENTION -->
    <#return field.name>
  </#if>
  <#return field.title!'标题'>
</#function>

<#-- 打印代码，模版代码由数据库维护 -->
<#macro print_source_code platform framework language snippet component widget indent>
  <#assign key = platform + '-' + framework + '-' + language + '-' + snippet + '-' + component>
  <#if !databasedTemplates[key]??><#return></#if>
  <#assign templateSnippet = databasedTemplates[key]>
  <#assign template = templateSnippet.template>
  <#assign sourceCode = helper.printSnippet(template, widget, indent)>
  <#if sourceCode?trim != "">
${sourceCode?substring(0, sourceCode?length - 1)}
  </#if>
</#macro>

<#macro print_string_line_by_line text indent>
  <#assign lines = text?split('\n')>
  <#list lines as line>
${""?left_pad(indent)}${line}
  </#list>
</#macro>

<#function print_html_style style>
  <#local ret = "">
  <#if !style??><#return ret></#if>
  <#if style?is_string><#return style></#if>
  <#list style as key, val>
    <#if key == "padding" || key == "margin">
      <#local ret = ret + key + ":" + val["top"] + "px " + val["right"] + "px " + val["bottom"] + "px " + val["left"] + "px" + ";">
    <#else>
      <#local ret = ret + key + ":" + val + ";">
    </#if>
  </#list>
  <#return ret>
</#function>

<#function recurse_wrappers_from_wrapper wrapper>
  <#local ret = []>
  <#local ret = ret + [wrapper]>
  <#list wrapper.children![] as childWrapper>
    <#local ret = ret + recurse_wrappers_from_wrapper(childWrapper)>
  </#list>
  <#return ret>
</#function>

<#macro print_sql_select rootWrapper columns indent>
  <#local root = rootWrapper.object>
  <#local rootId = modelbase.get_id_attributes(root)[0]>
  <#local wrappers = recurse_wrappers_from_wrapper(rootWrapper)>
  <#list columns as column>
    <#list wrappers as wrapper>
      <#if wrapper?index == 0><#-- 忽略掉根封装对象，因为在主select中已经存在 --><#continue></#if>
      <#if wrapper.object.name != column.objectName><#continue></#if>
      <#if wrapper.object.getLabelledOptions("persistence")["array"] == "true"><#continue></#if>
      <#list wrapper.object.attributes as attr>
        <#if get_attribute_sql_name(attr) == js.nameVariable(column.fieldName)>
${""?left_pad(indent)}${get_object_sql_alias(wrapper.object)}.${attr.persistenceName} ${modelbase.get_attribute_sql_name(attr)},
          <#break>
        </#if>
      </#list>
    </#list>
  </#list>
${""?left_pad(indent)}0
</#macro>

<#--
 ### 这个逻辑很重要，重新理清楚。
 -->
<#macro print_sql_left_join rootWrapper indent>
  <#local root = rootWrapper.object>
  <#local rootId = modelbase.get_id_attributes(root)[0]>
  <#list rootWrapper.children as childWrapper>
    <#local found = false>
    <#local childObj = childWrapper.object>
    <#if childObj.getLabelledOptions("persistence")["array"] == "true"><#continue></#if>
    <#list childObj.attributes as attr>
      <#if attr.type.custom && attr.type.name == root.name>
        <#local found = true>
${""?left_pad(indent)}left join ${childObj.persistenceName} ${get_object_sql_alias(childObj)} on ${get_object_sql_alias(childObj)}.${attr.persistenceName} = ${get_object_sql_alias(root)}.${rootId.persistenceName}
      </#if>
    </#list>
    <#if !found>
      <#local childObjIdAttrs = modelbase.get_id_attributes(childObj)>
      <#if childObjIdAttrs?size == 1>
        <#--
         ### 【实体对象】直接关联
         -->
${""?left_pad(indent)}left join ${childObj.persistenceName} ${get_object_sql_alias(childObj)} on ${get_object_sql_alias(childObj)}.${childObjIdAttrs[0].persistenceName} = ${get_object_sql_alias(root)}.${rootId.persistenceName}
      <#else>
        <#--
         ### 【值域对象】，又是非直接关联，就找引用标识关联。
         -->
        <#list childObjIdAttrs as childObjIdAttr>
          <#if is_attribute_reference_id(childObjIdAttr, childObj)>
${""?left_pad(indent)}left join ${childObj.persistenceName} ${get_object_sql_alias(childObj)} on ${get_object_sql_alias(childObj)}.${childObjIdAttr.persistenceName} = ${get_object_sql_alias(root)}.${rootId.persistenceName}
            <#break>
          </#if>
        </#list>
      </#if>
    </#if>
<@print_sql_left_join rootWrapper=childWrapper indent=indent />
  </#list>
</#macro>

<#macro print_sql_and_condition rootWrapper paramColumns constantColumns indent>
  <#local root = rootWrapper.object>
  <#local rootId = modelbase.get_id_attributes(root)[0]>
  <#list rootWrapper.children as childWrapper>
    <#local found = false>
    <#local childObj = childWrapper.object>
    <#if childObj.getLabelledOptions("persistence")["array"] == "true"><#continue></#if>
    <#list childObj.attributes as attr>
      <#list paramColumns as paramColumn>
        <#if modelbase.get_attribute_sql_name(attr) == js.nameVariable(paramColumn["name"])>
${""?left_pad(indent)}and ${get_object_sql_alias(childObj)}.${attr.persistenceName} = '${r"${"}params${js.nameType(paramColumn.name)}${r"}"}'
        </#if>
      </#list>
      <#list constantColumns as constantColumn>
        <#if modelbase.get_attribute_sql_name(attr) == js.nameVariable(constantColumn["name"])>
${""?left_pad(indent)}and ${get_object_sql_alias(childObj)}.${attr.persistenceName} = '${constantColumn.constant!""}'
        </#if>
      </#list>
    </#list>
<@print_sql_and_condition rootWrapper=childWrapper paramColumns=paramColumns constantColumns=constantColumns indent=indent />
  </#list>
</#macro>

<#macro print_html_format html indent>
  <#local lines = html?split("\n")>
  <#list lines as line>
${""?left_pad(indent)}${line}
  </#list>
</#macro>

<#function get_view_from_url url>
  <#if url == ""><#return ""></#if>
  <#local ret = url?substring(0,1)>
  <#if ret == "@" || ret == "#" || ret == "%" || ret == "$">
    <#return ret>
  </#if>
  <#return "">
</#function>

<#--
 ### '@' 函数式
 ### '#' 覆盖页
 ### '%' 侧边页
 ### '$' 正常页
 ### '^' 弹出式（对话框）
 -->
<#function get_uri_from_url url>
  <#local indexOfParams = url?index_of("?")>
  <#local view = get_view_from_url(url)>
  <#if view == "@" || view == "#" || view == "%" || view == "$">
    <#if indexOfParams == -1>
      <#return url?substring(1)>
    </#if>
    <#return url?substring(1, indexOfParams)>
  </#if>
  <#if indexOfParams == -1>
    <#return url>
  </#if>
  <#return url?substring(0, indexOfParams)>
</#function>

<#function get_params_from_url url>
  <#local indexOfParams = url?index_of("?")>
  <#local ret = []>
  <#if indexOfParams == -1>
    <#return ret>
  </#if>
  <#local strParams = url?substring(indexOfParams + 1)>
  <#local params = strParams?split("&")>
  <#list params as param>
    <#local strs = param?split("=")>
    <#if strs?size == 1>
      <#local ret = ret + [{"name": strs[0]}]>
    <#else>
      <#local ret = ret + [{"name": strs[0], "value": strs[1]}]>
    </#if>
  </#list>
  <#return ret>
</#function>

<#function get_column_sql_name name type>
  <#return name>
</#function>

<#--
 ### Checks the given object is not referenced by any other objects as a 
 ### collection attribute.
 ###
 ### @param object
 ###        the object to check
 ###
 ### @return true or false
 #-->
<#function is_root_object obj>
  <#list model.objects as o>
    <#list o.attributes as attr>
      <#if attr.type.componentType?? && attr.type.componentType.name == obj.name>
        <#return false>
      </#if>
    </#list>
  </#list>
  <#return true>
</#function>

<#--
 ### Gets the original object from the given extended object.
 ###
 ### @param object
 ###        the object to check
 ###
 ### @return true or false
 #-->
<#function get_original_object_from_object_name objname>
  <#if objname?ends_with('_')>
    <#local origname = objname?substring(0, objname?length - 1)>
    <#return model.findObjectByName(origname)>
  </#if>
  <#return model.findObjectByName(objname)>
</#function>

<#--
 ### 检查对象中是否存在针对指定属性的“观察者”属性。
 ### <p>
 ### 该函数用于判断当前对象 (`obj`) 中，是否有一个属性被配置为“观察”另一个属性 (`attr`) 的变化。
 ### 这通常用于冗余数据维护场景，例如：父对象有一个 'count' 字段，需要观察子集合的 'add/remove' 动作。
 ###
 ### 逻辑流程 (Logic Flow):
 ### 1. 遍历当前对象 (`obj`) 的所有属性。
 ### 2. 筛选出带有 "observer" 标签的属性（即观察者属性）。
 ### 3. 读取 "observer" 标签中的 "attribute" 配置项（即被观察的目标表达式）。
 ### 4. 匹配检查：判断配置的目标表达式是否等于或以传入的属性名 (`attr.name`) 开头。
 ###    （支持 "items" 或 "items(price)" 这种嵌套表达式的匹配）。
 ###
 ### @param obj
 ###        包含潜在观察者属性的对象定义 (ObjectDefinition)
 ### @param attr
 ###        被观察的目标属性定义 (AttributeDefinition)
 ###
 ### @return
 ###        true 表示存在观察者，false 表示不存在
 -->
<#function has_observer_for_attribute obj attr>
  <#list obj.attributes as objAttr>
    <#if !objAttr.isLabelled("observer")><#continue></#if>
    <#local attrexpr = objAttr.getLabelledOptions("observer")["attribute"]>
    <#if attrexpr == attr.name || attrexpr?starts_with(attr.name)>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#--
 ### 获取针对指定属性的“观察者”属性定义对象。
 ### <p>
 ### 当 `has_observer_for_attribute` 返回 true 时，通常紧接着调用此函数。
 ### 它返回那个负责“观察”的属性定义，以便生成器读取其具体的聚合逻辑（如 count, sum, max 等）。
 ###
 ### 上下文示例:
 ### Order.totalPrice (观察者) 观察 Order.items (被观察者)。
 ### 调用 get_observer_for_attribute(Order, items) 将返回 totalPrice 的属性定义。
 ###
 ### @param obj
 ###        包含观察者属性的对象定义
 ### @param attr
 ###        被观察的目标属性定义
 ###
 ### @return
 ###        找到的观察者属性定义 (AttributeDefinition)，未找到则无返回值(null)
 -->
<#function get_observer_for_attribute obj attr>
  <#list obj.attributes as objAttr>
    <#if !objAttr.isLabelled("observer")><#continue></#if>
    <#local attrexpr = objAttr.getLabelledOptions("observer")["attribute"]>
    <#if attrexpr == attr.name || attrexpr?starts_with(attr.name)>
      <#return objAttr>
    </#if>
  </#list>
</#function>

<#--
 ### 解析“可观察属性表达式”，并获取目标属性的定义对象。
 ### <p>
 ### 该函数用于解析形如 "relationAttr(targetAttr)" 的字符串表达式，并返回
 ### 关联对象（或集合组件对象）中的目标属性定义。
 ###
 ### 表达式语法 (Syntax):
 ### "关联属性名(目标属性名)"
 ### 例如: 在 Order 对象中，表达式 "items(price)"
 ###   1. "items" 是 Order 的属性，指向 OrderItem 集合。
 ###   2. "price" 是 OrderItem 的属性。
 ###   3. 函数返回 OrderItem.price 的属性定义。
 ###
 ### 逻辑流程 (Logic Flow):
 ### 1. 语法检查: 确保表达式包含括号。
 ### 2. 字符串解析: 分离出当前对象的引用属性名 (objattrname) 和目标对象的属性名 (attrname)。
 ### 3. 属性查找: 遍历当前对象的属性列表，找到引用属性。
 ### 4. 类型路由:
 ###    - 如果是自定义类型 (1:1): 在引用的对象类型中查找目标属性。
 ###    - 如果是集合类型 (1:N): 在集合的组件类型中查找目标属性。
 ###
 ### @param obj
 ###        当前上下文对象定义 (ObjectDefinition)
 ### @param attrexpr
 ###        属性路径表达式字符串 (String)
 ###
 ### @return
 ###        目标属性的定义对象 (AttributeDefinition)，如果未找到则返回 null
 -->
<#function get_observable_attribute obj attrexpr>
  <#if attrexpr?contains("(") && attrexpr?ends_with(")")>
    <#local objattrname = attrexpr?substring(0,attrexpr?index_of("("))>
    <#local attrname = attrexpr?substring(attrexpr?index_of("(")+1,attrexpr?index_of(")"))>
    <#list obj.attributes as attr>
      <#if objattrname == attr.name>
        <#if attr.type.custom>
          <#return model.findAttributeByNames(attr.type.name, attrname)>
        <#elseif attr.type.collection>
          <#return model.findAttributeByNames(attr.type.componentType.name, attrname)>
        </#if>
      </#if>
    </#list>  
  </#if>
</#function>

<#-- 
 ### 获取图片的网络访问链接测试值
 -->
<#function test_image_path>
  <#local val = tatabase.number(1,113)>
  <#local val = val?substring(0, val?index_of("."))>
  <#return "https://raw.githubusercontent.com/doublegsoft/tatabase-image/refs/heads/main/1024x768/" + val?number?string["0000"] + ".jpg">
</#function>


<#-- 
 ### Counts the number of attributes in a given object that match a specific custom type name.
 ### 
 ### This is useful for determining if a specific import or dependency needs to be 
 ### generated multiple times or referenced in a specific way.
 ###
 ### @param obj      The source object (e.g., a Class or Entity) containing an 'attributes' list.
 ### @param typename The specific custom type name to search for (e.g., "UserAddress").
 ### @return         The total count of attributes matching the criteria.
 -->
<#function count_custom_occurrences obj typename>
  <#local count = 0>
  <#list obj.attributes as attr>
    <#if attr.type.custom && attr.type.name == typename>
      <#local count = count + 1>
    </#if>
  </#list>
  <#return count>
</#function>

<#--
 ### Checks if an attribute with the specified name exists in the given list of attributes.
 ###
 ### @param proxyAttrs
 ###        the list of attributes to check
 ###
 ### @param attrname
 ###        the name of the attribute to look for
 ###
 ### @return true if the attribute exists, false otherwise
 -->
<#function is_attribute_existing consolAttrs attr>
  <#list consolAttrs as consolAttr>
    <#if consolAttr.name == attr.name>
      <#return true>
    </#if>
  </#list>
  <#return false>
</#function>

<#--
 ### 递归聚合（扁平化）对象及其关联对象的属性信息。
 ### <p>
 ### 该函数用于构建一个包含当前对象及其下级引用对象（1:1）所有属性的扁平列表。
 ### 它通常用于生成“详情页 DTO”、“宽表结构”或“Excel 导出模型”，将层级结构拉平。
 ###
 ### 逻辑流程 (Logic Flow):
 ### 1. 初始化容器: 准备存放当前对象普通属性 (selfAttrs) 和引用属性 (customAttrs) 的列表。
 ### 2. 遍历与过滤:
 ###    - 跳过集合属性 (1:N, N:M)。
 ###    - 跳过系统属性 (如审计字段)。
 ###    - 跳过已存在的属性 (去重)。
 ### 3. 分类:
 ###    - 引用类型 (Custom): 放入 customAttrs，准备递归。
 ###    - 基本类型 (Primitive): 放入 selfAttrs，直接收集。
 ### 4. 合并: 将当前对象的基本属性加入结果集 (consolAttrs)。
 ### 5. 递归 (Recursion): 遍历 customAttrs，递归调用本函数，将子对象的属性也拉平加入结果集。
 ###    (注意: 代码中似乎包含了处理同名类型冲突的逻辑框架 `typeCount`)
 ###
 ### @param consolAttrs
 ###        当前已收集的属性累加列表 (Accumulator List)
 ### @param attrname
 ###        当前处理属性的上下文名称 (通常用作前缀，处理命名冲突)
 ### @param obj
 ###        当前正在处理的对象定义 (ObjectDefinition)
 ###
 ### @return
 ###        合并后的属性列表
 -->
<#function consolidate_info_attributes consolAttrs attrname obj>
  <#local selfAttrs = []>
  <#local customAttrs = []>
  <#list obj.attributes as attr>
    <#if attr.type.collection><#continue></#if>
    <#if is_attribute_system(attr)><#continue></#if>
    <#if is_attribute_existing(consolAttrs, attr)><#continue></#if>
    <#if attr.type.custom>
      <#local customAttrs += [{"name": modelbase.get_attribute_sql_name(attr), "attr": attr, "ref": attr.parent}]>
    <#else>
      <#local selfAttrs += [{"name": modelbase.get_attribute_sql_name(attr), "attr": attr}]>
    </#if>
  </#list>
  <#local consolAttrs += selfAttrs>
  <#list customAttrs as proxy>
    <#local attr = proxy.attr>
    <#if attr.type.custom>
      <#local typeCount = count_custom_occurrences(consolAttrs, attr.type.name)>
      <#local ret = consolidate_info_attributes(consolAttrs, proxy.name, refObj)>
      <#if typeCount != 0>
      <#else>
      </#if>
    <#else>
    </#if>
  </#list>
  <#return consolAttrs>
</#function>

<#--
 ### 判断对象是否为标准的“业务实体”（Entity）。
 ### <p>
 ### 在该模型定义中，“标准实体”被定义为拥有**单一主键**的对象。
 ### 这类对象通常对应数据库中的标准表，拥有一个独立的 ID 列（如 UUID 或自增 ID）。
 ###
 ### 逻辑流程 (Logic Flow):
 ### 1. 遍历对象属性。
 ### 2. 统计标记为“可标识”（identifiable/主键）的属性数量。
 ### 3. 判定：必须【主键数量 == 1】。
 ###
 ### @param obj
 ###        待检查的对象定义 (ObjectDefinition)
 ###
 ### @return
 ###        true 表示是标准单主键实体，false 表示是其他类型（如复合主键对象或无主键对象）
 -->
<#function is_object_entity obj>
  <#local idAttrCount = 0>
  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable>
      <#local idAttrCount = idAttrCount + 1>
    </#if>
  </#list>
  <#return idAttrCount == 1>
</#function>

<#--
 ### 判断对象是否为“值对象”或“带属性的关联实体”（Value Object / Association Entity）。
 ### <p>
 ### 此类对象通常具有以下特征：
 ### 1. **复合主键**：由两个或以上的主键组成（通常是外键组合）。
 ### 2. **包含业务数据**：除了主键外，至少包含一个非主键的业务属性。
 ###
 ### 区别说明：
 ### - 与【标准实体 (Entity)】的区别：它是多主键，不是单主键。
 ### - 与【纯中间表 (Conjunction)】的区别：它包含业务属性（如“分数”、“权重”），而纯中间表只包含主键。
 ###
 ### 逻辑流程 (Logic Flow):
 ### 1. 遍历属性，分别统计“主键属性”和“非主键属性”的数量。
 ### 2. 判定：必须满足【主键数 > 1】且【非主键数 != 0】。
 ###
 ### @param obj
 ###        待检查的对象定义 (ObjectDefinition)
 ###
 ### @return
 ###        true 表示是复合主键且带数据的对象，false 否则
 -->
<#function is_object_value obj>
  <#local idAttrCount = 0>
  <#local nonIdAttrCount = 0>
  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable>
      <#local idAttrCount = idAttrCount + 1>
    <#else>
      <#local nonIdAttrCount = nonIdAttrCount + 1>  
    </#if>
  </#list>
  <#return (idAttrCount > 1) && (nonIdAttrCount != 0)>
</#function>

<#--
 ### 判断对象是否为“纯关联中间表”（Pure Conjunction/Junction Object）。
 ### <p>
 ### “纯关联中间表”通常用于在关系型数据库中实现【多对多 (Many-to-Many)】关系。
 ### 它的结构特征是：
 ### 1. 由多个主键组成（通常也是指向两端实体的外键）。
 ### 2. 不包含任何非主键的业务属性（如备注、时间戳等）。
 ###
 ### 如果一个中间表包含业务属性（例如“选课时间”），则本函数返回 false，
 ### 这种情况下它通常被视为一个独立的业务实体，而非纯粹的关联。
 ###
 ### 逻辑流程 (Logic Flow):
 ### 1. 遍历对象的所有属性。
 ### 2. 统计主键属性 (identifiable) 的数量。
 ### 3. 统计非主键属性的数量。
 ### 4. 判定：必须满足【主键数 > 1】且【非主键数 == 0】。
 ###
 ### @param obj
 ###        待检查的对象定义 (ObjectDefinition)
 ###
 ### @return
 ###        true 表示是纯关联对象，false 表示是普通实体或带属性的关联实体
 -->
<#function is_object_conjunction obj>
  <#local idAttrCount = 0>
  <#local nonIdAttrCount = 0>
  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable>
      <#local idAttrCount = idAttrCount + 1>
    <#else>
      <#local nonIdAttrCount = nonIdAttrCount + 1>  
    </#if>
  </#list>
  <#return (idAttrCount > 1) && (nonIdAttrCount == 0)>
</#function>

<#--
 ### 判断指定属性是否为“瞬态”（Transient，即非持久化属性）。
 ### <p>
 ### “瞬态”属性是指那些存在于对象模型（内存/代码）中，但**不需要**映射到数据库表列的属性。
 ### 该函数的判断标准是：属性存在，且**缺少** 'persistence' 标签。
 ###
 ### 逻辑流程 (Logic Flow):
 ### 1. 对象解析 (Object Resolution): 在全局模型中收集所有与输入对象同名的定义。
 ### 2. 递归检查 (Recursive Check): 如果上下文存在 'extObjName'，则递归检查父类/扩展对象。
 ### 3. 属性遍历 (Attribute Inspection): 遍历对象的属性列表。
 ### 4. 标签校验 (Label Check): 如果属性名匹配且**未标记** 'persistence'，则返回 true。
 ###
 ### @param attrname
 ###        待检查的属性名称 (String)
 ### @param obj
 ###        包含该属性的对象定义
 ###
 ### @return
 ###        true 表示是瞬态属性（不持久化），false 表示是持久化属性
 -->
<#function is_attribute_transient attrname obj>
  <#local objs = []>
  <#list model.objects as o>
    <#if o.name == obj.name>
      <#local objs = objs + [o]>  
    </#if>
  </#list>
  <#if model.findObjectByName(extObjName)??>
    <#local extObj = model.findObjectByName(extObjName)>
    <#local retVal = is_attribute_transient(attrname, extObj)>
    <#if retVal><#return true></#if>
  </#if>
  <#list objs as o>
    <#list o.attributes as attr>
      <#if attr.name == attrname && !attr.isLabelled('persistence')>
        <#return true>
      </#if>
    </#list>
  </#list>
  <#return false>
</#function>  

<#--
 ### 获取集合属性的关联属性                       
 ###                                              
 ### 功能说明：                                  
 ### 当一个属性是集合类型时，获取该集合元素的关联属性 
 ###                                              
 ### 参数：                                      
 ### @param attr - 需要分析的属性对象            
 ###                                              
 ### 返回值：                                    
 ### @return 集合元素的关联属性对象              
 ###         - 如果domainType未指定关联字段，返回引用对象的ID属性 
 ###         - 如果domainType指定了关联字段，返回该字段属性对象
 ###                                              
 ### 应用场景：                                  
 ### 1. 一对多关系：Order.orderItems (集合)     
 ###    - 未指定：返回 OrderItem.id             
 ###    - 指定如 "OrderItem(orderId)"：返回 OrderItem.orderId 
 ###                                              
 ### 2. 多对多关系：User.roles (集合)           
 ###    - 未指定：返回 Role.id                  
 ###    - 指定如 "Role(roleCode)"：返回 Role.roleCode 
 ###                                              
 ### domainType 格式说明：                       
 ### - 简单格式："ObjectName"                   
 ###   使用引用对象的ID作为关联字段             
 ### - 完整格式："ObjectName(attributeName)"    
 ###   使用指定的attributeName作为关联字段      
 -->
<#function get_attribute_collection_attribute attr>
  <#if attr.type.collection>
    <#local refObj = model.findObjectByName(attr.type.componentType.name)>
    <#local domainType = attr.constraint.domainType?string>
    <#if !domainType?contains("(")>
      <#return get_id_attributes(refObj)?first>
    </#if>
    <#local attrname = domainType?substring(domainType?index_of("(") + 1, domainType?index_of(")"))>
    <#list refObj.attributes as refObjAttr>
      <#if refObjAttr.name == attrname>
        <#return refObjAttr>
      </#if>
    </#list>
  </#if>
</#function>