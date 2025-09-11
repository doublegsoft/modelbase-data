<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.defaults.repository;

import java.util.List;
import java.util.ArrayList;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import net.doublegsoft.appbase.ObjectMap;
import net.doublegsoft.appbase.SqlParams;
import net.doublegsoft.appbase.JsonData;
import net.doublegsoft.appbase.util.Strings;

<#list imports as imp>
import ${imp}.model.entity.*;
import ${imp}.model.assembler.*;
import ${imp}.model.validation.*;
import ${imp}.model.repository.*;
</#list>

<#if modelbase.has_entity_object(app.name, model)>
import <#if namespace??>${namespace}.</#if>${app.name}.model.entity.*;
import <#if namespace??>${namespace}.</#if>${app.name}.model.repository.*;
</#if>
<#if modelbase.has_value_object(app.name, model)>
import <#if namespace??>${namespace}.</#if>${app.name}.model.value.*;
</#if>

<#list modelbase.get_dependencies(model) as dep>
  <#if appbase.has_value(model, dep)>
import <#if namespace??>${namespace}.</#if>${dep}.model.value.*;
  </#if>
  <#if appbase.has_entity(model, dep)>
import <#if namespace??>${namespace}.</#if>${dep}.model.entity.*;
  </#if>
</#list>

<#-- 实体类名 -->
<#assign typename = java.nameType(entity.name)>
<#-- 实体变量名 -->
<#assign varname = java.nameVariable(entity.name)>
<#assign label = modelbase.get_object_label(entity)>
<#-- 名称的单数和复数形式 -->
<#attempt>
  <#assign singular = modelbase.get_attribute_labelled_option(entity, 'name', 'singular')>
  <#assign plural   = modelbase.get_attribute_labelled_option(entity, 'name', 'plural')>
<#recover>
  <#stop entity.name + '没有单复数的名称'>
</#attempt>

<#-- 实体的标识属性 -->
<#assign idAttrs  = modelbase.get_id_attributes(entity)>
<#-- 所有关联对象根据业务关系的分组 -->
<#assign groups   = modelbase.group_object_references(entity, model)>

<#-- 实体访问库集合 -->
<#assign anyRefObjs = groups.anyRefObjs>
<#-- 引用一个 -->
<#assign o2oRefAttrs = groups.o2oRefAttrs>
<#assign o2oRefObjs  = groups.o2oRefObjs>
<#-- 引用多个 -->
<#assign o2mRefAttrs = groups.o2mRefAttrs>
<#assign o2mRefObjs  = groups.o2mRefObjs>
<#assign o2mConjObjs = groups.o2mConjObjs>

/**
 * ${modelbase.get_object_label(entity)}实体对象库测试。
 *
 * @author <a href="mailto:guo.guo.gan@gmail.com">Christian Gann</a>
 *
 * @since ${version}
 */
public class Default${java.nameType(entity.name)}RepositoryTest {

  private static final ApplicationContext context = new ClassPathXmlApplicationContext("spring-test.xml");

  private ${java.nameType(entity.name)}Repository ${java.nameVariable(entity.name)}Repository;
<#list anyRefObjs?values as anyRefObj>
  <#if !anyRefObj.isLabelled('entity') || anyRefObj.name == entity.name><#continue></#if>
  private ${java.nameType(anyRefObj.name)}Repository ${java.nameVariable(anyRefObj.name)}Repository;
</#list>

  @Before
  public void initialize() {
    ${java.nameVariable(entity.name)}Repository = context.getBean(${java.nameType(entity.name)}Repository.class);
<#list anyRefObjs?values as anyRefObj>
  <#if !anyRefObj.isLabelled('entity') || anyRefObj.name == entity.name><#continue></#if>
    ${java.nameVariable(anyRefObj.name)}Repository = context.getBean(${java.nameType(anyRefObj.name)}Repository.class);
</#list>
  }

