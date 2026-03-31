<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.sdk.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;
import java.util.List;

import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;

<#-- 元数据变量提取 -->
<#assign typename = java.nameType(obj.name)>
<#assign modulename = modelbase.get_object_module(obj)>
<#assign varname = java.nameVariable(obj.name)>
<#assign pluralName = inflector.pluralize(obj.name)>
<#assign kebabPath = pluralName?replace("_", "-")?lower_case>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#-- 获取主键类型和名称 (假设单主键场景用于 REST Path) -->
<#assign hasSingleId = (idAttrs?size == 1)>
<#if hasSingleId>
  <#assign idType = modelbase4java.type_attribute(idAttrs[0])>
  <#assign idName = java.nameVariable(idAttrs[0].name)>
  <#assign idSqlName = modelbase.get_attribute_sql_name(idAttrs[0])>
</#if>
/**
 * 自动生成的 OpenFeign 客户端接口。
 * 负责微服务之间对【${modelbase.get_object_label(obj)}】资源的 RPC 调用。
 */
@FeignClient(
  contextId = "${varname}Client",
  name = "${app.name}-service",
  path = "/api/v1/${app.name?replace("_", "-")?lower_case}/${modulename}/${obj.name?replace("_", "-")?lower_case}"
)
public interface ${typename}Client {

  /**
   * 创建【${modelbase.get_object_label(obj)}】
   */
  @PostMapping("/save")
  ${typename}Query save${typename}(@RequestBody ${typename}Query query);

  /**
   * 获得第一个【${modelbase.get_object_label(obj)}】
   */
  @PostMapping("/get")
  ${typename}Query get${typename}(@RequestBody ${typename}Query query);

  /**
   * 根据主键获取【${modelbase.get_object_label(obj)}】详情
   */
  @PostMapping("/read")
  ${typename}Query read${typename}(@RequestBody ${typename}Query query);

  /**
   * 局部修改【${modelbase.get_object_label(obj)}】(仅更新非空字段)
   */
  @PostMapping("/modify")
  ${typename}Query modify${typename}(@RequestBody ${typename}Query query);

  /**
   * 删除【${modelbase.get_object_label(obj)}】(物理删除)
   */
  @PostMapping("/delete")
  void delete${typename}(@RequestBody ${typename}Query query);

  /**
   * 查找【${modelbase.get_object_label(obj)}】分页列表
   */
  @PostMapping("/find")
  Pagination<${typename}Query> find${java.nameType(pluralName)}(@RequestBody ${typename}Query query);

  /**
   * 聚合统计【${modelbase.get_object_label(obj)}】
   */
  @PostMapping("/aggregate")
  Pagination<${typename}Query> aggregate${typename}(@RequestBody ${typename}Query query);

<#-- 状态机流转 (Enable / Disable) 逻辑 -->
<#list obj.attributes as attr>
  <#if attr.name == "state" || attr.name == "status">
  /**
   * 启用【${modelbase.get_object_label(obj)}】
   */
  @PostMapping("/enable")
  void enable${typename}(@RequestBody ${typename}Query query);

  /**
   * 禁用【${modelbase.get_object_label(obj)}】
   */
  @PostMapping("/disable")
  void disable${typename}(@RequestBody ${typename}Query query);
    <#break>
  </#if>
</#list>

<#-- 数值运算属性的特殊端点 (例如 incrementable) -->
<#if hasSingleId>
  <#list obj.attributes as attr>
    <#if attr.isLabelled("incrementable")>
  /**
   * 增加【${modelbase.get_attribute_label(attr)}】数值
   */
  @PostMapping("/{${idName}}/${attr.name?replace('_', '-')}/increment")
  void increment${java.nameType(attr.name)}(
    @PathVariable("${idName}") ${idType} ${idName}, 
    @RequestParam("value") int value);
    </#if>
  </#list>
</#if>

}