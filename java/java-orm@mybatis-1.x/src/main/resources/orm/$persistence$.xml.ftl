<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#macro print_id idAttr>${java.nameVariable(idAttr.name)}<#if idAttr.type.custom><#local refObj=model.findObjectByName(idAttr.type.name)><#local refIdAttr=modelbase.get_id_attributes(refObj)[0]>.<@print_id idAttr=refIdAttr /></#if></#macro>
<#macro print_o2o_left_join idAttr>
  <#if idAttr.type.custom>
    <#assign refObj = model.findObjectByName(idAttr.type.name)>
    <#assign refObjIdAttr = modelbase.get_id_attributes(refObj)[0]>
    left join <#if databaseName??>${databaseName}.</#if>${refObj.persistenceName} ${modelbase.get_object_sql_alias(refObj)} on ${modelbase.get_object_sql_alias(refObj)}.${refObjIdAttr.persistenceName} = "${modelbase.get_object_sql_alias(obj)}".${idAttrs[0].persistenceName}
    <@print_o2o_left_join idAttr=refObjIdAttr />
  </#if>
</#macro>
<#macro print_o2o_select idAttr>
  <#if idAttr.type.custom>
    <#local refObj = model.findObjectByName(idAttr.type.name)>
    <#local refObjIdAttr = modelbase.get_id_attributes(refObj)[0]>
    <#list refObj.attributes as refObjAttr>
      <#if refObjAttr.identifiable><#continue></#if>
      <#local found = false>
      <#list idAttr.parent.attributes as attr>
        <#if refObjAttr.name == attr.name>
          <#local found = true>
          <#break>
        </#if>
      </#list>
      <#if !found && refObjAttr.persistenceName??>
      ${modelbase.get_object_sql_alias(refObj)}.${refObjAttr.persistenceName} as "${modelbase.get_attribute_sql_name(refObjAttr)}",
      </#if>  
    </#list>  
<@print_o2o_select idAttr=refObjIdAttr />
  </#if>
</#macro>
<#assign obj=persistence>
<#assign idAttrs = []>
<#assign nonIdAttrs = []>
<#list obj.attributes as attr>
  <#if attr.persistenceName??>
    <#if attr.identifiable>
      <#assign idAttrs = idAttrs + [attr]>
    <#else>
      <#assign nonIdAttrs = nonIdAttrs + [attr]>
    </#if>
  </#if>
</#list>
<#assign idAttr = idAttrs[0]>
<#assign extObjs = modelbase.get_extension_objects(obj)>
<#assign refObjs = {}>
<#-- 在此对象中，搜集所有直接引用的对象 -->
<#list obj.attributes as attr>
  <#-- 主键关联，会自然带入，无需额外操作 -->
  <#-- 实体对象过滤，值体对象不过滤 -->
  <#if !attr.type.custom || (attr.identifiable && idAttrs?size == 1)><#continue></#if>
  <#assign refObj = model.findObjectByName(attr.type.name)>
  <#assign refObjAttrs = []>
  <#list refObj.attributes as refObjAttr>
    <#if refObjAttr.type.name == 'name' || refObjAttr.name == 'name'>
      <#assign refObjAttrs += [refObjAttr]>
    <#elseif refObjAttr.isLabelled("listable")>  
      <#assign refObjAttrs += [refObjAttr]>
    </#if>
  </#list>
  <#if (refObjAttrs?size > 0)>
    <#assign refObjs = refObjs + {attr: {'obj': refObj, 'attrs': refObjAttrs, 'attr': attr}}>
  </#if>
</#list>
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC 
  "-//mybatis.org//DTD Mapper 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${namespace}.${app.name}.dao.${java.nameType(obj.name)}DataAccess">

  <sql id="join${java.nameType(obj.name)}">
<#------------->
<#-- 主键扩展 -->  
<#------------->
<#if idAttrs?size == 1>
<#list idAttrs as idAttr>
  <#if idAttr.type.custom>
<@print_o2o_left_join idAttr=idAttr />    
  </#if>
</#list>
</#if>
<#------------->
<#-- 灵活扩展 -->  
<#------------->
<#list extObjs as extObjName, extRefAttr>
  <#assign extObj = extRefAttr.parent>
    left join <#if databaseName??>${databaseName}.</#if>${extObj.persistenceName} "${modelbase.get_object_sql_alias(extObj)}" on "${modelbase.get_object_sql_alias(extObj)}".${extRefAttr.persistenceName} = "${modelbase.get_object_sql_alias(obj)}".${idAttrs[0].persistenceName}
