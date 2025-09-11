<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import <Foundation/Foundation.h>
/*!
** 查询结果对象.
*/
@interface ${namespace!""}${objc.nameType(app.name)}TableResult : NSObject

/*!
**
*/
- (instancetype)initWithColumnCount:(NSInteger)columnCount;

/*!
**
*/
- (NSString*)getColumnTitleAtIndex:(NSInteger)index;

/*!
**
*/
- (void)setColumnTitle:(NSString*)title atIndex:(NSInteger)index;

/*!
**
*/
- (NSNumber*)getColumnTypeAtIndex:(NSInteger)index;

/*!
**
*/
- (void)setColumnType:(NSNumber*)type atIndex:(NSInteger)index;

/*!
**
*/
- (NSObject*)getValueAtRow:(NSInteger)row andColumn:(NSInteger)col;

/*!
**
*/
- (void)setValue:(NSObject*)value atRow:(NSInteger)row andColumn:(NSInteger)col;

/*!
**
*/
- (NSInteger)getCount;

@end