<#import '/$/modelbase.ftl' as modelbase>
{
	"info": {
		"_postman_id": "39937f90-a595-4461-ab43-5dd1e07e89e3",
		"name": "${parentApplication}/${app.name} API测试",
		"schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
	},
	"item": [{
		"name": "${app.name}应用程序心跳测试",
		"request": {
			"url": {
				"raw": "http://localhost:8088/api/heartbeat",
				"protocol": "http",
				"host": ["localhost"],
				"port": "8088",
				"path": ["api","heartbeat"]
			},
			"method": "POST",
			"header": [{
				"key": "Content-Type",
				"value": "application/json",
				"type": "text"
			}],
			"body": {
				"mode": "raw",
				"raw": "{}"
			}
		},
		"response": []
<#list model.objects as obj>
	<#if obj.isLabelled('entity')>
	},{
		<#assign entity = obj>
		"name": "【${modelbase.get_object_label(entity)}】创建",
		"event": [{
			"listen": "test",
			"script": {
				"type": "text/javascript",
				"exec": [
					"pm.test('【${modelbase.get_object_label(entity)}】对象有标识返回', function () {",
					"  console.log(pm.response.json())",
					"  pm.response.to.not.have.jsonBody('error')",
					"})"
				]
			}
		}],
		"request": {
			"url": {
				"raw": "http://localhost:8088/api/v3/common/script",
				"protocol": "http",
				"host": ["localhost"],
				"port": "8088",
				"path": ["api","v3","common","script"]
			},
			"method": "POST",
			"header": [{
				"key": "Content-Type",
				"value": "application/json",
				"type": "text"
			},{
				"key": "usecase",
				"value": "${parentApplication}/${app.name}/${entity.name}/merge",
				"type": "text"
			}],
			"body": {
				"mode": "raw",
				"raw": {
	<#list entity.attributes as attr>
    			"${modelbase.get_attribute_sql_name(attr)}":${modelbase.get_attribute_json_value(attr)},
	</#list>
    			"0":"0"
				}
			}
		},
		"response": []
	},{
		"name": "【${modelbase.get_object_label(entity)}】更新",
		"event": [{
			"listen": "test",
			"script": {
				"type": "text/javascript",
				"exec": [
					"pm.test('【${modelbase.get_object_label(entity)}】更新没有错误', function () {",
					"  console.log(pm.response.json())",
					"  pm.response.to.not.have.jsonBody('error')",
					"})"
				]
			}
		}],
		"request": {
			"url": {
				"raw": "http://localhost:8088/api/v3/common/script",
				"protocol": "http",
				"host": ["localhost"],
				"port": "8088",
				"path": ["api","v3","common","script"]
			},
			"method": "POST",
			"header": [{
				"key": "Content-Type",
				"value": "application/json",
				"type": "text"
			},{
				"key": "usecase",
				"value": "${parentApplication}/${app.name}/${entity.name}/save",
				"type": "text"
			}],
			"body": {
				"mode": "raw",
				"raw": {
	<#list entity.attributes as attr>
    			"${modelbase.get_attribute_sql_name(attr)}":${modelbase.get_attribute_json_value(attr)},
	</#list>
    			"0":"0"
				}
			}
		},
		"response": []
	},{
		"name": "【${modelbase.get_object_label(entity)}】读取",
		"event": [{
			"listen": "test",
			"script": {
				"type": "text/javascript",
				"exec": [
					"pm.test('【${modelbase.get_object_label(entity)}】对象能够返回数据', function () {",
					"  console.log(pm.response.json())",
					"  pm.response.to.not.have.jsonBody('error')",
					"})"
				]
			}
		}],
		"request": {
			"url": {
				"raw": "http://localhost:8088/api/v3/common/script",
				"protocol": "http",
				"host": ["localhost"],
				"port": "8088",
				"path": ["api","v3","common","script"]
			},
			"method": "POST",
			"header": [{
				"key": "Content-Type",
				"value": "application/json",
				"type": "text"
			},{
				"key": "usecase",
				"value": "${parentApplication}/${app.name}/${entity.name}/read",
				"type": "text"
			}],
			"body": {
				"mode": "raw",
				"raw": {
	<#list entity.attributes as attr>
		<#if !attr.constraint.identifiable><#continue></#if>
    			"${modelbase.get_attribute_sql_name(attr)}":${modelbase.get_attribute_json_value(attr)},
	</#list>
    			"0":"0"
				}
			}
		},
		"response": []
	},{
		"name": "【${modelbase.get_object_label(entity)}】删除",
		"event": [{
			"listen": "test",
			"script": {
				"type": "text/javascript",
				"exec": [
					"pm.test('【${modelbase.get_object_label(entity)}】对象能够成功删除', function () {",
					"  console.log(pm.response.json())",
					"  pm.response.to.not.have.jsonBody('error')",
					"})"
				]
			}
		}],
		"request": {
			"url": {
				"raw": "http://localhost:8088/api/v3/common/script",
				"protocol": "http",
				"host": ["localhost"],
				"port": "8088",
				"path": ["api","v3","common","script"]
			},
			"method": "POST",
			"header": [{
				"key": "Content-Type",
				"value": "application/json",
				"type": "text"
			},{
				"key": "usecase",
				"value": "${parentApplication}/${app.name}/${entity.name}/delete",
				"type": "text"
			}],
			"body": {
				"mode": "raw",
				"raw": {
	<#list entity.attributes as attr>
		<#if !attr.constraint.identifiable><#continue></#if>
    			"${modelbase.get_attribute_sql_name(attr)}":${modelbase.get_attribute_json_value(attr)},
	</#list>
    			"0":"0"
				}
			}
		},
		"response": []
	<#--
	<#elseif obj.isLabelled('value')>
	},{
		<#assign value = obj>
	-->
	</#if>
</#list>
	}],
	"protocolProfileBehavior": {}
}
