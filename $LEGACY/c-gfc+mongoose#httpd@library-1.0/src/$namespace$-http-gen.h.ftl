<#import '/$/paradigm-internal.ftl' as internal>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${c.nameConstant(namespace)}_HTTP_GEN_H__
#define __${c.nameConstant(namespace)}_HTTP_GEN_H__

#ifdef __cplusplus
extern "C"
{
#endif

#include <json-c/json.h>

#include "mongoose.h"

#include "${namespace}-entity-gen.h"
#include "${namespace}-sql-ext.h"

#include "${namespace}-util.h"

#include "${namespace}-http-base.h"
#include "${namespace}-http-ext.h"

<#list model.objects as obj>
  <#if !obj.isLabelled('entity')><#continue></#if>
static const struct mg_str ${c.nameConstant(namespace)}_API_${c.nameVariable(obj.name)?upper_case}_CREATE  = MG_MK_STR("/api/v1/${c.nameVariable(obj.name)?lower_case}/create");

static const struct mg_str ${c.nameConstant(namespace)}_API_${c.nameVariable(obj.name)?upper_case}_READ    = MG_MK_STR("/api/v1/${c.nameVariable(obj.name)?lower_case}/read");

static const struct mg_str ${c.nameConstant(namespace)}_API_${c.nameVariable(obj.name)?upper_case}_UPDATE  = MG_MK_STR("/api/v1/${c.nameVariable(obj.name)?lower_case}/update");

static const struct mg_str ${c.nameConstant(namespace)}_API_${c.nameVariable(obj.name)?upper_case}_DELETE  = MG_MK_STR("/api/v1/${c.nameVariable(obj.name)?lower_case}/delete");

static const struct mg_str ${c.nameConstant(namespace)}_API_${c.nameVariable(obj.name)?upper_case}_FIND    = MG_MK_STR("/api/v1/${c.nameVariable(obj.name)?lower_case}/find");

</#list>
<#list model.objects as obj>
  <#if !obj.isLabelled('http')><#continue></#if>
  <#list obj.behaviors as bx>
    <#if !bx.isLabelled('http')><#continue></#if>
    <#assign uri = bx.getLabelledOptions('http')['uri']!'/'>
    <#assign method = bx.getLabelledOptions('http')['method']!'get'>
    <#assign sqlId = bx.getLabelledOptions('sql')['id']!'TODO'>
static const struct mg_str ${c.nameConstant(namespace)}_API_${c.nameConstant(uri)}_${c.nameConstant(method)} = MG_MK_STR("/api/v1${uri}");

  </#list>
</#list>

extern int
${c.nameNamespace(namespace)}_http_do(struct mg_connection* conn, struct mg_str* uri, const char* json_params);

<#list model.objects as obj>
  <#if !obj.isLabelled('entity')><#continue></#if>
  <#assign idAttrs = internal.get_id_attributes(obj)>
  <#assign extended = obj.getLabelledOptions('entity')['extend']!>
/*!
** 创建${obj.text!''}.
*/
void
${c.nameNamespace(namespace)}_http_${c.nameVariable(obj.name)?lower_case}_create(struct mg_connection* conn, const char* json_params)
{
  json_object* params = json_tokener_parse(json_params);
  <#list idAttrs as idAttr>
  // 设置${idAttr.text!''}
  char ${c.nameVariable(idAttr.persistenceName)}[37] = {'\0'};
  ${c.nameNamespace(namespace)}_string_id(${c.nameVariable(idAttr.persistenceName)});
  json_object* jso_${c.nameVariable(idAttr.persistenceName)} = json_object_new_string(${c.nameVariable(idAttr.persistenceName)});
  json_object_object_add(params, "${c.nameVariable(idAttr.persistenceName)}", jso_${c.nameVariable(idAttr.persistenceName)});

  </#list>
  <#list obj.attributes as attr>
    <#if attr.type.name == extended>
    <#-- if extension exists, the primary key must be the same. -->
  json_object* jso_${c.nameVariable(attr.persistenceName)} = json_object_new_string(${c.nameVariable(idAttrs[0].persistenceName)});
  json_object_object_add(params, "${c.nameVariable(attr.persistenceName)}", jso_${c.nameVariable(attr.persistenceName)});

  json_object* extended = ${c.nameNamespace(namespace)}_database_execute(database, ${c.nameConstant(namespace)}_SQL_${c.nameVariable(attr.type.name)?upper_case}_CREATE, params);
  json_object_put(extended);

    </#if>
  </#list>
  json_object* result = ${c.nameNamespace(namespace)}_database_execute(database, ${c.nameConstant(namespace)}_SQL_${c.nameVariable(obj.name)?upper_case}_CREATE, params);
  const char* json = json_object_to_json_string(params);
  ${c.nameNamespace(namespace)}_http_ok(conn, json);

  // 减少json object引用，从而资源被释放
  json_object_put(params);
  json_object_put(result);
}

/*!
** 读取${obj.text!''}对象.
*/
void
${c.nameNamespace(namespace)}_http_${c.nameVariable(obj.name)?lower_case}_read(struct mg_connection* conn, const char* json_params)
{
  json_object* params = json_tokener_parse(json_params);
  json_object* result = ${c.nameNamespace(namespace)}_database_query(database, ${c.nameConstant(namespace)}_SQL_${c.nameVariable(obj.name)?upper_case}_FIND, params);
  const char* json = json_object_to_json_string(result);
  ${c.nameNamespace(namespace)}_http_ok(conn, json);

  // 减少json object引用，从而资源被释放
  json_object_put(params);
  json_object_put(result);
}

/*!
** 更新${obj.text!''}对象.
*/
void
${c.nameNamespace(namespace)}_http_${c.nameVariable(obj.name)?lower_case}_update(struct mg_connection* conn, const char* json_params)
{
  json_object* params = json_tokener_parse(json_params);
  json_object* result = ${c.nameNamespace(namespace)}_database_execute(database, ${c.nameConstant(namespace)}_SQL_${c.nameVariable(obj.name)?upper_case}_UPDATE, params);
  ${c.nameNamespace(namespace)}_http_ok(conn, json_object_to_json_string(result));

  // 减少json object引用，从而资源被释放
  json_object_put(params);
  json_object_put(result);
}

/*!
** 删除${obj.text!''}对象.
*/
void
${c.nameNamespace(namespace)}_http_${c.nameVariable(obj.name)?lower_case}_delete(struct mg_connection* conn, const char* json_params)
{
  json_object* params = json_tokener_parse(json_params);
  json_object* result = ${c.nameNamespace(namespace)}_database_execute(database, ${c.nameConstant(namespace)}_SQL_${c.nameVariable(obj.name)?upper_case}_DELETE, params);
  ${c.nameNamespace(namespace)}_http_ok(conn, json_object_to_json_string(result));

  // 减少json object引用，从而资源被释放
  json_object_put(params);
  json_object_put(result);
}

/*!
** 查询${obj.text!''}对象.
*/
void
${c.nameNamespace(namespace)}_http_${c.nameVariable(obj.name)?lower_case}_find(struct mg_connection* conn, const char* json_params)
{
  ${c.nameNamespace(namespace)}_http_${c.nameVariable(obj.name)?lower_case}_read(conn, json_params);
}

</#list>
int
${c.nameNamespace(namespace)}_http_prefix_check(const struct mg_str *uri, const struct mg_str *prefix)
{
  return uri->len >= prefix->len && memcmp(uri->p, prefix->p, prefix->len) == 0;
}

void
${c.nameNamespace(namespace)}_http_event_handle(struct mg_connection* conn,
                     int ev,
                     void* ev_data)
{
  struct http_message *hm = (struct http_message *) ev_data;
  struct mg_str key;

  switch (ev) {
  case MG_EV_HTTP_REQUEST:
    gfc_log_info("url = %s\n", hm->uri.p);
    if (!${c.nameNamespace(namespace)}_http_prefix_check(&hm->method, &${c.nameConstant(namespace)}_HTTP_METHOD_POST))
    {
      mg_serve_http(conn, hm, s_http_server_opts);
      return;
    }

    if (${c.nameNamespace(namespace)}_http_prefix_check(&hm->uri, &${c.nameConstant(namespace)}_API_PAGINATE))
    {
      ${c.nameNamespace(namespace)}_http_paginate(conn, hm->body.p);
      return;
    }
    else if (${c.nameNamespace(namespace)}_http_prefix_check(&hm->uri, &${c.nameConstant(namespace)}_API_QUERY))
    {
      ${c.nameNamespace(namespace)}_http_query(conn, hm->body.p);
      return;
    }
<#list model.objects as obj>
  <#if !obj.isLabelled('entity')><#continue></#if>
    /*!
    ** ${obj.text!''}HTTP处理
    */
    if (${c.nameNamespace(namespace)}_http_prefix_check(&hm->uri, &${c.nameConstant(namespace)}_API_${c.nameVariable(obj.name)?upper_case}_CREATE))
    {
      ${c.nameNamespace(namespace)}_http_${c.nameVariable(obj.name)?lower_case}_create(conn, hm->body.p);
      return;
    }
    else if (${c.nameNamespace(namespace)}_http_prefix_check(&hm->uri, &${c.nameConstant(namespace)}_API_${c.nameVariable(obj.name)?upper_case}_READ))
    {
      ${c.nameNamespace(namespace)}_http_${c.nameVariable(obj.name)?lower_case}_read(conn, hm->body.p);
      return;
    }
    else if (${c.nameNamespace(namespace)}_http_prefix_check(&hm->uri, &${c.nameConstant(namespace)}_API_${c.nameVariable(obj.name)?upper_case}_UPDATE))
    {
      ${c.nameNamespace(namespace)}_http_${c.nameVariable(obj.name)?lower_case}_update(conn, hm->body.p);
      return;
    }
    else if (${c.nameNamespace(namespace)}_http_prefix_check(&hm->uri, &${c.nameConstant(namespace)}_API_${c.nameVariable(obj.name)?upper_case}_DELETE))
    {
      ${c.nameNamespace(namespace)}_http_${c.nameVariable(obj.name)?lower_case}_delete(conn, hm->body.p);
      return;
    }
    else if (${c.nameNamespace(namespace)}_http_prefix_check(&hm->uri, &${c.nameConstant(namespace)}_API_${c.nameVariable(obj.name)?upper_case}_FIND))
    {
      ${c.nameNamespace(namespace)}_http_${c.nameVariable(obj.name)?lower_case}_find(conn, hm->body.p);
      return;
    }

</#list>
<#--
    /*!
    ** 其他扩展HTTP处理
    */
<#assign bxValidIndex = 0>
<#list model.objects as obj>
  <#if !obj.isLabelled('http')><#continue></#if>
  <#list obj.behaviors as bx>
    <#if !bx.isLabelled('http')><#continue></#if>
    <#assign uri = bx.getLabelledOptions('http')['uri']!'/'>
    <#assign method = bx.getLabelledOptions('http')['method']!'get'>
    <#if bx?index != 0>else </#if>if (${c.nameNamespace(namespace)}_http_prefix_check(&hm->uri, &${c.nameConstant(namespace)}_API_${c.nameConstant(uri)}_${c.nameConstant(method)}) && ${c.nameNamespace(namespace)}_http_prefix_check(&hm->method, &${c.nameConstant(namespace)}_HTTP_METHOD_${method?upper_case}))
      ${c.nameNamespace(namespace)}_http_${c.nameMethod('', bx.name)}(conn, hm->body.p);
    <#assign bxValidIndex = bxValidIndex + 1>
  </#list>
</#list>
-->
    if (${c.nameNamespace(namespace)}_http_do(conn, &hm->uri, hm->body.p))
      return;
    else
      // serve static content
      mg_serve_http(conn, hm, s_http_server_opts);
    break;
  default:
    break;
  }
}

<#--
<#list model.objects as obj>
  <#if !obj.isLabelled('http')><#continue></#if>
  <#list obj.behaviors as bx>
    <#if !bx.isLabelled('http')><#continue></#if>
    <#assign sqlId = bx.getLabelledOptions('sql')['id']!'TODO'>
/*!
** ${bx.text!''}.
*/
void
${c.nameNamespace(namespace)}_http_${c.nameMethod('', bx.name)}(struct mg_connection* conn, const char* json_params)
{
  json_object* params = NULL;
  if (json_params != NULL)
    params = json_tokener_parse(json_params);
  json_object* result = gm_database_query(database, ${c.nameConstant(namespace)}_SQL_${c.nameConstant(sqlId)}, params);
  const char* json = json_object_to_json_string(result);
  gm_http_ok(conn, json);

  // 释放资源
  json_object_put(params);
  json_object_put(result);
}

  </#list>
</#list>
-->
#ifdef __cplusplus
}
#endif

#endif // __${c.nameConstant(namespace)}_HTTP_H__
