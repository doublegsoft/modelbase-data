<#import '/$/modelbase.ftl' as modelbase>
<#import '/$/appbase.ftl' as appbase>
<#if license??>
${c.license(license)}
</#if>

#include <stdio.h>
#include <mysql.h>
#include <stdbool.h>
#include <pthread.h>
#include <assert.h>

#include <gfc.h>

#include "${app.name}-err.h"
#include "${app.name}-db.h"
#include "${app.name}-model.h"

static unsigned char    g_conns   = 0;
extern ${app.name}_db_p         g_db;
<#list model.objects as obj>
  <#if !obj.isLabelled('entity') && !obj.isLabelled('value')><#continue></#if>
  <#assign attrIds = modelbase.get_id_attributes(obj)>
  <#assign attrUpdate = appbase.get_update_attributes(obj)>
/*!
** 【${modelbase.get_object_label(obj)}】的语句。
*/
#define SQL_INSERT_${obj.persistenceName?upper_case}    "insert into ${obj.persistenceName} (<#list obj.attributes as attr><#if attr?index != 0>,</#if>${attr.persistenceName}</#list>)" \
${""?left_pad(obj.persistenceName?length + 19)}    "values (<#list obj.attributes as attr><#if attr?index != 0>,</#if>?</#list>);"

#define SQL_DELETE_${obj.persistenceName?upper_case}    "delete from ${obj.persistenceName} " \
${""?left_pad(obj.persistenceName?length + 19)}    "where 1 = 1 "
  <#list attrUpdate as attr>
    <#assign persistenceUpdate = attr.getLabelledOptions('persistence')['update']>

#define SQL_UPDATE_${obj.persistenceName?upper_case}_${attr.persistenceName?upper_case}    "update ${obj.persistenceName} " \
    <#if persistenceUpdate == 'now'>
${""?left_pad(obj.persistenceName?length + attr.persistenceName?length + 20)}    "set ${attr.persistenceName} = current_timestamp " \
    <#elseif persistenceUpdate?starts_with('+')>
${""?left_pad(obj.persistenceName?length + attr.persistenceName?length + 20)}    "set ${attr.persistenceName} = coalesce(${attr.persistenceName},0)${persistenceUpdate} " \
    <#else>
${""?left_pad(obj.persistenceName?length + attr.persistenceName?length + 20)}    "set ${attr.persistenceName} = ? " \
    </#if>
${""?left_pad(obj.persistenceName?length + attr.persistenceName?length + 20)}    "where 1 = 1 " \
    <#list attrIds as attrId>
${""?left_pad(obj.persistenceName?length + attr.persistenceName?length + 20)}    "and ${attrId.persistenceName} = ? " \
    </#list>
${""?left_pad(obj.persistenceName?length + attr.persistenceName?length + 20)}    ";"
    <#if persistenceUpdate?starts_with('+')>

#define SQL_UPDATE_${obj.persistenceName?upper_case}_${attr.persistenceName?upper_case}_RESET    "update ${obj.persistenceName} " \
${""?left_pad(obj.persistenceName?length + attr.persistenceName?length + 26)}    "set ${attr.persistenceName} = 0 " \
${""?left_pad(obj.persistenceName?length + attr.persistenceName?length + 26)}    "where 1 = 1 " \
    <#list attrIds as attrId>
${""?left_pad(obj.persistenceName?length + attr.persistenceName?length + 26)}    "and ${attrId.persistenceName} = ? " \
    </#list>
${""?left_pad(obj.persistenceName?length + attr.persistenceName?length + 26)}    ";"
    </#if>
  </#list>

  <#assign refObjs = appbase.get_reference_objects(obj)>
#define SQL_SELECT_${obj.persistenceName?upper_case}    "select " \
  <#list obj.attributes as attr>
${""?left_pad(obj.persistenceName?length + 19)}    "${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} ${js.nameVariable(modelbase.get_attribute_sql_name(attr))}, " \
  </#list>
  <#list refObjs as attrname, refObj>
    <#assign attr = model.findAttributeByNames(obj.name, attrname)>
    <#assign refObjLevelledAttrs = appbase.get_levelled_attributes(refObj)>
    <#list refObjLevelledAttrs as levelledAttr>
