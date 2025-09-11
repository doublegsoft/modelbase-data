<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import "DB/${modelbase4objc.type_application(app)}SQLiteDatabase.h"

int main() {
  @autoreleasepool {
    NSError* error;
    ${modelbase4objc.type_application(app)}SQLiteDatabase* sqlite = [[${namespace!""}${objc.nameType(app.name)}SQLiteDatabase alloc] initWithPath:@"./test.db"];
<#list model.objects as obj>
    error = nil;
    [sqlite createTable${objc.nameType(obj.name)}:&error];
    if (error != nil) {
      NSLog(@"error: %@", error.localizedDescription);
    }
</#list>

    /*!
    ** 准备数据
    */    
<#list model.objects as obj>
    ${modelbase4objc.type_object(obj)}Query* ${objc.nameVariable(obj.name)} = [[${namespace!""}${objc.nameType(obj.name)}Query alloc] init];
  <#list obj.attributes as attr>
    <#if attr.type.custom>
    ${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} = @"0";
    <#elseif attr.constraint.identifiable>
    <#elseif attr.type.name == "bool">
    ${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} = @"T";
    <#elseif attr.type.name == "int" || attr.type.name == "integer">
    ${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} = @"0";
    <#else>
    ${objc.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)} = @"0";
    </#if>
  </#list> 
</#list>

    /*!
    ** 插入操作
    */
<#list model.objects as obj>
    error = nil;
    [sqlite insert${objc.nameType(obj.name)}:${objc.nameVariable(obj.name)} ifError:&error];
    if (error != nil) {
      NSLog(@"error (%ld): %@", error.code, error.localizedDescription);
    }
</#list>

    /*!
    ** 更新操作
    */
<#list model.objects as obj>
    error = nil;
    [sqlite update${objc.nameType(obj.name)}:${objc.nameVariable(obj.name)} ifError:&error];
    if (error != nil) {
      NSLog(@"error (%ld): %@", error.code, error.localizedDescription);
    }
</#list>

    /*!
    ** 删除操作
    */
<#list model.objects as obj>
    error = nil;
    [sqlite delete${objc.nameType(obj.name)}:${objc.nameVariable(obj.name)} ifError:&error];
    if (error != nil) {
      NSLog(@"error (%ld): %@", error.code, error.localizedDescription);
    }
</#list>
  } // @autoreleasepool
  return 0;
}