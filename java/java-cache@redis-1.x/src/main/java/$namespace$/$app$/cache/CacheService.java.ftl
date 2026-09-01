<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${java.nameNamespace(app.name)}.cache;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;
import java.io.IOException;
import java.time.Duration;

import jakarta.annotation.*;
import jakarta.inject.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.redisson.api.RBucket;
import org.redisson.api.RedissonClient;
import org.springframework.stereotype.Service;

import ${namespace}.${java.nameNamespace(app.name)}.dto.payload.*;

/**
 * Redis缓存客户端。
 */
@Named 
public class CacheService {

  @Resource
  private RedissonClient redissonClient;

  <#list model.objects as obj>  
  <#if !obj.isLabelled("cache")><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>

  public void put${java.nameType(obj.name)}(${java.nameType(obj.name)}Query query) {
    
  } 
  <#if idAttrs?size != 0>
  
  public ${java.nameType(obj.name)}Query get${java.nameType(obj.name)}Query(<#list idAttrs as idAttr><#if idAttr?index != 0>, </#if>${modelbase4java.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)}</#list>) {
    return null;
  } 

  public void delete${java.nameType(obj.name)}Query(<#list idAttrs as idAttr><#if idAttr?index != 0>, </#if>${modelbase4java.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)}</#list>) {
    
  }
  </#if>
</#list>
}
