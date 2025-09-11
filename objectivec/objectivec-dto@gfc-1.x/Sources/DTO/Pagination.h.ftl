<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import <Foundation/Foundation.h>

/*!
** 分页对象.
*/
@interface Pagination : NSObject

/*!
** 总共条数。
*/
- (NSInteger)total;
- (void)setTotal:(NSInteger)newTotal;

/*!
** 当前数据。
*/
- (NSArray*)data;
- (void)setData:(NSArray*)newData;

@end
