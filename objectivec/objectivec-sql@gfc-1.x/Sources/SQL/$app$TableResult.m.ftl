<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import "${namespace!""}${objc.nameType(app.name)}TableResult.h"
/*!
** 查询结果对象.
*/
@interface ${namespace!""}${objc.nameType(app.name)}TableResult() {

  NSInteger columnCount;

  NSMutableArray<NSString*>* titles;

  NSMutableArray<NSNumber*>* types;

  NSMutableArray<NSMutableArray<NSObject*>*>* values;
}
@end

@implementation ${namespace!""}${objc.nameType(app.name)}TableResult

- (instancetype)initWithColumnCount:(NSInteger)columnCount {
  self = [super init];
  if (self) {
    self->columnCount = columnCount;
    self->titles = [[NSMutableArray alloc] init];
    self->types = [[NSMutableArray alloc] init];
    self->values = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self->columnCount; i++) {
      [self->titles addObject:@""];
      [self->types addObject:@(0)];
    }
  }
  return self;
}

- (NSString*)getColumnTitleAtIndex:(NSInteger)index {
  if (index >= self->columnCount) {
    return nil;;
  }
  return self->titles[index];
}

- (void)setColumnTitle:(NSString*)title atIndex:(NSInteger)index {
  if (index >= self->columnCount) {
    return;
  }
  [self->titles replaceObjectAtIndex:index withObject:title];
}

- (NSNumber*)getColumnTypeAtIndex:(NSInteger)index {
  if (index >= self->columnCount) {
    return nil;
  }
  return self->types[index];
}

- (void)setColumnType:(NSNumber*)type atIndex:(NSInteger)index {
  if (index >= self->columnCount) {
    return;
  }
  [self->types replaceObjectAtIndex:index withObject:type];
}

- (NSObject*)getValueAtRow:(NSInteger)row andColumn:(NSInteger)col {
  if (col >= self->columnCount) {
    return nil;
  }
  NSUInteger count = [self->values count];
  if (row == count) {
    return nil;
  }
  NSMutableArray* oldArray = self->values[row];
  return oldArray[col];
}

- (void)setValue:(NSObject*)value atRow:(NSInteger)row andColumn:(NSInteger)col {
  NSUInteger count = [self->values count];
  if (row == count) {
    NSMutableArray* newArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self->columnCount; i++) {
      [newArray addObject:@""];
    }
    [self->values addObject:newArray];
    [newArray replaceObjectAtIndex:col withObject:value];
  } else if (row < count) {
    NSMutableArray* oldArray = self->values[row];
    if (value != nil) {
      [oldArray replaceObjectAtIndex:col withObject:value];
    }
  } else {
    // 抛出错误
  }
}

- (NSInteger)getCount {
  if (self->values == nil) {
    return 0;
  }
  return [self->values count];
}

@end