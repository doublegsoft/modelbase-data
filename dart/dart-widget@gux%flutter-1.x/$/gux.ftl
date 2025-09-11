<#--
 ###############################################################################
 ### 循环导航 CYCLE NAVIGATOR
 ###############################################################################
 -->
<#macro print_flutter_headers_cyclenavigator existings>
  <#if !existings["cyclenavigator"]??>
import 'package:carousel_slider/carousel_slider.dart';
    <#local existings += {"cyclenavigator":"cyclenavigator"}>
  </#if>
</#macro> 
 
<#macro print_flutter_declare_cyclenavigator obj indent>
  <#local idAttrs = modelbase.get_id_attributes(obj)>
  <#local count = obj.getLabelledOptions("advertisable")["count"]!"5">
  <#local levelledAttrs = modelbase.level_object_attributes(obj)>
  <#if (levelledAttrs["image"]?size > 0)>
    <#local attrImage = levelledAttrs["image"][0]>
  </#if>
${""?left_pad(indent)}Consumer<${dart.nameType(obj.name)}Provider>(
${""?left_pad(indent)}  builder: (BuildContext context, ${dart.nameType(obj.name)}Provider value, Widget? child) {
${""?left_pad(indent)}    return CycleNavigator(
${""?left_pad(indent)}      height: 200,
${""?left_pad(indent)}      data: value.top${count}${inflector.pluralize(dart.nameType(obj.name))},
${""?left_pad(indent)}      builder: (context, item) {
${""?left_pad(indent)}        return GestureDetector(
${""?left_pad(indent)}          onTap: () => goto${dart.nameType(obj.name)}Detail(context,
  <#list idAttrs as idAttr>
${""?left_pad(indent)}            ${modelbase.get_attribute_sql_name(idAttr)}: item.${modelbase.get_attribute_sql_name(idAttr)}!,
  </#list>                  
${""?left_pad(indent)}          ),
${""?left_pad(indent)}          child: ${dart.nameType(obj.name)}Ad(
${""?left_pad(indent)}            ${dart.nameVariable(obj.name)}: item,
${""?left_pad(indent)}          ),
${""?left_pad(indent)}        );
${""?left_pad(indent)}      },
${""?left_pad(indent)}    );
${""?left_pad(indent)}  },
${""?left_pad(indent)}),
</#macro>

<#macro print_flutter_fields_cyclenavigator attr indent>

</#macro>

<#macro print_flutter_methods_cyclenavigator obj indent>

</#macro>

<#--
 ###############################################################################
 ### 滑动导航 SLIDE NAVIGATOR
 ###############################################################################
 -->
<#macro print_flutter_declare_scrollnavigator obj indent>
  <#local idAttrs = modelbase.get_id_attributes(obj)>
  <#local count = obj.getLabelledOptions("advertisable")["count"]!"5">
${""?left_pad(indent)}Container(
${""?left_pad(indent)}  decoration: BoxDecoration(
${""?left_pad(indent)}    color: Colors.transparent,
${""?left_pad(indent)}    borderRadius: BorderRadius.circular(16),
${""?left_pad(indent)}  ),
${""?left_pad(indent)}  height: 128,
${""?left_pad(indent)}  width: screenWidth - padding * 2,
${""?left_pad(indent)}  child: Consumer<${dart.nameType(obj.name)}Provider>(
${""?left_pad(indent)}    builder: (BuildContext context, ${dart.nameType(obj.name)}Provider value, Widget? child) {
${""?left_pad(indent)}      return ListView(
${""?left_pad(indent)}        scrollDirection: Axis.horizontal,
${""?left_pad(indent)}        children: _${dart.nameVariable(obj.name)}Provider.top${count}${inflector.pluralize(dart.nameType(obj.name))}.map((item) {
${""?left_pad(indent)}          return GestureDetector(
${""?left_pad(indent)}            onTap: () => goto${dart.nameType(obj.name)}Detail(context,
  <#list idAttrs as idAttr>
${""?left_pad(indent)}              ${modelbase.get_attribute_sql_name(idAttr)}: item.${modelbase.get_attribute_sql_name(idAttr)}!,
  </#list>                  
${""?left_pad(indent)}            ),
${""?left_pad(indent)}            child: ${dart.nameType(obj.name)}Ad(
${""?left_pad(indent)}              width: 200,
${""?left_pad(indent)}              ${dart.nameVariable(obj.name)}: item,
${""?left_pad(indent)}            ),
${""?left_pad(indent)}          );
${""?left_pad(indent)}        }).toList(),
${""?left_pad(indent)}      );
${""?left_pad(indent)}    },
${""?left_pad(indent)}  ),
${""?left_pad(indent)}),
</#macro>