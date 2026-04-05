<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.config;

import com.baomidou.mybatisplus.core.toolkit.PluginUtils;
import com.baomidou.mybatisplus.extension.plugins.inner.InnerInterceptor;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class BusinessPolicyInterceptor implements InnerInterceptor {

  @Override
  public void beforeQuery(
      Executor executor,
      MappedStatement ms,
      Object parameter,
      RowBounds rowBounds,
      ResultHandler resultHandler,
      BoundSql boundSql) {

    String originalSql = boundSql.getSql();

    // 👉 你的数据权限 SQL（比如 dept 过滤）
    String permissionSql = "dept_id = 100";

    String newSql = originalSql + " AND " + permissionSql;

    PluginUtils.mpBoundSql(boundSql).sql(newSql);
    System.out.println(newSql);
  }

}