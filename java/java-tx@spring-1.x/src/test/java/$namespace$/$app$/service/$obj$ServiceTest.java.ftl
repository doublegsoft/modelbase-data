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
    ${java.nameType(obj.name)}Service service = getContext().getBean(${java.nameType(obj.name)}Service.class);
    ${java.nameType(obj.name)}Query toSaveQuery = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(fromJson("json/${obj.name?replace("_","-")}#save.json"));
    ${java.nameType(obj.name)}Query savedQuery = service.save${java.nameType(obj.name)}(toSaveQuery);
    Assert.assertNotNull(savedQuery);
    service.save${java.nameType(obj.name)}(toSaveQuery);
    service.save${java.nameType(obj.name)}(toSaveQuery);
    service.save${java.nameType(obj.name)}(toSaveQuery);

  <#if idAttrs?size == 1>
    ${java.nameType(obj.name)}Query findQuery = new ${java.nameType(obj.name)}Query();
    <#list obj.attributes as attr>
      <#if attr.type.name == "string" && !modelbase.is_attribute_system(attr) && !attr.identifiable>
    findQuery.${modelbase4java.name_setter(attr)}2(toSaveQuery.${modelbase4java.name_getter(attr)}());
      </#if>
    </#list>  
    Pagination<${java.nameType(obj.name)}Query> result = service.find${inflector.pluralize(java.nameType(obj.name))}(findQuery);
    Assert.assertEquals(1L, result.getTotal());
  </#if>
  }
  
  @Test
  public void test_13_save_and_find() throws Exception {
    ${java.nameType(obj.name)}Service service = getContext().getBean(${java.nameType(obj.name)}Service.class);
    ${java.nameType(obj.name)}Query toSaveQuery = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(fromJson("json/${obj.name?replace("_","-")}#save.json"));
    service.save${java.nameType(obj.name)}(toSaveQuery);

    <#if idAttrs?size == 1>
      <#list idAttrs as idAttr>
    toSaveQuery.${modelbase4java.name_setter(idAttr)}(null);
      </#list>
    </#if>
    <#list 1..10 as idx>
    service.save${java.nameType(obj.name)}(toSaveQuery);
    </#list>

    ${java.nameType(obj.name)}Query findQuery = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(fromJson("json/${obj.name?replace("_","-")}#find.json"));
    service.find${inflector.pluralize(java.nameType(obj.name))}(findQuery);
  }
}
