<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#assign typeDef = objectConstructor("com.doublegsoft.jcommons.metacode.TypeDefinition", extension, model)>
<#assign flow = typeDef.flow>
<#assign idAttrs = typeDef.getIdentifiableAttributes()>
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC 
  "-//mybatis.org//DTD Mapper 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${namespace}.${app.name}.dao.${java.nameType(extension.name)}DataAccess">
  <sql id="join${java.nameType(extension.name)}">
<#list flow.types as typeObj>
  <#assign origObj = model.findObjectByName(typeObj.name)>
  ${origObj.persistenceName} ${modelbase.get_object_sql_alias(origObj)}
</#list>
  </sql>
  
  <sql id="column${java.nameType(extension.name)}">
  </sql>
  
  <#-- WHERE -->
  <sql id="where${java.nameType(extension.name)}">
<#list extension.attributes as attr> 
  <#if !attr.isLabelled("original")><#continue></#if>
  <#--  <#if !attr.persistenceName??><#continue></#if>  -->
  <#assign origObj = model.findObjectByName(attr.getLabelledOption("original", "object"))>
  <#if !origObj.getAttribute(attr.getLabelledOption("original", "attribute"))??><#continue></#if>
  <#assign origAttr = origObj.getAttribute(attr.getLabelledOption("original", "attribute"))>
  <#if !origAttr.persistenceName??><#continue></#if>
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
<#-- 处理集合属性的子查询 -->
<#list extension.attributes as attr>
  <#if !origAttr.type.collection><#continue></#if>
  <#assign inMap = "in" + java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))>
  <#assign collObj = model.findObjectByName(origAttr.type.componentType.name)>
  <#list collextension.attributes as collObjAttr>
    <#if collObjorigAttr.type.name == extension.name>
      <#assign refAttrInCollObj = collObjAttr>
    </#if>
  </#list>
  <#if !refAttrInCollObj??><#continue></#if>
  <#if !refAttrInCollextension.persistenceName??><#continue></#if>
    <if test = "!${inMap}.isEmpty()">
    and ${modelbase.get_object_sql_alias(idorigObj)}.${idorigAttr.persistenceName} in (
      select ${refAttrInCollextension.persistenceName} from ${collextension.persistenceName} ${modelbase.get_object_sql_alias(collObj)} 
  <#-- LEFT JOIN IN SUB-QUERY -->
  <#list collextension.attributes as collObjAttr>  
    <#if !collObjorigAttr.type.custom || collObjorigAttr.type.name == extension.name><#continue></#if> 
    <#if !collObjorigAttr.persistenceName??><#continue></#if>
    <#assign collObjAttrRefObj = model.findObjectByName(collObjorigAttr.type.name)> 
    <#assign collObjAttrRefObjIdAttr = modelbase.get_id_attributes(collObjAttrRefObj)[0]>
      left join ${collObjAttrRefextension.persistenceName} ${modelbase.get_object_sql_alias(collObjAttrRefObj)} on ${modelbase.get_object_sql_alias(collObjAttrRefObj)}.${collObjAttrRefObjIdorigAttr.persistenceName} = ${modelbase.get_object_sql_alias(collObj)}.${collObjorigAttr.persistenceName}
  </#list>
  <#-- WHERE IN SUB-QUERY -->
      where 1 = 1
  <#list collextension.attributes as collObjAttr>
    <#if !collObjorigAttr.persistenceName??><#continue></#if>
    <#if collObjorigAttr.name == "state" || !modelbase.is_attribute_system(collObjAttr)>
      <if test = "${inMap}.${modelbase.get_attribute_sql_name(collObjAttr)} != null">
      and ${modelbase.get_object_sql_alias(collObj)}.${collObjorigAttr.persistenceName} = ${r"#{"}${inMap}.${modelbase.get_attribute_sql_name(collObjAttr)}}
      </if>  
    </#if>  
  </#list>  
  <#list collextension.attributes as collObjAttr>  
    <#if !collObjorigAttr.type.custom || collObjorigAttr.type.name == extension.name><#continue></#if> 
      <#assign collObjAttrRefObj = model.findObjectByName(collObjorigAttr.type.name)> 
      <#assign collObjAttrRefObjIdAttr = modelbase.get_id_attributes(collObjAttrRefObj)[0]>
      <#list collObjAttrRefextension.attributes as collObjAttrRefObjAttr>
        <#if !collObjAttrRefObjorigAttr.isLabelled("listable")><#continue></#if>
      <if test = "${inMap}.${modelbase.get_attribute_sql_name(collObjAttrRefObjAttr)} != null">  
      and ${modelbase.get_object_sql_alias(collObjAttrRefObj)}.${collObjAttrRefObjorigAttr.persistenceName} like concat('%', ${r"#{"}${inMap}.${modelbase.get_attribute_sql_name(collObjAttrRefObjAttr)}}, '%')
      </if>
      </#list>
  </#list>
    )
    </if>  
</#list>   
  </sql>
  
  <sql id="orderBy${java.nameType(extension.name)}">
  </sql>
  
  <select id="select${java.nameType(extension.name)}" parameterType="${namespace}.${app.name}.dto.payload.${java.nameType(extension.name)}Query" 
          resultType="${namespace}.${app.name}.dto.payload.${java.nameType(extension.name)}Query">
  </select>
</mapper>
