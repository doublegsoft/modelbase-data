<!--
 !!! Copyright 2020 Chongqing Winning
 !!! 
 !!! Licensed under the Apache License, Version 2.0 (the "License");
 !!! you may not use this file except in compliance with the License.
 !!! You may obtain a copy of the License at
 !!! 
 !!!     http://www.apache.org/licenses/LICENSE-2.0
 !!! 
 !!! Unless required by applicable law or agreed to in writing, software
 !!! distributed under the License is distributed on an "AS IS" BASIS,
 !!! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 !!! See the License for the specific language governing permissions and
 !!! limitations under the License.
 -->
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
    <stdbiz.version>2.1</stdbiz.version>
  </properties>

  <parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.1.3.RELEASE</version>
  </parent>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>net.doublegsoft.appbase</groupId>
        <artifactId>appbase-parent</artifactId>
        <version>5.0</version>
        <scope>import</scope>
        <type>pom</type>
      </dependency>
    </dependencies>
  </dependencyManagement>

  <build>
    <plugins>
      <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
      </plugin>
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
    <dependency>
      <groupId>biz.doublegsoft.stdbiz</groupId>
      <artifactId>stdbiz-${app.name}-model</artifactId>
      <version>${r'${stdbiz.version}'}</version>
    </dependency>
    
    <dependency>
      <groupId>net.doublegsoft.appbase</groupId>
      <artifactId>appbase-common</artifactId>
    </dependency>
    <dependency>
      <groupId>net.doublegsoft.appbase</groupId>
      <artifactId>appbase-common-spring</artifactId>
    </dependency>

    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
      <exclusions>
        <exclusion>
          <groupId>org.apache.lucene</groupId>
          <artifactId>lucene-core</artifactId>
        </exclusion>
      </exclusions>
    </dependency>
    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>8.0.19</version>
    </dependency>
    <dependency>
      <groupId>org.aspectj</groupId>
      <artifactId>aspectjweaver</artifactId>
    </dependency>
    <dependency>
      <groupId>com.alibaba</groupId>
      <artifactId>druid</artifactId>
    </dependency>
    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-api</artifactId>
    </dependency>
    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-simple</artifactId>
    </dependency>
    <dependency>
      <groupId>org.apache.poi</groupId>
      <artifactId>poi</artifactId>
      <version>4.1.2</version>
    </dependency>
    <dependency>
      <groupId>org.apache.poi</groupId>
      <artifactId>poi-ooxml</artifactId>
      <version>4.1.2</version>
    </dependency>
    <dependency>
      <groupId>org.apache.poi</groupId>
      <artifactId>poi-ooxml-schemas</artifactId>
      <version>4.1.2</version>
    </dependency>

    <dependency>
      <groupId>com.microsoft.sqlserver</groupId>
      <artifactId>mssql-jdbc</artifactId>
      <version>7.0.0.jre8</version>
    </dependency>
    <dependency>
      <groupId>commons-codec</groupId>
      <artifactId>commons-codec</artifactId>
      <version>1.11</version>
    </dependency>
    <dependency>
      <groupId>com.squareup.okhttp</groupId>
      <artifactId>okhttp</artifactId>
      <version>2.5.0</version>
    </dependency>
    <dependency>
      <groupId>org.codehaus.groovy</groupId>
      <artifactId>groovy-all</artifactId>
      <version>2.5.6</version>
      <type>pom</type>
    </dependency>

    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>com.squareup.okhttp3</groupId>
      <artifactId>okhttp</artifactId>
      <version>3.14.2</version>
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
