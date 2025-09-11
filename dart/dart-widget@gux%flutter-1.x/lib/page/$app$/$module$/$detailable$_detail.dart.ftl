<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#if license??>
${dart.license(license)}
</#if>
<#assign type = detailable.getLabelledOptions("detailable")["type"]!"">
<#assign obj = detailable>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#if type == "article">
<#include "/$/detailable/article.ftl">
<#elseif type == "merchandise">
<#include "/$/detailable/merchandise.ftl">
<#elseif type == "activity">
<#include "/$/detailable/activity.ftl">
<#else>
class ${dart.nameType(obj.name)}Detail extends StatefulWidget {
<#list idAttrs as idAttr>

  final ${modelbase4dart.type_attribute_primitive(idAttr)} ${modelbase.get_attribute_sql_name(idAttr)};
</#list>

  ${dart.nameType(obj.name)}Detail({
    Key? key,
<#list idAttrs as idAttr>
    required this.${modelbase.get_attribute_sql_name(idAttr)},
</#list>    
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>  ${dart.nameType(obj.name)}DetailState();

}

class  ${dart.nameType(obj.name)}DetailState extends State< ${dart.nameType(obj.name)}Detail> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }  
}
</#if>