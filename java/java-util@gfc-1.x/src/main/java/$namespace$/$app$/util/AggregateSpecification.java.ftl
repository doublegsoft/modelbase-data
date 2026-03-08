<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.util;

/**
 * 单个聚合的描述信息。
 *   - name : 结果 map 中的键名（如 "totalAmount"、"avgAge" …）
 *   - type : 采用的 AggType
 *   - field: 需要聚合的属性名（COUNT、FIRST、LAST 可以为 null，表示对整条记录计数或取位置）
 */
public class AggregateSpecification {
  private final String   name;   // 结果中使用的键名
  private final AggregateType  type;
  private final String   field;  // 需要聚合的属性名（COUNT、FIRST、LAST 可 null）

  public AggregateSpecification(String name, AggregateType type, String field) {
    this.name  = name;
    this.type  = type;
    this.field = field;
  }

  public String getName()   { return name;   }
  public AggregateType getType() { return type;   }
  public String getField() { return field;   }

  /** 方便创建（可链式调用） */
  public static AggregateSpecification sum(String name, String field) {
    return new AggregateSpecification(name, AggregateType.SUM, field);
  }
  public static AggregateSpecification avg(String name, String field) {
    return new AggregateSpecification(name, AggregateType.AVG, field);
  }
  public static AggregateSpecification min(String name, String field) {
    return new AggregateSpecification(name, AggregateType.MIN, field);
  }
  public static AggregateSpecification max(String name, String field) {
    return new AggregateSpecification(name, AggregateType.MAX, field);
  }
  public static AggregateSpecification distinctCount(String name, String field) {
    return new AggregateSpecification(name, AggregateType.DISTINCT_COUNT, field);
  }
  public static AggregateSpecification count(String name) {
    return new AggregateSpecification(name, AggregateType.COUNT, null);
  }
  public static AggregateSpecification first(String name, String field) {
    return new AggregateSpecification(name, AggregateType.FIRST, field);
  }
  public static AggregateSpecification last(String name, String field) {
    return new AggregateSpecification(name, AggregateType.LAST, field);
  }
}