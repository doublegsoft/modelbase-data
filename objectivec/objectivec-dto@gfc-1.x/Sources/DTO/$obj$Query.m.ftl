<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import "${namespace!""}${objc.nameType(obj.name)}Query.h"
<#list obj.attributes as attr>
  <#if attr.type.custom>
#import "${namespace!""}${objc.nameType(attr.type.name)}Query.h"  
  </#if>
</#list>

/*!
** 【${modelbase.get_object_label(obj)}】查询对象.
*/
@implementation ${namespace!""}${objc.nameType(obj.name)}Query {
<#list obj.attributes as attr>
  <#assign attrtype = modelbase4objc.type_attribute_primitive(attr)>
  <#if !attr.persistenceName??><#continue></#if>
  /*!
  ** 【${modelbase.get_attribute_label(attr)}】属性.
  */
  ${attrtype} _${modelbase.get_attribute_sql_name(attr)};
  ${attrtype} _${modelbase.get_attribute_sql_name(attr)}0;
  ${attrtype} _${modelbase.get_attribute_sql_name(attr)}1;
<#if attr.type.name == "string" && attrtype == "NSString*">
  ${attrtype} _${modelbase.get_attribute_sql_name(attr)}2;
</#if>
<#if attr.constraint.domainType.name?starts_with("enum") || attr.identifiable || attr.type.custom>
  <#if attrtype == "BOOL" || attrtype == "NSInteger">
  NSMutableArray<NSNumber*>* _${modelbase4objc.name_attribute_as_primitive_plural(attr)}; 
  <#else>
  NSMutableArray<${attrtype}>* _${modelbase4objc.name_attribute_as_primitive_plural(attr)}; 
  </#if>
</#if>
<#if attr.type.custom>
  ${objc.nameType(attr.type.name)}Query* _${objc.nameVariable(attr.name)};
</#if>  
</#list>
}

- (instancetype)init {
  self = [super init];
  if (self) {
<#list obj.attributes as attr>
  <#assign attrtype = modelbase4objc.type_attribute_primitive(attr)>
  <#if attrtype == "NSInteger">
    _${modelbase.get_attribute_sql_name(attr)} = NSIntegerMin;
  <#elseif attrtype == "BOOL">
    _${modelbase.get_attribute_sql_name(attr)} = YES;
  </#if>
</#list>  
  }
  return self;
}
<#list obj.attributes as attr>
  <#assign attrtype = modelbase4objc.type_attribute_primitive(attr)>
  <#if !attr.persistenceName??><#continue></#if>

- (${attrtype})${modelbase.get_attribute_sql_name(attr)}{
  return _${modelbase.get_attribute_sql_name(attr)};
}
- (void)set${objc.nameType(modelbase.get_attribute_sql_name(attr))}:(${attrtype})new${objc.nameType(modelbase.get_attribute_sql_name(attr))} {
  _${modelbase.get_attribute_sql_name(attr)} = new${objc.nameType(modelbase.get_attribute_sql_name(attr))};
}
- (${attrtype})${modelbase.get_attribute_sql_name(attr)}0 {
  return _${modelbase.get_attribute_sql_name(attr)}0;
}
- (void)set${objc.nameType(modelbase.get_attribute_sql_name(attr))}0:(${attrtype})new${objc.nameType(modelbase.get_attribute_sql_name(attr))}0 {
  _${modelbase.get_attribute_sql_name(attr)}0 = new${objc.nameType(modelbase.get_attribute_sql_name(attr))}0;
}
- (${attrtype})${modelbase.get_attribute_sql_name(attr)}1 {
  return _${modelbase.get_attribute_sql_name(attr)}1;
}
- (void)set${objc.nameType(modelbase.get_attribute_sql_name(attr))}1:(${attrtype})new${objc.nameType(modelbase.get_attribute_sql_name(attr))}1 {
  _${modelbase.get_attribute_sql_name(attr)}1 = new${objc.nameType(modelbase.get_attribute_sql_name(attr))}1;
}
<#if attr.type.name == "string" && attrtype == "NSString*">
- (${attrtype})${modelbase.get_attribute_sql_name(attr)}2 {
  return _${modelbase.get_attribute_sql_name(attr)}2;
}
- (void)set${objc.nameType(modelbase.get_attribute_sql_name(attr))}2:(${attrtype})new${objc.nameType(modelbase.get_attribute_sql_name(attr))}2 {
  _${modelbase.get_attribute_sql_name(attr)}2 = new${objc.nameType(modelbase.get_attribute_sql_name(attr))}2;
}
</#if>
<#if attr.constraint.domainType.name?starts_with("enum") || attr.identifiable || attr.type.custom>
  <#if attrtype == "BOOL" || attrtype == "NSInteger">
- (NSMutableArray<NSNumber*>*)${modelbase4objc.name_attribute_as_primitive_plural(attr)} {
  return _${modelbase4objc.name_attribute_as_primitive_plural(attr)};
}
- (void)set${objc.nameType(modelbase4objc.name_attribute_as_primitive_plural(attr))}:(NSMutableArray<NSNumber*>*)new${objc.nameType(modelbase4objc.name_attribute_as_primitive_plural(attr))} {
  _${modelbase4objc.name_attribute_as_primitive_plural(attr)} = new${objc.nameType(modelbase4objc.name_attribute_as_primitive_plural(attr))};
}   
  <#else>
- (NSMutableArray<${attrtype}>*)${modelbase4objc.name_attribute_as_primitive_plural(attr)} {
  return _${modelbase4objc.name_attribute_as_primitive_plural(attr)};
}
- (void)set${objc.nameType(modelbase4objc.name_attribute_as_primitive_plural(attr))}:(NSMutableArray<${attrtype}>*)new${objc.nameType(modelbase4objc.name_attribute_as_primitive_plural(attr))} {
  _${modelbase4objc.name_attribute_as_primitive_plural(attr)} = new${objc.nameType(modelbase4objc.name_attribute_as_primitive_plural(attr))};
}  
  </#if>
</#if>
<#if attr.type.custom>
- (${objc.nameType(attr.type.name)}Query*)${objc.nameVariable(attr.name)} {
  return _${objc.nameVariable(attr.name)};
}  
- (void)set${objc.nameType(attr.name)}:(${objc.nameType(attr.type.name)}Query*)new${objc.nameType(attr.name)} {
  _${objc.nameVariable(attr.name)} = new${objc.nameType(objc.nameType(attr.name))};
}
</#if>  
</#list>

@end