</#list>  
<#------------->
<#-- 属性引用 --> 
<#------------->
<#list refObjs?keys as key>
  <#assign selfAttr = refObjs[key]['attr']>
  <#assign refObj = refObjs[key]['obj']>
  <#assign refObjIdAttr = modelbase.get_id_attributes(refObj)[0]>
    left join <#if databaseName??>${databaseName}.</#if>${refObj.persistenceName} ${java.nameVariable(selfAttr.name)}_${modelbase.get_object_sql_alias(refObj)} on ${java.nameVariable(selfAttr.name)}_${modelbase.get_object_sql_alias(refObj)}.${refObjIdAttr.persistenceName} = "${modelbase.get_object_sql_alias(obj)}".${selfAttr.persistenceName}
</#list>
  </sql>
  
  <#-- AGGREGATE COLUMN -->
  <sql id="column${java.nameType(obj.name)}">
    <foreach item="column" collection="columnList" separator=",">
<#list obj.attributes as attr>   
  <#if !attr.isLabelled("persistence")><#continue></#if>
      <if test="column == '${modelbase.get_attribute_sql_name(attr)}'"> 
      "${modelbase.get_object_sql_alias(obj)}".${attr.persistenceName}
      </if>
      <if test="column == 'count${java.nameType(modelbase.get_attribute_sql_name(attr))}'"> 
      count("${modelbase.get_object_sql_alias(obj)}".${attr.persistenceName}) count${java.nameType(modelbase.get_attribute_sql_name(attr))}
      </if>
      <if test="column == 'max${java.nameType(modelbase.get_attribute_sql_name(attr))}'"> 
      max("${modelbase.get_object_sql_alias(obj)}".${attr.persistenceName}) as max${java.nameType(modelbase.get_attribute_sql_name(attr))}
      </if>
      <if test="column == 'min${java.nameType(modelbase.get_attribute_sql_name(attr))}'"> 
      min("${modelbase.get_object_sql_alias(obj)}".${attr.persistenceName}) as min${java.nameType(modelbase.get_attribute_sql_name(attr))}
      </if>
      <if test="column == 'avg${java.nameType(modelbase.get_attribute_sql_name(attr))}'"> 
      avg("${modelbase.get_object_sql_alias(obj)}".${attr.persistenceName}) as avg${java.nameType(modelbase.get_attribute_sql_name(attr))}
      </if>
      <if test="column == 'sum${java.nameType(modelbase.get_attribute_sql_name(attr))}'"> 
      sum("${modelbase.get_object_sql_alias(obj)}".${attr.persistenceName}) as sum${java.nameType(modelbase.get_attribute_sql_name(attr))}
      </if>
</#list>        
    </foreach>
  </sql>
  
  <#-- WHERE -->
  <sql id="where${java.nameType(obj.name)}">