${""?left_pad(obj.persistenceName?length + 19)}    "${attr.persistenceName}_${modelbase.get_object_sql_alias(refObj)}.${levelledAttr.persistenceName} ${js.nameVariable(refObj.name)}${js.nameType(levelledAttr.name)}, " \
    </#list>
  </#list>
${""?left_pad(obj.persistenceName?length + 19)}    "0 " \
${""?left_pad(obj.persistenceName?length + 19)}    "from ${obj.persistenceName} ${modelbase.get_object_sql_alias(obj)} " \
  <#list refObjs as attrname, refObj>
    <#assign refObjLevelledAttrs = appbase.get_levelled_attributes(refObj)>
    <#assign attr = model.findAttributeByNames(obj.name, attrname)>
    <#assign refObjAttr = appbase.get_reference_attribute(attr)>
    <#if refObjLevelledAttrs?size != 0>
${""?left_pad(obj.persistenceName?length + 19)}    "left join ${refObj.persistenceName} ${attr.persistenceName}_${modelbase.get_object_sql_alias(refObj)} on ${attr.persistenceName}_${modelbase.get_object_sql_alias(refObj)}.${refObjAttr.persistenceName} = ${modelbase.get_object_sql_alias(attr.parent)}.${attr.persistenceName} " \
    </#if>
  </#list>
${""?left_pad(obj.persistenceName?length + 19)}    "where 1 = 1 "
</#list>

struct ${namespace}_db_s
{
  int max_connections;

  int active_connections;

  void**  connections;

  pthread_mutex_t   mutex;

  pthread_cond_t    cond;
};

int
${namespace}_db_create(${namespace}_db_p*${""?left_pad(13 - namespace?length - 6)}pdb, 
${""?left_pad(namespace?length + 11)}const char*  address, 
${""?left_pad(namespace?length + 11)}int          port, 
${""?left_pad(namespace?length + 11)}const char*  username, 
${""?left_pad(namespace?length + 11)}const char*  password,
${""?left_pad(namespace?length + 11)}const char*  dbname,
${""?left_pad(namespace?length + 11)}int          max_connections)
{
  int ret = 0, i = 0;

  *pdb = (${namespace}_db_p) gfc_gc_malloc(sizeof(${namespace}_db_t), 1);
  (*pdb)->max_connections = max_connections;
  (*pdb)->connections = (void**) malloc(sizeof(MYSQL*) * max_connections);
  (*pdb)->active_connections = 0;

  for (i = 0; i < max_connections; i++) 
  {
    MYSQL* conn = mysql_init(NULL);
    if (mysql_real_connect(conn, address, username, password, dbname, port, NULL, 0) == NULL)
    {
      fprintf(stderr, "%s\n", mysql_error(conn));
      mysql_close(conn);
      exit(1);
    }
    (*pdb)->connections[i] = conn;
  }

  pthread_mutex_init(&((*pdb)->mutex), NULL);
  pthread_cond_init(&((*pdb)->cond), NULL);

  return ret;
}

void*
${namespace}_db_connect(${namespace}_db_p db)
{
  void* ret = NULL;
  pthread_mutex_lock(&db->mutex);
  if (db->active_connections >= db->max_connections) 
    pthread_cond_wait(&db->cond, &db->mutex);
  db->active_connections++;
  if ((g_conns & 0b00000001) == 0)
  {
    ret = db->connections[0];
    g_conns |= 0b00000001;
  }
  else if ((g_conns & 0b00000010) == 0)
  {
    ret = db->connections[1];
    g_conns |= 0b00000010;
  }
  else if ((g_conns & 0b00000100) == 0)
  {
    ret = db->connections[2];
    g_conns |= 0b00000100;
  }
  else if ((g_conns & 0b00001000) == 0)
  {
    ret = db->connections[3];
    g_conns |= 0b00001000;
  }
  else if ((g_conns & 0b00010000) == 0)
  {
    ret = db->connections[4];
    g_conns |= 0b00010000;
  }
  else if ((g_conns & 0b00100000) == 0)
  {
    ret = db->connections[5];
    g_conns |= 0b00100000;
  }
  else if ((g_conns & 0b01000000) == 0)
  {
    ret = db->connections[6];
    g_conns |= 0b01000000;
  }
  else if ((g_conns & 0b10000000) == 0)
  {
    ret = db->connections[7];
    g_conns |= 0b10000000;
  }
  pthread_mutex_unlock(&db->mutex);
  return ret;
}

