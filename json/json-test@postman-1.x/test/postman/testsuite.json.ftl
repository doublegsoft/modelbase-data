<#import '/$/modelbase.ftl' as modelbase>
<#import "/$/modelbase4json.ftl" as modelbase4json>
<#assign UUID = statics['java.util.UUID']>
<#function get_object_json_raw obj>
  <#local ret = "{\\n">
  <#list obj.attributes as attr>
    <#if !attr.persistenceName??><#continue></#if>
    <#if modelbase.is_attribute_system(attr)><#continue></#if>
    <#if attr.identifiable>
      <#local ret += "  \\\"" + modelbase.get_attribute_sql_name(attr) + "\\\":\\\"" + modelbase4json.test_json_value(attr)?replace("\"","") + "\\\",\\n">
    <#else>
      <#local ret += "  \\\"" + modelbase.get_attribute_sql_name(attr) + "\\\":" + modelbase4json.test_json_value(attr)?replace("\"","\\\"") + ",\\n">
    </#if>
  </#list>
  <#local ret = ret?substring(0,ret?length - 3)>
  <#local ret += "\\n}">
  <#return ret>
</#function>
<#function get_object_and_child_json_raw obj attr>
  <#local collObj = model.findObjectByName(attr.type.componentType.name)>
  <#local ret = "{\\n">
  <#list obj.attributes as attr>
    <#if !attr.persistenceName??><#continue></#if>
    <#if attr.identifiable>
      <#local ret += "  \\\"" + modelbase.get_attribute_sql_name(attr) + "\\\":\\\"" + modelbase4json.test_json_value(attr)?replace("\"","") + "\\\",\\n">
    <#else>
      <#local ret += "  \\\"" + modelbase.get_attribute_sql_name(attr) + "\\\":" + modelbase4json.test_json_value(attr)?replace("\"","\\\"") + ",\\n">
    </#if>
  </#list>
  <#local ret += "  \\\"" + java.nameVariable(attr.name) + "\\\":[\\n">
  <#local ret += get_object_json_raw(collObj)>
  <#local ret += ",">
  <#local ret += get_object_json_raw(collObj)>
  <#local ret += "]\\n}">
  <#return ret>