  @Test
  public void test_create${java.nameType(entity.name)}() throws Exception {
    System.out.println("############## test_create${java.nameType(entity.name)}");
    ${java.nameType(entity.name)} ${java.nameVariable(entity.name)} = build${java.nameType(entity.name)}();
<#list idAttrs as idAttr>
  <#if idAttr.type.custom>
    ${java.nameType(idAttr.type.name)} ${java.nameVariable(idAttr.type.name)}${java.nameType(idAttr.name)} = build${java.nameType(idAttr.type.name)}();
    // ${java.nameVariable(idAttr.type.name)}Repository.create${java.nameType(idAttr.type.name)}(${java.nameVariable(idAttr.type.name)}${java.nameType(idAttr.name)});
    ${java.nameVariable(entity.name)}.set${java.nameType(idAttr.name)}(${java.nameVariable(idAttr.type.name)}${java.nameType(idAttr.name)});
  </#if>
</#list>
    ${java.nameVariable(entity.name)}Repository.create${java.nameType(entity.name)}(${java.nameVariable(entity.name)});

<#list idAttrs as idAttr>
    ${modelbase.type_attribute(idAttr)} ${java.nameVariable(idAttr.name)} = ${java.nameVariable(entity.name)}.get${java.nameType(idAttr.name)}();
    Assert.assertNotNull(${java.nameVariable(idAttr.name)});
</#list>
    ${java.nameVariable(entity.name)} = ${java.nameVariable(entity.name)}Repository.read${java.nameType(entity.name)}(<@appbase.print_attributes_as_primitive_arguments attrs=idAttrs/>, true);
    Assert.assertNotNull(${java.nameVariable(entity.name)});

    ${java.nameVariable(entity.name)}Repository.delete${java.nameType(entity.name)}(${java.nameVariable(idAttrs[0].name)});

<#if idAttrs[0].type.custom>
    // clean up
    ${java.nameVariable(idAttrs[0].type.name)}Repository.delete${java.nameType(idAttrs[0].type.name)}(<@appbase.print_attributes_as_primitive_arguments attrs=idAttrs/>);
</#if>  
  }

  @Test
  public void test_read${typename}() throws Exception {
    System.out.println("############## test_read${typename}");
    ${java.nameType(entity.name)} ${java.nameVariable(entity.name)} = build${java.nameType(entity.name)}();
<#list idAttrs as idAttr>
  <#if idAttr.type.custom>
    ${java.nameType(idAttr.type.name)} ${java.nameVariable(idAttr.type.name)}${java.nameType(idAttr.name)} = build${java.nameType(idAttr.type.name)}();
    // ${java.nameVariable(idAttr.type.name)}Repository.create${java.nameType(idAttr.type.name)}(${java.nameVariable(idAttr.type.name)}${java.nameType(idAttr.name)});
    ${java.nameVariable(entity.name)}.set${java.nameType(idAttr.name)}(${java.nameVariable(idAttr.type.name)}${java.nameType(idAttr.name)});
  </#if>
</#list>
    ${java.nameVariable(entity.name)}Repository.create${java.nameType(entity.name)}(${java.nameVariable(entity.name)});

<#list idAttrs as idAttr>
    ${modelbase.type_attribute(idAttr)} ${java.nameVariable(idAttr.name)} = ${java.nameVariable(entity.name)}.get${java.nameType(idAttr.name)}();
    Assert.assertNotNull(${java.nameVariable(idAttr.name)});
</#list>
    ${java.nameVariable(entity.name)} = ${java.nameVariable(entity.name)}Repository.read${java.nameType(entity.name)}(<@appbase.print_attributes_as_primitive_arguments attrs=idAttrs/>, true);
    Assert.assertNotNull(${java.nameVariable(entity.name)});

    ${java.nameVariable(entity.name)}Repository.delete${java.nameType(entity.name)}(${java.nameVariable(idAttrs[0].name)});

<#if idAttrs[0].type.custom>
    // clean up
    ${java.nameVariable(idAttrs[0].type.name)}Repository.delete${java.nameType(idAttrs[0].type.name)}(<@appbase.print_attributes_as_primitive_arguments attrs=idAttrs/>);
</#if>  
  }

