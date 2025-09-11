<#import '/$/modelbase.ftl' as modelbase>
<#assign Timestamp = statics['java.sql.Timestamp']>
<#assign Date = statics['java.sql.Date']>
goto("http://localhost:8088")

# 登录
click("//button[@id='buttonLogin']")
sleep("2")

# 展开模块：组织结构
click("//nav[@id='sidemenu']//a[contains(text(),'组织结构')]")

<#list model.objects as obj>
  <#if obj.isLabelled('generated')><#continue></#if>
  <#if obj.isLabelled('conjunction')><#continue></#if>
  <#if obj.isLabelled('constant')><#continue></#if>
  <#if obj.isLabelled('value')><#continue></#if>
click("//nav[@id='sidemenu']//a[contains(@href,'${modelbase.get_object_label(obj)}')]")
sleep("1")

click("//div[@id='page${java.nameType(obj.name)}List']//a[contains(@class,'card-header-action')]")

click("//div[@id='page${java.nameType(obj.name)}List']//a[contains(@href,'新建')]")
sleep("1")

  <#assign displayAttrs = []>
  <#list obj.attributes as attr>
  <#if attr.name == 'last_modified_time'><#continue></#if>
  <#if attr.name == 'state'><#continue></#if>
  <#if attr.type.collection><#continue></#if>
  <#if attr.constraint.identifiable && attr.type.custom>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#list refObj.attributes as refObjAttr>
      <#if refObjAttr.constraint.identifiable><#continue></#if>
      <#if refObjAttr.type.collection><#continue></#if>
      <#if refObjAttr.type.custom><#continue></#if>
      <#if refObjAttr.name == 'state'><#continue></#if>
      <#if refObjAttr.name == 'last_modified_time'><#continue></#if>
      <#assign displayAttrs = displayAttrs + [refObjAttr]>
    </#list>
    <#continue>
  </#if>
  <#assign displayAttrs = displayAttrs + [attr]>
</#list>

  <#list displayAttrs as attr>
    <#if attr.name == 'state'><#continue></#if>
    <#if attr.name == 'last_modified_time'><#continue></#if>
    <#if attr.constraint.domainType.name?contains('enum')>
      <#--TODO-->
    <#elseif attr.constraint.domainType.name == 'json'>
      <#--TODO-->
    <#elseif attr.type.name == 'string'>
      <#if (attr.type.length >= 400)>
input("//div[contains(@class,'rightbar')]//textarea[@name='${modelbase.get_attribute_sql_name(attr)}']" = "${tatabase.string((attr.type.length!12)/4)}")
      <#else>
input("//div[contains(@class,'rightbar')]//input[@name='${modelbase.get_attribute_sql_name(attr)}']" = "${tatabase.string((attr.type.length!12)/4)}")
      </#if>
    <#elseif attr.type.name == 'bool'>
      <#--TODO-->
    <#elseif attr.type.name == 'email'>
input("//div[contains(@class,'rightbar')]//input[@name='${modelbase.get_attribute_sql_name(attr)}']" = "${tatabase.value('email', '')}")
    <#elseif attr.type.name == 'mobile'>
input("//div[contains(@class,'rightbar')]//input[@name='${modelbase.get_attribute_sql_name(attr)}']" = "${tatabase.value('mobile', '')}")
    <#elseif attr.type.name == 'phone'>
input("//div[contains(@class,'rightbar')]//input[@name='${modelbase.get_attribute_sql_name(attr)}']" = "${tatabase.value('phone', '')}")
    <#elseif attr.type.name == 'number'>
input("//div[contains(@class,'rightbar')]//input[@name='${modelbase.get_attribute_sql_name(attr)}']" = "${tatabase.number(0,100)}")
    <#elseif attr.type.name == 'date'>
input("//div[contains(@class,'rightbar')]//input[@name='${modelbase.get_attribute_sql_name(attr)}']" = "${Date.valueOf(tatabase.date())?string("yyyy-MM-dd")}")
    <#elseif attr.type.name == 'datetime'>
input("//div[contains(@class,'rightbar')]//input[@name='${modelbase.get_attribute_sql_name(attr)}']" = "${Timestamp.valueOf(tatabase.datetime())?string("yyyy-MM-dd hh:mm:ss")}")
    <#elseif attr.type.name == 'text'>
input("//div[contains(@class,'rightbar')]//textarea[@name='${modelbase.get_attribute_sql_name(attr)}']" = "${tatabase.string((attr.type.length!12)/4)}")
    <#elseif attr.type.custom>
      <#--TODO-->
    <#else>
      <#--TODO-->
    </#if>
  </#list>

click("//div[contains(@class,'rightbar')]//button[contains(@class, 'btn-save')]")
sleep("2")

click("//div[contains(@class,'rightbar')]//button[contains(@class, 'btn-close')]")
sleep("1")

</#list>
