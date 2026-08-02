<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
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

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class ${java.nameType(obj.name)}ServiceTest extends ServiceTestBase {

  @Test
  public void test_11_save_and_find() throws Exception {
    clearData();
    ${java.nameType(obj.name)}Service service = getContext().getBean(${java.nameType(obj.name)}Service.class);
    ${java.nameType(obj.name)}Query toSaveQuery = test${java.nameType(obj.name)}Query();
    ${java.nameType(obj.name)}Query savedQuery = service.save${java.nameType(obj.name)}(toSaveQuery);
    Assert.assertNotNull(savedQuery);
<#if obj.isLabelled("composite") || obj.isLabelled("persistence")>
    ${java.nameType(obj.name)}Query toFindQuery = new ${java.nameType(obj.name)}Query();
  <#list idAttrs as idAttr>
    toFindQuery.${modelbase4java.name_setter(idAttr)}(savedQuery.${modelbase4java.name_getter(idAttr)}());
  </#list>
    Pagination<${java.nameType(obj.name)}Query> page = service.find${java.nameType(inflector.pluralize(obj.name))}(toFindQuery);
</#if>    
  }

  private ${java.nameType(obj.name)}Query test${java.nameType(obj.name)}Query() {
    ${java.nameType(obj.name)}Query retVal = new ${java.nameType(obj.name)}Query();
<#list obj.attributes as attr>
  <#if attr.type.collection><#continue></#if>
  <#if attr.constraint.defaultValue??><#continue></#if>
  <#if attr.name == "state">
    retVal.setState("E");
  <#else>
    retVal.${modelbase4java.name_setter(attr)}(Safe.safe${modelbase4java.type_attribute_primitive(attr)}(${modelbase4java.test_json_value(attr)}));
  </#if>
</#list>    
    return retVal;
  }

}