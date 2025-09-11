<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
import 'dart:core';
import 'package:bloc/bloc.dart';

import 'poco.dart';
import '/${app.name}/sdk/remote.dart' as sdk;
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  
///
/// 【${modelbase.get_object_label(obj)}】抽象状态。
///
class ${dart.nameType(obj.name)}State {
  ${dart.nameType(obj.name)}State();
}

///
/// 【${modelbase.get_object_label(obj)}】初始状态。
///
class ${dart.nameType(obj.name)}InitialState extends ${dart.nameType(obj.name)}State {}

///
/// 【${modelbase.get_object_label(obj)}】错误状态。
///
class ${dart.nameType(obj.name)}ErrorState extends ${dart.nameType(obj.name)}State {
  
  final int code;
  
  final String message;

  ${dart.nameType(obj.name)}ErrorState({
    required this.code,
    required this.message,
  });
  
}

///
/// 【${modelbase.get_object_label(obj)}】读取完成状态。
///
class ${dart.nameType(obj.name)}ReadState extends ${dart.nameType(obj.name)}State {

  final ${dart.nameType(obj.name)}? ${dart.nameVariable(obj.name)};

  ${dart.nameType(obj.name)}ReadState({
    required this.${dart.nameVariable(obj.name)},
  });
}

///
/// 【${modelbase.get_object_label(obj)}】保存成功状态。
///
class ${dart.nameType(obj.name)}SavedState extends ${dart.nameType(obj.name)}State {

  final ${dart.nameType(obj.name)} ${dart.nameVariable(obj.name)};
  
  ${dart.nameType(obj.name)}SavedState({
    required this.${dart.nameVariable(obj.name)},
  });
}

///
/// 【${modelbase.get_object_label(obj)}】正在加载状态。
///
class ${dart.nameType(obj.name)}LoadingState extends ${dart.nameType(obj.name)}State {}

///
/// 【${modelbase.get_object_label(obj)}】正在更新状态。
///
class ${dart.nameType(obj.name)}UpdatingState extends ${dart.nameType(obj.name)}State {}

///
/// 【${modelbase.get_object_label(obj)}】加载完成状态。
///
class ${dart.nameType(obj.name)}LoadedState extends ${dart.nameType(obj.name)}State {

  final List<${dart.nameType(obj.name)}> ${dart.nameVariable(modelbase.get_object_plural(obj))};
  
  final bool hasReachedMax;

  ${dart.nameType(obj.name)}LoadedState({
    required this.${dart.nameVariable(modelbase.get_object_plural(obj))},
    this.hasReachedMax = false,
  });
}

///
/// 【${modelbase.get_object_label(obj)}】抽象事件。
///
class ${dart.nameType(obj.name)}Event {}

///
/// 【${modelbase.get_object_label(obj)}】初始化事件。
///
class ${dart.nameType(obj.name)}InitEvent extends ${dart.nameType(obj.name)}Event {

}

///
/// 【${modelbase.get_object_label(obj)}】加载事件。
///
class ${dart.nameType(obj.name)}LoadEvent extends ${dart.nameType(obj.name)}Event {
  
  final int start;
  
  final int limit;
  
  final Map<String,dynamic> params;
  
  ///
  /// 静默加载，不产生加载状态
  ///
  final bool silent;
  
  ${dart.nameType(obj.name)}LoadEvent({
    required this.start,
    this.limit = 15,
    this.params = const {},
    this.silent = false,
  });
  
}

///
/// 【${modelbase.get_object_label(obj)}】读取事件。
///
class ${dart.nameType(obj.name)}ReadEvent extends ${dart.nameType(obj.name)}Event {
  <#list idAttrs as idAttr>
  
  ///
  /// 【${modelbase.get_attribute_label(idAttr)}】
  ///
  final ${modelbase4dart.get_native_type_name(idAttr.type)}? ${modelbase.get_attribute_sql_name(idAttr)};
  </#list>
  
  ${dart.nameType(obj.name)}ReadEvent({
  <#list idAttrs as idAttr>
    required this.${modelbase.get_attribute_sql_name(idAttr)},
  </#list> 
  });
}

///
/// 【${modelbase.get_object_label(obj)}】保存事件。
///
class ${dart.nameType(obj.name)}SaveEvent extends ${dart.nameType(obj.name)}Event {