<#list obj.attributes as attr> 
  <#if !attr.persistenceName??><#continue></#if>
  <#if attr.type.custom>
    <!-- 【${modelbase.get_attribute_label(attr)}】 -->
    <if test = "${modelbase.get_attribute_sql_name(attr)} != null">
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} = ${r"#{"}${modelbase.get_attribute_sql_name(attr)}}
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}0 != null">
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} like concat(${r"#{"}${modelbase.get_attribute_sql_name(attr)}0}, '%')
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}1 != null">
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} like concat('%', ${r"#{"}${modelbase.get_attribute_sql_name(attr)}1})
    </if>
  <#elseif attr.type.collection>
  <#elseif attr.name == "state">
    <!-- 【${modelbase.get_attribute_label(attr)}】 -->
    <if test = "${modelbase.get_attribute_sql_name(attr)} != null">
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} = ${r"#{"}${modelbase.get_attribute_sql_name(attr)}}
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)} == null">
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} = 'E'
    </if>
  <#elseif attr.type.name == "code">
  <#elseif attr.name == "status">
  <#elseif attr.constraint.domainType.name?index_of("enum") == 0>
  <#elseif attr.type.name == "date" || attr.type.name == "datetime">
    <!-- 【${modelbase.get_attribute_label(attr)}】 -->
    <if test = "${modelbase.get_attribute_sql_name(attr)} != null">
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} = ${r"#{"}${modelbase.get_attribute_sql_name(attr)}}
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}0 != null">
    <![CDATA[
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} >= ${r"#{"}${modelbase.get_attribute_sql_name(attr)}0}
    ]]>
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}1 != null">
    <![CDATA[
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} <= ${r"#{"}${modelbase.get_attribute_sql_name(attr)}1}
    ]]>
    </if>
    <#elseif attr.type.name == "int" || attr.type.name == "integer">
    <!-- 【${modelbase.get_attribute_label(attr)}】 -->
    <if test = "${modelbase.get_attribute_sql_name(attr)} != null">
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} = ${r"#{"}${modelbase.get_attribute_sql_name(attr)}}
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}0 != null">
    <![CDATA[
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} >= ${r"#{"}${modelbase.get_attribute_sql_name(attr)}0}
    ]]>
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}1 != null">
    <![CDATA[
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} <= ${r"#{"}${modelbase.get_attribute_sql_name(attr)}1}
    ]]>
    </if>
  <#elseif attr.type.name == "number">
    <!-- 【${modelbase.get_attribute_label(attr)}】 -->
    <if test = "${modelbase.get_attribute_sql_name(attr)} != null">
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} = ${r"#{"}${modelbase.get_attribute_sql_name(attr)}}
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}0 != null">
    <![CDATA[
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} >= ${r"#{"}${modelbase.get_attribute_sql_name(attr)}0}
    ]]>
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}1 != null">
    <![CDATA[
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} <= ${r"#{"}${modelbase.get_attribute_sql_name(attr)}1}
    ]]>
    </if>
    <#else>
    <!-- 【${modelbase.get_attribute_label(attr)}】 -->
    <if test = "${modelbase.get_attribute_sql_name(attr)} != null">
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} = ${r"#{"}${modelbase.get_attribute_sql_name(attr)}}
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}0 != null">
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} like concat(${r"#{"}${modelbase.get_attribute_sql_name(attr)}0}, '%')
    </if>
    <if test = "${modelbase.get_attribute_sql_name(attr)}1 != null">
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} like concat('%', ${r"#{"}${modelbase.get_attribute_sql_name(attr)}1})
    </if>
  </#if> 
  <#if attr.type.name == "string" && !attr.identifiable && !attr.constraint.domainType.name?starts_with("enum")>
    <if test = "${modelbase.get_attribute_sql_name(attr)}2 != null">
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} like concat('%', ${r"#{"}${modelbase.get_attribute_sql_name(attr)}2}, '%')
    </if>
  </#if> 
  <#if attr.identifiable || attr.type.custom>
    <if test = "${inflector.pluralize(modelbase.get_attribute_sql_name(attr))} != null and ${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}.size() > 0">
    and "${modelbase.get_object_sql_alias(attr.parent)}".${attr.persistenceName} in
    <foreach collection="${inflector.pluralize(modelbase.get_attribute_sql_name(attr))}" item="${attr.persistenceName}" open="(" separator="," close=")">
      ${r"#{"}${attr.persistenceName}}
    </foreach>
    </if>
  </#if>
</#list>
<#-- 处理集合属性的子查询 -->
<#list obj.attributes as attr>
  <#if !attr.type.collection><#continue></#if>
  <#assign inMap = "in" + java.nameType(inflector.pluralize(modelbase.get_attribute_sql_name(attr)))>
  <#assign collObj = model.findObjectByName(attr.type.componentType.name)>
  <#list collObj.attributes as collObjAttr>
    <#if collObjAttr.type.name == obj.name>
      <#assign refAttrInCollObj = collObjAttr>
    </#if>
  </#list>
  <#if !refAttrInCollObj??><#continue></#if>
    <if test = "!${inMap}.isEmpty()">
    and ${modelbase.get_object_sql_alias(idAttr.parent)}.${idAttr.persistenceName} in (
      select ${refAttrInCollObj.persistenceName} from ${collObj.persistenceName} ${modelbase.get_object_sql_alias(collObj)} 
  <#-- LEFT JOIN IN SUB-QUERY -->
  <#list collObj.attributes as collObjAttr>  
    <#if !collObjAttr.type.custom || collObjAttr.type.name == obj.name><#continue></#if> 
      <#assign collObjAttrRefObj = model.findObjectByName(collObjAttr.type.name)> 
      <#assign collObjAttrRefObjIdAttr = modelbase.get_id_attributes(collObjAttrRefObj)[0]>
      left join ${collObjAttrRefObj.persistenceName} ${modelbase.get_object_sql_alias(collObjAttrRefObj)} on ${modelbase.get_object_sql_alias(collObjAttrRefObj)}.${collObjAttrRefObjIdAttr.persistenceName} = ${modelbase.get_object_sql_alias(collObj)}.${collObjAttr.persistenceName}
  </#list>
  <#-- WHERE IN SUB-QUERY -->
      where 1 = 1
  <#list collObj.attributes as collObjAttr>
    <#if !collObjAttr.persistenceName??><#continue></#if>
    <#if collObjAttr.name == "state" || !modelbase.is_attribute_system(collObjAttr)>
      <if test = "${inMap}.${modelbase.get_attribute_sql_name(collObjAttr)} != null">
      and ${modelbase.get_object_sql_alias(collObj)}.${collObjAttr.persistenceName} = ${r"#{"}${inMap}.${modelbase.get_attribute_sql_name(collObjAttr)}}
      </if>  
    </#if>  
  </#list>  
  <#list collObj.attributes as collObjAttr>  
    <#if !collObjAttr.type.custom || collObjAttr.type.name == obj.name><#continue></#if> 
      <#assign collObjAttrRefObj = model.findObjectByName(collObjAttr.type.name)> 
      <#assign collObjAttrRefObjIdAttr = modelbase.get_id_attributes(collObjAttrRefObj)[0]>
      <#list collObjAttrRefObj.attributes as collObjAttrRefObjAttr>
        <#if !collObjAttrRefObjAttr.isLabelled("listable")><#continue></#if>
      <if test = "${inMap}.${modelbase.get_attribute_sql_name(collObjAttrRefObjAttr)} != null">  
      and ${modelbase.get_object_sql_alias(collObjAttrRefObj)}.${collObjAttrRefObjAttr.persistenceName} like concat('%', ${r"#{"}${inMap}.${modelbase.get_attribute_sql_name(collObjAttrRefObjAttr)}}, '%')
      </if>
      </#list>
  </#list>
    )
    </if>  
