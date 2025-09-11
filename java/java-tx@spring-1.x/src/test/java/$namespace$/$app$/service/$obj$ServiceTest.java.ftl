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
public class ${java.nameType(obj.name)}ServiceTest extends ServiceTestBase {
  
  @Test
  public void testSaveFromJson() throws Exception {
    ${java.nameType(obj.name)}Service service = getContext().getBean(${java.nameType(obj.name)}Service.class);
    ${java.nameType(obj.name)}Query query = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(fromJson("json/${obj.name?replace("_","-")}#save.json"));
    // service.save${java.nameType(obj.name)}(query);
  }
  
  @Test
  public void testReadFromJson() throws Exception {
    ${java.nameType(obj.name)}Service service = getContext().getBean(${java.nameType(obj.name)}Service.class);
    ${java.nameType(obj.name)}Query query = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(fromJson("json/${obj.name?replace("_","-")}#read.json"));
    try {
      service.read${java.nameType(obj.name)}(query);
    } catch (ServiceException ex) {
      Assert.assertEquals(404, ex.getCode());
    }
  }
  
  @Test
  public void testFindFromJson() throws Exception {
    ${java.nameType(obj.name)}Service service = getContext().getBean(${java.nameType(obj.name)}Service.class);
    ${java.nameType(obj.name)}Query query = ${java.nameType(obj.name)}QueryAssembler.assemble${java.nameType(obj.name)}Query(fromJson("json/${obj.name?replace("_","-")}#find.json"));
    service.find${inflector.pluralize(java.nameType(obj.name))}(query);
  }
}
