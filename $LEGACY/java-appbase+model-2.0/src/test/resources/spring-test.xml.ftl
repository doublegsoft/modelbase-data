<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
<?xml version="1.0" encoding="UTF-8" ?>

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:jdbc="http://www.springframework.org/schema/jdbc"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context
       http://www.springframework.org/schema/context/spring-context.xsd
       http://www.springframework.org/schema/jdbc
       http://www.springframework.org/schema/jdbc/spring-jdbc.xsd
       http://www.springframework.org/schema/mvc
       http://www.springframework.org/schema/mvc/spring-mvc.xsd">

  <context:component-scan base-package="${namespace}.*" />

  <jdbc:initialize-database data-source="dataSource" ignore-failures="DROPS">
<#list dependencies![] as dep>
  <#assign depObj = dep?string?split(':')>
    <jdbc:script location="classpath:sql/install-database-${depObj[1]?replace('stdbiz-', '')?replace('-model', '')}.sql" />
</#list>
    <jdbc:script location="classpath:sql/install-database-${app.name}.sql" />
  </jdbc:initialize-database>

  <bean name="dataSource" class="com.alibaba.druid.pool.DruidDataSource" init-method="init" destroy-method="close">
    <property name="driverClassName" value="org.h2.Driver" />
    <property name="url" value="jdbc:h2:mem:test;MODE=MYSQL" />
    <property name="username" value="sa" />
    <property name="password" value="" />

    <property name="initialSize" value="0" />
    <property name="maxActive" value="3" />
    <property name="minIdle" value="0" />
    <property name="maxWait" value="60000" />

    <property name="validationQuery" value="select 1" />
    <property name="testWhileIdle" value="true" />
    <property name="testOnBorrow" value="true" />
    <property name="testOnReturn" value="false" />

    <property name="timeBetweenEvictionRunsMillis" value="60000" />
    <property name="minEvictableIdleTimeMillis" value="25200000" />

    <property name="connectionErrorRetryAttempts" value="3" />
    <property name="breakAfterAcquireFailure" value="true" />

    <property name="removeAbandoned" value="false" />
    <property name="removeAbandonedTimeout" value="1800" />
    <property name="logAbandoned" value="true" />

    <property name="filters" value="stat" />
  </bean>

  <!-- Common Component -->

  <bean id="commonService" class="net.doublegsoft.appbase.service.CommonService">
    <property name="sqlManager" ref="sqlManager" />
    <property name="commonDataAccess" ref="commonDataAccess" />
  </bean>

  <bean id="repositoryService" class="net.doublegsoft.appbase.service.RepositoryService">
    <property name="namespace">
      <value>${namespace}</value>
    </property>
    <property name="namespaces">
      <map>
        <entry key="${parentApplication}" value="${namespace}" />
      </map>
    </property>
  </bean>

  <bean id="groovyService" class="net.doublegsoft.appbase.service.GroovyService">
    <property name="root" value="../dist/script" />
  </bean>

  <bean id="commonDataAccess" class="net.doublegsoft.appbase.dao.JdbcCommonDataAccess"
        destroy-method="close">
    <property name="dataSource" ref="dataSource" />
  </bean>

  <bean id="sqlManager" class="net.doublegsoft.appbase.sql.SqlManager">
    <property name="resources">
      <list>
<#list dependencies![] as dep>
  <#assign depObj = dep?string?split(':')>
        <value>/sql/${depObj[1]?replace('stdbiz', 'sql')}.xml</value>
</#list>
        <value>/sql/sql-${app.name}-model.xml</value>
      </list>
    </property>
  </bean>

</beans>
