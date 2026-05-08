<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
  PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
  <#--
  <typeHandlers>
<#list model.objects as obj>   
  <#if obj.isLabelled("entity") || obj.isLabelled("constant")>
    <typeHandler handler="${namespace}.${app.name}.orm.typehandler.${java.nameType(obj.name)}TypeHandler" javaType="${namespace}.${app.name}.poco.${java.nameType(obj.name)}" />
  </#if>  
</#list>
  </typeHandlers>
  -->
  <environments default="test">
    <environment id="test">
      <transactionManager type="JDBC"/>
      <dataSource type="POOLED">
        <property name="driver" value="org.h2.Driver"/>
        <property name="url" value="jdbc:h2:mem:test;MODE=MYSQL;DB_CLOSE_DELAY=-1" />
      </dataSource>
    </environment>
  </environments>
  <mappers>
<#list model.objects as obj>  
  <#if !obj.persistenceName??><#continue></#if>
    <mapper resource="orm/${java.nameType(obj.name)}.xml" />
</#list>    
  </mappers>
</configuration>