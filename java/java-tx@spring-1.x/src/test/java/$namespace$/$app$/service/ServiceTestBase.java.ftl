<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package biz.doublegsoft.${app.name}.service;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Type;
import java.nio.charset.StandardCharsets;
import java.util.Map;

/**
 * 服务测试基类。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since 1.0.0
 */
public class ServiceTestBase {
  
  protected static ApplicationContext context;
  
  public ApplicationContext getContext() {
    if (context == null) {
      context = new ClassPathXmlApplicationContext("spring-test.xml");
    }
    return context;
  }

  public Map<String,Object> fromJson(String filename) throws Exception {
    try (InputStream in = getClass().getClassLoader().getResourceAsStream(filename);
      InputStreamReader streamReader = new InputStreamReader(in, StandardCharsets.UTF_8);
      BufferedReader reader = new BufferedReader(streamReader)) {

      StringBuilder json = new StringBuilder();
      String line;
      while ((line = reader.readLine()) != null) {
        json.append(line);
      }
      Gson gson = new Gson();
      Type type = new TypeToken<Map<String, Object>>(){}.getType(); // Define the Map type
      return gson.fromJson(json.toString(), type);
    }
  }

}
