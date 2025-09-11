<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#import "/$/modelbase4flutter.ftl" as modelbase4flutter>
<#if license??>
${dart.license(license)}
</#if>
import 'package:flutter/material.dart';

import '/main.dart';
import '/model/dto.dart';
import '/page/personal/profile_settings.dart';
import '/page/personal/profile_base_edit.dart';
import '/page/personal/personal_cart.dart';
<#list model.objects as obj>
  <#if obj.isLabelled("browsable")>
import '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name}_coll.dart';     
import '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name}_search.dart';        
  </#if>
  <#if obj.isLabelled("listable")>
import '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name}_list.dart';     
import '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name}_search.dart';        
  </#if>
  <#if obj.isLabelled("editable")>
import '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name}_edit.dart';       
  </#if>
  <#if obj.isLabelled("detailable")>
import '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name}_detail.dart';        
  </#if>
  <#if obj.isLabelled("purchasable")>
import '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name}_purchase.dart';        
  </#if>
  <#if obj.isLabelled("personalizable")>
/// import '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name}_part_of_profile.dart';       
  </#if>
</#list>

<#assign gotoMethods = {}>
///
/// 跳转到【入口】页面
///
Future<void> gotoMain(BuildContext context) async {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => MainPage()),
        (Route<dynamic> route) => false,
  );
}
<#list model.objects as obj>
  <#assign idAttrs = modelbase.get_id_attributes(obj)>
  <#if obj.isLabelled("browsable")>
  
///
/// 跳转到【${modelbase.get_object_label(obj)}】栅格集合页面
///
Future<void> goto${dart.nameType(obj.name)}Coll(BuildContext context) async {
  await Navigator.push(context,
    MaterialPageRoute(builder: (context) => ${dart.nameType(obj.name)}Coll()),
  );
}
    <#if !gotoMethods["goto" + dart.nameType(obj.name) + "Search"]??>
      <#assign gotoMethods += {"goto" + dart.nameType(obj.name) + "Search": ""}>
      
///
/// 弹出显示【${modelbase.get_object_label(obj)}】栅格查询页面
///
Future<${dart.nameType(obj.name)}Query?> goto${dart.nameType(obj.name)}Search(BuildContext context, {
  ${dart.nameType(obj.name)}Query? criteria,
}) async {
  return await Navigator.push(context,
    MaterialPageRoute(builder: (context) => ${dart.nameType(obj.name)}Search(
      criteria: criteria,
    ),),
  );
}
    </#if>
  </#if>
  <#if obj.isLabelled("listable")>
  
///
/// 跳转到【${modelbase.get_object_label(obj)}】列表集合页面
///
Future<void> goto${dart.nameType(obj.name)}List(BuildContext context) async {
  await Navigator.push(context,
    MaterialPageRoute(builder: (context) => ${dart.nameType(obj.name)}List()),
  );
}
    <#if !gotoMethods["goto" + dart.nameType(obj.name) + "Search"]??>
      <#assign gotoMethods += {"goto" + dart.nameType(obj.name) + "Search": ""}>
///
/// 弹出显示【${modelbase.get_object_label(obj)}】列表查询页面
///
Future<${dart.nameType(obj.name)}Query?> goto${dart.nameType(obj.name)}Search(BuildContext context, {
  ${dart.nameType(obj.name)}Query? criteria,
}) async {
  return await Navigator.push(context,
    MaterialPageRoute(builder: (context) => ${dart.nameType(obj.name)}Search()),
  );
}
    </#if>
  </#if>
  <#if obj.isLabelled("detailable")>
  
///
/// 跳转到【${modelbase.get_object_label(obj)}】详情页面
///
Future<void> goto${dart.nameType(obj.name)}Detail(BuildContext context,{
  <#list idAttrs as idAttr>
  required ${modelbase4dart.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)},
  </#list>
}) async {
  await Navigator.push(context,
    MaterialPageRoute(builder: (context) => ${dart.nameType(obj.name)}Detail(
  <#list idAttrs as idAttr>
      ${modelbase.get_attribute_sql_name(idAttr)}: ${modelbase.get_attribute_sql_name(idAttr)},
  </#list>   
    ),),
  );
}  
  </#if>
  <#if obj.isLabelled("purchasable")>
  
///
/// 跳转到【${modelbase.get_object_label(obj)}】购买页面
///
Future<void> goto${dart.nameType(obj.name)}Purchase(BuildContext context,{
  <#list idAttrs as idAttr>
  required ${modelbase4dart.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)},
  </#list>
}) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.9,
      child: ${dart.nameType(obj.name)}Purchase(
  <#list idAttrs as idAttr>
        ${modelbase.get_attribute_sql_name(idAttr)}: ${modelbase.get_attribute_sql_name(idAttr)},
  </#list>  
      ), 
    ),
  );
}  
  </#if>
</#list>

///
/// 跳转到【个人信息】编辑页面
///
Future<void> gotoProfileBaseEdit(BuildContext context) async {
  Navigator.push(context,
    MaterialPageRoute(builder: (context) => ProfileBaseEdit(),),
  );
}

///
/// 跳转到【购物车】页面
///
Future<void> gotoPersonalCart(BuildContext context) async {
  await Navigator.push(context,
    MaterialPageRoute(builder: (context) => PersonalCart(),),
  );  
} 