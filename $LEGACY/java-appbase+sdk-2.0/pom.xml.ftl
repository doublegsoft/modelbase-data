<#if license??>
${xml.license(license)}
</#if>
<project xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://maven.apache.org/POM/4.0.0"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>${namespace}<#if appgroup??>.${appgroup}</#if></groupId>
  <artifactId>${artifact}</artifactId>
  <version>${version!'1.0'}</version>
  <packaging>jar</packaging>

  <description>${description!''}</description>

  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
  </properties>

  <build>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.2</version>
        <configuration>
          <source>1.8</source>
          <target>1.8</target>
          <encoding>utf8</encoding>
        </configuration>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-source-plugin</artifactId>
        <version>3.0.1</version>
        <executions>
          <execution>
            <id>attach-sources</id>
            <goals>
              <goal>jar</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>

  <dependencies>
<#list dependencies![] as dep>
	<#assign depObj = dep?string?split(':')>
    <dependency>
      <groupId>${depObj[0]}</groupId>
      <artifactId>${depObj[1]?replace('model','sdk')}</artifactId>
      <version>${depObj[2]}</version>
    </dependency>
</#list>
    <dependency>
      <groupId>com.squareup.okhttp</groupId>
      <artifactId>okhttp</artifactId>
      <version>2.5.0</version>
    </dependency>
    <dependency>
			<groupId>com.alibaba</groupId>
			<artifactId>fastjson</artifactId>
			<version>1.2.6</version>
		</dependency>
  </dependencies>

  <repositories>
    <repository>
      <id>cqwinning-releases</id>
      <url>http://120.79.137.143:8081/repository/maven-releases</url>
    </repository>
  </repositories>

  <distributionManagement>
    <repository>
			<id>cqwinning-repository</id>
      <url>http://120.79.137.143:8081/repository/maven-releases/</url>
		</repository>
	</distributionManagement>

</project>
