<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import <Foundation/Foundation.h>

#define ${namespace?upper_case}_SQL_ERROR_SUCCESS                             0
#define ${namespace?upper_case}_SQL_ERROR_PRIMARY_KEY_NOT_FOUND               401101
#define ${namespace?upper_case}_SQL_ERROR_NO_COLUMN_UPDATE                    401102
#define ${namespace?upper_case}_SQL_ERROR_NO_OBJECT_SPECIFIED                 402101

@interface ${namespace!""}${objc.nameType(app.name)}SQL : NSObject

+ (NSString*)escapeArray:(NSString*)str;

+ (NSString*)escapeInteger:(NSInteger)number;

+ (NSString*)escapeString:(NSString*)str andVar:(NSInteger)var;

+ (NSString*)escapeDate:(NSDate*)date;

+ (NSString*)escapeDecimal:(NSDecimalNumber*)number;

+ (NSString*)escapeBool:(BOOL)flag;


@end