<#import '/$/paradigm-internal.ftl' as internal>
<#if license??>
${c.license(license)}
</#if>

#ifndef __${c.nameConstant(namespace)}_HTTP_BASE_H__
#define __${c.nameConstant(namespace)}_HTTP_BASE_H__

#ifdef __cplusplus
extern "C"
{
#endif

#include <json-c/json.h>

#include "mongoose.h"

#include "${namespace}-sql-ext.h"

struct ${c.nameNamespace(namespace)}_file_data {
  FILE*   fp;
  char    relpth[2048];
  size_t  bytes_written;
};

extern ${c.nameNamespace(namespace)}_database_context_t* database;

const char* JSON_EMPTY = "{}";

struct mg_serve_http_opts s_http_server_opts;

const struct mg_str ${c.nameConstant(namespace)}_HTTP_METHOD_GET      = MG_MK_STR("GET");

const struct mg_str ${c.nameConstant(namespace)}_HTTP_METHOD_POST     = MG_MK_STR("POST");

const struct mg_str ${c.nameConstant(namespace)}_HTTP_METHOD_PUT      = MG_MK_STR("PUT");

const struct mg_str ${c.nameConstant(namespace)}_HTTP_METHOD_DELETE   = MG_MK_STR("DELETE");

const struct mg_str ${c.nameConstant(namespace)}_HTTP_METHOD_CONNECT  = MG_MK_STR("CONNECT");

static const struct mg_str ${c.nameConstant(namespace)}_API_PAGINATE   = MG_MK_STR("/api/v1/paginate");

static const struct mg_str ${c.nameConstant(namespace)}_API_QUERY      = MG_MK_STR("/api/v1/query");

static const struct mg_str ${c.nameConstant(namespace)}_API_UPLOAD     = MG_MK_STR("/api/v1/upload");

static const struct mg_str ${c.nameConstant(namespace)}_API_EXECUTE    = MG_MK_STR("/api/v1/execute");

/*!
** Sends ok status and result to http client.
**
** @param conn
**        the mongoose connection
**
** @param json
**        the json result
*/
void
${c.nameNamespace(namespace)}_http_ok(struct mg_connection* conn, const char* json)
{
  mg_printf(conn,
            "HTTP/1.1 200 OK\r\n"
            "Content-Type: application/json\r\n"
            "Content-Length: %d\r\n\r\n%s",
            (int) strlen(json), json);
}

/*!
** Handles query request.
**
** @param conn
**        the mongoose connection
**
** @param json_params
**        the parameters in json
*/
void
${c.nameNamespace(namespace)}_http_query(struct mg_connection* conn, const char* json_params)
{
  json_object* params = json_tokener_parse(json_params);
  json_object* jso_sql = json_object_object_get(params, "sql");

  if (jso_sql == NULL)
  {
    ${c.nameNamespace(namespace)}_http_ok(conn, JSON_EMPTY);
    json_object_put(params);
    return;
  }

  const char* sql_id = json_object_get_string(jso_sql);
  const char* sql = ${c.nameNamespace(namespace)}_sql_get(sql_id);
  if (sql == NULL)
  {
    ${c.nameNamespace(namespace)}_http_ok(conn, JSON_EMPTY);
    json_object_put(params);
    return;
  }

  json_object* result = ${c.nameNamespace(namespace)}_database_query(database, sql, params);
  const char* json = json_object_to_json_string(result);
  ${c.nameNamespace(namespace)}_http_ok(conn, json);

  // 减少json object引用，从而资源被释放
  json_object_put(params);
  json_object_put(result);
}

/*!
** Handles pagination request.
**
** @param conn
**        the mongoose connection
**
** @param json_params
**        the parameters in json
*/
void
${c.nameNamespace(namespace)}_http_paginate(struct mg_connection* conn, const char* json_params)
{
  json_object* params = json_tokener_parse(json_params);
  json_object* jso_start = json_object_object_get(params, "start");
  json_object* jso_limit = json_object_object_get(params, "limit");
  json_object* jso_sql = json_object_object_get(params, "sql");

  if (jso_sql == NULL)
  {
    ${c.nameNamespace(namespace)}_http_ok(conn, JSON_EMPTY);
    json_object_put(params);
    return;
  }

  const char* sql_id = json_object_get_string(jso_sql);
  const char* sql = ${c.nameNamespace(namespace)}_sql_get(sql_id);
  if (sql == NULL)
  {
    ${c.nameNamespace(namespace)}_http_ok(conn, JSON_EMPTY);
    json_object_put(params);
    return;
  }

  int start = 0;
  int limit = -1;

  if (jso_start != NULL)
    start = json_object_get_int(jso_start);
  if (jso_limit != NULL)
    limit = json_object_get_int(jso_limit);

  json_object* result = ${c.nameNamespace(namespace)}_database_paginate(database, sql, params, start, limit);
  const char* json = json_object_to_json_string(result);
  ${c.nameNamespace(namespace)}_http_ok(conn, json);

  // 减少json object引用，从而资源被释放
  json_object_put(params);
  json_object_put(result);
}

/*!
** Receives uploading file from http client.
**
** @param conn
**        the mongoose connection
**
** @param evt
**        the mongoose http event type
**
** @param pdata
**        the multipart data
*/
void
${c.nameNamespace(namespace)}_http_upload(struct mg_connection* conn, int evt, void* pdata) {
  struct ${c.nameNamespace(namespace)}_file_data* data = (struct ${c.nameNamespace(namespace)}_file_data *) conn->user_data;
  struct mg_http_multipart_part* mp = (struct mg_http_multipart_part *) pdata;

  switch (evt)
  {
  case MG_EV_HTTP_PART_BEGIN:
    if (data == NULL)
    {
      char original[1024] = {'\0'};
      strcpy(original, mp->file_name);
      char* dot = strrchr(original, '.');
      *dot = '\0';

      char uri[1024] = {'\0'};
      char* ext = strrchr(mp->file_name, '.');
      if (ext != NULL) ext++;
      data = calloc(1, sizeof(struct ${c.nameNamespace(namespace)}_file_data));
      data->fp = ${c.nameNamespace(namespace)}_file_create(original, ext, uri);
      data->bytes_written = 0;

      if (data->fp == NULL)
      {
        mg_printf(conn, "%s",
                  "HTTP/1.1 500 Failed to open a file\r\n"
                  "Content-Length: 0\r\n\r\n");
        conn->flags |= MG_F_SEND_AND_CLOSE;
        free(data);
        return;
      }
      strcpy(data->relpth, uri);
      conn->user_data = (void*) data;
    }
    break;
  case MG_EV_HTTP_PART_DATA:
    if (fwrite(mp->data.p, 1, mp->data.len, data->fp) != mp->data.len)
    {
      mg_printf(conn, "%s",
                "HTTP/1.1 500 Failed to write to a file\r\n"
                "Content-Length: 0\r\n\r\n");
      conn->flags |= MG_F_SEND_AND_CLOSE;
      return;
    }
    data->bytes_written += mp->data.len;
    break;
  case MG_EV_HTTP_PART_END:
    mg_printf(conn,
              "HTTP/1.1 200 OK\r\n"
              "Content-Type: text/plain\r\n"
              "Connection: close\r\n\r\n"
              "{\"uri\":\"%s\"}\n\n",
              data->relpth);
    conn->flags |= MG_F_SEND_AND_CLOSE;
    fclose(data->fp);
    free(data);
    conn->user_data = NULL;
    break;
  }
}

#ifdef __cplusplus
}
#endif

#endif // __${c.nameConstant(namespace)}_HTTP_BASE_H__
