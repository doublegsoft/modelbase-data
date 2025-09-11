<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:${app.name}/common/db.dart';
import 'package:${app.name}/model/dto.dart';
import 'package:${app.name}/model/poco.dart';

void main() async {

  TestWidgetsFlutterBinding.ensureInitialized();
  
  try {
    final file = File('.dart_tool/sqflite_common_ffi/databases/${app.name}.db');
    await file.delete();
  } catch (err) {

  }
  
<#list model.objects as obj>
  <#if !obj.persistenceName??><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  
  group('【${modelbase.get_object_label(obj)}】的本地数据库操作', () {
    test('保存【${modelbase.get_object_label(obj)}】', () async {
      databaseFactory = databaseFactoryFfi;
      ${dart.nameType(app.name)}Database db = ${dart.nameType(app.name)}Database.instance;
      ${dart.nameType(obj.name)}Query query = ${dart.nameType(obj.name)}Query();
  <#list obj.attributes as attr>
    <#if !attr.persistenceName??><#continue></#if>
      query.${modelbase.get_attribute_sql_name(attr)} = ${modelbase4dart.get_attribute_value_as_code(attr)};
  </#list>       
      await db.save${dart.nameType(obj.name)}(query);
    });
    
    test('查找【${modelbase.get_object_label(obj)}】', () async {
      databaseFactory = databaseFactoryFfi;
      ${dart.nameType(app.name)}Database db = ${dart.nameType(app.name)}Database.instance;
      ${dart.nameType(obj.name)}Query query = ${dart.nameType(obj.name)}Query();   
      List<${dart.nameType(obj.name)}Query> rows = await db.find${dart.nameType(inflector.pluralize(obj.name))}(query);
    });
    
    test('删除【${modelbase.get_object_label(obj)}】', () async {
      databaseFactory = databaseFactoryFfi;
      ${dart.nameType(app.name)}Database db = ${dart.nameType(app.name)}Database.instance;
      ${dart.nameType(obj.name)}Query query = ${dart.nameType(obj.name)}Query();
  <#list idAttrs as idAttr>
      query.${modelbase.get_attribute_sql_name(idAttr)} = ${modelbase4dart.get_attribute_value_as_code(idAttr)};
  </#list>      
      await db.remove${dart.nameType(obj.name)}(query);
    });
  });
</#list>  
}