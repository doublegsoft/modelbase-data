<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import <Foundation/Foundation.h>

#import "${objc.nameType(app.name)}SQL.h"
#import "POCO/${objc.nameType(obj.name)}.h"
#import "DTO/${objc.nameType(obj.name)}Query.h"

@interface ${namespace!""}${objc.nameType(obj.name)}SQL : NSObject

/*!
** 获取插入语句。
*/
+ (NSString*)getInsertSQL:(${objc.nameType(obj.name)}Query*)${objc.nameVariable(obj.name)};

/*!
** 获取更新语句。
*/
+ (NSString*)getUpdateSQL:(${objc.nameType(obj.name)}Query*)${objc.nameVariable(obj.name)};

/*!
** 获取删除语句。
*/
+ (NSString*)getDeleteSQL:(${objc.nameType(obj.name)}Query*)${objc.nameVariable(obj.name)};

/*!
** 获取查询语句。
*/
+ (NSString*)getSelectSQL:(${objc.nameType(obj.name)}Query*)${objc.nameVariable(obj.name)};

@end