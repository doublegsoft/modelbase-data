<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4kotlin.ftl" as modelbase4kotlin>
package ${namespace}.${java.nameNamespace(app.name)}.sdk.payload

import java.util.Date
import java.math.BigDecimal
<#list model.objects as obj>

/**
 * 【${modelbase.get_object_label(obj)}】传输对象。
 */
data class ${java.nameType(obj.name)}Query(
  <#list obj.attributes as attr>
  val ${modelbase.get_attribute_sql_name(attr)}: ${modelbase4kotlin.type_attribute(attr)}? = null,
  </#list>
)
</#list>