</#list>   
  </sql>
  
  <sql id="orderBy${java.nameType(obj.name)}">
    <if test="orderByList != null and !orderByList.isEmpty()">
      order by
      <foreach item="orderBy" collection="orderByList" separator=",">
<#list obj.attributes as attr>   
  <#if !attr.isLabelled("persistence")><#continue></#if>
        <if test="orderBy == 'asc${java.nameType(modelbase.get_attribute_sql_name(attr))}'"> 
        ${attr.persistenceName} asc
        </if>
        <if test="orderBy == 'desc${java.nameType(modelbase.get_attribute_sql_name(attr))}'"> 
        ${attr.persistenceName} desc
        </if>
</#list>        
      </foreach>
    </if>
  </sql>
  
  <sql id="groupBy${java.nameType(obj.name)}">
    <if test="groupByList != null and !groupByList.isEmpty()">
      group by
      <foreach item="groupBy" collection="groupByList" separator=",">
<#list obj.attributes as attr>   
  <#if !attr.isLabelled("persistence")><#continue></#if>
        <if test="groupBy == '${modelbase.get_attribute_sql_name(attr)}'"> 
        ${attr.persistenceName}
        </if>
</#list>  
      </foreach>
    </if>
  </sql>
  
  <select id="select${java.nameType(obj.name)}" parameterType="${namespace}.${app.name}.dto.payload.${java.nameType(obj.name)}Query" resultType="java.util.HashMap">
    select 
<#------------->
<#-- 自身属性 -->  
<#------------->    
<#list idAttrs as attr>
      "${modelbase.get_object_sql_alias(obj)}".${attr.persistenceName} as "${modelbase.get_attribute_sql_name(attr)}",
</#list>
<#list nonIdAttrs as attr>
      "${modelbase.get_object_sql_alias(obj)}".${attr.persistenceName} as "${modelbase.get_attribute_sql_name(attr)}",
</#list>
<#------------->
<#-- 属性引用 -->  
<#------------->
<#list refObjs?keys as key>
  <#assign refObjAttrs = refObjs[key]['attrs']> 
  <#assign attr = refObjs[key]['attr']> 
  <#list refObjAttrs as refObjAttr>
    <#if attr.name != attr.type.name>
      ${java.nameVariable(attr.name)}_${modelbase.get_object_sql_alias(refObjAttr.parent)}.${refObjAttr.persistenceName} as "${java.nameVariable(attr.name)}_${modelbase.get_attribute_sql_name(refObjAttr)}",
    <#else>
      ${java.nameVariable(attr.name)}_${modelbase.get_object_sql_alias(refObjAttr.parent)}.${refObjAttr.persistenceName} as "${java.nameVariable(attr.name)}_${modelbase.get_attribute_sql_name(refObjAttr)}",
    </#if>  
  </#list>    