  @Test
  public void test_update${typename}() throws Exception {
    System.out.println("############## test_update${typename}");
    ${java.nameType(entity.name)} ${java.nameVariable(entity.name)} = build${java.nameType(entity.name)}();
<#list idAttrs as idAttr>
  <#if idAttr.type.custom>
    ${java.nameType(idAttr.type.name)} ${java.nameVariable(idAttr.type.name)}${java.nameType(idAttr.name)} = build${java.nameType(idAttr.type.name)}();
    // ${java.nameVariable(idAttr.type.name)}Repository.create${java.nameType(idAttr.type.name)}(${java.nameVariable(idAttr.type.name)}${java.nameType(idAttr.name)});
    ${java.nameVariable(entity.name)}.set${java.nameType(idAttr.name)}(${java.nameVariable(idAttr.type.name)}${java.nameType(idAttr.name)});
  </#if>
</#list>
    ${java.nameVariable(entity.name)}Repository.create${java.nameType(entity.name)}(${java.nameVariable(entity.name)});

<#list idAttrs as idAttr>
    ${modelbase.type_attribute(idAttr)} ${java.nameVariable(idAttr.name)} = ${java.nameVariable(entity.name)}.get${java.nameType(idAttr.name)}();
</#list>
    ${java.nameVariable(entity.name)} = ${java.nameVariable(entity.name)}Repository.read${java.nameType(entity.name)}(<@appbase.print_attributes_as_primitive_arguments attrs=idAttrs/>, true);
<#list entity.attributes as attr>
  <#if attr.constraint.identifiable || !attr.persistenceName??><#continue></#if>
    <#if attr.type.name == 'string' && !attr.type.custom>
    ${java.nameVariable(entity.name)}.set${java.nameType(attr.name)}(${modelbase.test_unit_value(attr)});
    </#if>
</#list>
    ${java.nameVariable(entity.name)}Repository.update${java.nameType(entity.name)}(${java.nameVariable(entity.name)});
    ${java.nameVariable(entity.name)} = ${java.nameVariable(entity.name)}Repository.read${java.nameType(entity.name)}(<@appbase.print_attributes_as_primitive_arguments attrs=idAttrs/>, true);
<#list entity.attributes as attr>
  <#if attr.constraint.identifiable || !attr.persistenceName??><#continue></#if>
    <#if attr.type.name == 'string' && !attr.type.custom && attr.constraint.domainType.name != 'uuid'>
    // FIXME
    // Assert.assertEquals(${modelbase.test_unit_value(attr)}, ${java.nameVariable(entity.name)}.get${java.nameType(attr.name)}());
    </#if>
</#list>   

    ${java.nameVariable(entity.name)}Repository.delete${java.nameType(entity.name)}(${java.nameVariable(idAttrs[0].name)});

<#if idAttrs[0].type.custom>
    // clean up
    ${java.nameVariable(idAttrs[0].type.name)}Repository.delete${java.nameType(idAttrs[0].type.name)}(<@appbase.print_attributes_as_primitive_arguments attrs=idAttrs/>);
</#if>  
  }

  @Test
  public void test_delete${typename}() throws Exception {
    System.out.println("############## test_delete${typename}");
    ${java.nameType(entity.name)} ${java.nameVariable(entity.name)} = build${java.nameType(entity.name)}();
<#list idAttrs as idAttr>
  <#if idAttr.type.custom>
    ${java.nameType(idAttr.type.name)} ${java.nameVariable(idAttr.type.name)}${java.nameType(idAttr.name)} = build${java.nameType(idAttr.type.name)}();
    // ${java.nameVariable(idAttr.type.name)}Repository.create${java.nameType(idAttr.type.name)}(${java.nameVariable(idAttr.type.name)}${java.nameType(idAttr.name)});
    ${java.nameVariable(entity.name)}.set${java.nameType(idAttr.name)}(${java.nameVariable(idAttr.type.name)}${java.nameType(idAttr.name)});
  </#if>
</#list>
    ${java.nameVariable(entity.name)}Repository.create${java.nameType(entity.name)}(${java.nameVariable(entity.name)});
<#list idAttrs as idAttr>
    ${modelbase.type_attribute(idAttr)} ${java.nameVariable(idAttr.name)} = ${java.nameVariable(entity.name)}.get${java.nameType(idAttr.name)}();
</#list>
    ${java.nameVariable(entity.name)} = ${java.nameVariable(entity.name)}Repository.read${java.nameType(entity.name)}(<@appbase.print_attributes_as_primitive_arguments attrs=idAttrs/>, true);
    Assert.assertNotNull(${java.nameVariable(entity.name)});
    
    ${java.nameVariable(entity.name)}Repository.delete${java.nameType(entity.name)}(<@appbase.print_attributes_as_primitive_arguments attrs=idAttrs/>);
    
    ${java.nameVariable(entity.name)} = ${java.nameVariable(entity.name)}Repository.read${java.nameType(entity.name)}(<@appbase.print_attributes_as_primitive_arguments attrs=idAttrs/>, true);
    Assert.assertNull(${java.nameVariable(entity.name)});

<#if idAttrs[0].type.custom>
    // clean up
    ${java.nameVariable(idAttrs[0].type.name)}Repository.delete${java.nameType(idAttrs[0].type.name)}(<@appbase.print_attributes_as_primitive_arguments attrs=idAttrs/>);
</#if>  
  }

