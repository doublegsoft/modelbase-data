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
    <#return get_type_name(type.componentType) + '*'>
  </#if>
  <#if type.primitive>
    <#return typebase.typename(type, 'c', 'char*')>
  <#elseif type.custom>
    <#return c.nameType(type.name)>
  </#if>
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
    <#return c.nameType(obj.name)>
  <#elseif obj.isLabelled('value')>
    <#return c.nameType(obj.alias)>
  </#if>
  <#return c.nameType(obj.name)>
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
    <#return type_object(refObj) + '_t*'>
  <#elseif attr.type.primitive>
    <#return typebase.typename(attr.type, 'c', 'char*')>
  <#elseif attr.type.collection>
    <#assign fakeAttr = {'type': attr.type.componentType}>
    <#return type_attribute(fakeAttr) + '*'>
  <#elseif attr.type.domain>
    <#assign exprDomain = attr.type.toString()>
    <#if exprDomain?index_of('&') == 0>
      <#assign refObj = model.findObjectByName(attr.type.name)>
      <#return type_object(refObj) + '_t*'>
    <#else>
      <#return typebase.typename(attr.type, 'c', 'char*')>
    </#if>
  </#if>
  <#return typebase.typename(attr.type, 'c', 'char*')>
</#function>

<#--
 ### Gets type length for the attribute. Only supports primitive type, if
 ### others, returns empty string.
 ###
 ### @param attr
 ###        the attribute definition
 ###
 ### @return
 ###        the programming language type name
 #-->
<#function length_attribute attr>
  <#if attr.type.primitive>
    <#assign typename = typebase.typename(attr.type, 'c', 'char*')>
    <#if typename == 'char'>
      <#if attr.type.length?? && attr.type.length gt 1>
        <#return '[' + attr.type.length?string('####') + ']'>
      </#if>
      <#return '[100]'>
    </#if>
  </#if>
  <#return ''>
</#function>

<#function name_variable any>
  <#if type.collection>
    <#return get_type_name(type.componentType) + '*'>
  </#if>
  <#if type.primitive>
    <#return typebase.typename(type, 'c', 'char*')>
  <#elseif type.custom>
    <#return java.nameType(type.name)>
  </#if>
</#function>

<#function freemarker_to_mustache line prev>
  <#assign idxIfStartTag = line?index_of('<#if !_empty(')>
  <#assign idxIfCloseTag = line?index_of(')>')>
  <#if idxIfStartTag != -1 && idxIfCloseTag != -1>
    <#assign paramName = line?substring(idxIfStartTag + '<#if !_empty('?length, idxIfCloseTag)>
  </#if>
  <#assign newLine = line?replace('<#if !_empty(', '{{#')>
  <#assign newLine = newLine?replace(')>', '}}')>
  <#assign newLine = newLine?replace('</#if>', '{{/' + prev.param + '}}')>
  <#if paramName??>
    <#return {'param': paramName, 'line': newLine, 'start': idxIfStartTag, 'end': idxIfCloseTag}>
  <#else>
    <#return {'param': prev.param, 'line': newLine, 'start': idxIfStartTag, 'end': idxIfCloseTag}>
  </#if>
</#function>

<#--
 ### Gets the named value from labelled options of the attribute.
 ### <pre>
 ### e.g. @xml(name='hello')
 ### </pre>
 ###
 ### @param attr
 ###      the attribute
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
  <#return getter_var + '.get' + java.nameType(getter.name) + '()'>
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
  <#return getter_var + '.get("' + java.nameVariable(getter.name) + '")'>
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
  <#elseif attr.type.name == 'long' || attr.type.name == 'integer' || attr.type.name == 'int'>
    <#return var + ' = ' + num>
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
  <#assign ret = []>
  <#list obj.attributes as attr>
    <#if attr.identifiable>
      <#assign ret = ret + [attr]>
    </#if>
  </#list>
  <#return ret>
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
    <#assign single = c.nameVariable(attr.name)>
    <#assign ret = ret + single>
  </#list>
  <#return ret>
</#function>

<#function get_attributes_as_arguments2 attrs>
  <#assign ret = ''>
  <#list attrs as attr>
    <#if ret != ''>
      <#assign ret = ret + ', '>
    </#if>
    <#assign single = c.nameVariable(attr.persistenceName)>
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
    <#assign single = typebase.typename(attr.type, 'c', 'char*') + ' ' + java.nameVariable(attr.name)>
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
 ### SPECS:
 ###
 ### 01. 创建实体本身
 ### 02. 读取实体本身
 ### 03. 更新实体本身
 ### 04. 删除实体本身
 ### 05. 创建实体中引用到的【值对象】
 ### 06. 更新实体中引用到的【值对象】
 ### 07. 删除实体中引用到的【值对象】
 ### 08. 创建多对多引用的【实体对象的关联关系】
 ### 09. 删除多对多引用的【实体对象的关联关系】
 ### 10. 创建一对多引用的【值对象的关联关系】
 ### 10. 删除一对多引用的【值对象的关联关系】
 ### XX. 数据校验
 -->
