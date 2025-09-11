<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.dao;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.DriverManager;

import java.io.Reader;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class BaseDataAccessTest {
  
  private static boolean initialized = false;
  
  private static SqlSessionFactory sqlSessionFactory;
 
  public static void initialize() throws Exception {
    if (!initialized) {
      Class.forName("org.h2.Driver");
      Connection conn = DriverManager.getConnection("jdbc:h2:mem:test;MODE=MySQL;DB_CLOSE_DELAY=-1");
      Statement stmt = conn.createStatement();
      
      StringBuilder sql = new StringBuilder();
      ClassLoader classLoader = BaseDataAccessTest.class.getClassLoader();
      
      InputStream inputStream = classLoader.getResourceAsStream("sql/install-database-${app.name}-mysql.sql");
      BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
      String line;
      while ((line = reader.readLine()) != null) {
        sql.append(line).append("\n");
      }
      stmt.execute(sql.toString());
      initialized = true;
    }
  }
  
  public static SqlSessionFactory getSessionFactory() throws Exception {
    if (sqlSessionFactory == null) {
      initialize();
      try (Reader reader = Resources.getResourceAsReader("mybatis-config.xml")) {
        sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
      }
    }
    return sqlSessionFactory;
  }
  

}