  final ${dart.nameType(obj.name)} ${dart.nameVariable(obj.name)};
  
  ${dart.nameType(obj.name)}SaveEvent({
    required this.${dart.nameVariable(obj.name)},
  });
}

///
/// 【${modelbase.get_object_label(obj)}】删除事件。
///
class ${dart.nameType(obj.name)}RemoveEvent extends ${dart.nameType(obj.name)}Event {
  <#list idAttrs as idAttr>
  
  ///
  /// 【${modelbase.get_attribute_label(idAttr)}】
  ///
  final ${modelbase4dart.get_native_type_name(idAttr.type)} ${modelbase.get_attribute_sql_name(idAttr)};
  </#list>
  
  ${dart.nameType(obj.name)}RemoveEvent({
  <#list idAttrs as idAttr>
    required this.${modelbase.get_attribute_sql_name(idAttr)},
  </#list> 
  });
}

///
/// 【${modelbase.get_object_label(obj)}】业务组件。
///
class ${dart.nameType(obj.name)}Bloc extends Bloc<${dart.nameType(obj.name)}Event, ${dart.nameType(obj.name)}State> {
  
  ///
  /// 已经加载的【${modelbase.get_object_label(obj)}】对象数据，通常用于集合显示。
  ///
  List<${dart.nameType(obj.name)}> loaded${dart.nameType(inflector.pluralize(obj.name))} = [];
  
  ${dart.nameType(obj.name)}Bloc(super.initialState) {
  
    on<${dart.nameType(obj.name)}InitEvent>((event, emit) async {
      emit(${dart.nameType(obj.name)}InitialState());
    });
  
    on<${dart.nameType(obj.name)}SaveEvent>((event, emit) async {
      emit(${dart.nameType(obj.name)}UpdatingState());
      try {
        ${dart.nameType(obj.name)} ${dart.nameVariable(obj.name)} = await sdk.save${dart.nameType(obj.name)}(event.${dart.nameVariable(obj.name)});
        emit(${dart.nameType(obj.name)}SavedState(
          ${dart.nameVariable(obj.name)}: ${dart.nameVariable(obj.name)},
        ));
      } on ${dart.nameType(app.name)}Exception catch (ex) {
        emit(${dart.nameType(obj.name)}ErrorState(
          code: ex.code,
          message: ex.message,
        ));
      }
    });
    
    on<${dart.nameType(obj.name)}ReadEvent>((event, emit) async {
      <#list idAttrs as idAttr>
      if (event.${modelbase.get_attribute_sql_name(idAttr)} == null) {
        return;
      }
      </#list>
      emit(${dart.nameType(obj.name)}LoadingState());
      try {
        ${dart.nameType(obj.name)}? ${dart.nameVariable(obj.name)} = await sdk.read${dart.nameType(obj.name)}(
  <#list idAttrs as idAttr>
        ${modelbase.get_attribute_sql_name(idAttr)}: event.${modelbase.get_attribute_sql_name(idAttr)}!,
  </#list>    
      );
        emit(${dart.nameType(obj.name)}ReadState(
          ${dart.nameVariable(obj.name)}: ${dart.nameVariable(obj.name)},
        ));
      } on ${dart.nameType(app.name)}Exception catch (ex) {
        emit(${dart.nameType(obj.name)}ErrorState(
          code: ex.code,
          message: ex.message,
        ));
      }
    });
    
    on<${dart.nameType(obj.name)}LoadEvent>((event, emit) async {
      if (!event.silent) {
        emit(${dart.nameType(obj.name)}LoadingState());
      }
      try {
        Map<String,dynamic> params = event.params;
        Pagination<${dart.nameType(obj.name)}> page = await sdk.load${dart.nameType(inflector.pluralize(obj.name))}(params);
        loaded${dart.nameType(inflector.pluralize(obj.name))}.addAll(page.data);
        emit(${dart.nameType(obj.name)}LoadedState(
          ${dart.nameVariable(modelbase.get_object_plural(obj))}: page.data,
        ));
      } on ${dart.nameType(app.name)}Exception catch (ex) {
        emit(${dart.nameType(obj.name)}ErrorState(
          code: ex.code,
          message: ex.message,
        ));
      }
    });
  }
}  
</#list>