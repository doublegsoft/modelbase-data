<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
<#assign persistentAttrs = []>
<#assign persistentNonIdAttrs = []>
<#list obj.attributes as attr>
  <#if attr.isLabelled("persistence")>
    <#assign persistentAttrs += [attr]>
    <#if !attr.identifiable>
      <#assign persistentNonIdAttrs += [attr]>
    </#if>
  </#if>
</#list>
#import "${objc.nameType(obj.name)}SQL.h"

@implementation ${namespace!""}${objc.nameType(obj.name)}SQL

+ (NSString*)getInsertSQL:(${objc.nameType(obj.name)}Query*)${objc.nameVariable(obj.name)} {
  NSString* ret = @""
    "insert into ${obj.persistenceName} ("
<#list persistentAttrs as attr>
    "  ${attr.persistenceName}<#if attr?index != persistentAttrs?size - 1>,</#if>"
</#list>    
    ") values (";
<#list persistentAttrs as attr>
  <#if attr?index == persistentAttrs?size - 1>
    <#assign fmt = "%@">
  <#else>
    <#assign fmt = "%@,">
  </#if>
  <#assign attrtype = modelbase4objc.type_attribute_primitive(attr)>
  <#if attrtype == "NSString*">
  ret = [ret stringByAppendingFormat:@"${fmt}", [${objc.nameType(app.name)}SQL escapeString:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} andVar:-1]];
  <#elseif attrtype == "NSInteger">
  ret = [ret stringByAppendingFormat:@"${fmt}", [${objc.nameType(app.name)}SQL escapeInteger:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}]];
  <#elseif attrtype == "NSDate*">
  ret = [ret stringByAppendingFormat:@"${fmt}", [${objc.nameType(app.name)}SQL escapeDate:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}]];
  <#elseif attrtype == "NSDecimalNumber*">
  ret = [ret stringByAppendingFormat:@"${fmt}", [${objc.nameType(app.name)}SQL escapeDecimal:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}]];
  <#elseif attrtype == "BOOL">
  ret = [ret stringByAppendingFormat:@"${fmt}", [${objc.nameType(app.name)}SQL escapeBool:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}]];
  </#if>
</#list>    
  [ret stringByAppendingString:@")"];
  return ret;
}

+ (NSString*)getUpdateSQL:(${objc.nameType(obj.name)}Query*)${objc.nameVariable(obj.name)} {
  NSString* ret = @""
    "update ${obj.persistenceName} set ";
<#list persistentNonIdAttrs as attr>
  <#if attr?index == persistentNonIdAttrs?size - 1>
    <#assign fmt = "%@">
  <#else>
    <#assign fmt = "%@,">
  </#if>
  <#assign attrtype = modelbase4objc.type_attribute_primitive(attr)>
  <#if attrtype == "NSString*">  
  if (${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} != nil) {
    ret = [ret stringByAppendingFormat:@"${attr.persistenceName} = ${fmt} ", [${objc.nameType(app.name)}SQL escapeString:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} andVar:-1]];
  }
  <#elseif attrtype == "NSDate*">
  if (${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} != nil) {
    ret = [ret stringByAppendingFormat:@"${attr.persistenceName} = ${fmt} ", [${objc.nameType(app.name)}SQL escapeDate:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}]];
  }
  <#elseif attrtype == "NSDecimalNumber*">
  if (${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} != nil) {
    ret = [ret stringByAppendingFormat:@"${attr.persistenceName} = ${fmt} ", [${objc.nameType(app.name)}SQL escapeDecimal:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}]];
  }
  <#elseif attrtype == "NSInteger">
  if (${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} != NSIntegerMin) {
    ret = [ret stringByAppendingFormat:@"${attr.persistenceName} = ${fmt} ", [${objc.nameType(app.name)}SQL escapeInteger:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}]];
  }
  <#elseif attrtype == "BOOL">
  ret = [ret stringByAppendingFormat:@"${attr.persistenceName} = ${fmt} ", [${objc.nameType(app.name)}SQL escapeBool:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}]];
  </#if>
</#list>      
  [ret stringByAppendingString:@"where 1=1"];
  NSString* val;
