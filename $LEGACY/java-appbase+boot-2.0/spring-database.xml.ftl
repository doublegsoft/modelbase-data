<?xml version="1.0" encoding="UTF-8" ?>

<!--suppress SpringFacetInspection -->
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:jdbc="http://www.springframework.org/schema/jdbc"
       xsi:schemaLocation="
       http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/jdbc
       http://www.springframework.org/schema/jdbc/spring-jdbc.xsd">

  <jdbc:initialize-database data-source="dataSource">
    <jdbc:script location="classpath:/sql/install-database-gb-mysql.sql"/>
    <jdbc:script location="classpath:/sql/install-database-sms-mysql.sql"/>
    <jdbc:script location="classpath:/sql/install-database-dmm-mysql.sql"/>
    <jdbc:script location="classpath:/sql/install-database-etl-mysql.sql"/>
    <jdbc:script location="classpath:/sql/install-database-sam-mysql.sql"/>
    <jdbc:script location="classpath:/sql/install-database-ttm-mysql.sql"/>
    <jdbc:script location="classpath:/sql/install-database-wfm-mysql.sql"/>
    <jdbc:script location="classpath:/sql/install-database-km-mysql.sql"/>
    <jdbc:script location="classpath:/sql/install-database-aux-mysql.sql"/>
    <jdbc:script location="classpath:/sql/install-database-trm-mysql.sql"/>
    <jdbc:script location="classpath:/sql/install-database-nlp-mysql.sql"/>
    <jdbc:script location="classpath:/sql/install-database-gds-mysql.sql"/>

    <jdbc:script location="file:data/setup-testdata.sql"/>
  </jdbc:initialize-database>

  <bean name="dataSource" class="com.alibaba.druid.pool.DruidDataSource" init-method="init" destroy-method="close">
    <property name="driverClassName" value="com.mysql.jdbc.Driver" />
    <property name="url" value="jdbc:mysql://localhost:3306/stdbiz" />
    <property name="username" value="root" />
    <property name="password" value="ganguo" />

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

</beans>