  @Test
  public void test_find${java.nameType(plural)}By() throws Exception {

  }
  <#-- 单一实体对象引用 -->
<#list o2oRefAttrs as o2oRefAttr>
  <#if !o2oRefAttr.persistenceName??><#continue></#if>
  <#assign o2oRefObj = o2oRefObjs[o2oRefAttr?index]>
  <#assign o2oRefObjAttr = o2oRefAttr.directRelationship.targetAttribute>

  public void test_find${java.nameType(entity.plural)}By${java.nameType(o2oRefAttr.name)}() throws Exception {

  }
</#list>
<#list o2mRefAttrs as o2mRefAttr>
  <#assign o2mRefObj  = o2mRefObjs[o2mRefAttr?index]>
  <#assign o2mConjObj = o2mConjObjs[o2mRefAttr?index]>

  @Test  
  public void test_add${java.nameType(o2mRefAttr.name)}() throws Exception {

  }

  @Test
  public void test_remove${java.nameType(o2mRefAttr.name)}() throws Exception {

  }

  @Test  
  public void test_add${java.nameType(modelbase.get_attribute_singular(o2mRefAttr))}() throws Exception {

  }

  @Test
  public void test_remove${java.nameType(modelbase.get_attribute_singular(o2mRefAttr))}() throws Exception {

  }

  @Test
  public void test_find${java.nameType(plural)}By${java.nameType(o2mRefAttr.name)}() throws Exception {

  }

</#list>