</#list>
<#------------->
<#-- 主键引用 -->  
<#------------->
<#if idAttrs?size == 1>
<@print_o2o_select idAttr=idAttrs[0] />
</#if>
<#------------->
<#-- 灵活扩展 -->  
<#------------->
<#list extObjs as extObjName, extRefAttr>
  <#assign extObj = extRefAttr.parent>
  <#list extObj.attributes as attr>
    <#if attr.name == 'name'>
      "${modelbase.get_object_sql_alias(extObj)}".${attr.persistenceName} as "${java.nameVariable(modelbase.get_attribute_sql_name(attr))}",
    <#elseif attr.isLabelled("listable")>
      "${modelbase.get_object_sql_alias(extObj)}".${attr.persistenceName} as "${java.nameVariable(modelbase.get_attribute_sql_name(attr))}",
    </#if>
  </#list>
</#list>
      0
    from <#if databaseName??>${databaseName}.</#if>${obj.persistenceName} "${modelbase.get_object_sql_alias(obj)}"
    <include refid="join${java.nameType(obj.name)}"/>
    where 1 = 1
    <include refid="where${java.nameType(obj.name)}"/>
    <include refid="orderBy${java.nameType(obj.name)}"/>
  </select>
  
  <select id="selectCountOf${java.nameType(obj.name)}" parameterType="${namespace}.${app.name}.dto.payload.${java.nameType(obj.name)}Query" resultType="long">
    select count(*)
    from <#if databaseName??>${databaseName}.</#if>${obj.persistenceName} "${modelbase.get_object_sql_alias(obj)}"
    <include refid="join${java.nameType(obj.name)}"/>
    where 1 = 1
    <include refid="where${java.nameType(obj.name)}"/>
  </select>
  
  <select id="selectAggregateOf${java.nameType(obj.name)}" parameterType="${namespace}.${app.name}.dto.payload.${java.nameType(obj.name)}Query" resultType="java.util.HashMap">
    select
    <include refid="column${java.nameType(obj.name)}"/>
    from <#if databaseName??>${databaseName}.</#if>${obj.persistenceName} "${modelbase.get_object_sql_alias(obj)}"
    <include refid="join${java.nameType(obj.name)}"/>
    where 1 = 1
    <include refid="where${java.nameType(obj.name)}"/>
    <include refid="groupBy${java.nameType(obj.name)}"/>
    <include refid="orderBy${java.nameType(obj.name)}"/>
  </select>
<#-- 观察属性 -->  
<#--
<#assign existingAttrExprs = {}>
<#list model.objects as checkingObj>
  <#list checkingObj.attributes as checkingAttr>
    <#if !checkingAttr.isLabelled("observer")><#continue></#if>
    <#assign operator = checkingAttr.getLabelledOptions("observer")["operator"]>
    <#assign attrexpr = checkingAttr.getLabelledOptions("observer")["attribute"]>
    <#if existingAttrExprs[attrexpr]??><#continue></#if>
    <#assign existingAttrExprs += {attrexpr:attrexpr}>
    <#if attrexpr?contains("(") && attrexpr?ends_with(")")>
      <#assign attrname = attrexpr?substring(attrexpr?index_of("(")+1,attrexpr?index_of(")"))>
      <#if checkingAttr.type.name == obj.name && model.findAttributeByNames(checkingAttr.type.name, attrname)??>
        <#assign observableAttr = model.findAttributeByNames(checkingAttr.type.name, attrname)>
        <#assign observableIdAttr = modelbase.get_id_attributes(observableAttr.parent)[0]>
        <#if operator == "max">
      
  <select id="selectMax${java.nameType(attrname)}Of${java.nameType(obj.name)}" parameterType="${namespace}.${app.name}.dto.payload.${java.nameType(obj.name)}Query" resultType="java.util.HashMap">
    select ${observableIdAttr.persistenceName}, max(${observableAttr.persistenceName}) 
    from ${obj.persistenceName}
    where 1 = 1
    <include refid="where${java.nameType(obj.name)}"/>
  </select>  
        <#elseif operator == "min">
    
  <select id="selectMin${java.nameType(attrname)}Of${java.nameType(obj.name)}" parameterType="${namespace}.${app.name}dto.payload.${java.nameType(obj.name)}Query" resultType="java.util.HashMap">
    select ${observableIdAttr.persistenceName}, min(${observableAttr.persistenceName}) 
    from ${obj.persistenceName}
    where 1 = 1
    <include refid="where${java.nameType(obj.name)}"/>
  </select>  
        <#elseif operator == "sum">
    
  <select id="selectSum${java.nameType(attrname)}Of${java.nameType(obj.name)}" parameterType="${namespace}.${app.name}.dto.payload.${java.nameType(obj.name)}Query" resultType="${modelbase4java.type_attribute_primitive(observableAttr)}">
    select sum(${observableAttr.persistenceName}) 
    from ${obj.persistenceName}
    where 1 = 1
    <include refid="where${java.nameType(obj.name)}"/>
  </select>                  
        </#if>
      </#if>
    </#if>
  </#list>
