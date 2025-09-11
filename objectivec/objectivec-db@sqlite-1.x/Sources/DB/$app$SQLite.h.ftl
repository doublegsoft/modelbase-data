<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/modelbase4objc.ftl' as modelbase4objc>
<#if license??>
${objc.license(license)}
</#if>
<#list model.objects as obj>
#import "DTO/${objc.nameType(obj.name)}Query.h"
</#list>
#import "DTO/Pagination.h"

@interface ${objc.nameType(app.name)}SQLite : NSObject

+ (${objc.nameType(app.name)}SQLite*)sharedInstance;

/*!
** 初始化【${app.name}】数据库。
*/
- (instancetype)initWithPath:(NSString*)path;

/*!
** 执行【${app.name}】数据库建库脚本。
*/
- (void)installDatabase;

- (void)beginTransaction;

- (void)commit;

- (void)rollback;
<#list model.objects as obj>

/*!
** 插入【${modelbase.get_object_label(obj)}】数据。
*/
- (void)insert${objc.nameType(obj.name)}:(${objc.nameType(obj.name)}Query*)data ifError:(NSError**)error;

/*!
** 更新【${modelbase.get_object_label(obj)}】数据。
*/
- (void)update${objc.nameType(obj.name)}:(${objc.nameType(obj.name)}Query*)data ifError:(NSError**)error;

/*!
** 删除【${modelbase.get_object_label(obj)}】数据。
*/
- (void)delete${objc.nameType(obj.name)}:(${objc.nameType(obj.name)}Query*)data ifError:(NSError**)error;

/*!
** 查询【${modelbase.get_object_label(obj)}】数据。
*/
- (Pagination*)select${objc.nameType(obj.name)}:(${objc.nameType(obj.name)}Query*)data ifError:(NSError**)error;

/*!
** 创建【${modelbase.get_object_label(obj)}】表结构。
*/
- (void)createTable${objc.nameType(obj.name)}:(NSError**)error;
</#list>
@end