<#function group_entity_reference entity>
  <#assign ret = {}>

  <#-- 实体访问库集合 -->
  <#assign anyRefObjs = {}>

  <#-- SPEC：当一个实体对象属性中一对一或者一对多其他子实体或者值对象，则支持同时创建 -->
  <#--#########################################################-->
  <#-- 一对一引用的属性集合，被引用对象，包含扩展属性，父属性等一对一特性 -->
  <#--#########################################################-->
  <#-- TODO: 父对象引用 -->
  <#assign o2oParAttrs = []>
  <#assign o2oParObjs = []>
  <#-- 扩展引用 -->
  <#assign o2oExtAttrs = []>
  <#assign o2oExtObjs = []>
  <#-- 枚举对象引用 -->
  <#assign o2oEnmAttrs = []>
  <#assign o2oEnmObjs = []>
  <#-- 值对象引用 -->
  <#assign o2oValAttrs = []>
  <#assign o2oValObjs = []>
  <#-- 一般引用 -->
  <#assign o2oRefAttrs = []>
  <#assign o2oRefObjs = []>
  <#--#############################-->
  <#-- 多对一引用的属性集合，被引用对象 -->
  <#--#############################-->
  <#-- TODO: 子对象引用 -->
  <#assign o2mChnAttrs = []>
  <#assign o2mChnObjs = []>
  <#-- 值对象引用 -->
  <#assign o2mValAttrs = []>
  <#assign o2mValObjs = []>
  <#-- 一般引用 -->
  <#assign o2mRefAttrs = []>
  <#assign o2mRefObjs = []>
  <#-- 多对多引用的对象集合，抽出与此对象具有多对多关系的关联对象，无论对方对象是实体、值、枚举都一样处理 -->
  <#-- 枚举对象引用 -->
  <#assign m2mEnmAttrs = []>
  <#assign m2mEnmObjs = []>
  <#-- 一般对象引用 -->
  <#assign m2mRefAttrs = []>
  <#assign m2mRefObjs = []>
  <#list entity.attributes as attr>
    <#if appbase.get_ref(attr, model)??>
      <#assign refObj = appbase.get_ref(attr, model)>
      <#if attr.type.collection>
        <#if refObj.isLabelled('enum')>
          <#-- 枚举对象只可能是多对多 -->
          <#assign m2mEnmAttrs = m2mEnmAttrs + [attr]>
          <#assign m2mEnmObjs = m2mEnmObjs + [refObj]>
        <#elseif refObj.isLabelled('value')>
          <#-- 值对象只可能是一对多 -->
          <#assign o2mValAttrs = o2mValAttrs + [attr]>
          <#assign o2mValObjs = o2mValObjs + [refObj]>
        <#elseif refObj.name == entity.name>
          <#-- 子集合引用判断条件 -->
          <#assign o2mChnAttrs = o2mChnAttrs + [attr]>
          <#assign o2mChnObjs = o2mChnObjs + [refObj]>
        <#elseif is_source_in_target(entity, refObj)>
          <#-- FIXME: THERE IS A DEFEAT -->
          <#-- 一对多引用 -->
          <#assign o2mRefAttrs = o2mRefAttrs + [attr]>
          <#assign o2mRefObjs = o2mRefObjs + [refObj]>
        <#else>
          <#-- FIXME: Do we need to find the conjunction object definition? -->
          <#assign m2mRefAttrs = m2mRefAttrs + [attr]>
          <#assign m2mRefObjs = m2mRefObjs + [refObj]>
        </#if>
      <#else>
        <#if refObj.name == entity.name>
          <#-- 父引用判断条件 -->
          <#assign o2oParAttrs = o2oParAttrs + [attr]>
          <#assign o2oParObjs = o2oParObjs + [attr]>
        <#elseif get_object_label_value(entity, 'entity', 'extend') == refObj.name>
          <#-- 扩展引用判断条件，把引用对象作为Base对象 -->
          <#assign o2oExtAttrs = o2oExtAttrs + [attr]>
          <#assign o2oExtObjs = o2oExtObjs + [refObj]>
        <#elseif refObj.isLabelled('value')>
          <#-- 值对象 -->
          <#assign o2oValAttrs = o2oValAttrs + [attr]>
          <#assign o2oValObjs = o2oValObjs + [refObj]>
        <#elseif refObj.isLabelled('enum')>
          <#-- 枚举 -->
          <#assign o2oEnmAttrs = o2oEnmAttrs + [attr]>
          <#assign o2oEnmObjs = o2oEnmObjs + [refObj]>
        <#else>
          <#-- 一般引用 -->
          <#assign o2oRefAttrs = o2oRefAttrs + [attr]>
          <#assign o2oRefObjs = o2oRefObjs + [refObj]>
        </#if>
      </#if>
      <#assign anyRefObjs = anyRefObjs + {refObj.name: refObj}>
    </#if>
  </#list>

  <#assign ret = ret + {'o2oParAttrs': o2oParAttrs}>
  <#assign ret = ret + {'o2oParObjs': o2oParObjs}>

  <#assign ret = ret + {'o2oExtAttrs': o2oExtAttrs}>
  <#assign ret = ret + {'o2oExtObjs': o2oExtObjs}>

  <#assign ret = ret + {'o2oEnmAttrs': o2oEnmAttrs}>
  <#assign ret = ret + {'o2oEnmObjs': o2oEnmObjs}>

  <#assign ret = ret + {'o2oValAttrs': o2oValAttrs}>
  <#assign ret = ret + {'o2oValObjs': o2oValObjs}>

  <#assign ret = ret + {'o2oRefAttrs': o2oRefAttrs}>
  <#assign ret = ret + {'o2oRefObjs': o2oRefObjs}>

  <#assign ret = ret + {'o2mChnAttrs': o2mChnAttrs}>
  <#assign ret = ret + {'o2mChnObjs': o2mChnObjs}>

  <#assign ret = ret + {'o2mValAttrs': o2mValAttrs}>
  <#assign ret = ret + {'o2mValObjs': o2mValObjs}>

  <#assign ret = ret + {'o2mRefAttrs': o2mRefAttrs}>
  <#assign ret = ret + {'o2mRefObjs': o2mRefObjs}>

  <#assign ret = ret + {'m2mEnmAttrs': m2mEnmAttrs}>
  <#assign ret = ret + {'m2mEnmObjs': m2mEnmObjs}>

  <#assign ret = ret + {'m2mRefAttrs': m2mRefAttrs}>
  <#assign ret = ret + {'m2mRefObjs': m2mRefObjs}>

  <#assign ret = ret + {'anyRefObjs': anyRefObjs}>

  <#return ret>
