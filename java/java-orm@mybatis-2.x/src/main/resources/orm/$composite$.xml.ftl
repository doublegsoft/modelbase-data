<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#assign typeDef = objectConstructor("com.doublegsoft.jcommons.metacode.TypeDefinition", composite, model)>
<#assign flow = typeDef.flow>
<#assign idAttrs = typeDef.getIdentifiableAttributes()>
<#assign obj = composite>
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC 
  "-//mybatis.org//DTD Mapper 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${namespace}.${app.name}.dao.${java.nameType(composite.name)}DataAccess">
  <sql id="join${java.nameType(composite.name)}">
<#list flow.types as typeObj>
  <#assign origObj = model.findObjectByName(typeObj.name)>
  <#if typeObj.reference??>
    <#assign predicate = typeObj.reference.joinPredicates[0]>
    <#assign leftObj = predicate.leftObject>
    <#assign leftAttr = predicate.leftAttribute>
    <#assign rightObj = predicate.rightObject>
    <#assign rightAttr = predicate.rightAttribute>
    left join ${rightObj.persistenceName} "${modelbase.get_object_sql_alias(rightObj)}" on "${modelbase.get_object_sql_alias(leftObj)}".${leftAttr.persistenceName} = "${modelbase.get_object_sql_alias(rightObj)}".${rightAttr.persistenceName} 
  </#if>
</#list>
  </sql>

<#assign columnedAttrs = []>
<#assign existingAttrs = {}>  
<#if obj.isLabelled("composite")>
  <#list obj.attributes as attr>
    <#assign origAttr = model.findAttributeByNames(attr.getLabelledOptions("original")["object"], attr.getLabelledOptions("original")["attribute"])>
    <#assign columnedAttrs += [origAttr]>
  </#list>
<#else>
  <#list flow.types as typeObj>
    <#assign origObj = model.findObjectByName(typeObj.name)>
    <#list origObj.attributes as attr>
      <#if !attr.isLabelled("persistence")><#continue></#if>
      <#assign attrSqlName = modelbase.get_attribute_sql_name(attr)>
      <#if existingAttrs[attrSqlName]??><#continue></#if>
      <#assign existingAttrs += {attrSqlName: attr}>
      <#assign columnedAttrs += [attr]>
    </#list>
  </#list>    
</#if>
  <sql id="column${java.nameType(composite.name)}">
<#list columnedAttrs as attr>
  <#assign origObjAlias = modelbase.get_object_sql_alias(attr.parent)>
  <#assign attrSqlName = modelbase.get_attribute_sql_name(attr)>
    "${origObjAlias}".${attr.persistenceName} ${attrSqlName}<#if attr?index != columnedAttrs?size - 1>,</#if>
</#list>
  </sql>
  
  <sql id="where${java.nameType(composite.name)}">