</#function>
{
  "info": {
    "_postman_id": "${UUID.randomUUID()?string}",
    "name": "${app.name}",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json",
    "_exporter_id": "6085668"
  },
  "item": [
<#list model.objects as obj>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
    {
      "name": "【${modelbase.get_object_label(obj)}】保存",
      "event": [{
        "listen": "test",
        "script": {
          "exec": [
            "pm.test(\"Successful POST request\", function () {",
            "  pm.expect(pm.response.code).to.be.oneOf([200]);",
            "});"
          ],
          "type": "text/javascript",
          "packages": {}
        }
      }],
      "request": {
        "method": "POST",
        "header": [],
        "body": {
          "mode": "raw",
          "raw": "${get_object_json_raw(obj)}",
          "options": {
            "raw": {
              "language": "json"
            }
          }
        },
        "url": {
          "raw": "http://{{host}}:{{port}}/${app.name}/${obj.name}/save",
          "protocol": "http",
          "host": [
            "{{host}}"
          ],
          "port": "{{port}}",
          "path": [
            "${app.name}",
            "${obj.name}",
            "save"
          ]
        }
      },   
      "response": []
    },
  <#list obj.attributes as attr>
    <#if !attr.type.collection><#continue></#if>
    {
      "name": "【${modelbase.get_object_label(obj)}】保存（包含【${modelbase.get_attribute_label(attr)}】子集）",
      "event": [{
        "listen": "test",
        "script": {
          "exec": [
            "pm.test(\"Successful POST request\", function () {",
            "  pm.expect(pm.response.code).to.be.oneOf([200]);",
            "});"
          ],
          "type": "text/javascript",
          "packages": {}
        }
      }],
      "request": {
        "method": "POST",
        "header": [],
        "body": {
          "mode": "raw",
          "raw": "${get_object_and_child_json_raw(obj,attr)}",
          "options": {
            "raw": {
              "language": "json"
            }
          }
        },
        "url": {
          "raw": "http://{{host}}:{{port}}/${app.name}/${obj.name}/save",
          "protocol": "http",
          "host": [
            "{{host}}"
          ],
          "port": "{{port}}",
          "path": [
            "${app.name}",
            "${obj.name}",
            "save"
          ]
        }
      },   
      "response": []
    },
  </#list>    
    {
      "name": "【${modelbase.get_object_label(obj)}】修改",
      "event": [{
        "listen": "test",
        "script": {
          "exec": [
            "pm.test(\"Successful POST request\", function () {",
            "  pm.expect(pm.response.code).to.be.oneOf([200]);",
            "});"
          ],
          "type": "text/javascript",
          "packages": {}
        }
      }],
      "request": {
        "method": "PATCH",
        "header": [],
        "body": {
          "mode": "raw",
          "raw": "${get_object_json_raw(obj)}",
          "options": {
            "raw": {
              "language": "json"
            }
          }
        },
        "url": {
          "raw": "http://{{host}}:{{port}}/${app.name}/${obj.name}/modify",
          "protocol": "http",
          "host": [
            "{{host}}"
          ],
          "port": "{{port}}",
          "path": [
            "${app.name}",
            "${obj.name}",
            "modify"
          ]
        }
      },   
      "response": []
    },
  <#list obj.attributes as attr>
    <#if !attr.type.collection><#continue></#if>
    <#assign collObj = model.findObjectByName(attr.type.componentType.name)>
    <#list collObj.attributes as collObjAttr>
      <#if collObjAttr.type.name == obj.name>
        <#assign refAttrInCollObj = collObjAttr>
     <#elseif collObjAttr.type.custom>
        <#-- 另外的引用对象 -->
        <#assign otherRefAttrInCollObj = collObjAttr>
      </#if>
    </#list>
    {
      "name": "【${modelbase.get_object_label(obj)}】查询（同时返回【${modelbase.get_object_label(collObj)}】子集}）",
      "event": [{
        "listen": "test",
        "script": {
          "exec": [
            "pm.test(\"Successful POST request\", function () {",
            "  pm.expect(pm.response.code).to.be.oneOf([200]);",
            "});"
          ],
          "type": "text/javascript",
          "packages": {}
        }
      }],
      "request": {
        "method": "POST",
        "header": [],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"queryHandlers\": [{\n    \"handler\":\"//${collObj.name}/find\",\n    \"sourceField\":\"${modelbase.get_attribute_sql_name(idAttrs[0])}\",\n    \"targetField\":\"${modelbase.get_attribute_sql_name(refAttrInCollObj)}\",\n    \"resultName\":\"${java.nameVariable(inflector.pluralize(collObj.name))}\",\n    \"query\":{}\n  }]\n}",
          "options": {
            "raw": {
              "language": "json"
            }
          }
        },
        "url": {
          "raw": "http://{{host}}:{{port}}/${app.name}/${obj.name}/find",
          "protocol": "http",
          "host": [
            "{{host}}"
          ],
          "port": "{{port}}",
          "path": [
            "${app.name}",
            "${obj.name}",
            "find"
          ]
        }
      },   
      "response": []
    },
    <#if otherRefAttrInCollObj??>
      <#assign otherRefObj = model.findObjectByName(otherRefAttrInCollObj.type.name)>
      <#assign otherRefObjIdAttr = modelbase.get_id_attributes(otherRefObj)[0]>
    {
      "name": "【${modelbase.get_object_label(obj)}】查询（把【${modelbase.get_object_label(otherRefObj)}】作为查询条件}）",
      "event": [{
        "listen": "test",
        "script": {
          "exec": [
            "pm.test(\"Successful POST request\", function () {",
            "  pm.expect(pm.response.code).to.be.oneOf([200]);",
            "});"
          ],
          "type": "text/javascript",
          "packages": {}
        }
      }],
      "request": {
        "method": "POST",
        "header": [],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"in${java.nameType(inflector.pluralize(otherRefObj.name))}\":{\"${modelbase.get_attribute_sql_name(otherRefObjIdAttr)}\":\"123456\"},\n\"queryHandlers\": [{\n    \"handler\":\"//${collObj.name}/find\",\n    \"sourceField\":\"${modelbase.get_attribute_sql_name(idAttrs[0])}\",\n    \"targetField\":\"${modelbase.get_attribute_sql_name(refAttrInCollObj)}\",\n    \"resultName\":\"${java.nameVariable(inflector.pluralize(collObj.name))}\",\n    \"query\":{}\n  }]\n}",
          "options": {
            "raw": {
              "language": "json"
            }
          }
        },
        "url": {
          "raw": "http://{{host}}:{{port}}/${app.name}/${obj.name}/find",
          "protocol": "http",
          "host": [
            "{{host}}"
          ],
          "port": "{{port}}",
          "path": [
            "${app.name}",
            "${obj.name}",
            "find"
          ]
        }
      },   
      "response": []
    },
    </#if>
  </#list>     
</#list>    
    {
      "name": "空白占位",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "http://{{host}}:{{port}}/${app.name}/${model.objects[0].name}/read",
          "protocol": "http",
          "host": [
            "{{host}}"
          ],
          "port": "{{port}}",
          "path": [
            "${app.name}",
            "${model.objects[0].name}",
            "read"
          ]
        }
      },
      "response": []
    }
  ],
  "auth": {
    "type": "apikey",
    "apikey": [
      {
        "key": "key",
        "value": "Authorization",
        "type": "string"
      },
      {
        "key": "value",
        "value": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJsb2dpbl90aW1lIjoxNzM4ODM0NzEwODYyLCJsb2dpbl91c2VyX2tleSI6Njk2MDkxOTc4NjM1Mjg0NDgwfQ.T_Isr3ETNV6QD7A3hX05Ly0vzdTXSVWkimghEYOPOQK0-f2Z2D87QKyNxiho74iDXJZAl0FlYcEcZs6PQDeBiw",
        "type": "string"
      }
    ]
  },
  "event": [
    {
      "listen": "prerequest",
      "script": {
        "type": "text/javascript",
        "packages": {},
        "exec": [
          ""
        ]
      }
    },
    {
      "listen": "test",
      "script": {
        "type": "text/javascript",
        "packages": {},
        "exec": [
          ""
        ]
      }
    }
  ],
  "variable": [
    {
      "key": "host",
      "value": "localhost",
      "type": "string"
    },
    {
      "key": "port",
      "value": "8810",
      "type": "string"
    }
  ]
}