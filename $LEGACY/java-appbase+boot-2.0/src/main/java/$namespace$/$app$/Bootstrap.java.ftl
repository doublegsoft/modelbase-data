<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name};

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ImportResource;

/**
 * It is the startup entry to ${app.name} application.
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since 1.0
 */
@SpringBootApplication
@ImportResource({"file:${r'${user.dir}'}/spring.xml"})
public class Bootstrap {

  public static void main(String[] args) throws Exception {
    if (args.length > 0 && "-i".equals(args[0])) {
      Installation.main(args);
      return;
    }
    SpringApplication.run(Bootstrap.class, args);
  }

}
