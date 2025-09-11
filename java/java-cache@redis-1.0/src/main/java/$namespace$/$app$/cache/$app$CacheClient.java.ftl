<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.httpc;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;
import java.io.IOException;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

/**
 * Redis缓存客户端。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since 1.0.0
 */
public class ${java.nameType(app.name)}CacheClient {

<#list model.objects as obj>  
  <#if !obj.isLabelled("request")><#continue></#if>
  <#assign response = obj.getLabelledOptions("request")["response"]>
  <#assign respObj = model.findObjectByName(response)>
  <#assign httpmethod = obj.getLabelledOptions("http")["method"]>
  /*!
  **
  */
  public void put${java.nameType(obj.name)}() throws IOException {
    JedisPool pool = new JedisPool("localhost", 6379);

    try (Jedis jedis = pool.getResource()) {
      // Store & Retrieve a simple string
      jedis.set("foo", "bar");
      System.out.println(jedis.get("foo")); // prints bar
      
      // Store & Retrieve a HashMap
      Map<String, String> hash = new HashMap<>();;
      hash.put("name", "John");
      hash.put("surname", "Smith");
      hash.put("company", "Redis");
      hash.put("age", "29");
      jedis.hset("user-session:123", hash);
      System.out.println(jedis.hgetAll("user-session:123"));
      // Prints: {name=John, surname=Smith, company=Redis, age=29}
    }
  } 
</#list>
}
