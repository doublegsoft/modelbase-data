<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package ${namespace}.${app.name}.util;

public enum AggregateType {
  COUNT,          // 计数（不需要指定字段，默认对整个记录计数）
  SUM,            // 求和
  AVG,            // 平均值（内部会根据 SUM + COUNT 计算）
  MIN,            // 最小值
  MAX,            // 最大值
  DISTINCT_COUNT, // 去重计数
  FIRST,          // 第一个（保持流的顺序）
  LAST            // 最后一个
}