void
${namespace}_db_release(${namespace}_db_p   db,
${""?left_pad(namespace?length * 2 + 12)}void*  conn)
{
  int i = 0;
  pthread_mutex_lock(&db->mutex);
  if (db->active_connections >= db->max_connections) 
  {
    pthread_cond_signal(&db->cond);
  }
  for (i = 0; i < 8; i++) 
  {
    if (conn == db->connections[i])
    {
      if (i == 0)
        g_conns &= 0b11111110;
      else if (i == 1)
        g_conns &= 0b11111101;
      else if (i == 2)
        g_conns &= 0b11111011;
      else if (i == 3)
        g_conns &= 0b11110111;
      else if (i == 4)
        g_conns &= 0b11101111;
      else if (i == 5)
        g_conns &= 0b11011111;
      else if (i == 6)
        g_conns &= 0b10111111;
      else if (i == 7)
        g_conns &= 0b01111111;
      break;
    }
  }
  db->active_connections--;
  pthread_mutex_unlock(&db->mutex);
}

void
${namespace}_db_destroy(${namespace}_db_p db)
{
  if (db == NULL) return;
  int i = 0;

  for (i = 0; i < db->max_connections; i++)
  {
    MYSQL* conn = (MYSQL*) db->connections[i];
    mysql_close(conn);
  }

  assert(GFC_GC_OK == gfc_gc_free(db));
}

int
${namespace}_db_many(void*         conn_inst,
${""?left_pad(namespace?length + 9)}char*         errmsg,
${""?left_pad(namespace?length + 9)}gfc_list_p    holder,
${""?left_pad(namespace?length + 9)}const char*   sql)
{
  int           ret           = ERROR_SUCCESS;
  MYSQL*        conn          = (MYSQL*) conn_inst;
  MYSQL_RES*    result        = NULL;
  MYSQL_FIELD*  field;
  MYSQL_ROW     row;
  uint          i;


  ret = mysql_query(conn, sql);
  if (ret)
  {
    sprintf(errmsg, "%s", mysql_error(conn));
    goto RELEASE;
  }
  result = mysql_store_result(conn);
  if (result != NULL)
  {
    while ((row = mysql_fetch_row (result)) != NULL)
    {
      gfc_map_p row_obj = gfc_map_new();
      for (i = 0; i < mysql_num_fields(result); i++)
      {
        field = mysql_fetch_field(result);
        if (field->type == MYSQL_TYPE_STRING ||
            field->type == MYSQL_TYPE_VAR_STRING ||
            field->type == MYSQL_TYPE_VARCHAR)
            gfc_map_put(row_obj, field->name, strdup(row[i]));
        else
          gfc_map_put(row_obj, field->name, row[i]);
      }
      gfc_list_append(holder, row_obj);
    }
  }

RELEASE:

  if (result != NULL)
    mysql_free_result(result);

  return ret;
}

<#list model.objects as obj>
  <#if !obj.isLabelled('entity') && !obj.isLabelled('value')><#continue></#if>
  <#assign max_arg_len = appbase.max_object_argument_length(obj)>
  <#assign attrIds = modelbase.get_id_attributes(obj)>
  <#assign attrSelect = appbase.get_select_attributes(obj)>
  <#assign attrDelete = appbase.get_delete_attributes(obj)>
  <#assign attrUpdate = appbase.get_update_attributes(obj)>
