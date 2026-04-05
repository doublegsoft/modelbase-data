<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.config;

import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.DataPermissionInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MybatisPlusConfig {

  @Bean
  public MybatisPlusInterceptor mybatisPlusInterceptor(BusinessPolicyHandler handler) {
    MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();

    DataPermissionInterceptor dataPermissionInterceptor = new DataPermissionInterceptor();
    dataPermissionInterceptor.setDataPermissionHandler(handler);
    interceptor.addInnerInterceptor(dataPermissionInterceptor);

    return interceptor;
  }

  @Bean
  public ConfigurationCustomizer configurationCustomizer() {
    return configuration -> {
      configuration.addInterceptor(new SlowSqlInterceptor());
    };
  }
}