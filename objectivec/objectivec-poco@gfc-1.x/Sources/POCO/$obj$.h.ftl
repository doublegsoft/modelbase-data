<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import <Foundation/Foundation.h>

<#list obj.attributes as attr>
  <#if !attr.type.custom><#continue></#if>
  <#list model.objects as objInModel>
    <#if attr.type.name == objInModel.name>
#import "${namespace!""}${objc.nameType(objInModel.name)}.h"
      <#break>
    </#if>
  </#list>
</#list>
/*!
** 【${modelbase.get_object_label(obj)}】对象.
*/
@interface ${namespace!""}${objc.nameType(obj.name)} : NSObject
<#list obj.attributes as attr>
  <#assign attrtype = modelbase4objc.type_attribute(attr)>

/*!
** 【${modelbase.get_attribute_label(attr)}】属性.
*/
- (${attrtype})${objc.nameVariable(attr.name)};
- (void)set${objc.nameType(attr.name)}:(${attrtype})new${objc.nameType(attr.name)};
</#list>

- (instancetype)init;
@end