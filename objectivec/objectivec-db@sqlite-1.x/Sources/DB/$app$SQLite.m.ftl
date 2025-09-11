<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
#import <SQLite/sqlite3.h>
#import "${namespace!""}${objc.nameType(app.name)}SQLite.h"
#import "SQL/${namespace!""}${objc.nameType(app.name)}SQL.h"

@interface ${namespace!""}${objc.nameType(app.name)}SQLite() {
  sqlite3*          db;
}
@end

@implementation ${objc.nameType(app.name)}SQLite

+ (${objc.nameType(app.name)}SQLite*)sharedInstance {
   static ${objc.nameType(app.name)}SQLite *sharedInstance = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) {
      NSString* path = paths.firstObject;
      path = [path stringByAppendingString:@"/mm.db"];
      sharedInstance = [[self alloc] initWithPath:path];
    }
   });
   return sharedInstance;
 }

- (instancetype)initWithPath:(NSString*)path {
  assert(sqlite3_threadsafe());
  self = [super init];
  int rc = sqlite3_open([path UTF8String], &db);
  if (rc != SQLITE_OK) {
    NSLog(@"%@", [NSString stringWithFormat:@"error to open database (%d): %@", rc, path]);
  }
  return self;
}

- (void)installDatabase {
  NSError* error;
<#list model.objects as obj>
  [self createTable${objc.nameType(obj.name)}:&error];
</#list>  
}

- (void)beginTransaction {
  char* errMsg = NULL;
  sqlite3_exec(db, "BEGIN TRANSACTION", 0, 0, &errMsg);
}

- (void)commit {
  char* errMsg = NULL;
  sqlite3_exec(db, "COMMIT TRANSACTION", 0, 0, &errMsg);
}

- (void)rollback {
  char* errMsg = NULL;
  sqlite3_exec(db, "ROLLBACK TRANSACTION", 0, 0, &errMsg);
}
<#list model.objects as obj>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  <#assign idAttr = idAttrs[0]>

/*!
** 插入【${modelbase.get_object_label(obj)}】数据。
*/
- (void)insert${objc.nameType(obj.name)}:(${namespace!""}${objc.nameType(obj.name)}Query*)data ifError:(NSError**)error {
  NSString* sql = @"insert into ${obj.persistenceName} (<#list obj.attributes as attr><#if !attr.persistenceName??><#continue></#if><#if attr?index != 0>,</#if>${attr.persistenceName}</#list>)";
  sql = [sql stringByAppendingString:@"values (<#list obj.attributes as attr><#if attr?index != 0>,</#if>?</#list>);"];
  sqlite3_stmt*         stmt;
  int rc = ${namespace?upper_case}_SQL_ERROR_SUCCESS;
  
  rc = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, 0);                         
  if (rc)
  {
    NSString* errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(db)];
    NSDictionary* userInfo = @{NSLocalizedDescriptionKey: errorMessage};
    *error = [NSError errorWithDomain:@"${app.name}"
                                 code:rc
                             userInfo:userInfo];
    return;
  } 
  
  <#list obj.attributes as attr>
    <#if !attr.persistenceName??><#continue></#if>
    <#assign attrtype = modelbase4objc.type_attribute_primitive(attr)>
    <#if attrtype == "NSString*">
  if (data.${modelbase.get_attribute_sql_name(attr)} == nil) {  
    sqlite3_bind_null(stmt, ${attr?index + 1});
  } else {
    sqlite3_bind_text(stmt, ${attr?index + 1}, [data.${modelbase.get_attribute_sql_name(attr)} UTF8String], -1, SQLITE_STATIC);
  }
    <#elseif attrtype == "NSDate*">
  if (data.${modelbase.get_attribute_sql_name(attr)} == nil) { 
    sqlite3_bind_null(stmt, ${attr?index + 1}); 
  } else {  
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    sqlite3_bind_text(stmt, ${attr?index + 1}, [[formatter stringFromDate:data.${modelbase.get_attribute_sql_name(attr)}] UTF8String], -1, SQLITE_STATIC);
  }
    <#elseif attrtype == "NSDecimalNumber*">
  if (data.${modelbase.get_attribute_sql_name(attr)} == nil) {    
    sqlite3_bind_null(stmt, ${attr?index + 1});
  } else {
    sqlite3_bind_text(stmt, ${attr?index + 1}, [[data.${modelbase.get_attribute_sql_name(attr)} stringValue] UTF8String], -1, SQLITE_STATIC);
  }
    <#elseif attrtype == "NSInteger">
  if (data.${modelbase.get_attribute_sql_name(attr)} == NSIntegerMin) {
    sqlite3_bind_null(stmt, ${attr?index + 1});
  } else {  
    sqlite3_bind_int64(stmt, ${attr?index + 1}, data.${modelbase.get_attribute_sql_name(attr)});    
  } 
    <#elseif attrtype == "BOOL">
  if (data.${modelbase.get_attribute_sql_name(attr)} == YES) {
    sqlite3_bind_text(stmt, ${attr?index + 1}, [@"T" UTF8String], -1, SQLITE_STATIC);     
  } else {
    sqlite3_bind_text(stmt, ${attr?index + 1}, [@"F" UTF8String], -1, SQLITE_STATIC);     
  }
    </#if>
  </#list>

  rc = sqlite3_step(stmt);
  if (rc && rc != SQLITE_DONE)
  {
    NSString* errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(db)];
    NSDictionary* userInfo = @{NSLocalizedDescriptionKey: errorMessage};
    *error = [NSError errorWithDomain:@"${app.name}"
                                 code:rc
                             userInfo:userInfo];
  }
  sqlite3_finalize(stmt);
}