int
${namespace}_model_create_${obj.name}(void*${""?left_pad(max_arg_len - 5 + 2)}conn_inst,
${""?left_pad(namespace?length + obj.name?length + 15)}char*${""?left_pad(max_arg_len - 5 + 2)}errmsg,
  <#list obj.attributes as attr>
    <#assign typename = appbase.type_attribute_as_argument(attr)>
${""?left_pad(namespace?length + obj.name?length + 15)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attr.name}<#if attr?index == obj.attributes?size - 1>)<#else>,</#if>
  </#list>
{
  MYSQL*        conn = (MYSQL*) conn_inst;
  MYSQL_STMT*   stmt;
  MYSQL_BIND    params[${obj.attributes?size}];
  ulong         lengths[${obj.attributes?size}];

  stmt    = mysql_stmt_init(conn);

  int res = ERROR_SUCCESS;
  
  res = mysql_stmt_prepare(stmt, 
                           SQL_INSERT_${obj.persistenceName?upper_case}, 
                           strlen(SQL_INSERT_${obj.persistenceName?upper_case}));
  if (res)
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }                         
  memset(params, 0, sizeof(params));    

  <#list obj.attributes as attr>
    <#assign typename = appbase.type_attribute_as_argument(attr)>
  // 【${modelbase.get_attribute_label(attr)}】
    <#if typename == 'const char*'>
  lengths[${attr?index}] = ${attr.name} != NULL ? strlen(${attr.name}) : 0;
  params[${attr?index}].buffer_type = ${attr.name} != NULL ? MYSQL_TYPE_STRING : MYSQL_TYPE_NULL;
  params[${attr?index}].buffer = (char *) ${attr.name};
    <#else>
  lengths[${attr?index}] = 0;  
  params[${attr?index}].buffer_type = MYSQL_TYPE_LONG;
  params[${attr?index}].buffer = (int *) &${attr.name};
    </#if>
  params[${attr?index}].length = &lengths[${attr?index}];
  params[${attr?index}].is_null = 0;
  </#list>       

  res = mysql_stmt_bind_param(stmt, params);
  if (res)
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

  res = mysql_stmt_execute(stmt);
  if (res)
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

RELEASE:

  mysql_stmt_close(stmt);

  return res;
}
  <#if attrDelete?size != 0>

