<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.runtime;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Named;
import jakarta.servlet.http.HttpSession;

import org.springframework.cache.Cache;

@Named
@ApplicationScoped
public class PlatformCacheManager implements CacheManager {

  private final org.springframework.cache.CacheManager delegate;

  public PlatformCacheManager(org.springframework.cache.CacheManager delegate) {
    this.delegate = delegate;
  }

  @Override
  public <T> T get(String cacheName,
                   Object key,
                   Class<T> type) {

    Cache cache = delegate.getCache(cacheName);
    if (cache == null) {
      return null;
    }

    Cache.ValueWrapper wrapper = cache.get(key);

    if (wrapper == null) {
      return null;
    }

    Object value = wrapper.get();

    if (value == null) {
      return null;
    }

    return type.cast(value);
  }

  @Override
  public void put(String cacheName,
                  Object key,
                  Object value) {

    Cache cache = delegate.getCache(cacheName);
    if (cache != null) {
      cache.put(key, value);
    }
  }

  @Override
  public void evict(String cacheName,
                    Object key) {

    Cache cache = delegate.getCache(cacheName);
    if (cache != null) {
      cache.evict(key);
    }
  }

  @Override
  public void clear(String cacheName) {

    Cache cache = delegate.getCache(cacheName);
    if (cache != null) {
      cache.clear();
    }
  }

  @Override
  public boolean exists(String cacheName,
                        Object key) {

    Cache cache = delegate.getCache(cacheName);

    if (cache == null) {
      return false;
    }

    return cache.get(key) != null;
  }
}
