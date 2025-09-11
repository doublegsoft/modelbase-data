<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import "${namespace!""}${objc.nameType(app.name)}SQL.h"

@implementation ${namespace!""}${objc.nameType(app.name)}SQL

+ (NSString*)escapeArray:(NSString*)str {
  NSString* ret = @"";
  NSArray<NSString *>* components = [str componentsSeparatedByString:@","];
  for (NSString* component in components) {
    if (![ret isEqualToString:@""]) {
      ret = [ret stringByAppendingString:@","];
    }
    ret = [ret stringByAppendingString:@"'"];
    ret = [ret stringByAppendingString:component];
    ret = [ret stringByAppendingString:@"'"];
  }
  return ret;
}

+ (NSString*)escapeInteger:(NSInteger)number {
  if (number == NSIntegerMin) {
    return @"null";
  }
  return [NSString stringWithFormat:@"%ld", number];
}

+ (NSString*)escapeString:(NSString*)str andVar:(NSInteger)var {
  if (str == nil) {
    return @"null";
  }
  NSString* escapedStr = [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
  if (var == 0) {
    return [NSString stringWithFormat:@"'%@%%'", escapedStr];
  } else if (var == 1) {
    return [NSString stringWithFormat:@"'%%%@'", escapedStr];
  } else if (var == 2) {
    return [NSString stringWithFormat:@"'%%%@%%'", escapedStr];
  }
  return [NSString stringWithFormat:@"'%@'", escapedStr];
}

+ (NSString*)escapeDate:(NSDate*)date {
  if (date == nil) {
    return @"null";
  }
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  return [NSString stringWithFormat:@"'%@'", [formatter stringFromDate:date]];
}

+ (NSString*)escapeDecimal:(NSDecimalNumber*)number {
  if (number == nil) {
    return @"null";
  }
  return [number stringValue];
}

+ (NSString*)escapeBool:(BOOL)flag {
  if (flag == YES) {
    return @"'T'";
  } else {
    return @"'F'";
  }
}


@end