int
${namespace}_model_delete_${obj.name}(void*${""?left_pad(max_arg_len - 5 + 2)}conn_inst,
${""?left_pad(namespace?length + obj.name?length + 15)}char*${""?left_pad(max_arg_len - 5 + 2)}errmsg,
    <#list attrDelete as attr>
      <#assign typename = appbase.type_attribute_as_argument(attr)>
      <#assign persistenceDelete = attr.getLabelledOptions('persistence')['delete']>
      <#if persistenceDelete == '<>'>
${""?left_pad(namespace?length + obj.name?length + 15)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attr.name}0,
${""?left_pad(namespace?length + obj.name?length + 15)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attr.name}1<#if attr?index == attrDelete?size - 1>)<#else>,</#if>
      <#else>
${""?left_pad(namespace?length + obj.name?length + 15)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attr.name}<#if attr?index == attrDelete?size - 1>)<#else>,</#if>
      </#if>
    </#list>  
{
  MYSQL*        conn = (MYSQL*) conn_inst;
  MYSQL_STMT*   stmt;
  MYSQL_BIND*   params = NULL;
  ulong*        lengths = NULL;
  int           param_count = 0;
  int           param_index = 0;
  int           res = ERROR_SUCCESS;

  gfc_string_p sql = gfc_string_new(SQL_DELETE_${obj.persistenceName?upper_case});
    <#list attrDelete as attr>
      <#assign persistenceDelete = attr.getLabelledOptions('persistence')['delete']>
      <#if persistenceDelete == '<>'>
  if (${attr.name}0 != NULL) 
  {
    gfc_string_concat(sql, "and ${attr.persistenceName} >= ? ");
    param_count++;
  }
  if (${attr.name}1 != NULL) 
  {
    gfc_string_concat(sql, "and ${attr.persistenceName} <= ? ");
    param_count++;
  }  
    <#else>
  if (${attr.name} != NULL) 
  {
    gfc_string_concat(sql, "and ${attr.persistenceName} = ? ");
    param_count++;
  }
      </#if>
    </#list>

  stmt    = mysql_stmt_init(conn);
  params  = (MYSQL_BIND*) gfc_gc_malloc(sizeof(MYSQL_BIND), param_count);
  lengths = (ulong*) gfc_gc_malloc(sizeof(ulong), param_count);
  
  res = mysql_stmt_prepare(stmt, 
                           sql->buffer, 
                           gfc_string_length(sql));
  if (res) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }
  memset(params, 0, sizeof(MYSQL_BIND) * param_count);   

    <#list attrDelete as attr>
      <#assign typename = appbase.type_attribute_as_argument(attr)>
      <#assign persistenceDelete = attr.getLabelledOptions('persistence')['delete']>
      <#if persistenceDelete == '<>'>
  if (${attr.name}0 != NULL) 
  {
    lengths[param_index] = strlen(${attr.name}0);
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${attr.name}0;
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
  if (${attr.name}1 != NULL) 
  {
    lengths[param_index] = strlen(${attr.name}1);
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${attr.name}1;
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }  
    <#else>
  if (${attr.name} != NULL) 
  {
    <#if typename == 'const char*'>
    lengths[param_index] = strlen(${attr.name});
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${attr.name};
    <#else>
    lengths[param_index] = 0;  
    params[param_index].buffer_type = MYSQL_TYPE_LONG;
    params[param_index].buffer = (int *) &${attr.name};
    </#if>
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
      </#if>
    </#list>    

  res = mysql_stmt_bind_param(stmt, params);
  if (res) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

  res = mysql_stmt_execute(stmt);
  if (res) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

RELEASE:

  mysql_stmt_close(stmt);
  gfc_string_free(sql);
  if (params != NULL)
    assert(GFC_GC_OK == gfc_gc_free(params));
  if (lengths != NULL)
    assert(GFC_GC_OK == gfc_gc_free(lengths));

  return res;
}
  </#if>
  <#if attrUpdate?size != 0>
    <#list attrUpdate as attr>
      <#assign persistenceUpdate = attr.getLabelledOptions('persistence')['update']>
      
/*!
** 更新【${modelbase.get_object_label(obj)}】中【${modelbase.get_attribute_label(attr)}】数据。
*/
int
${namespace}_model_update_${obj.name}_${attr.name}(void*${""?left_pad(max_arg_len - 5 + 2)}conn_inst,
${""?left_pad(namespace?length + obj.name?length + attr.name?length + 16)}char*${""?left_pad(max_arg_len - 5 + 2)}errmsg,
      <#list attrIds as attrId>
        <#assign typename = appbase.type_attribute_as_argument(attrId)>
${""?left_pad(namespace?length + obj.name?length + attr.name?length + 16)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attrId.name},
      </#list>
      <#assign typename = appbase.type_attribute_as_argument(attr)>
${""?left_pad(namespace?length + obj.name?length + attr.name?length + 16)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attr.name})
{
  MYSQL*        conn = (MYSQL*) conn_inst;
  MYSQL_STMT*   stmt;
      <#if persistenceUpdate != '='>
  MYSQL_BIND    params[${attrIds?size}];
  ulong         lengths[${attrIds?size}];
      <#else>
  MYSQL_BIND    params[${attrIds?size + 1}];
  ulong         lengths[${attrIds?size + 1}];    
      </#if>
  int           param_index = 0;
  int           res         = ERROR_SUCCESS;
  
  stmt    = mysql_stmt_init(conn);
  

  res = mysql_stmt_prepare(stmt, 
                           SQL_UPDATE_${obj.persistenceName?upper_case}_${attr.persistenceName?upper_case}, 
                           strlen(SQL_UPDATE_${obj.persistenceName?upper_case}_${attr.persistenceName?upper_case}));
  if (res) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

  memset(params, 0, sizeof(params)); 
      <#if persistenceUpdate == '='>
  lengths[param_index] = strlen(${attr.name});
  params[param_index].buffer_type = MYSQL_TYPE_STRING;
  params[param_index].buffer = (char *) ${attr.name};   
  params[param_index].length = &lengths[param_index];
  params[param_index].is_null = 0;   
  param_index++;     
      </#if>
      <#list attrIds as attrId>
        <#assign typename = appbase.type_attribute_as_argument(attrId)>
        <#if typename == 'const char*'>
  lengths[param_index] = strlen(${attrId.name});
  params[param_index].buffer_type = MYSQL_TYPE_STRING;
  params[param_index].buffer = (char *) ${attrId.name};
        <#else>
  lengths[param_index] = 0;  
  params[param_index].buffer_type = MYSQL_TYPE_LONG;
  params[param_index].buffer = (int *) &${attrId.name};
        </#if>
  params[param_index].length = &lengths[param_index];
  params[param_index].is_null = 0;   
  param_index++;       
      </#list>
  
  res = mysql_stmt_bind_param(stmt, params);
  if (res) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

  res = mysql_stmt_execute(stmt);
  if (res) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

RELEASE:

  mysql_stmt_close(stmt);  

  return res;
} 
    </#list>
  </#if>   

int
${namespace}_model_select_${obj.name}(void*${""?left_pad(max_arg_len - 5 + 2)}conn_inst,
${""?left_pad(namespace?length + obj.name?length + 15)}char*${""?left_pad(max_arg_len - 5 + 2)}errmsg,
${""?left_pad(namespace?length + obj.name?length + 15)}gfc_list_p${""?left_pad(max_arg_len - 10 + 2)}list,
  <#list attrSelect as attr>
    <#assign typename = appbase.type_attribute_as_argument(attr)>
    <#assign persistenceSelect = attr.getLabelledOptions('persistence')['select']>
    <#if persistenceSelect == '<>'>
${""?left_pad(namespace?length + obj.name?length + 15)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attr.name}0,
${""?left_pad(namespace?length + obj.name?length + 15)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attr.name}1,
    <#else>
${""?left_pad(namespace?length + obj.name?length + 15)}${typename}${""?left_pad(max_arg_len - typename?length + 2)}${attr.name},
    </#if>
  </#list>
${""?left_pad(namespace?length + obj.name?length + 15)}const char*${""?left_pad(max_arg_len - typename?length + 2)}suffix)
{
  <#assign attrSize = obj.attributes?size + 1>
  <#assign refObjs = appbase.get_reference_objects(obj)>
  <#list refObjs as attrname, refObj>
    <#assign attr = model.findAttributeByNames(obj.name, attrname)>
    <#assign refObjLevelledAttrs = appbase.get_levelled_attributes(refObj)>
    <#assign attrSize = attrSize + refObjLevelledAttrs?size>
  </#list>
  int           res  = ERROR_SUCCESS;
  MYSQL*        conn = (MYSQL*) conn_inst;
  MYSQL_STMT*   stmt;
  MYSQL_BIND*   params;
  MYSQL_BIND    binds[${attrSize}];
  MYSQL_FIELD*  field;
  MYSQL_ROW     row;
  MYSQL_RES*    result;
  ulong*        lengths;
  ulong         bindlens[${attrSize}];
  bool          is_nulls[${attrSize}];
  int           param_count = 0;
  int           param_index = 0;
  int           i = 0;
  stmt = mysql_stmt_init(conn);

  gfc_string_p sql = gfc_string_new(SQL_SELECT_${obj.persistenceName?upper_case});
  <#list attrSelect as attr>
    <#assign persistenceSelect = attr.getLabelledOptions('persistence')['select']>
    <#if persistenceSelect == '<>'>
  if (${attr.name}0 != NULL) 
  {
    gfc_string_concat(sql, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} >= ? ");
    param_count++;
  }
  if (${attr.name}1 != NULL) 
  {
    gfc_string_concat(sql, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} <= ? ");
    param_count++;
  }  
    <#else>
  if (${attr.name} != NULL) 
  {
    gfc_string_concat(sql, "and ${modelbase.get_object_sql_alias(obj)}.${attr.persistenceName} = ? ");
    param_count++;
  }
    </#if>
  </#list>
  if (suffix != NULL)
    gfc_string_concat(sql, suffix);

  params  = (MYSQL_BIND*) gfc_gc_malloc(sizeof(MYSQL_BIND), param_count);
  lengths = (ulong*) gfc_gc_malloc(sizeof(ulong), param_count);
  
  res = mysql_stmt_prepare(stmt, 
                           sql->buffer, 
                           gfc_string_length(sql));
  if (res) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }                             
  memset(params, 0, sizeof(MYSQL_BIND) * param_count); 
  memset(binds, 0, sizeof(binds));  

  <#list attrSelect as attr>
    <#assign typename = appbase.type_attribute_as_argument(attr)>
    <#assign persistenceSelect = attr.getLabelledOptions('persistence')['select']>
    <#if persistenceSelect == '<>'>
  if (${attr.name}0 != NULL) 
  {
    lengths[param_index] = strlen(${attr.name}0);
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${attr.name}0;
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
  if (${attr.name}1 != NULL) 
  {
    lengths[param_index] = strlen(${attr.name}1);
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${attr.name}1;
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }  
    <#else>
  if (${attr.name} != NULL) 
  {
    <#if typename == 'const char*'>
    lengths[param_index] = strlen(${attr.name});
    params[param_index].buffer_type = MYSQL_TYPE_STRING;
    params[param_index].buffer = (char *) ${attr.name};
    <#else>
    lengths[param_index] = 0;  
    params[param_index].buffer_type = MYSQL_TYPE_LONG;
    params[param_index].buffer = (int *) &${attr.name};
    </#if>
    params[param_index].length = &lengths[param_index];
    params[param_index].is_null = 0;
    param_index++;
  }
    </#if>
  </#list>    

  res = mysql_stmt_bind_param(stmt, params);
  if (res) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

  res = mysql_stmt_execute(stmt);
  if (res) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }

  <#list obj.attributes as attr>
    <#assign typename = appbase.type_attribute_as_argument(attr)>
    <#if typename == 'const char*'>
  char buff_${attr.name}[2048];  
    <#else>
  int buff_${attr.name};  
    </#if>
  </#list>
  <#list refObjs as attrname, refObj>
    <#assign attr = model.findAttributeByNames(obj.name, attrname)>
    <#assign refObjLevelledAttrs = appbase.get_levelled_attributes(refObj)>
    <#list refObjLevelledAttrs as levelledAttr>
      <#assign typename = appbase.type_attribute_as_argument(attr)>
      <#if typename == 'const char*'>
  char buff_${attr.name}_${levelledAttr.name}[2048];  
      <#else>
  int buff_${attr.name}_${levelledAttr.name};  
      </#if>
    </#list>
  </#list>
  int buff_reserved;
  <#list obj.attributes as attr>
    <#assign typename = appbase.type_attribute_as_argument(attr)>
    <#if typename == 'const char*'>
  binds[${attr?index}].buffer_type = MYSQL_TYPE_STRING;
  binds[${attr?index}].buffer = (char *) buff_${attr.name};
  binds[${attr?index}].buffer_length = 2048;
    <#else>
  binds[${attr?index}].buffer_type = MYSQL_TYPE_LONG;
  binds[${attr?index}].buffer = (int *) &buff_${attr.name};
    </#if>
  binds[${attr?index}].length = &bindlens[${attr?index}];  
  binds[${attr?index}].is_null = &is_nulls[${attr?index}];  
  </#list>
  <#-- 引用字段绑定 -->
  <#assign attrIndex = obj.attributes?size>
  <#assign refObjs = appbase.get_reference_objects(obj)>
  <#list refObjs as attrname, refObj>
    <#assign attr = model.findAttributeByNames(obj.name, attrname)>
    <#assign refObjLevelledAttrs = appbase.get_levelled_attributes(refObj)>
    <#list refObjLevelledAttrs as levelledAttr>  
      <#assign typename = appbase.type_attribute_as_argument(levelledAttr)>
      <#if typename == 'const char*'>
  binds[${attrIndex}].buffer_type = MYSQL_TYPE_STRING;
  binds[${attrIndex}].buffer = (char *) buff_${attr.name}_${levelledAttr.name};
  binds[${attrIndex}].buffer_length = 2048;
      <#else>
  binds[${attrIndex}].buffer_type = MYSQL_TYPE_LONG;
  binds[${attrIndex}].buffer = (int *) &buff_${attr.name}_${levelledAttr.name};
      </#if>
  binds[${attrIndex}].length = &bindlens[${attrIndex}];  
  binds[${attrIndex}].is_null = &is_nulls[${attrIndex}];  
      <#assign attrIndex = attrIndex + 1>
    </#list>
  </#list>
  binds[${attrIndex}].buffer_type = MYSQL_TYPE_LONG;
  binds[${attrIndex}].buffer = (int *) &buff_reserved;
  binds[${attrIndex}].length = &bindlens[${attrIndex}];  

  mysql_stmt_bind_result(stmt, binds);
  if (res) 
  {
    sprintf(errmsg, "%s", mysql_stmt_error(stmt));
    goto RELEASE;
  }
  while (!mysql_stmt_fetch(stmt))
  {
    gfc_map_p obj = gfc_map_new();
  <#list obj.attributes as attr>
    <#assign typename = appbase.type_attribute_as_argument(attr)>
    if (!is_nulls[${attr?index}])
    {
    <#if typename == 'const char*'>
      if (buff_${attr.name}[0] != '\0')
      {
        void* ptr = (void*) strdup(buff_${attr.name});
        gfc_map_put(obj, "${js.nameVariable(modelbase.get_attribute_sql_name(attr))}", ptr);
      }
    <#else>
      int* val = malloc(sizeof(int));
      *val = buff_${attr.name};
      gfc_map_put(obj, "${js.nameVariable(modelbase.get_attribute_sql_name(attr))}", (void*) val);
    </#if>
    }
  </#list>
  <#assign attrIndex = obj.attributes?size>
  <#assign refObjs = appbase.get_reference_objects(obj)>
  <#list refObjs as attrname, refObj>
    <#assign attr = model.findAttributeByNames(obj.name, attrname)>
    <#assign refObjLevelledAttrs = appbase.get_levelled_attributes(refObj)>
    <#list refObjLevelledAttrs as levelledAttr>  
    if (!is_nulls[${attrIndex}])
    {
    <#if typename == 'const char*'>
      if (buff_${attr.name}_${levelledAttr.name}[0] != '\0')
      {
        void* ptr = (void*) strdup(buff_${attr.name}_${levelledAttr.name});
        gfc_map_put(obj, "${js.nameVariable(attr.name)}${js.nameType(js.nameType(levelledAttr.name))}", ptr);
      }
    <#else>
      int* val = malloc(sizeof(int));
      *val = buff_${attr.name}_${levelledAttr.name};
      gfc_map_put(obj, "${js.nameVariable(attr.name)}${js.nameType(levelledAttr.name)}", (void*) val);
    </#if>
    }
      <#assign attrIndex = attrIndex + 1>
    </#list>
  </#list>  
    gfc_list_append(list, obj);
  }

RELEASE: 

  mysql_stmt_free_result(stmt);
  mysql_stmt_close(stmt);
  gfc_string_free(sql);
  
  int rc;
  if (params != NULL)
  {
    rc = gfc_gc_free(params);
    assert(rc == GFC_GC_OK);
  }
  if (lengths != NULL)
  {
    rc = gfc_gc_free(lengths);
    assert(rc == GFC_GC_OK);
  }

  return res;
}

</#list>