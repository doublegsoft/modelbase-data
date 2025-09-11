<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4java.ftl" as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#macro print_reference_assemble attr objname attrname indent>
  <#local refObj = model.findObjectByName(attr.type.name)>
  <#local idAttrs = modelbase.get_id_attributes(refObj)>
${""?left_pad(indent)}${java.nameType(refObj.name)} ${java.nameVariable(refObj.name)} = new ${java.nameType(refObj.name)}();
${""?left_pad(indent)}${objname}.set${java.nameType(attr.name)}(${java.nameVariable(refObj.name)});  
  <#if idAttrs[0].type.custom>
<@print_reference_assemble attr=idAttrs[0] objname=java.nameVariable(refObj.name) attrname=attrname indent=indent />  
  <#else>
${""?left_pad(indent)}${java.nameVariable(refObj.name)}.set${java.nameType(idAttrs[0].name)}(${attrname});  
  </#if>
</#macro>
<#assign typename = java.nameType(obj.name)>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
package <#if namespace??>${namespace}.</#if>${app.name}.dto.assembler;

import java.util.List;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

import org.junit.Test;
import org.junit.Assert;

import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;
import <#if namespace??>${namespace}.</#if>${app.name}.util.*;

public final class ${typename}QueryAssemblerTest {

  /**
   * 测试附加QueryHandler。
   */
  @Test 
  public void test_1_assemble${typename}Query() throws Exception {
    Map<String,Object> params = new HashMap<>();
    Map<String,Object> inner1Params = new HashMap<>();
    Map<String,Object> inner2Params = new HashMap<>();
    <#list idAttrs as idAttr>
      <#if idAttr.type.name == "string">
        <#assign UUID = statics['java.util.UUID']>
    params.put("${modelbase.get_attribute_sql_name(idAttr)}", "${UUID.randomUUID()?string?upper_case}");
    inner1Params.put("${modelbase.get_attribute_sql_name(idAttr)}", "${UUID.randomUUID()?string?upper_case}");
    inner2Params.put("${modelbase.get_attribute_sql_name(idAttr)}", "${UUID.randomUUID()?string?upper_case}");
      <#elseif idAttr.type.name == "int" || idAttr.type.name == "integer">
    params.put("${modelbase.get_attribute_sql_name(idAttr)}", "${tatabase.number(1, 100)}");
    inner1Params.put("${modelbase.get_attribute_sql_name(idAttr)}", "${tatabase.number(1, 100)}");
    inner2Params.put("${modelbase.get_attribute_sql_name(idAttr)}", "${tatabase.number(1, 100)}");  
      <#elseif idAttr.type.name == "date" || idAttr.type.name == "datetime">
    params.put("${modelbase.get_attribute_sql_name(idAttr)}", "${tatabase.datetime()}");
    inner1Params.put("${modelbase.get_attribute_sql_name(idAttr)}", "${tatabase.datetime()}");
    inner2Params.put("${modelbase.get_attribute_sql_name(idAttr)}", "${tatabase.datetime()}");   
      </#if>
    </#list>
    
    List<Map<String,Object>> queryHandlers = new ArrayList<>();
    Map<String,Object> qh1 = new HashMap<>();
    qh1.put("handler", "||stdhit/hrm/${obj.name}/merge");
    qh1.put("query", inner1Params);
    queryHandlers.add(qh1);
    
    Map<String,Object> qh2 = new HashMap<>();
    qh2.put("handler", "||stdhit/hrm/${obj.name}/remove");
    qh2.put("query", inner2Params);
    queryHandlers.add(qh2);
    
    params.put("queryHandlers", queryHandlers);
    ${typename}Query query = ${typename}QueryAssembler.assemble${typename}Query(params);
    
    Assert.assertEquals(2, query.getQueryHandlers().size());
  }
  
