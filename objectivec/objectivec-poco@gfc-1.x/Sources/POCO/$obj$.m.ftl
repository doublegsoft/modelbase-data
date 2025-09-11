<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import "${namespace!""}${objc.nameType(obj.name)}.h"

/*!
** 【${modelbase.get_object_label(obj)}】对象.
*/
@interface ${namespace!""}${objc.nameType(obj.name)}() {
<#list obj.attributes as attr>
  <#assign attrtype = modelbase4objc.type_attribute(attr)>

  /*!
  ** 【${modelbase.get_attribute_label(attr)}】属性.
  */
  ${attrtype} _${objc.nameVariable(attr.name)};
</#list>
}
@end

@implementation ${namespace!""}${objc.nameType(obj.name)}

- (instancetype)init {
  self = [super init];
  if (self) {
<#list obj.attributes as attr>
  <#if attr.type.componentType??>
    <#assign refObj = model.findObjectByName(attr.type.componentType.name)>
    self.${objc.nameVariable(attr.name)} = [[NSMutableArray alloc] init];
  </#if>
</#list>    
  }
  return self;
}

<#list obj.attributes as attr>
  <#assign attrtype = modelbase4objc.type_attribute(attr)>

/*!
** 【${modelbase.get_attribute_label(attr)}】属性.
*/
- (${attrtype})${objc.nameVariable(attr.name)} {
  return _${objc.nameVariable(attr.name)};
}
- (void)set${objc.nameType(attr.name)}:(${attrtype})new${objc.nameType(attr.name)} {
  _${objc.nameVariable(attr.name)} = new${objc.nameType(attr.name)};
}
</#list>

@end