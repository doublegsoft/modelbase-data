<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:smbiz/model/dto.dart';
<#list model.objects as obj>
import 'package:smbiz/provider/${obj.name}_provider.dart';
</#list>

void main() {
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  
  group('【${modelbase.get_object_label(obj)}】数据提供器', () {
    ${dart.nameType(obj.name)}Provider provider = ${dart.nameType(obj.name)}Provider();
    test('编辑【${obj.name}】对象加载', () async {
  <#list idAttrs as idAttr>
    <#if idAttr.type.name == 'datetime'><#continue></#if>
      ${modelbase4dart.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)} = ${modelbase4dart.get_attribute_value_as_code(idAttr)};
  </#list>     
      expect(provider.editing${dart.nameType(obj.name)}, isNull);
      await provider.fetch${dart.nameType(obj.name)}(
  <#list idAttrs as idAttr>
    <#if idAttr.type.name == 'datetime'><#continue></#if>
        ${modelbase.get_attribute_sql_name(idAttr)}: ${modelbase.get_attribute_sql_name(idAttr)},
  </#list>    
      );
      expect(provider.editing${dart.nameType(obj.name)}, isNotNull);
    });
    test('列表【${obj.name}】对象加载', () async {
      expect(provider.listed${inflector.pluralize(dart.nameType(obj.name))}.length, equals(0));
      ${dart.nameType(obj.name)}Query query = ${dart.nameType(obj.name)}Query();
      bool fetched = await provider.fetch${inflector.pluralize(dart.nameType(obj.name))}(
        query: query,
      );
      /// 必须还有更多
      expect(fetched, equals(true)); 
      expect(provider.listed${inflector.pluralize(dart.nameType(obj.name))}.length, equals(10));
      fetched = await provider.fetch${inflector.pluralize(dart.nameType(obj.name))}(
        query: query,
      );
      /// 必须还有更多
      expect(fetched, equals(true)); 
      expect(provider.listed${inflector.pluralize(dart.nameType(obj.name))}.length, equals(20));
      fetched = await provider.fetch${inflector.pluralize(dart.nameType(obj.name))}(
        query: query,
      );
      /// 必须还有更多
      expect(fetched, equals(true)); 
      expect(provider.listed${inflector.pluralize(dart.nameType(obj.name))}.length, equals(30));
      // 下拉刷新
      fetched = await provider.fetch${inflector.pluralize(dart.nameType(obj.name))}(
        query: query,
        reload: true,
      );
      /// 必须还有更多
      expect(fetched, equals(true)); 
      expect(provider.listed${inflector.pluralize(dart.nameType(obj.name))}.length, equals(10));
    });
  });
</#list>  
}