  /**
   * 测试集合Query。
   */
  @Test 
  public void test_2_assemble${typename}Query() throws Exception {
    Map<String,Object> params = new HashMap<>();
    List<Map<String,Object>> rows = new ArrayList<>();
    
    for (int i = 0; i < 2; i++) {
      Map<String,Object> row = new HashMap<>();
    <#list idAttrs as idAttr>
      <#if idAttr.type.name == "string">
        <#assign UUID = statics['java.util.UUID']>
      row.put("${modelbase.get_attribute_sql_name(idAttr)}", "${UUID.randomUUID()?string?upper_case}");
      <#elseif idAttr.type.name == "int" || idAttr.type.name == "integer">
      row.put("${modelbase.get_attribute_sql_name(idAttr)}", "${tatabase.number(1, 100)}");
      <#elseif idAttr.type.name == "date" || idAttr.type.name == "datetime">
      row.put("${modelbase.get_attribute_sql_name(idAttr)}", "${tatabase.datetime()}");
      </#if>
    </#list>  
      rows.add(row);
    }
    params.put("${inflector.pluralize(java.nameVariable(obj.name))}", rows);
    
    ${typename}Query query = ${typename}QueryAssembler.assemble${typename}Query(params);
    Assert.assertEquals(2, query.getQueries().size());
  }
  
  /**
   * 附加QueryHandler和参数为数组作为集合Query
   */
  @Test 
  public void test_3_assemble${typename}Query() throws Exception {
    Map<String,Object> params = new HashMap<>();
    
    List<Map<String,Object>> rows = new ArrayList<>();
    for (int i = 0; i < 3; i++) {
      Map<String,Object> row = new HashMap<>();
    <#list idAttrs as idAttr>
      <#if idAttr.type.name == "string">
        <#assign UUID = statics['java.util.UUID']>
      row.put("${modelbase.get_attribute_sql_name(idAttr)}", "${UUID.randomUUID()?string?upper_case}");
      <#elseif idAttr.type.name == "int" || idAttr.type.name == "integer">
      row.put("${modelbase.get_attribute_sql_name(idAttr)}", "${tatabase.number(1, 100)}");
      <#elseif idAttr.type.name == "date" || idAttr.type.name == "datetime">
      row.put("${modelbase.get_attribute_sql_name(idAttr)}", "${tatabase.datetime()}");
      </#if>
    </#list>
      rows.add(row);
    }

    List<Map<String,Object>> queryHandlers = new ArrayList<>();
    Map<String,Object> qh1 = new HashMap<>();
    qh1.put("handler", "||stdhit/hrm/${obj.name}/merge");
    qh1.put("queries", rows);
    queryHandlers.add(qh1);
    
    params.put("queryHandlers", queryHandlers);
    ${typename}Query query = ${typename}QueryAssembler.assemble${typename}Query(params);
    
    Assert.assertEquals(1, query.getQueryHandlers().size());
  }
  
  /**
   * 附加QueryHandler和参数中的一个属性作为集合Query
   */
  @Test 
  public void test_4_assemble${typename}Query() throws Exception {
    Map<String,Object> params = new HashMap<>();
    Map<String,Object> innerParams = new HashMap<>();
    List<Map<String,Object>> rows = new ArrayList<>();
    for (int i = 0; i < 3; i++) {
      Map<String,Object> row = new HashMap<>();
    <#list idAttrs as idAttr>
      <#if idAttr.type.name == "string">
        <#assign UUID = statics['java.util.UUID']>
      row.put("${modelbase.get_attribute_sql_name(idAttr)}", "${UUID.randomUUID()?string?upper_case}");
      <#elseif idAttr.type.name == "int" || idAttr.type.name == "integer">
      row.put("${modelbase.get_attribute_sql_name(idAttr)}", "${tatabase.number(1, 100)}");
      <#elseif idAttr.type.name == "date" || idAttr.type.name == "datetime">
      row.put("${modelbase.get_attribute_sql_name(idAttr)}", "${tatabase.datetime()}");
      </#if>
    </#list>
      rows.add(row);
    }
    innerParams.put("${inflector.pluralize(java.nameVariable(obj.name))}", rows);
    
    List<Map<String,Object>> queryHandlers = new ArrayList<>();
    Map<String,Object> qh1 = new HashMap<>();
    qh1.put("handler", "||stdhit/hrm/${obj.name}/merge");
    qh1.put("query", innerParams);
    queryHandlers.add(qh1);
    
    params.put("queryHandlers", queryHandlers);
    ${typename}Query query = ${typename}QueryAssembler.assemble${typename}Query(params);
    
    Assert.assertEquals(1, query.getQueryHandlers().size());
  }
 
}