  private ${java.nameType(entity.name)} build${java.nameType(entity.name)}() {
    ${java.nameType(entity.name)} retVal = new ${java.nameType(entity.name)}();
<#list entity.attributes as attr>
  <#if !attr.persistenceName?? || attr.constraint.identifiable><#continue></#if>
  <#if attr.constraint.domainType.name?contains('enum')>
    retVal.set${java.nameType(attr.name)}("${tatabase.enumcode(attr.constraint.domainType.name)}");
  <#elseif attr.constraint.domainType.name == 'state'>
    retVal.set${java.nameType(attr.name)}("E");
  <#elseif attr.constraint.domainType.name == 'bool'>
    retVal.set${java.nameType(attr.name)}(true);
  <#elseif attr.type.name == 'string'>
    retVal.set${java.nameType(attr.name)}("${tatabase.string((attr.type.length!12) / 4)}");
  <#elseif attr.type.name == 'number'>
    retVal.set${java.nameType(attr.name)}(new BigDecimal("${tatabase.number(0, 100)}"));
  <#elseif attr.type.name == 'date'>
    retVal.set${java.nameType(attr.name)}(java.sql.Date.valueOf("${tatabase.date()}"));
  <#elseif attr.type.name == 'datetime'>
    retVal.set${java.nameType(attr.name)}(Timestamp.valueOf("${tatabase.datetime()}"));
  <#elseif attr.type.name == 'long'>
    retVal.set${java.nameType(attr.name)}(new BigDecimal("${tatabase.number(0, 100)}").longValue());
  <#elseif attr.type.name == 'int' || attr.type.name == 'integer'>
    retVal.set${java.nameType(attr.name)}(new BigDecimal("${tatabase.number(0, 100)}").intValue());
  <#elseif attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#assign attrIdRefObj = modelbase.get_id_attributes(refObj)[0]>
    <#--FIXME-->
    // FIXME
    ${java.nameType(refObj.name)} ${java.nameVariable(attr.name)} = new ${java.nameType(refObj.name)}();
    ${java.nameVariable(attr.name)}.set${java.nameType(attrIdRefObj.name)}("123456");
    retVal.set${java.nameType(attr.name)}(${java.nameVariable(attr.name)});
  </#if>
</#list>
    return retVal;
  }
<#if idAttrs[0].type.custom>
  <#assign idEntity = model.findObjectByName(idAttrs[0].type.name)>
  <#assign idEntityPrevName = 'retVal'>
  private ${java.nameType(idEntity.name)} build${java.nameType(idEntity.name)}() {
    ${java.nameType(idEntity.name)} retVal = new ${java.nameType(idEntity.name)}();
<#list 0..10 as index>
    <#assign idEntityIdAttr = modelbase.get_id_attributes(idEntity)[0]>
    <#if idEntityIdAttr.type.name == 'uuid' || idEntityIdAttr.type.name == 'id' || idEntityIdAttr.type.name == 'string'>
    ${idEntityPrevName}.set${java.nameType(idEntityIdAttr.name)}("1234567890");
      <#break>
    <#else>
      <#assign idEntity = model.findObjectByName(idEntityIdAttr.type.name)>
    ${java.nameType(idEntity.name)} ${java.nameVariable(idEntity.name)} = new ${java.nameType(idEntity.name)}();
    ${idEntityPrevName}.set${java.nameType(idEntityIdAttr.name)}(${java.nameVariable(idEntity.name)});
      <#assign idEntityPrevName = java.nameVariable(idEntity.name)>
    </#if>
</#list>
    <#assign idEntity = model.findObjectByName(idAttrs[0].type.name)>
<#list idEntity.attributes as attr>
  <#if !attr.persistenceName?? || attr.constraint.identifiable><#continue></#if>
  <#if attr.constraint.domainType.name?contains('enum')>
    retVal.set${java.nameType(attr.name)}("${tatabase.enumcode(attr.constraint.domainType.name)}");
  <#elseif attr.constraint.domainType.name == 'state'>
    retVal.set${java.nameType(attr.name)}("E");
  <#elseif attr.constraint.domainType.name == 'bool'>
    retVal.set${java.nameType(attr.name)}(true);
  <#elseif attr.type.name == 'string'>
    retVal.set${java.nameType(attr.name)}("${tatabase.string((attr.type.length!12) / 4)}");
  <#elseif attr.type.name == 'number'>
    retVal.set${java.nameType(attr.name)}(new BigDecimal("${tatabase.number(0, 100)}"));
  <#elseif attr.type.name == 'date'>
    retVal.set${java.nameType(attr.name)}(java.sql.Date.valueOf("${tatabase.date()}"));
  <#elseif attr.type.name == 'datetime'>
    retVal.set${java.nameType(attr.name)}(Timestamp.valueOf("${tatabase.datetime()}"));
  <#elseif attr.type.name == 'long'>
    retVal.set${java.nameType(attr.name)}(new BigDecimal("${tatabase.number(0, 100)}").longValue());
  <#elseif attr.type.name == 'int' || attr.type.name == 'integer'>
    retVal.set${java.nameType(attr.name)}(new BigDecimal("${tatabase.number(0, 100)}").intValue());
  <#elseif attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#assign attrIdRefObj = modelbase.get_id_attributes(refObj)[0]>
    <#--FIXME-->
    // FIXME
    ${java.nameType(refObj.name)} ${java.nameVariable(attr.name)} = new ${java.nameType(refObj.name)}();
    ${java.nameVariable(attr.name)}.set${java.nameType(attrIdRefObj.name)}("123456");
    retVal.set${java.nameType(attr.name)}(${java.nameVariable(attr.name)});
  </#if>
</#list>
    return retVal;
  }
  </#if>
}
