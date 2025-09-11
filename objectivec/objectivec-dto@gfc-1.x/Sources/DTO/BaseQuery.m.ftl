<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import "BaseQuery.h"

/*!
** 基础查询对象.
*/
@implementation BaseQuery {

  NSInteger _start;
  
  NSInteger _limit;

}

/*!
** 起始序号。
*/
- (NSInteger)start {
  return _start;
}
- (void)setStart:(NSInteger)newStart {
  _start = newStart;
}

/*!
** 当前数据。
*/
- (NSInteger)limit {
  return _limit;
}
- (void)setLimit:(NSInteger)newLimit {
  _limit = newLimit;
}

@end
