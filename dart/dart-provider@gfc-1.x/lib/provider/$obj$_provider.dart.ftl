<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
import 'package:flutter/material.dart';

import '/model/dto.dart';
import '/sdk/sdk.dart' as sdk;
import '/common/error.dart';

class ${dart.nameType(obj.name)}Provider with ChangeNotifier {
  
  ///
  /// 数据加载状态
  ///
  sdk.DataState _state = sdk.DataState.idle;

  sdk.DataState get state => _state;
  
  ///
  /// 正在编辑的或者当前活跃【${modelbase.get_object_label(obj)}】对象。
  ///
  ${dart.nameType(obj.name)}Query? _criteriaForEditing;
  
  ${dart.nameType(obj.name)}Query? _editing${dart.nameType(obj.name)};
  
  ${dart.nameType(obj.name)}Query? get editing${dart.nameType(obj.name)} => _editing${dart.nameType(obj.name)};
  
  ///
  /// 当前条件下已经加载的【${modelbase.get_object_label(obj)}】对象集合。
  ///
  ${dart.nameType(obj.name)}Query? _criteriaForListing;
  
  List<${dart.nameType(obj.name)}Query> _listed${dart.nameType(inflector.pluralize(obj.name))} = [];
  
  List<${dart.nameType(obj.name)}Query> get listed${dart.nameType(inflector.pluralize(obj.name))} => _listed${dart.nameType(inflector.pluralize(obj.name))};
  
  int _countOf${dart.nameType(inflector.pluralize(obj.name))} = 0;
<#assign existingTops = {}>  
<#-- 可以广而告之的 -->
<#if obj.isLabelled("advertisable")>  
  <#assign count = obj.getLabelledOptions("advertisable")["count"]!"3">
  <#if !existingTops[count]??>
    <#assign existingTops += {count:count}>
    
  List<${dart.nameType(obj.name)}Query> _top${count}${dart.nameType(inflector.pluralize(obj.name))} = [];
  
  List<${dart.nameType(obj.name)}Query> get top${count}${dart.nameType(inflector.pluralize(obj.name))} => _top${count}${dart.nameType(inflector.pluralize(obj.name))};
  </#if>  
</#if>
<#if obj.isLabelled("browsable")>  
  <#assign count = "4">
  <#if !existingTops[count]??>
    <#assign existingTops += {count:count}>
  
  List<${dart.nameType(obj.name)}Query> _top${count}${dart.nameType(inflector.pluralize(obj.name))} = [];
  
  List<${dart.nameType(obj.name)}Query> get top${count}${dart.nameType(inflector.pluralize(obj.name))} => _top${count}${dart.nameType(inflector.pluralize(obj.name))}; 
  </#if> 
</#if>
<#if obj.isLabelled("verifiable")>
  
  ///
  /// 当前用户
  ///
  ${dart.nameType(obj.name)}Query _current${dart.nameType(obj.name)} = ${dart.nameType(obj.name)}Query();
  
  ${dart.nameType(obj.name)}Query get current${dart.nameType(obj.name)} => _current${dart.nameType(obj.name)};
</#if>
        
  ///
  /// 重置一切变量，以及已提供的数据。
  ///
  void reset() {
    _state = sdk.DataState.idle;
    _criteriaForEditing = null;
    _editing${dart.nameType(obj.name)} = null;
    _criteriaForListing = null;
    _listed${dart.nameType(inflector.pluralize(obj.name))} = [];
    _countOf${dart.nameType(inflector.pluralize(obj.name))} = 0;
  }
  
  ///
  /// 保存当前的编辑的【${modelbase.get_object_label(obj)}】对象。
  ///
  Future<${modelbase4dart.type_attribute_primitive(idAttrs[0])}?> save${dart.nameType(obj.name)}() async {
    if (_editing${dart.nameType(obj.name)} == null) {
      return null;
    }
    _state = sdk.DataState.loading;
    notifyListeners();
    try {
      _editing${dart.nameType(obj.name)} = await sdk.save${dart.nameType(obj.name)}(
        ${java.nameVariable(obj.name)}: _editing${dart.nameType(obj.name)}!,
      );
      _state = sdk.DataState.success;
      notifyListeners();
      return _editing${dart.nameType(obj.name)}!.${modelbase.get_attribute_sql_name(idAttrs[0])};
    } catch (ex) {
      handleError(ex);
    }
    return null;
  }
  
