<#import "/$/modelbase.ftl" as modelbase>
<#if license??>
${dart.license(license)}
</#if>
// ignore_for_file: unused_import
import 'base.dart';

import '/model/dto.dart';
import 'memory.dart' as memory;
import 'local.dart' as local;
import 'remote.dart' as remote;

export 'base.dart';
export 'options.dart';
export 'optionx.dart';

enum DataState { idle, loading, success, error }

// 编译环境变量
const String _env = String.fromEnvironment('ENV', defaultValue: 'remote');
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>

final Save${dart.nameType(modelbase.get_object_plural(obj))}Fn save${dart.nameType(modelbase.get_object_plural(obj))} = switch (_env) {
  'memory' => memory.save${dart.nameType(modelbase.get_object_plural(obj))},
  'local'  => local.save${dart.nameType(modelbase.get_object_plural(obj))},
  _        => remote.save${dart.nameType(modelbase.get_object_plural(obj))},
};

final Save${dart.nameType(obj.name)}Fn save${dart.nameType(obj.name)} = switch (_env) {
  'memory' => memory.save${dart.nameType(obj.name)},
  'local'  => local.save${dart.nameType(obj.name)},
  _        => remote.save${dart.nameType(obj.name)},
};

final Read${dart.nameType(obj.name)}Fn read${dart.nameType(obj.name)} = switch (_env) {
  'memory' => memory.read${dart.nameType(obj.name)},
  'local'  => local.read${dart.nameType(obj.name)},
  _        => remote.read${dart.nameType(obj.name)},
};

final Find${dart.nameType(modelbase.get_object_plural(obj))}Fn find${dart.nameType(modelbase.get_object_plural(obj))} = switch (_env) {
  'memory' => memory.find${dart.nameType(modelbase.get_object_plural(obj))},
  'local'  => local.find${dart.nameType(modelbase.get_object_plural(obj))},
  _        => remote.find${dart.nameType(modelbase.get_object_plural(obj))},
};

final Delete${dart.nameType(obj.name)}Fn delete${dart.nameType(obj.name)} = switch (_env) {
  'memory' => memory.delete${dart.nameType(obj.name)},
  'local'  => local.delete${dart.nameType(obj.name)},
  _        => remote.delete${dart.nameType(obj.name)},
};
</#list>