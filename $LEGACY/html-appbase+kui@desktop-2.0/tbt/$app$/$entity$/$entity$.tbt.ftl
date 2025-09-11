<#import '/$/modelbase.ftl' as modelbase>
<#assign Timestamp = statics['java.sql.Timestamp']>
<#assign Date = statics['java.sql.Date']>
goto("http://localhost:8880")

# 登录
click("//button[@id='buttonLogin']")
sleep("2")

###########################
# 新建
###########################

# 点击菜单
click("//nav[@id='sidemenu']//a[contains(text(),'')]")
click("//nav[@id='sidemenu']//a[contains(@href,'')]")
sleep("1")

# 点击新建
click("//div[@id='page${js.nameType(entity.name)}List']//a[contains(@class,'card-header-action')]")
click("//div[@id='page${js.nameType(entity.name)}List']//a[@widget-id='buttonNew']")
sleep("1")

<#assign formAttrs = []>
<#list entity.attributes as attr>
  <#if attr.name == 'state' 
    || attr.name == 'last_modified_time' 
    || attr.name == 'modifier_id' 
    || attr.name == 'modifier_type'
    || attr.name == 'ordinal_position'
    || attr.constraint.identifiable><#continue></#if>
  <#assign formAttrs = formAttrs + [attr]>
</#list>

<#list formAttrs as attr>
  <#if attr.type.name == 'string'>
    <#if attr.constraint.maxSize gt 200>
input("//div[@id='page${java.nameType(entity.name)}Edit']//textarea[@name='${modelbase.get_attribute_sql_name(attr)}']" = "")
    <#else>
input("//div[@id='page${java.nameType(entity.name)}Edit']//input[@name='${modelbase.get_attribute_sql_name(attr)}']" = "")
    </#if>
  <#elseif attr.type.name == 'date' || attr.type.name == 'datetime'>
input("//div[@id='page${java.nameType(entity.name)}Edit']//input[@name='${modelbase.get_attribute_sql_name(attr)}']" = "")
  <#elseif attr.type.custom>
click("//div[@id='page${java.nameType(entity.name)}Edit']//select[@name='${modelbase.get_attribute_sql_name(attr)}']/following-sibling::span")
click("//li[contains(text(), '')]")
  </#if>
</#list>

## 保存信息
click("//div[@id='page${java.nameType(entity.name)}Edit']//button[contains(@class, 'btn-save')]")
click("//div[@id='page${java.nameType(entity.name)}Edit']//button[contains(@class, 'btn-close')]")
sleep("1")