  ///
  /// 删除当前的编辑的【${modelbase.get_object_label(obj)}】对象。
  ///
  Future<void> remove${dart.nameType(obj.name)}() async {
    if (_editing${dart.nameType(obj.name)} == null) {
      return null;
    }
    _state = sdk.DataState.loading;
    notifyListeners();
    try {
      await sdk.remove${dart.nameType(obj.name)}(
<#list idAttrs as idAttr>  
  <#if idAttr.type.name == "datetime"><#continue></#if>
        ${modelbase.get_attribute_sql_name(idAttr)}: _editing${dart.nameType(obj.name)}!.${modelbase.get_attribute_sql_name(idAttr)}!,
</#list>      
      );
      _state = sdk.DataState.success;
      notifyListeners();
    } catch (ex) {
      handleError(ex);
      _state = sdk.DataState.error;
      notifyListeners();
    }
  }
  
  ///
  /// 通过标识获取一个【${modelbase.get_object_label(obj)}】对象。
  ///
  Future<void> fetch${dart.nameType(obj.name)}({
<#list idAttrs as idAttr>  
    ${modelbase4dart.type_attribute_primitive(idAttr)}? ${modelbase.get_attribute_sql_name(idAttr)},
</#list>    
  }) async {
    if (
<#list idAttrs as idAttr>      
      ${modelbase.get_attribute_sql_name(idAttr)} == null<#if idAttr?index != idAttrs?size - 1> ||</#if>
</#list>       
    ) {
      _editing${dart.nameType(obj.name)} = new ${dart.nameType(obj.name)}Query();
      return;
    }
    ${dart.nameType(obj.name)}Query criteria = new ${dart.nameType(obj.name)}Query();
<#list idAttrs as idAttr> 
    criteria.${modelbase.get_attribute_sql_name(idAttr)} = ${modelbase.get_attribute_sql_name(idAttr)};
</#list>    
    if (_criteriaForEditing != null && _criteriaForEditing == criteria) {
      return;
    }
    _state = sdk.DataState.loading;
    notifyListeners();
    
    _criteriaForEditing = criteria;
    try {
      _editing${dart.nameType(obj.name)} = await sdk.read${dart.nameType(obj.name)}(
<#list idAttrs as idAttr>  
  <#if idAttr.type.name == "datetime"><#continue></#if>      
        ${modelbase.get_attribute_sql_name(idAttr)}: _criteriaForEditing!.${modelbase.get_attribute_sql_name(idAttr)}!,
</#list>        
      );
      _state = sdk.DataState.success;
      notifyListeners();
    } catch (ex) {
      handleError(ex);
      _state = sdk.DataState.error;
      notifyListeners();
    }
    return null;
  }
  
  ///
  /// 通过条件获取多个【${modelbase.get_object_label(obj)}】对象集合。
  /// 返回true则说明还有更多。
  ///
  Future<bool> fetch${dart.nameType(inflector.pluralize(obj.name))}({
    ${dart.nameType(obj.name)}Query? query,
    bool reload = false,
  }) async {
    if (query == null) {
      query = new ${dart.nameType(obj.name)}Query();
    }
    if (_criteriaForListing != null && _criteriaForListing != query) {
      reload = true;
    }
    if (reload) {
      /// 表示下拉刷新，重置后再加载
      _countOf${dart.nameType(inflector.pluralize(obj.name))} = 0;
      _listed${dart.nameType(inflector.pluralize(obj.name))} = [];
    }
    if (!reload && _criteriaForListing != null && 
        _countOf${dart.nameType(inflector.pluralize(obj.name))} == _listed${dart.nameType(inflector.pluralize(obj.name))}.length) {
      /// 表示想加载更多，但没有更多了
      return false;
    }
    _state = sdk.DataState.loading;
    notifyListeners();
    
    _criteriaForListing = query;
    _criteriaForListing!.start = _listed${dart.nameType(inflector.pluralize(obj.name))}.length;
    _criteriaForListing!.limit = 10;
    try {
      Pagination<${dart.nameType(obj.name)}Query> page = await sdk.find${dart.nameType(inflector.pluralize(obj.name))}(
        query: _criteriaForListing!,
      );
      _countOf${dart.nameType(inflector.pluralize(obj.name))} = page.total;     
      _listed${dart.nameType(inflector.pluralize(obj.name))}.addAll(page.data);
<#-- 可以广而告之的 -->      
<#if obj.isLabelled("advertisable")>  
  <#assign count = obj.getLabelledOptions("advertisable")["count"]!"3">
      if (_top${count}${dart.nameType(inflector.pluralize(obj.name))}.length < ${count}) {
        for (${dart.nameType(obj.name)}Query row in page.data) {
          if (_top${count}${dart.nameType(inflector.pluralize(obj.name))}.length >= ${count}) break;
          _top${count}${dart.nameType(inflector.pluralize(obj.name))}.add(row);
        }
      }
</#if>    
<#if obj.isLabelled("browsable")>  
  <#assign count = "4">
      if (_top${count}${dart.nameType(inflector.pluralize(obj.name))}.length < ${count}) {
        for (${dart.nameType(obj.name)}Query row in page.data) {
          if (_top${count}${dart.nameType(inflector.pluralize(obj.name))}.length >= ${count}) break;
          _top${count}${dart.nameType(inflector.pluralize(obj.name))}.add(row);
        }
      }
</#if>   
      _state = sdk.DataState.success;
      notifyListeners();
    } catch (ex) {
      handleError(ex);
      _state = sdk.DataState.error;
      notifyListeners();
    }
    return _listed${dart.nameType(inflector.pluralize(obj.name))}.length != _countOf${dart.nameType(inflector.pluralize(obj.name))};
  }  
<#list obj.attributes as attr>
  <#if attr.isLabelled("incrementable")>
  
