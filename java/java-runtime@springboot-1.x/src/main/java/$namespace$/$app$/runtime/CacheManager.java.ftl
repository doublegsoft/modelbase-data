<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.runtime;

public interface CacheManager {

  <T> T get(String cacheName, Object key, Class<T> type);

  void put(String cacheName, Object key, Object value);

  void evict(String cacheName, Object key);

  void clear(String cacheName);

  boolean exists(String cacheName, Object key);
}
