<#import "/$/modelbase4java.ftl" as modelbase4java>
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
  <version>${version!'1.0.0'}</version>
  <packaging>jar</packaging>

  <description>${description!''}</description>

  <properties>
    <maven.build.timestamp.format>yyyyMMdd</maven.build.timestamp.format>
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
<@modelbase4java.print_pom_dependencies deps=dependencies indent=4 />  
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.12</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>com.h2database</groupId>
      <artifactId>h2</artifactId>
      <version>1.4.200</version>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <repositories>
    <repository>
      <id>doublegsoft-online</id>
      <url>http://nexus.doublegsoft.cn/repository/maven-releases</url>
    </repository>
  </repositories>  
</project>