<#list persistentAttrs as attr>
  <#if !attr.identifiable><#continue></#if>
  <#assign attrtype = modelbase4objc.type_attribute_primitive(attr)>
  <#if attrtype == "NSString*">
  val = [${objc.nameType(app.name)}SQL escapeString:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} andVar:-1];
  <#elseif attrtype == "NSInteger">
  val = [${objc.nameType(app.name)}SQL escapeInteger:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}];
  <#elseif attrtype == "NSDate*">
  val = [${objc.nameType(app.name)}SQL escapeDate:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}];
  <#elseif attrtype == "NSDecimalNumber*">
  val = [${objc.nameType(app.name)}SQL escapeDecimal:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}];
  </#if>
  ret = [ret stringByAppendingFormat:@"and ${attr.persistenceName} = %@", val];
</#list>  
  return ret;
}

+ (NSString*)getDeleteSQL:(${objc.nameType(obj.name)}Query*)${objc.nameVariable(obj.name)} {
  NSString* ret = @""
    "delete from ${obj.persistenceName} ";
  [ret stringByAppendingString:@"where 1=1"];
  NSString* val;
<#list persistentAttrs as attr>
  <#if !attr.identifiable><#continue></#if>
  <#assign attrtype = modelbase4objc.type_attribute_primitive(attr)>
  <#if attrtype == "NSString*">
  val = [${objc.nameType(app.name)}SQL escapeString:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} andVar:-1];
  <#elseif attrtype == "NSInteger">
  val = [${objc.nameType(app.name)}SQL escapeInteger:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}];
  </#if>
  ret = [ret stringByAppendingFormat:@"and ${attr.persistenceName} = %@", val];
</#list>  
  return ret;
}

+ (NSString*)getSelectSQL:(${objc.nameType(obj.name)}Query*)${objc.nameVariable(obj.name)} {
  NSString* sql = @"select ";
<#list obj.attributes as attr> 
  <#if !attr.persistenceName??><#continue></#if>
  sql = [sql stringByAppendingString:@"${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} ${modelbase.get_attribute_sql_name(attr)},"];
</#list>    
  sql = [sql stringByAppendingString:@"0 "];
  sql = [sql stringByAppendingString:@"from ${obj.persistenceName} ${modelbase.get_object_sql_alias(obj)} "];
  sql = [sql stringByAppendingString:@"where 1 = 1 "];
<#list obj.attributes as attr>
  <#assign attrtype = modelbase4objc.type_attribute_primitive(attr)>
  <#if attrtype == "NSString*">
  if (${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} != nil && ${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}.length > 0)
  {
    NSString* val = [${objc.nameType(app.name)}SQL escapeString:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} andVar:-1];
    sql = [sql stringByAppendingFormat:@"and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} = %@ ", val];
  }
  if (${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}0 != nil && ${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}0.length > 0)
  {
    NSString* val = [${objc.nameType(app.name)}SQL escapeString:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}0 andVar:0];
    sql = [sql stringByAppendingFormat:@"and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} like %@ ", val];
  }
  if (${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}1 != nil && ${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}1.length > 0)
  {
    NSString* val = [${objc.nameType(app.name)}SQL escapeString:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}1 andVar:1];
    sql = [sql stringByAppendingFormat:@"and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} like %@ ", val];
  }
  <#elseif attrtype == "NSInteger">
  if (${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} != NSIntegerMin)
  {
    NSString* val = [${objc.nameType(app.name)}SQL escapeInteger:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}];
    sql = [sql stringByAppendingFormat:@"and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} = %@ ", val];
  }
  if (${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}0 != NSIntegerMin)
  {
    NSString* val = [${objc.nameType(app.name)}SQL escapeInteger:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}0];
    sql = [sql stringByAppendingFormat:@"and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} > %@ ", val];
  }
  if (${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}1 != NSIntegerMin)
  {
    NSString* val = [${objc.nameType(app.name)}SQL escapeInteger:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}1];
    sql = [sql stringByAppendingFormat:@"and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} < %@ ", val];
  }
  </#if>
  <#if attrtype == "NSString*">
  if (${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}2 != nil && ${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}2.length > 0)
  {
    NSString* val = [${objc.nameType(app.name)}SQL escapeString:${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}2 andVar:2];
    sql = [sql stringByAppendingFormat:@"and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} like %@ ", val];
  }
  </#if>
<#-- 
  if (${objc.nameVariable(obj.name)}.${modelbase4objc.name_attribute_as_primitive_plural(attr)} != nil)
  {
    NSString* in = [${namespace!""}${objc.nameType(app.name)}SQL str2in:_${modelbase4objc.name_attribute_as_primitive_plural(attr)}];
    sql = [sql stringByAppendingString:@"and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} in ("];
    sql = [sql stringByAppendingString:in];
    sql = [sql stringByAppendingString:@")"];
  }
-->  
</#list>  
  return sql;
}

@end