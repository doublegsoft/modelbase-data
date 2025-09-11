<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#list model.objects as obj>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  <#assign pktype = modelbase4java.type_attribute_primitive(idAttrs[0])>
  <#break>
</#list>
package ${namespace}.${app.name}.util;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;

public class IdGenerator {
  
  private static final Snowflake SNOWFLAKE = new Snowflake(1);

  public static ${pktype} id() {
    <#if pktype == 'String'>
    return String.valueOf(SNOWFLAKE.nextId());
    <#else>
    return SNOWFLAKE.nextId();
    </#if>
  }

}