</#list>
-->
<#list obj.attributes as attr>
  <#if attr.isLabelled("comparable")>  
  
  <select id="selectMax${java.nameType(attr.name)}Of${java.nameType(obj.name)}" parameterType="${namespace}.${app.name}.dto.payload.${java.nameType(obj.name)}Query" resultType="${namespace}.${app.name}.dto.payload.${java.nameType(obj.name)}Query">
    select 
    <#list obj.attributes as innerAttr>
      <#if !innerAttr.persistenceName??><#continue></#if>
      ${innerAttr.persistenceName} ${modelbase.get_attribute_sql_name(innerAttr)},
    </#list>    
      0
    from ${obj.persistenceName}
    where ${attr.persistenceName} = (
      select max(${attr.persistenceName})
      from ${obj.persistenceName}
      <include refid="where${java.nameType(obj.name)}"/>
    )
    <include refid="where${java.nameType(obj.name)}"/>
    limit 1
  </select>  
  
  <select id="selectMin${java.nameType(attr.name)}Of${java.nameType(obj.name)}" parameterType="${namespace}.${app.name}.dto.payload.${java.nameType(obj.name)}Query" resultType="${namespace}.${app.name}.dto.payload.${java.nameType(obj.name)}Query">
    select 
    <#list obj.attributes as innerAttr>
      <#if !innerAttr.persistenceName??><#continue></#if>
      ${innerAttr.persistenceName} ${modelbase.get_attribute_sql_name(innerAttr)},
    </#list>    
      0
    from ${obj.persistenceName}
    where ${attr.persistenceName} = (
      select min(${attr.persistenceName})
      from ${obj.persistenceName}
      <include refid="where${java.nameType(obj.name)}"/>
    )
    <include refid="where${java.nameType(obj.name)}"/>
    limit 1
  </select>  
  </#if>  
</#list>  
<#list obj.attributes as attr>
  <#if attr.isLabelled("arithmeticable")>  
  
  <select id="selectAverage${java.nameType(attr.name)}Of${java.nameType(obj.name)}" parameterType="${namespace}.${app.name}.dto.payload.${java.nameType(obj.name)}Query" resultType="${modelbase4java.type_attribute_primitive(attr)}">
    select avg(${attr.persistenceName}) 
    from ${obj.persistenceName}
    where 1 = 1
    <include refid="where${java.nameType(obj.name)}"/>
  </select>  
  
  <select id="selectSum${java.nameType(attr.name)}Of${java.nameType(obj.name)}" parameterType="${namespace}.${app.name}.dto.payload.${java.nameType(obj.name)}Query" resultType="${modelbase4java.type_attribute_primitive(attr)}">
    select sum(${attr.persistenceName}) 
    from ${obj.persistenceName}
    where 1 = 1
    <include refid="where${java.nameType(obj.name)}"/>
  </select>  
  </#if>  
</#list> 
  
  <insert id="insert${java.nameType(obj.name)}" parameterType="${namespace}.${app.name}.poco.${java.nameType(obj.name)}">
    insert into ${obj.persistenceName} (
<#list idAttrs as attr>
      ${attr.persistenceName}<#if attr?index != idAttrs?size - 1 || nonIdAttrs?size != 0>,</#if>
</#list>
<#list nonIdAttrs as attr>
      ${attr.persistenceName}<#if attr?index != nonIdAttrs?size - 1>,</#if>
</#list>      
    ) values (
<#list idAttrs as attr>
  <#if attr.type.custom>  
      ${r"#{"}<@print_id idAttr=attr />}<#if attr?index != idAttrs?size - 1 || nonIdAttrs?size != 0>,</#if>
  <#else>
      ${r"#{"}${java.nameVariable(attr.name)}}<#if attr?index != idAttrs?size - 1 || nonIdAttrs?size != 0>,</#if>
  </#if>    
</#list>
<#list nonIdAttrs as attr>
  <#if attr.type.custom>  
      ${r"#{"}<@print_id idAttr=attr />}<#if attr?index != nonIdAttrs?size - 1>,</#if>
  <#elseif attr.type.name == 'bool'>
    <if test = "${modelbase.get_attribute_sql_name(attr)} == true">
      'T'<#if attr?index != nonIdAttrs?size - 1>,</#if>
    </if>  
    <if test = "${modelbase.get_attribute_sql_name(attr)} == null or ${modelbase.get_attribute_sql_name(attr)} == false">
      'F'<#if attr?index != nonIdAttrs?size - 1>,</#if>
    </if>  
  <#elseif attr.name == 'state'>
      'E'<#if attr?index != nonIdAttrs?size - 1>,</#if>
  <#else>
      ${r"#{"}${java.nameVariable(attr.name)}}<#if attr?index != nonIdAttrs?size - 1>,</#if>
  </#if>    