/*!
** 更新【${modelbase.get_object_label(obj)}】数据。
*/
- (void)update${objc.nameType(obj.name)}:(${namespace!""}${objc.nameType(obj.name)}Query*)data ifError:(NSError**)error {
  int updateColumnCount = 0;
  int primaryKeyCount = 0;
  int paramIndex = 0;
  NSString* sql = @"update ${obj.persistenceName} set ";
  sqlite3_stmt*         stmt;
  int rc = ${namespace?upper_case}_SQL_ERROR_SUCCESS;

  <#list obj.attributes as attr>
    <#if !attr.persistenceName??><#continue></#if>
    <#if attr.constraint.identifiable><#continue></#if>
    <#assign attrtype = modelbase4objc.type_attribute_primitive(attr)>
    <#if attrtype == "NSInteger">
  if (data.${modelbase.get_attribute_sql_name(attr)} != NSIntegerMin) {  
    <#else>
  if (data.${modelbase.get_attribute_sql_name(attr)} != nil) {  
    </#if>
    if (updateColumnCount > 0) {
      sql = [sql stringByAppendingString:@","];
    }
    sql = [sql stringByAppendingString:@"${attr.persistenceName} = ? "];
    updateColumnCount++;
  }  
  </#list>  

  if (updateColumnCount == 0) {
    NSString* errorMessage = @"no column found to update";
    NSDictionary* userInfo = @{NSLocalizedDescriptionKey: errorMessage};
    *error = [NSError errorWithDomain:@"${app.name}"
                                 code:${namespace?upper_case}_SQL_ERROR_NO_COLUMN_UPDATE
                             userInfo:userInfo];
    return;
  }

  sql = [sql stringByAppendingString:@"where 1 = 1 "];

  <#list idAttrs as idAttr>
    <#assign attrtype = modelbase4objc.type_attribute_primitive(idAttr)>
    <#if attrtype == "NSInteger">
  if (data.${modelbase.get_attribute_sql_name(idAttr)} != NSIntegerMin) {  
    <#else>
  if (data.${modelbase4objc.name_attribute_as_primitive(idAttr)} != nil) {
    </#if>
    sql = [sql stringByAppendingString:@"and ${idAttr.persistenceName} = ? "];
    primaryKeyCount++;
  }
  </#list>
  if (primaryKeyCount == 0) {
    NSString* errorMessage = @"no primary key found";
    NSDictionary* userInfo = @{NSLocalizedDescriptionKey: errorMessage};
    *error = [NSError errorWithDomain:@"${app.name}"
                                 code:${namespace?upper_case}_SQL_ERROR_PRIMARY_KEY_NOT_FOUND 
                             userInfo:userInfo];
    return;
  }
  
  rc = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, 0);                         
  if (rc)
  {
    NSString* errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(db)];
    NSDictionary* userInfo = @{NSLocalizedDescriptionKey: errorMessage};
    *error = [NSError errorWithDomain:@"${app.name}"
                                 code:rc
                             userInfo:userInfo];
    return;
  } 

  <#list obj.attributes as attr>
    <#if !attr.persistenceName??><#continue></#if>
    <#if attr.constraint.identifiable><#continue></#if>
    <#assign attrtype = modelbase4objc.type_attribute_primitive(attr)>
  <#if attrtype == "NSString*">
  if (data.${modelbase.get_attribute_sql_name(attr)} == nil) {  
    sqlite3_bind_null(stmt, ${attr?index + 1});
  } else {
    sqlite3_bind_text(stmt, ${attr?index + 1}, [data.${modelbase.get_attribute_sql_name(attr)} UTF8String], -1, SQLITE_STATIC);
  }
  paramIndex++;
    <#elseif attrtype == "NSDate*">
  if (data.${modelbase.get_attribute_sql_name(attr)} == nil) { 
    sqlite3_bind_null(stmt, ${attr?index + 1}); 
  } else {  
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    sqlite3_bind_text(stmt, ${attr?index + 1}, [[formatter stringFromDate:data.${modelbase.get_attribute_sql_name(attr)}] UTF8String], -1, SQLITE_STATIC);
  }
  paramIndex++;
    <#elseif attrtype == "NSDecimalNumber*">
  if (data.${modelbase.get_attribute_sql_name(attr)} == nil) {    
    sqlite3_bind_null(stmt, ${attr?index + 1});
  } else {
    sqlite3_bind_text(stmt, ${attr?index + 1}, [[data.${modelbase.get_attribute_sql_name(attr)} stringValue] UTF8String], -1, SQLITE_STATIC);
  }
  paramIndex++;
    <#elseif attrtype == "NSInteger">
  if (data.${modelbase.get_attribute_sql_name(attr)} == NSIntegerMin) {
    sqlite3_bind_null(stmt, ${attr?index + 1});
  } else {  
    sqlite3_bind_int64(stmt, ${attr?index + 1}, data.${modelbase.get_attribute_sql_name(attr)});    
  } 
  paramIndex++;
    <#elseif attrtype == "BOOL">
  if (data.${modelbase.get_attribute_sql_name(attr)} == YES) {
    sqlite3_bind_text(stmt, ${attr?index + 1}, [@"T" UTF8String], -1, SQLITE_STATIC);     
  } else {
    sqlite3_bind_text(stmt, ${attr?index + 1}, [@"F" UTF8String], -1, SQLITE_STATIC);     
  }
  paramIndex++;
    </#if>
  </#list>  
  <#list idAttrs as idAttr>
    <#assign attrtype = modelbase4objc.type_attribute_primitive(idAttr)>
    <#if attrtype == "NSInteger">
  if (data.${modelbase.get_attribute_sql_name(idAttr)} != NSIntegerMin) {  
    sqlite3_bind_int64(stmt, paramIndex + 1, data.${modelbase4objc.name_attribute_as_primitive(idAttr)});
    <#else>
  if (data.${modelbase4objc.name_attribute_as_primitive(idAttr)} != nil) {
    sqlite3_bind_text(stmt, paramIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(idAttr)} UTF8String], -1, SQLITE_STATIC);   
    </#if>
    paramIndex++;
  }
  </#list>

  rc = sqlite3_step(stmt);
  if (rc && rc != SQLITE_DONE)
  {
    NSString* errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(db)];
    NSDictionary* userInfo = @{NSLocalizedDescriptionKey: errorMessage};
    *error = [NSError errorWithDomain:@"${app.name}"
                                 code:rc
                             userInfo:userInfo];
  }
  sqlite3_finalize(stmt);
}

