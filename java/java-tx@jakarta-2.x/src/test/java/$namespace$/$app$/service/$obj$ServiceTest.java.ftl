<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#macro print_test_obj attr obj suffix="" is_aggregate_like=false>
  private ${java.nameType(obj.name)}Query test${java.nameType(attr.name)}${suffix}() {
    ${java.nameType(obj.name)}Query retVal = new ${java.nameType(obj.name)}Query();
<#list obj.attributes as attr>
  <#if attr.type.collection><#continue></#if>
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
  <#else>
    retVal.${modelbase4java.name_setter(attr)}(Safe.safe${modelbase4java.type_attribute_primitive(attr)}(${modelbase4java.test_json_value(attr)}));
  </#if>
</#list>    
    return retVal;
  }
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

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ${java.nameType(obj.name)}ServiceTest extends ServiceTestBase {

  @Test
  public void test_11_save_and_find() throws Exception {
    clearData();
    ${java.nameType(obj.name)}Service service = getContext().getBean(${java.nameType(obj.name)}Service.class);
<#if !obj.isLabelled("composite")>    
    ${java.nameType(obj.name)}Query toSaveQuery = test${java.nameType(obj.name)}Query();
    ${java.nameType(obj.name)}Query savedQuery = service.save${java.nameType(obj.name)}(toSaveQuery);
    Assert.assertNotNull(savedQuery);
</#if>
<#if obj.isLabelled("composite") || obj.isLabelled("persistence")>
    ${java.nameType(obj.name)}Query toFindQuery = new ${java.nameType(obj.name)}Query();
  <#list idAttrs as idAttr>
    toFindQuery.${modelbase4java.name_setter(idAttr)}(savedQuery.${modelbase4java.name_getter(idAttr)}());
  </#list>
    Pagination<${java.nameType(obj.name)}Query> page = service.find${java.nameType(inflector.pluralize(obj.name))}(toFindQuery);
</#if>    
  }

<@print_test_obj attr={"name": obj.name} obj=obj suffix="Query" is_aggregate_like=modelbase.is_aggregate_like(obj) />
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
      test${java.nameType(attr.name)}_1()
    );
  }

<@print_test_obj attr=attr obj=collObj suffix="_0" />

<@print_test_obj attr=attr obj=collObj suffix="_1" />
  </#if>
</#list>
}