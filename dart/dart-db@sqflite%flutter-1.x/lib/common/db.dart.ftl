<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;

import '/model/dto.dart';
import 'safe.dart';

<#list model.objects as obj>
  <#assign idAttrs = []>
  <#assign nonIdAttrs = []>
  <#list obj.attributes as attr>
    <#if attr.persistenceName??>
      <#if attr.identifiable>
        <#assign idAttrs = idAttrs + [attr]>
      <#else>
        <#assign nonIdAttrs = nonIdAttrs + [attr]>
      </#if>
    </#if>
  </#list>
  <#assign extObjs = modelbase.get_extension_objects(obj)>
  <#assign refObjs = {}>
  <#-- 在此对象中，搜集所有直接引用的对象 -->
  <#list obj.attributes as attr>
    <#-- 主键关联，会自然带入，无需额外操作 -->
    <#if !attr.type.custom || attr.identifiable><#continue></#if>
    <#assign refObj = model.findObjectByName(attr.type.name)>
    <#assign refObjAttrs = []>
    <#list refObj.attributes as refObjAttr>
      <#if refObjAttr.type.name == 'name' || refObjAttr.name == 'name'>
        <#assign refObjAttrs += [refObjAttr]>
      <#elseif refObjAttr.isLabelled("listable")>  
        <#assign refObjAttrs += [refObjAttr]>
      </#if>
    </#list>
    <#if (refObjAttrs?size > 0)>
      <#assign refObjs = refObjs + {attr: {'obj': refObj, 'attrs': refObjAttrs, 'attr': attr}}>
    </#if>
  </#list>
  <#if !obj.persistenceName??><#continue></#if>

const String sqlSelect${dart.nameType(obj.name)} = '''
select
  <#list idAttrs as attr>
  ${attr.persistenceName},
  </#list>
  <#list nonIdAttrs as attr>
  ${attr.persistenceName},
  </#list>    
  0  
from ${obj.persistenceName}
where 1 = 1
''';  
</#list>

class ${dart.nameType(app.name)}Database {

  static final ${dart.nameType(app.name)}Database instance = ${dart.nameType(app.name)}Database._internal();

  static Database? _database;

  ${dart.nameType(app.name)}Database._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _open();
    return _database!;
  }

  Future<Database> _open() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, '${app.name}.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        final sql = await rootBundle.loadString('asset/sql/install-database-sqlite.sql');
        await db.execute(sql);
      },
    );
  }
  
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
<#list model.objects as obj>
  <#if !obj.persistenceName??><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  
  ///
  /// 保存【${modelbase.get_object_label(obj)}】
  ///
  Future<void> save${dart.nameType(obj.name)}(${dart.nameType(obj.name)}Query query) async {
    final db = await instance.database;
    await db.insert(
       '${obj.persistenceName}',
       query.sql(),
       conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  ///
  /// 读取【${modelbase.get_object_label(obj)}】
  ///
  Future<${dart.nameType(obj.name)}Query?> read${dart.nameType(obj.name)}(${dart.nameType(obj.name)}Query query) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(sqlSelect${dart.nameType(obj.name)});
    if (maps.length == 0) {
      return null;
    }
    return ${dart.nameType(obj.name)}Query(
  <#list obj.attributes as attr>      
    <#if attr.type.collection><#continue></#if>
    <#if attr.type.name == "int" || attr.type.name == "integer" || attr.type.name == "long">
      ${modelbase.get_attribute_sql_name(attr)}: Safe.safeInt(maps[0]['${modelbase.get_attribute_sql_name(attr)}']),
    <#elseif attr.type.name == "number">
      ${modelbase.get_attribute_sql_name(attr)}: Safe.safeDouble(maps[0]['${modelbase.get_attribute_sql_name(attr)}']),    
    <#elseif attr.type.name == "date" || attr.type.name == "datetime">
      ${modelbase.get_attribute_sql_name(attr)}: Safe.safeDateTime(maps[0]['${modelbase.get_attribute_sql_name(attr)}']),
    <#else>
      ${modelbase.get_attribute_sql_name(attr)}: maps[0]['${modelbase.get_attribute_sql_name(attr)}'],
    </#if>    
  </#list>
    );
  }
  
  ///
  /// 查找【${modelbase.get_object_label(obj)}】
  ///
  Future<List<${dart.nameType(obj.name)}Query>> find${dart.nameType(inflector.pluralize(obj.name))}(${dart.nameType(obj.name)}Query query) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(sqlSelect${dart.nameType(obj.name)});
    return List.generate(maps.length, (i) {
      return ${dart.nameType(obj.name)}Query(
  <#list obj.attributes as attr>      
    <#if attr.type.collection><#continue></#if>
    <#if attr.type.name == "int" || attr.type.name == "integer" || attr.type.name == "long">
        ${modelbase.get_attribute_sql_name(attr)}: Safe.safeInt(maps[i]['${modelbase.get_attribute_sql_name(attr)}']),
    <#elseif attr.type.name == "number">
        ${modelbase.get_attribute_sql_name(attr)}: Safe.safeDouble(maps[i]['${modelbase.get_attribute_sql_name(attr)}']),    
    <#elseif attr.type.name == "date" || attr.type.name == "datetime">
        ${modelbase.get_attribute_sql_name(attr)}: Safe.safeDateTime(maps[i]['${modelbase.get_attribute_sql_name(attr)}']),
    <#else>
        ${modelbase.get_attribute_sql_name(attr)}: maps[i]['${modelbase.get_attribute_sql_name(attr)}'],
    </#if>    
  </#list>
      );
    });
  }
  
  ///
  /// 删除【${modelbase.get_object_label(obj)}】
  ///
  Future<int> remove${dart.nameType(obj.name)}(${dart.nameType(obj.name)}Query query) async {
    final db = await instance.database;
    return await db.delete(
      '${obj.persistenceName}',
      where: '<#list idAttrs as idAttr><#if idAttr?index != 0> and </#if>${idAttr.persistenceName} = ?</#list>',
      whereArgs: [
  <#list idAttrs as idAttr>
    <#if idAttr.type.name == "date" || idAttr.type.name == "datetime">
        DateFormat('yyyy-MM-dd HH:mm:ss').format(query.${modelbase.get_attribute_sql_name(idAttr)}!),
    <#else>
        query.${modelbase.get_attribute_sql_name(idAttr)},
    </#if>
   </#list>
      ],
    );
  }
</#list>
}