/*!
** 删除【${modelbase.get_object_label(obj)}】数据。
*/
- (void)delete${objc.nameType(obj.name)}:(${namespace!""}${objc.nameType(obj.name)}Query*)data ifError:(NSError**)error {
  int paramIndex = 0;
  int paramCount = 0;
  NSString* sql = @"delete from ${obj.persistenceName} where 1 = 1 ";
  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable>
    <#assign attrtype = modelbase4objc.type_attribute_primitive(attr)>
    <#if attrtype == "NSInteger">
  if (data.${modelbase.get_attribute_sql_name(idAttr)} != NSIntegerMin) {  
    <#else>
  if (data.${modelbase4objc.name_attribute_as_primitive(attr)} != nil) {
    </#if>
    sql = [sql stringByAppendingString:@"and ${attr.persistenceName} = ? "];
    paramCount++;
  }  
    </#if>
  </#list>  

  if (paramCount == 0) {
    NSString* errorMessage = @"no primary key found";
    NSDictionary* userInfo = @{NSLocalizedDescriptionKey: errorMessage};
    *error = [NSError errorWithDomain:@"${app.name}"
                                 code:${namespace?upper_case}_SQL_ERROR_PRIMARY_KEY_NOT_FOUND
                             userInfo:userInfo];
    return;
  }

  sqlite3_stmt*         stmt;
  int rc = ${namespace?upper_case}_SQL_ERROR_SUCCESS;
  
  rc = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, 0);                         
  if (rc)
  {
    NSString* errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(db)];
    NSDictionary* userInfo = @{NSLocalizedDescriptionKey: errorMessage};
    *error = [NSError errorWithDomain:@"${app.name}"
                                 code:rc
                             userInfo:userInfo];
    return;
  } 
  <#list obj.attributes as attr>
    <#if attr.constraint.identifiable>
    <#assign attrtype = modelbase4objc.type_attribute_primitive(attr)>
    <#if attrtype == "NSInteger">
  if (data.${modelbase.get_attribute_sql_name(idAttr)} != NSIntegerMin) {  
    sqlite3_bind_int64(stmt, paramIndex + 1, data.${modelbase4objc.name_attribute_as_primitive(attr)});
    <#else>
  if (data.${modelbase4objc.name_attribute_as_primitive(attr)} != nil) {
    sqlite3_bind_text(stmt, paramIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)} UTF8String], -1, SQLITE_STATIC);
    </#if>
    paramIndex++;
  }  
    </#if>
  </#list>  
  
  rc = sqlite3_step(stmt);
  if (rc && rc != SQLITE_DONE)
  {
    NSString* errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(db)];
    NSDictionary* userInfo = @{NSLocalizedDescriptionKey: errorMessage};
    *error = [NSError errorWithDomain:@"${app.name}"
                                 code:rc
                             userInfo:userInfo];
  }
  sqlite3_finalize(stmt);
}