</#function>

<#--
 ### Writes object's attributes as object members.
 ### <p>
 ### Primitive attribute is attribute which its type is primitive type,
 ### and is distinguish from value, code, parent, master, detail, extension.
 ###
 ### @param obj
 ###      the object definition
 ###
 ### @param indent
 ###      the left pad count
 #-->
<#macro write_pojo_members obj indent>
  <#list obj.attributes as attr>
${''?left_pad(indent)}/**
${''?left_pad(indent)} * ${attr.text!'TODO'}.
${''?left_pad(indent)} */
    <#if attr.type.collection>
${''?left_pad(indent)}private final ${get_type_name(attr.type)} ${java.nameVariable(attr.name)} = new ArrayList<>();
    <#else>
${''?left_pad(indent)}private ${get_type_name(attr.type)} ${java.nameVariable(attr.name)};
    </#if>

  </#list>
</#macro>

<#--
 ### Writes object's attribute accessors as object getters and setters.
 ###
 ### @param obj
 ###      the object definition
 ###
 ### @param indent
 ###      the left pad count
 #-->
<#macro write_pojo_accessors obj indent>
  <#list obj.attributes as attr>
    <#if attr.type.collection>
${''?left_pad(indent)}public ${get_type_name(attr.type)} get${java.nameType(attr.name)}() {
${''?left_pad(indent)}  return ${java.nameVariable(attr.name)};
${''?left_pad(indent)}}
    <#else>
${''?left_pad(indent)}public ${get_type_name(attr.type)} get${java.nameType(attr.name)}() {
${''?left_pad(indent)}  return ${java.nameVariable(attr.name)};
${''?left_pad(indent)}}

${''?left_pad(indent)}public void set${java.nameType(attr.name)}(${get_type_name(attr.type)} ${java.nameVariable(attr.name)}) {
${''?left_pad(indent)}  this.${java.nameVariable(attr.name)} = ${java.nameVariable(attr.name)};
${''?left_pad(indent)}}
    </#if>

  </#list>
</#macro>

<#--
 ### Writes object's attribute accessors as object getters and setters under rest framework.
 ###
 ### @param obj
 ###      the any object, @request, @response, @payload
 ###
 ### @param indent
 ###      the left pad count
 #-->
<#macro write_xml_accessors obj indent>
  <#list obj.attributes as attr>
@XmlElement<#if attr.isLabelled('xml')>(name = "${get_attribute_label_value(attr, 'xml', 'name')}")</#if>
@JsonProperty<#if attr.isLabelled('xml')>(value = "${get_attribute_label_value(attr, 'xml', 'name')}")</#if>
${''?left_pad(indent)}public ${get_type_name(attr.type)} get${java.nameType(attr.name)}() {
${''?left_pad(indent)}  return ${java.nameVariable(attr.name)};
${''?left_pad(indent)}}
    <#if !attr.type.collection>

