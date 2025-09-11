<#import '/$/modelbase.ftl' as modelbase>
<#if license??>
${c.license(license)}
</#if>

#include <json.h>

#include <gfc.h>

#include "${namespace}-biz.h"
#include "${namespace}-db.h"
#include "${namespace}-model.h"
#include "${namespace}-err.h"
#include "${namespace}-util.h"

extern gfc_lru_p    g_sessions;
extern jim_db_p     g_db;

void
jim_biz_error(ws_cli_conn_t* client,
              int error,
              const char* message)
{
  char resp[256] = {'\0'};
  sprintf(resp, "{\"error\":{\"code\":%d,\"message\":\"%s\"}}", error, message);
  ws_sendframe_txt(client, resp);
}

void
jim_biz_success(ws_cli_conn_t* client)
{
  jim_biz_error(client, ERROR_SUCCESS, ERRMSG_SUCCESS);
}
<#list model.objects as obj>
  <#if !obj.isLabelled('request')><#continue></#if>
  <#assign operation = obj.name?replace('_request', '')>
  <#assign response = model.findObjectByName(operation + '_response')!''>

/*!
** ${modelbase.get_object_label(obj)?replace('请求', '')}。
*/
void
${namespace}_biz_${operation}(ws_cli_conn_t* client,
${""?left_pad(namespace?length + operation?length + 6)}json_object* payload)
{
  <#list obj.attributes as attr>
  char ${attr.name}[1024] = {'\0'};
  </#list>

  <#list obj.attributes as attr>
  jim_util_get_string(payload, "${js.nameVariable(attr.name)}", ${attr.name});
  </#list>

  <#list obj.attributes as attr>
  if (${attr.name}[0] == '\0')
  {
    jim_biz_error(client, ERROR_PARAM_NO_${attr.name?upper_case}, ERRMSG_PARAM_NO_${attr.name?upper_case});
    return;
  }
  </#list>

  void* conn = jim_db_connect(g_db);
  <#if response != ''>
    <#list response.attributes as attr>
      <#if attr.type.collection>
  gfc_list_p ${attr.name} = gfc_list_new();
      <#else>
  gfc_map_p ${attr.name} = gfc_map_new();    
      </#if>
    </#list>
  int res = jim_model_select_conversation_member(
      conn, conversations, NULL, member_id, member_type);
  if (res != ERROR_SUCCESS)
  {
    
  }
  </#if>
  jim_db_release(g_db, conn);
}
</#list>

void
jim_biz_login(ws_cli_conn_t* client,
              json_object* payload)
{
  // 获取用户标识
  json_object *jval = json_object_object_get(payload, "userId");
  enum json_type jtype = json_object_get_type(jval);

  if (jtype != json_type_string)
  {
    jim_biz_error(client, ERROR_UNAUTHORIZED_USER, ERRMSG_UNAUTHORIZED_USER);
    return;
  }

  const char* user_id = json_object_get_string(jval);

  // 存入用户进入缓存
  gfc_lru_set(g_sessions,
              (void*) strdup(user_id), strlen(user_id),
              client, ws_size_of_cli_conn());

  char buff[1024] = {'\0'};
  sprintf(buff, "{\"userId\":\"%s\"}", user_id);
  ws_sendframe_txt(client, buff);
}

/*!
** 客户端用户登出。
*/
void
jim_biz_logout(ws_cli_conn_t* client,
               json_object* payload)
{
  // 获取用户标识
  json_object *jval = json_object_object_get(payload, "userId");
  enum json_type jtype = json_object_get_type(jval);

  if (jtype != json_type_string)
  {
    jim_biz_error(client, ERROR_UNAUTHORIZED_USER, ERRMSG_UNAUTHORIZED_USER);
    return;
  }

  const char* user_id = json_object_get_string(jval);

  // 删除用户缓存
  gfc_lru_remove(g_sessions,
                 (void*) user_id,
                 strlen(user_id));

  ws_close_client(client);
}

/*!
** 用户发送消息。
*/
void
jim_biz_send(ws_cli_conn_t* client,
             json_object* payload)
{
  // 用户验证
  json_object *jval = json_object_object_get(payload, "userId");
  enum json_type jtype = json_object_get_type(jval);

  if (jtype != json_type_string)
  {
    jim_biz_error(client, ERROR_UNAUTHORIZED_USER, ERRMSG_UNAUTHORIZED_USER);
    return;
  }
  const char* user_id = json_object_get_string(jval);

  jval = json_object_object_get(payload, "receiverId");
  jtype = json_object_get_type(jval);

  if (jtype != json_type_string)
  {
    jim_biz_error(client, ERROR_UNAUTHORIZED_USER, ERRMSG_UNAUTHORIZED_USER);
    return;
  }
  const char* receiver_id = json_object_get_string(jval);

  ws_cli_conn_t* receiver;
  gfc_lru_get(g_sessions,
              (void*) receiver_id,
              strlen(receiver_id),
              (void**) &receiver);

  if (receiver == NULL)
  {
    printf("receiver is null\n");
    return;
  }

  jval = json_object_object_get(payload, "message");
  const char* msg = json_object_to_json_string_ext(jval, JSON_C_TO_STRING_SPACED | JSON_C_TO_STRING_PRETTY);
  ws_sendframe_txt(receiver, msg);
  jim_biz_success(client);
}

void
jim_biz_create_conversation(ws_cli_conn_t* client,
                            json_object* payload)
{
  char conversation_id[37] = {'\0'};
  char conversation_name[128] = {'\0'};
  char conversation_type[16] = {'\0'};

  jim_util_id(conversation_id);
}

void
jim_biz_get_conversations(ws_cli_conn_t* client,
                          json_object* payload)
{
  char member_id[128] = {'\0'};
  char member_type[128] = {'\0'};

  jim_util_get_string(payload, "memberId", member_id);
  jim_util_get_string(payload, "memberType", member_id);

  if (member_id[0] == '\0')
  {
    jim_biz_error(client, ERROR_PARAM_NO_MEMBER_ID, ERRMSG_PARAM_NO_MEMBER_ID);
    return;
  }
  if (member_type[0] == '\0')
  {
    jim_biz_error(client, ERROR_PARAM_NO_MEMBER_TYPE, ERRMSG_PARAM_NO_MEMBER_TYPE);
    return;
  }

  void* conn = jim_db_connect(g_db);
  gfc_list_p conversations = gfc_list_new();
  int res = jim_model_select_conversation_member(
      conn, conversations, NULL, member_id, member_type);
  if (res != ERROR_SUCCESS)
  {

  }

  jim_db_release(g_db, conn);
}
