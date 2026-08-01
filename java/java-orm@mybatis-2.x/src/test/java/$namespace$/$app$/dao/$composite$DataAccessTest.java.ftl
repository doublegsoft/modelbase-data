<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4java.ftl' as modelbase4java>
<#if license??>
${java.license(license)}
</#if>
<#list model.objects as obj>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  <#assign pktype = modelbase4java.type_attribute_primitive(idAttrs[0])>
  <#break>
</#list>
<#assign obj=composite>
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
package <#if namespace??>${namespace}.</#if>${app.name}.dao;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.io.Reader;

import java.sql.Date;
import java.sql.Timestamp;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.DriverManager;

import org.junit.Test;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.AfterClass;

import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import <#if namespace??>${namespace}.</#if>${app.name}.poco.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dto.payload.*;
import <#if namespace??>${namespace}.</#if>${app.name}.dao.*;

<#assign typename = java.nameType(obj.name)>
<#assign varname = java.nameVariable(obj.name)>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
/**
 * 【${modelbase.get_object_label(obj)}】实体各层对象的装配器。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since ${version}
 */
public class ${typename}DataAccessTest {

  @Test 
  public void testSelect${typename}() throws Exception {
    try (SqlSession session = BaseDataAccessTest.getSessionFactory().openSession()) {
      ${typename}DataAccess dao = session.getMapper(${typename}DataAccess.class);

      ${typename}Query data = new ${typename}Query();
      // dao.insert${typename}(data);
      ${typename}Query query = new ${typename}Query();
  <#--  <#list idAttrs as idAttr>
      query.set${java.nameType(modelbase.get_attribute_sql_name(idAttr))}(<#if pktype == "Long">1L<#else>"1"</#if>);
  </#list>        -->
      RowBounds rowBounds = new RowBounds(0, 1);
      List rows = dao.select${typename}Query(query, rowBounds);
      // Assert.assertEquals(1, rows.size());
      <#--  // Assert.assertEquals(<#if pktype == "Long">1L<#else>"1"</#if>, ((Map<String,Object>)rows.get(0)).get("${modelbase.get_attribute_sql_name(idAttrs[0])}"));  -->
    }
  }
  
}
