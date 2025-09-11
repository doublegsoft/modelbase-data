<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import "Pagination.h"

/*!
** 分页对象.
*/
@implementation Pagination {

  NSInteger _total;
  
  NSArray* _data;

}

- (NSInteger)total {
  return _total;
}
- (void)setTotal:(NSInteger)newTotal {
  _total = newTotal;
}

- (NSArray*)data {
  return _data;
}
- (void)setData:(NSArray*)newData {
  _data = newData;
}

@end
