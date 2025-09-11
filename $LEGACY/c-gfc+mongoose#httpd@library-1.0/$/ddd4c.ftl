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
<#macro state_code stmt>
</#macro>


<#macro state_variable_assignment stmt obj>
  <#assign idAttrs = internal.get_id_attributes(obj)>
    char ${c.nameVariable(idAttrs[0].name)}[37];
    ${c.nameNamespace(namespace)}_string_id(${c.nameVariable(idAttrs[0].name)});
</#macro>

<#macro state_variable_assignment stmt obj>
  <#assign idAttrs = internal.get_id_attributes(obj)>
    char ${c.nameVariable(idAttrs[0].name)}[37];
    ${c.nameNamespace(namespace)}_string_id(${c.nameVariable(idAttrs[0].name)});
</#macro>
