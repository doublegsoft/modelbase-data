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
 ###      the attribute definition
 ###
 ### @return
 ###      the programming language primitive type name
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

<#function get_attribute_sql_name attr>
  <#if attr.name == 'id'>
    <#return naming.nameVariable(attr.parent.name) + 'Id'>
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
  <#if attr.type.primitive>
    <#return naming.nameVariable(attr.name)>
  </#if>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#assign refObjIdAttrs = get_id_attributes(refObj)>
    <#assign alias = naming.nameVariable(refObj.name) + naming.nameType(refObjIdAttrs[0].name)>
    <#if alias?lower_case?index_of(naming.nameVariable(attr.name)?lower_case) != -1>
      <#return alias>
    <#else>
      <#return naming.nameVariable(attr.name) + naming.nameType(refObj.name) + naming.nameType(refObjIdAttrs[0].name)>
    </#if>
  </#if>
  <#return naming.nameVariable(attr.name)>
</#function>

<#function get_object_sql_alias obj>
  <#assign lastIndex = obj.persistenceName?last_index_of('_')>
  <#if lastIndex == -1>
    <#return obj.persistenceName>
  </#if>
  <#return obj.persistenceName?substring(lastIndex + 1)>
</#function>

<#function get_attribute_sql_initial_var attr>
  <#assign ret = get_attribute_sql_name(attr)>
  <#if attr.type.name == 'now' || attr.name == 'last_modified_time'>
    <#return 'current_timestamp'>
  <#elseif attr.type.name == 'state' || attr.name == 'state'>
    <#return "'E'">
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
  <#if typestr == 'lmt'>
    <#return 'Timestamp.valueOf("' + val + '")'>
  <#elseif typestr == 'id'>
    <#return 'Strings.id()'>
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
    <#if (length > get_attribute_label(attr)?length * 2 + 6)>
      <#return '"' + get_attribute_label(attr) + '测试值' + '"'>
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
  </#if>
  <#return '(' + type_attribute(attr) + ') null'>
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
  </#list>
  <#return false>
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
  <#local ret = obj.getLabelledOptions('name')['plural']!>
  <#return ret>
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
  <#if attr.type.collection>
    <#return attr.name>
  </#if>
  <#stop attr.parent.name + '【' + attr.name + '】不是数组类型且没有定义复数名称'> 
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
  <#assign ret = attr.getLabelledOptions('name')['label']!>
  <#if ret == ''>
    <#assign ret = attr.getLabelledOptions('persistence')['text']!>
  </#if>
  <#return ret>
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
  <#if attr.type.custom>
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