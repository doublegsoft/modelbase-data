<?xml version="1.0" encoding="UTF-8" ?>

<!--suppress SpringFacetInspection -->
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xmlns:p="http://www.springframework.org/schema/p"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context
       http://www.springframework.org/schema/context/spring-context.xsd
       http://www.springframework.org/schema/mvc
       http://www.springframework.org/schema/mvc/spring-mvc.xsd">
  
  <context:annotation-config />
  <context:component-scan base-package="<#if namespace??>${namespace}.</#if>,net.doublegsoft" />

  <bean name="dataSource" class="com.alibaba.druid.pool.DruidDataSource" init-method="init" destroy-method="close">
    <property name="driverClassName" value="com.microsoft.sqlserver.jdbc.SQLServerDriver" />
    <property name="url" value="jdbc:sqlserver://120.79.137.143:1433;databaseName=ONLIQUIZ" />
    <property name="username" value="sa" />
    <property name="password" value="Winning123" />

    <property name="initialSize" value="10" />
    <property name="maxActive" value="30" />
    <property name="minIdle" value="10" />
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

  <bean id="groovyService" class="net.doublegsoft.appbase.service.GroovyService">
    <property name="root" value="script" />
  </bean>

  <bean id="repositoryService" class="net.doublegsoft.appbase.service.RepositoryService">
    <property name="namespaces">
      <map>
        <entry key="stdbiz" value="biz.doublegsoft.stdbiz"/>
      </map>
    </property>
  </bean>

  <bean id="fileStoreService" class="net.doublegsoft.appbase.service.FileStoreService">
    <property name="resources">
      <map>
        <entry key="avatar" value="/www/avatar"/>
      </map>
    </property>
  </bean>
  
  <bean id="commonService" class="net.doublegsoft.appbase.service.CommonService">
    <property name="sqlManager" ref="sqlManager" />
    <property name="commonDataAccess" ref="commonDataAccess" />
  </bean>

  <bean id="commonDataAccess" class="net.doublegsoft.appbase.dao.JdbcCommonDataAccess"
        destroy-method="close">
    <property name="dataSource" ref="dataSource" />
  </bean>

  <bean id="sqlManager" class="net.doublegsoft.appbase.sql.SqlManager">
    <property name="resources">
      <list>
        <value>/sql/sql-${app.name}-model-mysql.xml</value>
      </list>
    </property>
  </bean>
  
  <bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
    <property name="maxUploadSize" value="1073741824" />
  </bean>

  <bean id="objectMapResolver" class="net.doublegsoft.appbase.webmvc.ObjectMapArgumentResolver" lazy-init="false"/>

  <mvc:interceptors>
    <bean id="controllerInterceptor" class="net.doublegsoft.appbase.webmvc.ControllerInterceptor" />
  </mvc:interceptors>

  <!-- 自定义请求对象和应答对象的封装 -->
  <bean class="net.doublegsoft.appbase.webmvc.AppbaseRequestMappingHandlerAdapter">
    <property name="messageConverters">
      <list>
        <bean class="org.springframework.http.converter.StringHttpMessageConverter">
          <property name="supportedMediaTypes" value="text/plain;charset=UTF-8" />
        </bean>
        <bean class="net.doublegsoft.appbase.webmvc.JsonDataHttpMessageConverter" />
      </list>
    </property>
    <property name="customArgumentResolvers">
      <list>
        <bean class="net.doublegsoft.appbase.webmvc.ObjectMapArgumentResolver"/>
      </list>
    </property>
  </bean>

</beans>
