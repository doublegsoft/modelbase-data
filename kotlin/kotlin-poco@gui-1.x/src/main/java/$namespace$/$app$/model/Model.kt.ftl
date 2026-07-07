<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4kotlin.ftl" as modelbase4kotlin>
package ${namespace}.${java.nameNamespace(app.name)}.model

import java.util.Date
import java.math.BigDecimal

/**
 * 表示通常用于 UI 选择组件（如下拉菜单、单选框等）的键值对。
 *
 * @property value 与该选项关联的内部标识符或原始值。
 * @property label 在用户界面中显示的友好文本。
 */
data class Option(
  val value: String,
  val label: String
)

/**
 * 用于结构化分页查询结果的泛型包装类。
 *
 * @param T 列表中包含的数据元素类型。
 * @property data 对应于当前请求页面的数据列表。
 * @property total 所有页面中的记录总数。
 */
data class Pagination<T>(
  val data: List<T>,
  val total: Int
)
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