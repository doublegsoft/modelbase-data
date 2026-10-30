<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#assign typeDef = objectConstructor("com.doublegsoft.jcommons.metacode.TypeDefinition", obj, model)>
<#assign flow = typeDef.flow>
<#-- 生成属性为自定义对象的对象数据 -->
<#macro print_test_obj attr obj suffix="" is_aggregate_like=false>
  private ${java.nameType(obj.name)}Query test${java.nameType(attr.name)}${suffix}() {
    ${java.nameType(obj.name)}Query retVal = new ${java.nameType(obj.name)}Query();
<#list obj.attributes as attr>
  <#if modelbase.is_attribute_system(attr)><#continue></#if>
  <#if !modelbase.is_aggregate_like(obj) && attr.type.collection><#continue></#if>
  <#if attr.constraint.defaultValue??><#continue></#if>
  <#if attr.name == "state">
    retVal.setState("E");
  <#elseif attr.type.name == "datetime">
    retVal.${modelbase4java.name_setter(attr)}(Safe.safeTimestamp(${modelbase4java.test_json_value(attr)}));
  <#elseif attr.type.custom>
    <#if is_aggregate_like>
    retVal.set${java.nameType(attr.name)}(test${java.nameType(attr.name)}());
    <#else>
    retVal.${modelbase4java.name_setter(attr)}(Safe.safe${modelbase4java.type_attribute_primitive(attr)}(${modelbase4java.test_json_value(attr)}));
    </#if>
  <#elseif attr.type.collection>
    retVal.${modelbase4java.name_getter(attr)}().addAll(test${java.nameType(attr.name)}());  
  <#elseif attr.constraint.domainType.name?starts_with("strings")>
    retVal.${modelbase4java.name_getter(attr)}().add("标签1");  
    retVal.${modelbase4java.name_getter(attr)}().add("标签2"); 
    retVal.${modelbase4java.name_getter(attr)}().add("标签3"); 
  <#elseif attr.constraint.domainType.name?starts_with("{") && attr.constraint.domainType.name?ends_with("}")>
    // TODO: JSON
  <#else>
    retVal.${modelbase4java.name_setter(attr)}(Safe.safe${modelbase4java.type_attribute_primitive(attr)}(${modelbase4java.test_json_value(attr)}));
  </#if>
</#list>    
    return retVal;
  }
</#macro>
<#-- 生成属性为自定义对象的对象数据 -->
<#macro print_assert_obj obj expected actual indent>
  <#list obj.attributes as attr>
    <#if modelbase.is_attribute_system(attr)><#continue></#if>
    <#if attr.type.collection><#continue></#if>
    <#if attr.constraint.defaultValue??><#continue></#if>
    <#if attr.name?starts_with("parent")><#continue></#if><#-- FIXME: 暂时规避Parent的全部属性 -->
    <#if attr.type.name == "number">
${""?left_pad(indent)}Assert.assertEquals(0, ${expected}.${modelbase4java.name_getter(attr)}().compareTo(${actual}.${modelbase4java.name_getter(attr)}()));
    <#elseif attr.type.name == "datetime" || attr.type.name == "date">
${""?left_pad(indent)}Assert.assertTrue(isSameDate(${expected}.${modelbase4java.name_getter(attr)}(), ${actual}.${modelbase4java.name_getter(attr)}()));
    <#elseif attr.constraint.domainType.name?starts_with("{") && attr.constraint.domainType.name?ends_with("}")>
    // TODO: JSON
    <#else>
${""?left_pad(indent)}Assert.assertEquals(${expected}.${modelbase4java.name_getter(attr)}(), ${actual}.${modelbase4java.name_getter(attr)}());
    </#if>
  </#list>
