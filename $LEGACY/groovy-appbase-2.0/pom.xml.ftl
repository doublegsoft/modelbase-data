<#if license??>
${xml.license(license)}
</#if>
<project xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://maven.apache.org/POM/4.0.0"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>${namespace}<#if appgroup??>.${appgroup}</#if></groupId>
  <artifactId>${artifact?replace('model', 'script')}</artifactId>
  <version>${version!'1.0'}</version>
  <packaging>jar</packaging>

  <description>${description!''}</description>

  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
  </properties>

  <build>
    <resources>
      <resource>
        <directory>src/main/script</directory>
        <filtering>true</filtering>
      </resource>
    </resources>
  </build>

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