/*!
** 查询【${modelbase.get_object_label(obj)}】数据。
*/
- (Pagination*)select${objc.nameType(obj.name)}:(${namespace!""}${objc.nameType(obj.name)}Query*)data ifError:(NSError**)error {
  Pagination* ret = [[Pagination alloc] init];
<#--  
  NSString* sql = [data getSelectSQL];

  sqlite3_stmt*         stmt;
  int rc = ${namespace?upper_case}_SQL_ERROR_SUCCESS;
  
  rc = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, 0);                         
  if (rc)
  {
    NSString* errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(db)];
    NSDictionary* userInfo = @{NSLocalizedDescriptionKey: errorMessage};
    *error = [NSError errorWithDomain:@"${app.name}"
                                 code:rc
                             userInfo:userInfo];
    return ret;
  } 
  int bindIndex = 0;
  int bindCount = sqlite3_bind_parameter_count(stmt);
 
  <#list obj.attributes as attr>
    <#if !attr.persistenceName??><#continue></#if>
    <#if attr.type.custom>
  if (data.${modelbase4objc.name_attribute_as_primitive(attr)} != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)} UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }
  if (data.${modelbase4objc.name_attribute_as_primitive(attr)}0 != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)}0 UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }
  if (data.${modelbase4objc.name_attribute_as_primitive(attr)}1 != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)}1 UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }
  if (data.${modelbase4objc.name_attribute_as_primitive(attr)}2 != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)}2 UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }    
    <#elseif attr.constraint.identifiable>
  if (data.${modelbase4objc.name_attribute_as_primitive(attr)} != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)} UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }
  if (data.${modelbase4objc.name_attribute_as_primitive(attr)}0 != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)}0 UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }
  if (data.${modelbase4objc.name_attribute_as_primitive(attr)}1 != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)}1 UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }
  if (data.${modelbase4objc.name_attribute_as_primitive(attr)}2 != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)}2 UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }  
    <#elseif attr.constraint.domainType.name?starts_with("enum")>
  if (data.${modelbase4objc.name_attribute_as_primitive(attr)} != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)} UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }  
    <#elseif attr.type.name == "string">
  if (data.${modelbase4objc.name_attribute(attr)} != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)} UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }
  if (data.${modelbase4objc.name_attribute(attr)}0 != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)}0 UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }
  if (data.${modelbase4objc.name_attribute(attr)}1 != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)}1 UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }
  if (data.${modelbase4objc.name_attribute(attr)}2 != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)}2 UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }
    <#elseif attr.type.name == "date" || attr.type.name == "datetime" || attr.type.name == "time">
  if (data.${modelbase4objc.name_attribute(attr)} != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)} UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }
  if (data.${modelbase4objc.name_attribute(attr)}0 != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)}0 UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }
  if (data.${modelbase4objc.name_attribute(attr)}1 != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)}1 UTF8String], -1, SQLITE_STATIC);   
    bindIndex++;
  }
    <#elseif attr.type.name == "int" || attr.type.name == "long">
  if (data.${modelbase4objc.name_attribute(attr)} != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)} UTF8String], -1, SQLITE_STATIC);
    bindIndex++;
  }  
  if (data.${modelbase4objc.name_attribute(attr)}0 != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)}0 UTF8String], -1, SQLITE_STATIC);
    bindIndex++;
  }  
  if (data.${modelbase4objc.name_attribute(attr)}1 != nil) 
  {
    sqlite3_bind_text(stmt, bindIndex + 1, [data.${modelbase4objc.name_attribute_as_primitive(attr)}1 UTF8String], -1, SQLITE_STATIC);
    bindIndex++;
  }  
    </#if>
  </#list>    

  rc = sqlite3_step(stmt);

  if (rc == SQLITE_ROW) 
  {
    int columnCount = sqlite3_column_count(stmt);
    int rowIndex = 0;
    ret = [[${namespace!""}${objc.nameType(app.name)}TableResult alloc] initWithColumnCount:columnCount];
    for (int i = 0; i < columnCount; i++) 
    {
      const char* columnName = sqlite3_column_name(stmt, i);
      int columnType = sqlite3_column_type(stmt, i);
      [ret setColumnTitle:[NSString stringWithUTF8String:columnName] atIndex:i];
      [ret setColumnType:[NSNumber numberWithInt:columnType] atIndex:i];
    }
    do 
    {
      for (int i = 0; i < columnCount; i++) 
      {
        int type = [[ret getColumnTypeAtIndex:i] intValue];
        if (type == SQLITE_TEXT)
        {
          const char* value = (const char*)sqlite3_column_text(stmt, i);
          [ret setValue:[NSString stringWithUTF8String:value] atRow:rowIndex andColumn:i];
        }
        else if (type == SQLITE_BLOB)
        {
          // TODO
        }
        else if (type == SQLITE_INTEGER)
        {
          int value = sqlite3_column_int(stmt, i);
          [ret setValue:[NSNumber numberWithInt:value] atRow:rowIndex andColumn:i];
        }
        else if (type == SQLITE_FLOAT)
        {
          float value = sqlite3_column_double(stmt, i);
          [ret setValue:[NSNumber numberWithFloat:value] atRow:rowIndex andColumn:i];
        }
        else if (type == SQLITE_NULL)
        {
          [ret setValue:nil atRow:rowIndex andColumn:i];
        }
      }
      rowIndex++;
    } 
    while (sqlite3_step(stmt) == SQLITE_ROW);
  }
