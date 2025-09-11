<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import <Foundation/Foundation.h>

#import "${namespace!""}${objc.nameType(obj.name)}JSON.h"
<#list obj.attributes as attr>
  <#if !attr.type.custom><#continue></#if>
  <#list model.objects as objInModel>
    <#if attr.type.name == objInModel.name>
#import "${namespace!""}${objc.nameType(objInModel.name)}JSON.h"
      <#break>
    </#if>
  </#list>
</#list>

/*!
** 【${modelbase.get_object_label(obj)}】对象.
*/
@implementation ${namespace!""}${objc.nameType(obj.name)}JSON

+ (NSString*)serializeWithObject:(${namespace!""}${objc.nameType(obj.name)}*)obj ifError:(NSError**)error {
  NSDictionary* dictionary = [${namespace!""}${objc.nameType(obj.name)}JSON serializeToDictionary:obj];
  NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:error];

  if (error != nil) {
    return nil;
  }
  return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary*)serializeToDictionary:(${namespace!""}${objc.nameType(obj.name)}*)obj {
  return nil;
}

+ (${namespace!""}${objc.nameType(obj.name)}*)deserializeWithJson:(NSString*)json ifError:(NSError**)error {
  NSData* jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:error];
  if (error != nil) {
    return nil;
  }
  return [${namespace!""}${objc.nameType(obj.name)}JSON deserializeWithDictionary:dictionary];
}

+ (${namespace!""}${objc.nameType(obj.name)}*)deserializeWithDictionary:(NSDictionary*)dict {
  ${namespace!""}${objc.nameType(obj.name)}* ret = [[${namespace!""}${objc.nameType(obj.name)} alloc] init];
  return ret;
}

@end