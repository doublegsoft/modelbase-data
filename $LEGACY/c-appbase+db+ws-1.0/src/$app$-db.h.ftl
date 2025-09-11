<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${namespace?upper_case}_DB_H__
#define __${namespace?upper_case}_DB_H__

#include <stdlib.h>
#include <json.h>
#include <gfc.h>

#include "${namespace}-err.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct  ${namespace}_db_s   ${namespace}_db_t;
typedef         ${namespace}_db_t*  ${namespace}_db_p;

/*!
** 打开一个数据库连接。
**
** @param address
**        数据库地址
**
** @param port
**        数据库端口
**
** @param username
**        用户名
**
** @param password
**        密码
**
** @param dbname
**        数据库名称
**
** @param max_connections
**        最大连接数
**
** @return 0为成功，非0为错误代码
*/
int
${namespace}_db_create(${namespace}_db_p*         pdb,
${""?left_pad(namespace?length + 11)}const char*  address, 
${""?left_pad(namespace?length + 11)}int          port, 
${""?left_pad(namespace?length + 11)}const char*  username, 
${""?left_pad(namespace?length + 11)}const char*  password,
${""?left_pad(namespace?length + 11)}const char*  dbname,
${""?left_pad(namespace?length + 11)}int          max_connections);

/*!
** 获取一个数据库连接。
**
** @param db
**        数据库连接池实例
*/
void*
${namespace}_db_connect(${namespace}_db_p db);                     

/*!
** 释放数据库连接给连接池。
**
** @param conn
**        数据库连接
*/
void
${namespace}_db_release(${namespace}_db_p db, 
${""?left_pad(namespace?length + 12)}void* conn);

/*!
** 销毁数据库连接池，回收内存资源。
*/
void
${namespace}_db_destroy(${namespace}_db_p db);

/*!
** 查询返回多条数据。
*/
int
${namespace}_db_many(void*         conn_inst,
${""?left_pad(namespace?length + 9)}char*         errmsg,
${""?left_pad(namespace?length + 9)}gfc_list_p    holder,
${""?left_pad(namespace?length + 9)}const char*   sql);

#ifdef __cplusplus
}
#endif

#endif // __${namespace?upper_case}_DB_H__