${''?left_pad(indent)}public void set${java.nameType(attr.name)}(${get_type_name(attr.type)} ${java.nameVariable(attr.name)}) {
${''?left_pad(indent)}  this.${java.nameVariable(attr.name)} = ${java.nameVariable(attr.name)};
${''?left_pad(indent)}}
    </#if>

  </#list>
</#macro>

<#--
 ### If the object is labelled @target, uses the macro to generate assembler source code.
 ###
 ### @param obj
 ###      the any object
 ###
 ### @param indent
 ###      the left pad count
 #-->
<#macro write_object_assemblers obj indent>
  <#if !obj.isLabelled('target')>
    <#return>
  </#if>
  <#assign target_types = get_object_label_value(obj, 'target', 'types')>
  <#assign types = target_types?split(',')>
  <#list types as type>
    <#assign trimmed_type = type?trim>
    <#if model.findObjectByName(trimmed_type)??>
      <#assign target = model.findObjectByName(trimmed_type)>
${''?left_pad(indent)}public static ${java.nameType(target.name)} assemble${java.nameType(target.name)}(${java.nameType(obj.name)} ${java.nameVariable(obj.name)}) {
${''?left_pad(indent)}  ${java.nameType(target.name)} retVal = new ${java.nameType(target.name)}();
      <#list target.attributes as attr>
        <#assign getter = get_similar_attribute(attr, obj)!>
<@write_attribute_setter_from_getter setter_var='retVal' setter=attr getter_var=java.nameVariable(obj.name) getter=getter indent=4/>
      </#list>
${''?left_pad(indent)}  return retVal;
${''?left_pad(indent)}}

${''?left_pad(indent)}public static ${java.nameType(obj.name)} assemble${java.nameType(obj.name)}(${java.nameType(target.name)} ${java.nameVariable(target.name)}) {
${''?left_pad(indent)}  ${java.nameType(obj.name)} retVal = new ${java.nameType(obj.name)}();
      <#list obj.attributes as attr>
        <#assign getter = get_similar_attribute(attr, obj)!>
<@write_attribute_setter_from_getter setter_var='retVal' setter=attr getter_var=java.nameVariable(target.name) getter=getter indent=4/>
      </#list>
${''?left_pad(indent)}  return retVal;
${''?left_pad(indent)}}

    </#if>
  </#list>

</#macro>

<#macro write_attribute_setter_from_getter setter_var setter getter_var getter indent>
  <#if !getter.name??>
${''?left_pad(indent)}${setter_var}.set${java.nameType(setter.name)}(null);
    <#return>
  </#if>
  <#if setter.type.collection>
    <#-- collection type -->
${''?left_pad(indent)}for (${java.nameType(getter.type.componentType.name)} ${java.nameVariable(getter.type.componentType.name)} : ${getter_var}.get${java.nameType(getter.name)}()) {
${''?left_pad(indent)}  ${setter_var}.get${java.nameType(setter.name)}().add(${java.nameVariable(getter.type.componentType.name)});
${''?left_pad(indent)}}
  <#elseif setter.type.primitive>
    <#-- primitive type -->
${''?left_pad(indent)}${setter_var}.set${java.nameType(setter.name)}(${infer_value_conversion(setter, getter, get_object_get(getter_var, getter))});
  <#elseif setter.type.custom>
    <#-- TODO: custom type -->
${''?left_pad(indent)}${setter_var}.set${java.nameType(setter.name)}(${infer_value_conversion(setter, getter, get_object_get(getter_var, getter))});
  </#if>
</#macro>

<#macro write_attribute_setter_from_hash setter_var setter getter_var getter indent>
  <#if !getter.name??>
${''?left_pad(indent)}${setter_var}.set${java.nameType(setter.name)}(null);
    <#return>
  </#if>
  <#if setter.type.collection>
${''?left_pad(indent)}for (Object obj : ${getter_var}.get("${java.nameType(getter.name)}")) {
${''?left_pad(indent)}  ${setter_var}.get${java.nameType(setter.name)}().add(obj);
${''?left_pad(indent)}}
  <#elseif setter.type.primitive>
${''?left_pad(indent)}${setter_var}.set${java.nameType(setter.name)}(${infer_value_conversion(setter, getter, get_hash_get(getter_var, getter))});
  <#elseif setter.type.custom>
  <#-- TODO -->
${''?left_pad(indent)}${setter_var}.set${java.nameType(setter.name)}(${infer_value_conversion(setter, getter, get_hash_get(getter_var, getter))});
  </#if>
</#macro>
