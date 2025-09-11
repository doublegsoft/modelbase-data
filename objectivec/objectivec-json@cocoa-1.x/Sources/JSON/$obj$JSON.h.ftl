<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import <Foundation/Foundation.h>

#import "POCO/${namespace!""}${objc.nameType(obj.name)}.h"

/*!
** 【${modelbase.get_object_label(obj)}】对象.
*/
@interface ${namespace!""}${objc.nameType(obj.name)}JSON : NSObject

+ (NSString*)serializeWithObject:(${namespace!""}${objc.nameType(obj.name)}*)obj ifError:(NSError**)error;

+ (NSDictionary*)serializeToDictionary:(${namespace!""}${objc.nameType(obj.name)}*)obj;

+ (${namespace!""}${objc.nameType(obj.name)}*)deserializeWithJson:(NSString*)json ifError:(NSError**)error;

+ (${namespace!""}${objc.nameType(obj.name)}*)deserializeWithDictionary:(NSDictionary*)dict;

@end