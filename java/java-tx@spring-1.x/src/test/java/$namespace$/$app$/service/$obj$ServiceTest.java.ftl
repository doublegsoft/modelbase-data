<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.service;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

import org.junit.*;
import org.junit.runners.MethodSorters;

import <#if namespace??>${namespace}.</#if>${app.name}.poco.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.assembler.*;
import <#if namespace??>${namespace}.</#if>${app.name}.util.*;

<#assign typename = java.nameType(obj.name)>
<#assign varname = java.nameVariable(obj.name)>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#assign uniqueGroups = modelbase.group_unique_attributes(obj)>
/**
 * 【${modelbase.get_object_label(obj)}】测试基类。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since ${version}
 */
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ${java.nameType(obj.name)}ServiceTest extends ServiceTestBase {
  
  @Test
  public void test_11_save_and_read() throws Exception {
    clearData();
    ${java.nameType(obj.name)}Service service = getContext().getBean(${java.nameType(obj.name)}Service.class);
    ${java.nameType(obj.name)}Query toSaveQuery = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(fromJson("json/${obj.name?replace("_","-")}#save.json"));
    ${java.nameType(obj.name)}Query savedQuery = service.save${java.nameType(obj.name)}(toSaveQuery);
    Assert.assertNotNull(savedQuery);

<#if idAttrs?size != 0>
    Assert.assertFalse(Strings.isBlank(savedQuery.${modelbase4java.name_getter(idAttrs[0])}()));
</#if>
<#list idAttrs as idAttr>
    Assert.assertEquals(toSaveQuery.${modelbase4java.name_getter(idAttr)}(), savedQuery.${modelbase4java.name_getter(idAttr)}());
</#list>
    ${java.nameType(obj.name)}Query toReadQuery = new ${java.nameType(obj.name)}Query();
<#list idAttrs as idAttr>
    toReadQuery.${modelbase4java.name_setter(idAttr)}(savedQuery.${modelbase4java.name_getter(idAttr)}());
</#list>
    ${java.nameType(obj.name)}Query readQuery = service.read${java.nameType(obj.name)}(toReadQuery);
    Assert.assertNotNull(readQuery);
<#list obj.attributes as attr>
  <#if modelbase.is_attribute_system(attr) || attr.identifiable || attr.type.collection><#continue></#if>  
    Assert.assertEquals(toSaveQuery.${modelbase4java.name_getter(attr)}(), readQuery.${modelbase4java.name_getter(attr)}());
</#list>
  }

  @Test
  public void test_12_save_more_times() throws Exception {
    clearData();
    ${java.nameType(obj.name)}Service service = getContext().getBean(${java.nameType(obj.name)}Service.class);
    ${java.nameType(obj.name)}Query toSaveQuery = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(fromJson("json/${obj.name?replace("_","-")}#save.json"));
    ${java.nameType(obj.name)}Query savedQuery = service.save${java.nameType(obj.name)}(toSaveQuery);
    Assert.assertNotNull(savedQuery);

<#if uniqueGroups?size != 0>
  <#assign uniqueGroup = uniqueGroups[0]>
    // 特殊处理唯一组的属性，确保保存的数据是唯一的
    try {
      service.save${java.nameType(obj.name)}(toSaveQuery);  
      Assert.fail("Expected ServiceException not thrown.");
    } catch (Throwable e) {
      // nothing to do
    }
<#else>
    service.save${java.nameType(obj.name)}(toSaveQuery);
    service.save${java.nameType(obj.name)}(toSaveQuery);
    service.save${java.nameType(obj.name)}(toSaveQuery);  
</#if>    

<#if idAttrs?size == 1>
    ${java.nameType(obj.name)}Query findQuery = new ${java.nameType(obj.name)}Query();
  <#list obj.attributes as attr>
    <#if attr.type.name == "string" && !modelbase.is_attribute_system(attr) && !attr.identifiable>
    findQuery.${modelbase4java.name_setter(attr)}2(toSaveQuery.${modelbase4java.name_getter(attr)}());
    </#if>
  </#list>  
    Pagination<${java.nameType(obj.name)}Query> result = service.find${inflector.pluralize(java.nameType(obj.name))}(findQuery);
    Assert.assertEquals(1L, result.getData().size());
</#if>
  }
  
  @Test
  public void test_13_save_and_find() throws Exception {
    clearData();
    ${java.nameType(obj.name)}Service service = getContext().getBean(${java.nameType(obj.name)}Service.class);
    ${java.nameType(obj.name)}Query toSaveQuery = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(fromJson("json/${obj.name?replace("_","-")}#save.json"));
    service.save${java.nameType(obj.name)}(toSaveQuery);

<#if uniqueGroups?size != 0>
  <#assign uniqueGroup = uniqueGroups[0]>
    // 特殊处理唯一组的属性，确保保存的数据是唯一的
    try {
      service.save${java.nameType(obj.name)}(toSaveQuery);  
      Assert.fail("Expected ServiceException not thrown.");
    } catch (Throwable e) {
      // nothing to do
    }
<#else>
  <#list 1..10 as idx>
    <#if idAttrs?size == 1>
      <#list idAttrs as idAttr>
    toSaveQuery.${modelbase4java.name_setter(idAttr)}(null);
      </#list>
    </#if>
    service.save${java.nameType(obj.name)}(toSaveQuery);
  </#list>
</#if>  

    ${java.nameType(obj.name)}Query findQuery = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(fromJson("json/${obj.name?replace("_","-")}#find.json"));
    service.find${inflector.pluralize(java.nameType(obj.name))}(findQuery);
  }

  @Test
  public void test_21_save_with_transact_one_tier() throws Exception {
    clearData();
    ${java.nameType(obj.name)}Service service = getContext().getBean(${java.nameType(obj.name)}Service.class);
    ${java.nameType(obj.name)}Query toSaveQuery = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(fromJson("json/${obj.name?replace("_","-")}#save.json"));
<#list model.objects as otherObj>
  <#if otherObj.name == obj.name><#continue></#if>
  <#if (modelbase.get_id_attributes(otherObj)?size <= 1)><#continue></#if>
  <#-- 通常测试值域对象 -->
  <#assign anotherObj = otherObj>
  <#break>
</#list>
<#if anotherObj??>
  <#assign anotherObjIdAttr = modelbase.get_id_attributes(anotherObj)?first>
    // 主键关联传递，把主对象的主键值传递给其他对象的主键字段
    Map<String,Object> toSave${java.nameType(anotherObj.name)}Data = fromJson("json/${anotherObj.name?replace("_","-")}#save.json");
    ${java.nameType(anotherObj.name)}Query toSave${java.nameType(anotherObj.name)}Query = ${java.nameType(anotherObj.name)}QueryAssembler.assemble${java.nameType(anotherObj.name)}Query(fromJson("json/${anotherObj.name?replace("_","-")}#save.json"));
    QueryHandler queryHandler = new QueryHandler();
    queryHandler.setSourceField("${modelbase.get_attribute_sql_name(idAttrs[0])}");
    queryHandler.setTargetField("${modelbase.get_attribute_sql_name(anotherObjIdAttr)}");
    queryHandler.setQuery(toSave${java.nameType(anotherObj.name)}Data);
    queryHandler.setHandler("||${anotherObj.name}/save");
    toSaveQuery.getQueryHandlers().add(queryHandler);
</#if>  
    ${java.nameType(obj.name)}Query savedQuery = service.save${java.nameType(obj.name)}(toSaveQuery);
<#if anotherObj??>
  <#assign anotherObjIdAttr = modelbase.get_id_attributes(anotherObj)?first>
    // 验证关联对象的数据也保存成功了
    ${java.nameType(anotherObj.name)}Service ${java.nameVariable(anotherObj.name)}Service = getContext().getBean(${java.nameType(anotherObj.name)}Service.class);
    ${java.nameType(anotherObj.name)}Query toFind${java.nameType(anotherObj.name)}Query = new ${java.nameType(anotherObj.name)}Query();
    toFind${java.nameType(anotherObj.name)}Query.${modelbase4java.name_setter(anotherObjIdAttr)}(savedQuery.${modelbase4java.name_getter(idAttrs[0])}());
    List<${java.nameType(anotherObj.name)}Query> ${java.nameVariable(anotherObj.name)}List = ${java.nameVariable(anotherObj.name)}Service.find${inflector.pluralize(java.nameType(anotherObj.name))}(toFind${java.nameType(anotherObj.name)}Query).getData();
    Assert.assertEquals(1, ${java.nameVariable(anotherObj.name)}List.size());
</#if>
  }
}