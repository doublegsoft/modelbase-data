<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
<#if license??>
${java.license(license)}
</#if>
package <#if namespace??>${namespace}.</#if>${app.name}.defaults.usecase;

import java.util.List;
import java.util.ArrayList;
import java.math.BigDecimal;
import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.Ignore;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import net.doublegsoft.appbase.ObjectMap;
import net.doublegsoft.appbase.SqlParams;
import net.doublegsoft.appbase.JsonData;
import net.doublegsoft.appbase.util.Strings;
import net.doublegsoft.appbase.service.RepositoryService;
import net.doublegsoft.appbase.service.GroovyService;

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
public class ${java.nameType(entity.name)}MergeTest {

  private static final ApplicationContext context = new ClassPathXmlApplicationContext("spring-test.xml");

  private RepositoryService repositoryService;

  private GroovyService groovyService;

  @Before
  public void initialize() {
    repositoryService = context.getBean(RepositoryService.class);
    groovyService = context.getBean(GroovyService.class);
  }

  @Test
  public void test_usecase() throws Exception {
    System.out.println("############## ${java.nameType(entity.name)}MergeTest");
    ObjectMap params = build${java.nameType(entity.name)}();
    ${java.nameType(entity.name)} data = (${java.nameType(entity.name)}) repositoryService.handleUsecase("${parentApplication}/${app.name}/${entity.name}/save", params);
    System.out.println(new JsonData().set("data", data));

    params.set("${modelbase.get_attribute_sql_name(idAttrs[0])}", data.get${java.nameType(idAttrs[0].name)}().toString());
    data = (${java.nameType(entity.name)}) repositoryService.handleUsecase("${parentApplication}/${app.name}/${entity.name}/merge", params);
    System.out.println(new JsonData().set("data", data));
  }

  @Test
  public void test_script() throws Exception {
    System.out.println("############## ${java.nameType(entity.name)}MergeTest -- script");
    ObjectMap params = build${java.nameType(entity.name)}("3");
    params.set("@${parentApplication}/${app.name}/${entity.name}/merge", buildInner${java.nameType(entity.name)}());
    JsonData data = groovyService.execute("${parentApplication}/${app.name}/${entity.name}/merge", params);
    System.out.println(data);
  }

  private ObjectMap build${java.nameType(entity.name)}() {
    return build${java.nameType(entity.name)}("");
  }

  private ObjectMap build${java.nameType(entity.name)}(String suffix) {
    ObjectMap retVal = new ObjectMap();
<#if idAttrs[0].type.custom>
    retVal.putAll(build${java.nameType(idAttrs[0].name)}());
</#if>
<#list entity.attributes as attr>
  <#if !attr.persistenceName?? || attr.constraint.identifiable><#continue></#if>
  <#if attr.constraint.domainType.name?contains('enum')>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", "${tatabase.enumcode(attr.constraint.domainType.name)}");
  <#elseif attr.constraint.domainType.name == 'state'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", "E");
  <#elseif attr.constraint.domainType.name == 'bool'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", "T");
  <#elseif attr.type.name == 'string'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", "${tatabase.string((attr.type.length!12) / 4)}" + suffix);
  <#elseif attr.type.name == 'number'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", "${tatabase.number(0, 100)}");
  <#elseif attr.type.name == 'date'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", "${tatabase.date()}");
  <#elseif attr.type.name == 'datetime'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", "${tatabase.datetime()}");
  <#elseif attr.type.name == 'long'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", String.valueOf(new BigDecimal("${tatabase.number(0, 100)}").longValue()));
  <#elseif attr.type.name == 'int' || attr.type.name == 'integer'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", String.valueOf(new BigDecimal("${tatabase.number(0, 100)}").intValue()));
  <#elseif attr.type.custom>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", "123456");
  </#if>
</#list>
    return retVal;
  }

  private ObjectMap buildInner${java.nameType(entity.name)}() {
    ObjectMap retVal = new ObjectMap();
    retVal.set("_result_name", "another");
    retVal.set("${modelbase.get_attribute_sql_name(idAttrs[0])}", "${r'${'}${modelbase.get_attribute_sql_name(idAttrs[0])}${r'}'}");
    retVal.putAll(build${java.nameType(entity.name)}("3"));
    return retVal;
  }
<#if idAttrs[0].type.custom>
  <#assign idEntity = model.findObjectByName(idAttrs[0].type.name)>

  private ObjectMap build${java.nameType(idAttrs[0].name)}() {
    ObjectMap retVal = new ObjectMap();
<#list idEntity.attributes as attr>
  <#if !attr.persistenceName?? || attr.constraint.identifiable><#continue></#if>
  <#if attr.constraint.domainType.name?contains('enum')>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", "${tatabase.enumcode(attr.constraint.domainType.name)}");
  <#elseif attr.constraint.domainType.name == 'state'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", "E");
  <#elseif attr.constraint.domainType.name == 'bool'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", "T");
  <#elseif attr.type.name == 'string'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", "${tatabase.string((attr.type.length!12) / 4)}");
  <#elseif attr.type.name == 'number'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", new BigDecimal("${tatabase.number(0, 100)}"));
  <#elseif attr.type.name == 'date'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", "${tatabase.date()}");
  <#elseif attr.type.name == 'datetime'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", "${tatabase.datetime()}");
  <#elseif attr.type.name == 'long'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", new BigDecimal("${tatabase.number(0, 100)}").longValue());
  <#elseif attr.type.name == 'int' || attr.type.name == 'integer'>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", new BigDecimal("${tatabase.number(0, 100)}").intValue());
  <#elseif attr.type.custom>
    retVal.set("${modelbase.get_attribute_sql_name(attr)}", "123456");
  </#if>
</#list>
    return retVal;
  }
</#if>
}