  Future<void> increment${dart.nameType(attr.name)}() async {
  }  
  </#if>
</#list>
 
<#-- 通用：集合对象属性 -->  
<#list obj.attributes as attr>
  <#if !attr.type.collection><#continue></#if>
  <#assign refObj = model.findObjectByName(attr.type.componentType.name)>
  <#assign refObjIdAttrs = modelbase.get_id_attributes(refObj)>
  <#assign singular = modelbase.get_attribute_singular(attr)>
  
  ///
  /// 添加或者更新一个【${modelbase.get_object_label(refObj)}】对象到【${modelbase.get_attribute_label(attr)}】属性。
  ///
  Future<void> addOrSet${dart.nameType(singular)}({
    required ${java.nameType(refObj.name)}Query ${java.nameVariable(refObj.name)},
  }) async {
    if (_editing${dart.nameType(obj.name)} == null) {
      return;
    }
    _state = sdk.DataState.loading;
    notifyListeners();
    try {
      ${java.nameVariable(refObj.name)} = await sdk.save${java.nameType(refObj.name)}(
        ${java.nameVariable(refObj.name)}: ${java.nameVariable(refObj.name)},
      );
      if (${java.nameVariable(refObj.name)}.${modelbase.get_attribute_sql_name(refObjIdAttrs[0])} != null) {
        _editing${dart.nameType(obj.name)}!.addOrSet${dart.nameType(singular)}(${java.nameVariable(refObj.name)});
      }
      _state = sdk.DataState.success;
      notifyListeners();
    } catch (ex) {
      handleError(ex);
      _state = sdk.DataState.error;
      notifyListeners();
    }
  }
  
  ///
  /// 从【${modelbase.get_attribute_label(attr)}】属性中删除一个【${modelbase.get_object_label(refObj)}】对象。
  ///
  Future<void> remove${dart.nameType(singular)}({
    required ${java.nameType(refObj.name)}Query ${java.nameVariable(refObj.name)},
  }) async {
    if (_editing${dart.nameType(obj.name)} == null) {
      return;
    }
    _state = sdk.DataState.loading;
    notifyListeners();
    try {
      if (await sdk.remove${java.nameType(refObj.name)}(
  <#list refObjIdAttrs as refObjIdAttr>
    <#if refObjIdAttr.type.name == "datetime"><#continue></#if>
        ${modelbase.get_attribute_sql_name(refObjIdAttr)}: ${java.nameVariable(refObj.name)}.${modelbase.get_attribute_sql_name(refObjIdAttr)}!,
  </#list>       
      )) {
        _editing${dart.nameType(obj.name)}!.remove${dart.nameType(singular)}(${java.nameVariable(refObj.name)});
      }
      _state = sdk.DataState.success;
      notifyListeners();
    } catch (ex) {
      handleError(ex);
      _state = sdk.DataState.error;
      notifyListeners();
    }
  }  
</#list>
}