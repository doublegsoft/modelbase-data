<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:smbiz/model/dto.dart';
import 'package:smbiz/sdk/remote.dart';

void main() {
<#list model.objects as obj>

  group('【${modelbase.get_object_label(obj)}】', () {
    test('保存【${obj.name}】', () async {
      try {
        String json = '''
{
<#list obj.attributes as attr>
  "${modelbase.get_attribute_sql_name(attr)}":${modelbase.get_attribute_json_value(attr)},
</#list>
  "0":0
}        
''';
        Map<String, dynamic> jsonObj = jsonDecode(json);
        ${java.nameType(obj.name)}Query query = ${java.nameType(obj.name)}Query.from(jsonObj);
        // await save${java.nameType(obj.name)}(query: query,);
      } catch (ex) {
        print(ex);
        expect(true, false, reason: '保存【${modelbase.get_object_label(obj)}】失败');
      }
    });
  });
</#list>  
}