</#list>     
    );
  </insert>
  
  <update id="update${java.nameType(obj.name)}" parameterType="${namespace}.${app.name}.poco.${java.nameType(obj.name)}">
    update ${obj.persistenceName} set
<#list nonIdAttrs as attr>
  <#if attr.type.custom>  
      ${attr.persistenceName} = ${r"#{"}<@print_id idAttr=attr />},
  <#elseif attr.type.name == 'bool'>
    <if test = "${modelbase.get_attribute_sql_name(attr)} != null and ${modelbase.get_attribute_sql_name(attr)} == true">
      ${attr.persistenceName} = 'T',
    </if>  
    <if test = "${modelbase.get_attribute_sql_name(attr)} == null or ${modelbase.get_attribute_sql_name(attr)} == false">
      ${attr.persistenceName} = 'F',
    </if> 
  <#else>
      ${attr.persistenceName} = ${r"#{"}${java.nameVariable(attr.name)}},
  </#if>   
</#list>  
      ${idAttrs[0].persistenceName} = ${idAttrs[0].persistenceName}    
    where 1 = 1
<#list idAttrs as attr>
  <#if attr.type.custom>
    <if test="<@print_id idAttr=attr /> != null">
      and ${attr.persistenceName} = ${r"#{"}<@print_id idAttr=attr />}
    </if>  
  <#elseif attr.type.name != 'datetime'>
    <if test="${java.nameVariable(attr.name)} != null">
      and ${attr.persistenceName} = ${r"#{"}${java.nameVariable(attr.name)}}
    </if>  
  </#if>    
</#list>   
  </update>
  
  <update id="updatePartial${java.nameType(obj.name)}" parameterType="${namespace}.${app.name}.poco.${java.nameType(obj.name)}">
    update ${obj.persistenceName} set
<#list nonIdAttrs as attr>
    <if test="${java.nameVariable(attr.name)} != null">
  <#if attr.type.custom>  
      ${attr.persistenceName} = ${r"#{"}<@print_id idAttr=attr />},
  <#elseif attr.type.name == 'bool'>
      <if test = "${modelbase.get_attribute_sql_name(attr)} == true">
      ${attr.persistenceName} = 'T',
      </if>  
      <if test = "${modelbase.get_attribute_sql_name(attr)} == false">
      ${attr.persistenceName} = 'F',
      </if>
  <#else>
      ${attr.persistenceName} = ${r"#{"}${java.nameVariable(attr.name)}},
  </#if>   
    </if> 
</#list>  
      ${idAttrs[0].persistenceName} = ${idAttrs[0].persistenceName}    
    where 1 = 1
<#list idAttrs as attr>
  <#if attr.type.custom>
    <if test="<@print_id idAttr=attr /> != null">
      and ${attr.persistenceName} = ${r"#{"}<@print_id idAttr=attr />}
    </if>  
  <#elseif attr.type.name != 'datetime'>
    <if test="${java.nameVariable(attr.name)} != null">
      and ${attr.persistenceName} = ${r"#{"}${java.nameVariable(attr.name)}}
    </if>  
  </#if>    
</#list>    
  </update>
  
  <delete id="delete${java.nameType(obj.name)}" parameterType="${namespace}.${app.name}.poco.${java.nameType(obj.name)}">
    delete from ${obj.persistenceName} 
    where 1 = 1
<#list idAttrs as attr>
  <#if attr.type.custom>
    <if test="<@print_id idAttr=attr /> != null">
      and ${attr.persistenceName} = ${r"#{"}<@print_id idAttr=attr />}
    </if>  
  <#else>
    <if test="${java.nameVariable(attr.name)} != null">
      and ${attr.persistenceName} = ${r"#{"}${java.nameVariable(attr.name)}}
    </if>  
  </#if>    
</#list>   
    <if test="<#list idAttrs as attr><#if (attr?index > 0)> and </#if><#if attr.type.custom><@print_id idAttr=attr /> == null<#else>${java.nameVariable(attr.name)} == null</#if></#list>">
      and '没有任何主键传入' = '此种行为非常危险'
    </if>
  </delete>