</#macro>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
package <#if namespace??>${namespace}.</#if>${app.name}.service;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Arrays;
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
import <#if namespace??>${namespace}.</#if>${app.name}.service.*;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ${java.nameType(obj.name)}ServiceTest extends ServiceTestBase {

  @Test
  public void test_11_save_root_and_read() throws Exception {
    clearData();
    ${java.nameType(obj.name)}Service service = getContext().getBean(${java.nameType(obj.name)}Service.class);
    ${java.nameType(obj.name)}Query toSaveQuery = test${java.nameType(obj.name)}();
    ${java.nameType(obj.name)}Query savedQuery = service.save${java.nameType(obj.name)}(toSaveQuery);
    Assert.assertNotNull(savedQuery);
<#if obj.isLabelled("composite") || obj.isLabelled("persistence")>

    // 验证全部可持久化属性的值
    ${java.nameType(obj.name)}Query toFindQuery = new ${java.nameType(obj.name)}Query();
  <#list idAttrs as idAttr>
    <#if idAttr.type.name == "datetime"><#continue></#if>
    toFindQuery.${modelbase4java.name_setter(idAttr)}(savedQuery.${modelbase4java.name_getter(idAttr)}());
  </#list>
    ${java.nameType(obj.name)}Query foundQuery = service.read${java.nameType(obj.name)}(toFindQuery);

<@print_assert_obj obj=obj expected="toSaveQuery" actual="foundQuery" indent=4 />
<#elseif modelbase.is_aggregate_like(obj)>
  <#assign attrRoot = obj.attributes[0]>
  <#assign rootObj = model.findObjectByName(attrRoot.type.name)>

    ${java.nameType(obj.name)}Query toFindQuery = new ${java.nameType(obj.name)}Query();
    <#-- 是否需要考虑一致性和通用性 -->
    toFindQuery.set${java.nameType(attrRoot.name)}Id(savedQuery.get${java.nameType(attrRoot.name)}Id());
    ${java.nameType(obj.name)}Query foundQuery = service.read${java.nameType(obj.name)}(toFindQuery);
    ${java.nameType(rootObj.name)}Query toSave${java.nameType(attrRoot.name)} = foundQuery.get${java.nameType(attrRoot.name)}();
    ${java.nameType(rootObj.name)}Query found${java.nameType(attrRoot.name)} = foundQuery.get${java.nameType(attrRoot.name)}();
<@print_assert_obj obj=rootObj expected="toSave"+java.nameType(attrRoot.name) actual="found"+java.nameType(attrRoot.name) indent=4 />
</#if>    
  }

  @Test
  public void test_12_save_full_and_read() throws Exception {
    clearData();
    ${java.nameType(obj.name)}Service service = getContext().getBean(${java.nameType(obj.name)}Service.class); 
    ${java.nameType(obj.name)}Query toSaveQuery = test${java.nameType(obj.name)}();
    <#--  <#list obj.attributes as attr>
      <#if !attr.type.custom><#continue></#if>
    toSaveQuery.${modelbase4java.name_setter(attr)}(null);
    toSaveQuery.set${java.nameType(attr.name)}(test${java.nameType(attr.name)}());
    </#list>  -->
    ${java.nameType(obj.name)}Query savedQuery = service.save${java.nameType(obj.name)}(toSaveQuery);
    Assert.assertNotNull(savedQuery);
<#if obj.isLabelled("composite") || obj.isLabelled("persistence")>

    // 验证
    ${java.nameType(obj.name)}Query toFindQuery = new ${java.nameType(obj.name)}Query();
  <#list idAttrs as idAttr>
    <#if idAttr.type.name == "datetime"><#continue></#if>
    toFindQuery.${modelbase4java.name_setter(idAttr)}(savedQuery.${modelbase4java.name_getter(idAttr)}());
  </#list>
    ${java.nameType(obj.name)}Query foundQuery = service.read${java.nameType(obj.name)}(toFindQuery);

  <#list obj.attributes as attr>
    <#if modelbase.is_attribute_system(attr)><#continue></#if>
    <#if attr.type.collection><#continue></#if>
    <#if attr.constraint.defaultValue??><#continue></#if>
    <#if attr.name?starts_with("parent")><#continue></#if><#-- FIXME: 暂时规避Parent的全部属性 -->
    <#if attr.type.name == "number">
    Assert.assertEquals(0, toSaveQuery.${modelbase4java.name_getter(attr)}().compareTo(foundQuery.${modelbase4java.name_getter(attr)}()));
    <#elseif attr.type.name == "datetime" || attr.type.name == "date">
    Assert.assertTrue(isSameDate(toSaveQuery.${modelbase4java.name_getter(attr)}(), foundQuery.${modelbase4java.name_getter(attr)}()));
    <#elseif attr.constraint.domainType.name?starts_with("{") && attr.constraint.domainType.name?ends_with("}")>
    // TODO: JSON
    <#else>
    Assert.assertEquals(toSaveQuery.${modelbase4java.name_getter(attr)}(), foundQuery.${modelbase4java.name_getter(attr)}());
    </#if>
  </#list>
<#elseif modelbase.is_aggregate_like(obj)>
  <#assign attrRoot = obj.attributes[0]>
  <#assign idAttr = modelbase.get_aggregate_id(obj)?first>
    // 验证
    ${java.nameType(obj.name)}Query toFindQuery = new ${java.nameType(obj.name)}Query();
    toFindQuery.set${java.nameType(attrRoot.name)}Id(savedQuery.get${java.nameType(attrRoot.name)}Id());
    <#--  toFindQuery.set${java.nameType(obj.attributes?first.name)}(new ${java.nameType(obj.attributes?first.type.name)}Query());
    toFindQuery.get${java.nameType(obj.attributes?first.name)}().${modelbase4java.name_setter(idAttr)}(savedQuery.get${java.nameType(obj.attributes?first.name)}().${modelbase4java.name_getter(idAttr)}());  -->
    ${java.nameType(obj.name)}Query foundQuery = service.read${java.nameType(obj.name)}(toFindQuery);
    Assert.assertNotNull(foundQuery);
  <#list obj.attributes as attr>
    <#if attr.type.custom>
      <#assign rootObj = model.findObjectByName(attr.type.name)>

    // 【${modelbase.get_attribute_label(attr)}】对象数据验证
    Assert.assertNotNull(foundQuery.get${java.nameType(attr.name)}());
    ${java.nameType(rootObj.name)}Query toSave${java.nameType(attr.name)} = toSaveQuery.get${java.nameType(attr.name)}();
    ${java.nameType(rootObj.name)}Query found${java.nameType(attr.name)} = foundQuery.get${java.nameType(attr.name)}();
<@print_assert_obj obj=rootObj expected="toSave"+java.nameType(attr.name) actual="found"+java.nameType(attr.name) indent=4 />    
    <#elseif attr.type.collection>
      <#assign collObj = model.findObjectByName(attr.type.componentType.name)>
      <#if !modelbase.is_aggregate_like(collObj)>
    // 【${modelbase.get_attribute_label(attr)}】对象数据验证
    Assert.assertTrue(foundQuery.get${java.nameType(attr.name)}().size() > 0);
      </#if>
    </#if>
  </#list>
</#if>    
  }

  @Test
  public void test_21_save_root_and_find() throws Exception {
    clearData();
    ${java.nameType(obj.name)}Service service = getContext().getBean(${java.nameType(obj.name)}Service.class);
    ${java.nameType(obj.name)}Query toSaveQuery = test${java.nameType(obj.name)}();
<#-- 非关键依赖的设置为null -->
<#if modelbase.is_aggregate_like(obj)>
  <#assign null_set = false>
  <#assign rootObj = model.findObjectByName(obj.attributes?first.type.name)>
  <#list flow.sortTypes() as typeObj>
    <#if null_set && !typeObj.collection>
    toSaveQuery.set${java.nameType(typeObj.variable)}(null);
    </#if>
    <#if rootObj.name == typeObj.name>
      <#assign null_set = true>
    </#if>
  </#list>
</#if>
    ${java.nameType(obj.name)}Query savedQuery = service.save${java.nameType(obj.name)}(toSaveQuery);
    Assert.assertNotNull(savedQuery);
<#if obj.isLabelled("composite") || obj.isLabelled("persistence")>

    // 验证全部可持久化属性的值
    ${java.nameType(obj.name)}Query toFindQuery = new ${java.nameType(obj.name)}Query();
  <#list idAttrs as idAttr>
    <#if idAttr.type.name == "datetime"><#continue></#if>
    toFindQuery.${modelbase4java.name_setter(idAttr)}(savedQuery.${modelbase4java.name_getter(idAttr)}());
  </#list>
    Pagination<${java.nameType(obj.name)}Query> page = service.find${java.nameType(inflector.pluralize(obj.name))}(toFindQuery);
    ${java.nameType(obj.name)}Query foundQuery = page.getData().get(0);

<@print_assert_obj obj=obj expected="toSaveQuery" actual="foundQuery" indent=4 />
<#elseif modelbase.is_aggregate_like(obj)>
  <#assign attrRoot = obj.attributes[0]>
  <#assign rootObj = model.findObjectByName(attrRoot.type.name)>
  <#assign rootObjIdAttr = modelbase.get_id_attributes(rootObj)?first>

    ${java.nameType(obj.name)}Query toFindQuery = new ${java.nameType(obj.name)}Query();
    ${java.nameType(rootObj.name)}Query toFind${java.nameType(attrRoot.name)} = new ${java.nameType(rootObj.name)}Query();
    toFindQuery.set${java.nameType(attrRoot.name)}(toFind${java.nameType(attrRoot.name)});
    toFind${java.nameType(attrRoot.name)}.${modelbase4java.name_setter(rootObjIdAttr)}(savedQuery.get${java.nameType(attrRoot.name)}Id());
    Pagination<${java.nameType(obj.name)}Query> page = service.find${java.nameType(inflector.pluralize(obj.name))}(toFindQuery);
    ${java.nameType(obj.name)}Query foundQuery = page.getData().get(0);

    ${java.nameType(rootObj.name)}Query toSave${java.nameType(attrRoot.name)} = foundQuery.get${java.nameType(attrRoot.name)}();
    ${java.nameType(rootObj.name)}Query found${java.nameType(attrRoot.name)} = foundQuery.get${java.nameType(attrRoot.name)}();
<@print_assert_obj obj=rootObj expected="toSave"+java.nameType(attrRoot.name) actual="found"+java.nameType(attrRoot.name) indent=4 />
    // 检验应该为空的关联对象属性
  <#assign null_set = false>
  <#assign rootObj = model.findObjectByName(obj.attributes?first.type.name)>
  <#list flow.sortTypes() as typeObj>
    <#if null_set && !typeObj.collection>
    Assert.assertNull(foundQuery.get${java.nameType(typeObj.variable)}());
    </#if>
    <#if rootObj.name == typeObj.name>
      <#assign null_set = true>
    </#if>
  </#list>
</#if>    
  }

  @Test
  public void test_21_save_full_and_find() throws Exception {
    clearData();
    ${java.nameType(obj.name)}Service service = getContext().getBean(${java.nameType(obj.name)}Service.class);
    ${java.nameType(obj.name)}Query toSaveQuery = test${java.nameType(obj.name)}();

    ${java.nameType(obj.name)}Query savedQuery = service.save${java.nameType(obj.name)}(toSaveQuery);
    Assert.assertNotNull(savedQuery);
<#if obj.isLabelled("composite") || obj.isLabelled("persistence")>

    // 验证全部可持久化属性的值
    ${java.nameType(obj.name)}Query toFindQuery = new ${java.nameType(obj.name)}Query();
  <#list idAttrs as idAttr>
    <#if idAttr.type.name == "datetime"><#continue></#if>
    toFindQuery.${modelbase4java.name_setter(idAttr)}(savedQuery.${modelbase4java.name_getter(idAttr)}());
  </#list>
    Pagination<${java.nameType(obj.name)}Query> page = service.find${java.nameType(inflector.pluralize(obj.name))}(toFindQuery);
    ${java.nameType(obj.name)}Query foundQuery = page.getData().get(0);

<@print_assert_obj obj=obj expected="toSaveQuery" actual="foundQuery" indent=4 />
<#elseif modelbase.is_aggregate_like(obj)>
  <#assign attrRoot = obj.attributes[0]>
  <#assign rootObj = model.findObjectByName(attrRoot.type.name)>
  <#assign rootObjIdAttr = modelbase.get_id_attributes(rootObj)?first>

    ${java.nameType(obj.name)}Query toFindQuery = new ${java.nameType(obj.name)}Query();
    ${java.nameType(rootObj.name)}Query toFind${java.nameType(attrRoot.name)} = new ${java.nameType(rootObj.name)}Query();
    toFindQuery.set${java.nameType(attrRoot.name)}(toFind${java.nameType(attrRoot.name)});
    toFind${java.nameType(attrRoot.name)}.${modelbase4java.name_setter(rootObjIdAttr)}(savedQuery.get${java.nameType(attrRoot.name)}Id());
    Pagination<${java.nameType(obj.name)}Query> page = service.find${java.nameType(inflector.pluralize(obj.name))}(toFindQuery);
    ${java.nameType(obj.name)}Query foundQuery = page.getData().get(0);

    ${java.nameType(rootObj.name)}Query toSave${java.nameType(attrRoot.name)} = foundQuery.get${java.nameType(attrRoot.name)}();
    ${java.nameType(rootObj.name)}Query found${java.nameType(attrRoot.name)} = foundQuery.get${java.nameType(attrRoot.name)}();
<@print_assert_obj obj=rootObj expected="toSave"+java.nameType(attrRoot.name) actual="found"+java.nameType(attrRoot.name) indent=4 />
  <#list obj.attributes as attr>
    <#if attr?index == 0><#continue></#if>
    <#if attr.type.custom>
    Assert.assertNotNull(foundQuery.get${java.nameType(attr.name)}());
    </#if>
  </#list>
</#if>    
  }

  @Test(expected = ServiceException.class)
  public void test_99_save_and_throw() throws Exception {
<#-- 利用【非空属性】置空来测试 -->
<#if modelbase.is_aggregate_like(obj)>
<#else>
</#if>
    throw new ServiceException(500, "test_99_save_throw_error");
  }

<@print_test_obj attr={"name": obj.name} obj=obj is_aggregate_like=modelbase.is_aggregate_like(obj) />
<#list obj.attributes as attr>
  <#if attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>

<@print_test_obj attr=attr obj=refObj />
  </#if>
</#list>
<#list obj.attributes as attr>
  <#if attr.type.collection>
    <#assign collObj = model.findObjectByName(attr.type.componentType.name)>

  private List<${java.nameType(collObj.name)}Query> test${java.nameType(attr.name)}() {
    return Arrays.asList(
      test${java.nameType(attr.name)}_0(),
      test${java.nameType(attr.name)}_1(),
      test${java.nameType(attr.name)}_2()
    );
  }

<@print_test_obj attr=attr obj=collObj suffix="_0" />

<@print_test_obj attr=attr obj=collObj suffix="_1" />

<@print_test_obj attr=attr obj=collObj suffix="_2" />
  </#if>
</#list>
}