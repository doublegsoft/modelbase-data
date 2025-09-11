<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name};

import org.springframework.context.support.FileSystemXmlApplicationContext;


public class Installation {

  public static void main(String[] args) throws Exception {
    new FileSystemXmlApplicationContext("./spring-database.xml");
  }

}