<#list obj.attributes as attr>
  <#if !attr.isLabelled("arithmeticable")><#continue></#if>
  
  <update id="increment${java.nameType(attr.name)}Of${java.nameType(obj.name)}" parameterType="int">
    update ${obj.persistenceName} set
    ${attr.persistenceName} = ${attr.persistenceName} + ${r"#{"}value}
    where 1 = 1
    <#list idAttrs as attr>
      <#if attr.type.custom>  
      and ${attr.persistenceName} = ${r"#{"}<@print_id idAttr=attr />}
      <#else>
      and ${attr.persistenceName} = ${r"#{"}${java.nameVariable(attr.name)}}
      </#if>    
    </#list>   
  </update>
  
  <update id="decrement${java.nameType(attr.name)}Of${java.nameType(obj.name)}" parameterType="int">
    update ${obj.persistenceName} set
    ${attr.persistenceName} = ${attr.persistenceName} - ${r"#{"}value}
    where 1 = 1
    <#list idAttrs as attr>
      <#if attr.type.custom>  
      and ${attr.persistenceName} = ${r"#{"}<@print_id idAttr=attr />}
      <#else>
      and ${attr.persistenceName} = ${r"#{"}${java.nameVariable(attr.name)}}
      </#if>    
    </#list>   
  </update>
  
  <update id="multiply${java.nameType(attr.name)}Of${java.nameType(obj.name)}" parameterType="java.math.BigDecimal">
    update ${obj.persistenceName} set
    ${attr.persistenceName} = ${attr.persistenceName} * ${r"#{"}value}
    where 1 = 1
    <#list idAttrs as attr>
      <#if attr.type.custom>  
      and ${attr.persistenceName} = ${r"#{"}<@print_id idAttr=attr />}
      <#else>
      and ${attr.persistenceName} = ${r"#{"}${java.nameVariable(attr.name)}}
      </#if>    
    </#list>   
  </update>
  
  <update id="divide${java.nameType(attr.name)}Of${java.nameType(obj.name)}" parameterType="java.math.BigDecimal">
    update ${obj.persistenceName} set
    ${attr.persistenceName} = ${attr.persistenceName} / ${r"#{"}value}
    where 1 = 1
    <#list idAttrs as attr>
      <#if attr.type.custom>  
      and ${attr.persistenceName} = ${r"#{"}<@print_id idAttr=attr />}
      <#else>
      and ${attr.persistenceName} = ${r"#{"}${java.nameVariable(attr.name)}}
      </#if>    
    </#list>   
  </update>
</#list>
<#list obj.attributes as attr>
  <#if attr.name == "state">  
    
  <update id="enable${java.nameType(obj.name)}" parameterType="${modelbase4java.type_attribute_primitive(idAttrs[0])}">
    update ${obj.persistenceName} set
    ${attr.persistenceName} = 'E'
    where 1 = 1
    <#list idAttrs as attr>
      <#if attr.type.custom>  
      and ${attr.persistenceName} = ${r"#{"}<@print_id idAttr=attr />}
      <#else>
      <if test="${java.nameVariable(attr.name)} != null">
      and ${attr.persistenceName} = ${r"#{"}${java.nameVariable(attr.name)}}
      </if>  
      </#if>  
    </#list>   
  </update>
  
  <update id="disable${java.nameType(obj.name)}" parameterType="${modelbase4java.type_attribute_primitive(idAttrs[0])}">
    update ${obj.persistenceName} set
    ${attr.persistenceName} = 'D'
    where 1 = 1
    <#list idAttrs as attr>
      <#if attr.type.custom>  
      and ${attr.persistenceName} = ${r"#{"}<@print_id idAttr=attr />}
      <#else>
      <if test="${java.nameVariable(attr.name)} != null">
      and ${attr.persistenceName} = ${r"#{"}${java.nameVariable(attr.name)}}
      </if>  
      </#if>     
    </#list>   
  </update>
  </#if>
</#list>
<#if idAttrs?size == 1>
  
  <select id="isExisting${java.nameType(obj.name)}" parameterType="${modelbase4java.type_attribute_primitive(idAttrs[0])}">
    select exists (
      select 1 from ${obj.persistenceName} where ${idAttrs[0].persistenceName}=${r"#{"}${modelbase.get_attribute_sql_name(idAttrs[0])}}
    )
  </select>
<#else>
  
  <select id="isExisting${java.nameType(obj.name)}" parameterType="${namespace}.${app.name}.dto.payload.${java.nameType(obj.name)}Query">
    select exists (
      select 1 from ${obj.persistenceName} 
      where 1 = 1
<#list idAttrs as idAttr>
      <if test = "${modelbase.get_attribute_sql_name(idAttr)} != null">
      and ${idAttr.persistenceName}=${r"#{"}${modelbase.get_attribute_sql_name(idAttr)}}
      </if>
</#list>
    )
  </select>  
</#if>
</mapper>