-->
  return ret;
}

/*!
** 创建【${modelbase.get_object_label(obj)}】表结构。
*/
- (void)createTable${objc.nameType(obj.name)}:(NSError**)error {
  NSString* sql = @"";
  <#if obj.persistenceName??>
    <#assign attrIds = []>
    <#assign attrNids = []>
    <#list obj.attributes as attr>
      <#if attr.persistenceName??>
        <#if attr.identifiable>
          <#assign attrIds = attrIds + [attr]>
        <#else>
          <#assign attrNids = attrNids + [attr]>
        </#if>
      </#if>
    </#list>
  sql = [sql stringByAppendingString:@"create table if not exists ${obj.persistenceName} ("];
    <#list attrIds as attr>
      <#assign domaintype = attr.constraint.domainType.name>
      <#assign attrtype = modelbase4objc.type_attribute_primitive(attr)>
      <#assign sqltype = "text">
      <#if attrtype == "NSInteger">
        <#assign sqltype = "integer">
      </#if>  
      <#if domaintype?index_of('&') == 0>
  sql = [sql stringByAppendingString:@"  ${attr.persistenceName?right_pad(24)} ${sqltype?right_pad(24)} not null,"];
      <#else>
  sql = [sql stringByAppendingString:@"  ${attr.persistenceName?right_pad(24)} ${sqltype?right_pad(24)} not null,"];
      </#if>
    </#list>
    <#list attrNids as attr>
      <#assign domaintype = attr.constraint.domainType.toString()>
      <#if domaintype?index_of('&') == 0>
  sql = [sql stringByAppendingString:@"  ${attr.persistenceName?right_pad(24)} text,"];
      <#else>
  sql = [sql stringByAppendingString:@"  ${attr.persistenceName?right_pad(24)} text,"];
      </#if>
    </#list>
  sql = [sql stringByAppendingString:@"  primary key (<#list attrIds as attrId>${attrId.persistenceName}<#if attrId?index != attrIds?size - 1>,</#if></#list>)"];
  sql = [sql stringByAppendingString:@");"];
  </#if>
  int rc = sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL);
  if (rc != SQLITE_OK) {
    NSString* errorMessage = [NSString stringWithUTF8String:sqlite3_errmsg(db)];
    NSDictionary* userInfo = @{NSLocalizedDescriptionKey: errorMessage};
    *error = [NSError errorWithDomain:@"${app.name}"
                                 code:rc
                             userInfo:userInfo];

  }
}
</#list>
@end