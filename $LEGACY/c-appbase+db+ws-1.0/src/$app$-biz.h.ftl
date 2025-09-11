<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${namespace?upper_case}_BIZ_H__
#define __${namespace?upper_case}_BIZ_H__

#include <ws.h>
#include <json.h>

#ifdef __cplusplus
extern "C" {
#endif

<#assign maxOpLen = 0>
<#list model.objects as obj>
  <#if !obj.isLabelled("request")><#continue></#if>
  <#assign op = obj.name?replace('_request', '')>
  <#if (op?length > maxOpLen)>
    <#assign maxOpLen = op?length>
  </#if>
</#list>    
#define OP_ERROR${""?left_pad(maxOpLen)}"error"
<#list model.objects as obj>
  <#if !obj.isLabelled("request")><#continue></#if>
  <#assign op = obj.name?replace('_request', '')>
#define OP_${op?upper_case}${""?left_pad(maxOpLen - op?length + 5)}"${js.nameVariable(op)}"
</#list>  

/*!
** 发送错误信息给客户端。
*/
void
${namespace}_biz_error(ws_cli_conn_t*   client,
${""?left_pad(namespace?length + 11)}const char*      op,
${""?left_pad(namespace?length + 11)}int              error,
${""?left_pad(namespace?length + 11)}const char*      message);

/*!
** 发送成功信息给客户端。
*/
void
${namespace}_biz_success(ws_cli_conn_t* client,
${""?left_pad(namespace?length + 13)}const char*      op);
<#list model.objects as obj>
  <#if !obj.isLabelled('request')><#continue></#if>
  <#assign operation = obj.name?replace('_request', '')>

/*!
** ${modelbase.get_object_label(obj)?replace('请求', '')}。
*/
void
${namespace}_biz_${operation}(ws_cli_conn_t* client,
${""?left_pad(namespace?length + operation?length + 6)}json_object* payload);
</#list>

#ifdef __cplusplus
}
#endif

#endif // __${namespace?upper_case}_BIZ_H__