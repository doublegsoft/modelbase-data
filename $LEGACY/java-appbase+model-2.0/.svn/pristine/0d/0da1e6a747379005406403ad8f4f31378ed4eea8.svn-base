<#import '/$/modelbase.ftl' as modelbase>
<?xml version="1.0" encoding="UTF-8"?>  

<databaseChangeLog  
        xmlns="http://www.liquibase.org/xml/ns/dbchangelog"  
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
        xmlns:ext="http://www.liquibase.org/xml/ns/dbchangelog-ext"  
        xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-3.8.xsd
        http://www.liquibase.org/xml/ns/dbchangelog-ext http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-ext.xsd">  

  <preConditions>  
    <runningAs  username=""/>  
  </preConditions>  

  <changeSet  id="1"  author="Christian Gann">  
<#list model.objects as obj>  
  <#if obj.isLabelled('generated') || !obj.persistenceName??><#continue></#if>

    <createTable  tableName="${obj.persistenceName}"> 
  <#list obj.attributes as attr>
    <#if !attr.persistenceName??><#continue></#if>
    <#assign datatype = ''>
    <#if attr.constraint.domainType.name?index_of('&') == 0>
      <#assign datatype = 'varchar(64)'>
    <#else>
      <#assign datatype = typebase.typename(attr.constraint.domainType.name, 'sql')!'varchar(64)'>
    </#if>
    <#if attr.constraint.identifiable>
      <column name="${attr.persistenceName}" type="${datatype}">  
        <constraints primaryKey="true" nullable="false"/>  
      </column>  
    <#elseif !attr.constraint.nullable>
      <column name="${attr.persistenceName}" type="${datatype}">
        <constraints nullable="false"/> 
      </column>
    <#else>
      <column name="${attr.persistenceName}" type="${datatype}"/>
    </#if>
  </#list>
    </createTable>  
  <#if obj.getLabelledOptions('persistence')['revision']??>

    <createTable  tableName="${obj.getLabelledOptions('persistence')['revision']}"> 
    <#list obj.attributes as attr>
      <#if !attr.persistenceName??><#continue></#if>
      <#assign datatype = ''>
      <#if attr.constraint.domainType.name?index_of('&') == 0>
        <#assign datatype = 'varchar(64)'>
      <#else>
        <#assign datatype = typebase.typename(attr.constraint.domainType.name, 'sql')!'varchar(64)'>
      </#if>
      <#if attr.constraint.identifiable>
      <column name="${attr.persistenceName}" type="${datatype}">  
        <constraints primaryKey="true" nullable="false"/>  
      </column>  
      <#elseif !attr.constraint.nullable>
      <column name="${attr.persistenceName}" type="${datatype}">
        <constraints nullable="false"/> 
      </column>
      <#elseif attr.name == 'last_modified_time'>
      <column name="${attr.persistenceName}" type="${datatype}">  
        <constraints primaryKey="true" nullable="false"/>  
      </column>  
      <#else>
      <column name="${attr.persistenceName}" type="${datatype}"/>
      </#if>
    </#list>
    </createTable>  
  </#if>
</#list>
  </changeSet>  

</databaseChangeLog>