<#list columnedAttrs as attr> 
  <#assign origObj = attr.parent>
  <#assign origAttr = attr>
  <#if origAttr.type.custom>
    <!-- 【${modelbase.get_attribute_label(attr)}】 -->
    <if test = "${modelbase.get_attribute_sql_name(attr)} != null">
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} = ${r"#{"}${modelbase.get_attribute_sql_name(attr)}}
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}0 != null">
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} like concat(${r"#{"}${modelbase.get_attribute_sql_name(attr)}0}, '%')
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}1 != null">
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} like concat('%', ${r"#{"}${modelbase.get_attribute_sql_name(attr)}1})
    </if>
  <#elseif origAttr.type.collection>
  <#elseif origAttr.name == "state">
    <!-- 【${modelbase.get_attribute_label(attr)}】 -->
    <if test = "${modelbase.get_attribute_sql_name(attr)} != null">
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} = ${r"#{"}${modelbase.get_attribute_sql_name(attr)}}
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)} == null">
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} = 'E'
    </if>
  <#elseif origAttr.type.name == "code">
  <#elseif origAttr.name == "status">
  <#elseif origAttr.constraint.domainType.name?index_of("enum") == 0>
  <#elseif origAttr.type.name == "date" || origAttr.type.name == "datetime">
    <!-- 【${modelbase.get_attribute_label(attr)}】 -->
    <if test = "${modelbase.get_attribute_sql_name(attr)} != null">
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} = ${r"#{"}${modelbase.get_attribute_sql_name(attr)}}
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}0 != null">
    <![CDATA[
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} >= ${r"#{"}${modelbase.get_attribute_sql_name(attr)}0}
    ]]>
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}1 != null">
    <![CDATA[
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} <= ${r"#{"}${modelbase.get_attribute_sql_name(attr)}1}
    ]]>
    </if>
    <#elseif origAttr.type.name == "int" || origAttr.type.name == "integer">
    <!-- 【${modelbase.get_attribute_label(attr)}】 -->
    <if test = "${modelbase.get_attribute_sql_name(attr)} != null">
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} = ${r"#{"}${modelbase.get_attribute_sql_name(attr)}}
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}0 != null">
    <![CDATA[
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} >= ${r"#{"}${modelbase.get_attribute_sql_name(attr)}0}
    ]]>
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}1 != null">
    <![CDATA[
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} <= ${r"#{"}${modelbase.get_attribute_sql_name(attr)}1}
    ]]>
    </if>
  <#elseif origAttr.type.name == "number">
    <!-- 【${modelbase.get_attribute_label(attr)}】 -->
    <if test = "${modelbase.get_attribute_sql_name(attr)} != null">
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} = ${r"#{"}${modelbase.get_attribute_sql_name(attr)}}
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}0 != null">
    <![CDATA[
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} >= ${r"#{"}${modelbase.get_attribute_sql_name(attr)}0}
    ]]>
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}1 != null">
    <![CDATA[
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} <= ${r"#{"}${modelbase.get_attribute_sql_name(attr)}1}
    ]]>
    </if>
    <#else>
    <!-- 【${modelbase.get_attribute_label(attr)}】 -->
    <if test = "${modelbase.get_attribute_sql_name(attr)} != null">
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} = ${r"#{"}${modelbase.get_attribute_sql_name(attr)}}
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}0 != null">
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} like concat(${r"#{"}${modelbase.get_attribute_sql_name(attr)}0}, '%')
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}1 != null">
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} like concat('%', ${r"#{"}${modelbase.get_attribute_sql_name(attr)}1})
    </if>
  </#if> 
  <#if origAttr.type.name == "string" && !origAttr.identifiable && !origAttr.constraint.domainType.name?starts_with("enum")>
    <if test = "${modelbase.get_attribute_sql_name(attr)}2 != null">
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} like concat('%', ${r"#{"}${modelbase.get_attribute_sql_name(attr)}2}, '%')
    </if>
  </#if> 
  <#if origAttr.identifiable || origAttr.type.custom ||
       modelbase.is_masterless_detail_reference_attribute(attr)>
    <if test = "${inflector.pluralize(modelbase.get_attribute_sql_name(attr))} != null and ${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}.size() > 0">
    and "${modelbase.get_object_sql_alias(origObj)}".${origAttr.persistenceName} in
      <foreach collection="${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}" item="${origAttr.persistenceName}" open="(" separator="," close=")">
      ${r"#{"}${origAttr.persistenceName}}
      </foreach>
    </if>
  </#if>
</#list>
  </sql>
  
  <sql id="orderBy${java.nameType(composite.name)}">
  </sql>
  
  <select id="select${java.nameType(composite.name)}Query" parameterType="${namespace}.${app.name}.dto.payload.${java.nameType(composite.name)}Query" 
          resultType="${namespace}.${app.name}.dto.payload.${java.nameType(composite.name)}Query">
    select <include refid="column${java.nameType(composite.name)}"/>
  <#assign origObj = model.findObjectByName(flow.types[0].name)>
    from <#if databaseName??>${databaseName}.</#if>${origObj.persistenceName} "${modelbase.get_object_sql_alias(origObj)}"
    <include refid="join${java.nameType(composite.name)}"/>
    where 1 = 1
    <include refid="where${java.nameType(composite.name)}"/>          
  </select>

  <select id="selectCountOf${java.nameType(composite.name)}Query" parameterType="${namespace}.${app.name}.dto.payload.${java.nameType(composite.name)}Query" resultType="long">
    select count(*)
    from <#if databaseName??>${databaseName}.</#if>${origObj.persistenceName} "${modelbase.get_object_sql_alias(origObj)}"
    <include refid="join${java.nameType(composite.name)}"/>
    where 1 = 1
    <include refid="where${java.nameType(composite.name)}"/>
  </select>
</mapper>
