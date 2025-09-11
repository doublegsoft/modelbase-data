<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import <Foundation/Foundation.h>

/*!
** 基础查询对象.
*/
@interface BaseQuery : NSObject

/*!
** 起始序号。
*/
- (NSInteger)start;
- (void)setStart:(NSInteger)newStart;

/*!
** 当前数据。
*/
- (NSInteger)limit;
- (void)setLimit:(NSInteger)newLimit;

@end
