<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/modelbase4dart.ftl" as modelbase4dart>
<#import "/$/modelbase4flutter.ftl" as modelbase4flutter>
<#import "/$/gux.ftl" as gux>
<#if license??>
${dart.license(license)}
</#if>
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../route.dart';
import '/common/format.dart';
import '/design/all.dart';
import '/model/dto.dart';
<#assign providers = {}>
<#assign browsables = []>
<#assign advertisables = []>
<#assign enterables = []>
<#list model.objects as obj>
  <#if obj.isLabelled("browsable")>
    <#assign browsables += [obj]>
    <#assign providers += {obj.name:obj}>
import '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name}_card.dart';        
  </#if>  
  <#if obj.isLabelled("advertisable")>
    <#assign advertisables += [obj]>
    <#assign providers += {obj.name:obj}> 
import '/page/${app.name}/${modelbase.get_object_module(obj)}/${obj.name}_ad.dart';    
  </#if>   
  <#if obj.isLabelled("enterable")>
    <#assign enterables += [obj]>
    <#assign providers += {obj.name:obj}>    
  </#if>
</#list>
<#list providers?keys as objname>
import '/provider/${objname}_provider.dart';
</#list>
import '/sdk/sdk.dart';

class Home extends StatefulWidget {
  
  Home({
    super.key,
  });
  
  @override
  State<StatefulWidget> createState() => HomeState();

}

class HomeState extends State<Home> {
<#list providers?keys as objname>

  late ${dart.nameType(objname)}Provider _${dart.nameVariable(objname)}Provider;
</#list>  

  @override
  void initState() {
    super.initState();
<#list providers?keys as objname>    
    _${dart.nameVariable(objname)}Provider = context.read<${dart.nameType(objname)}Provider>();
</#list>    
    WidgetsBinding.instance.addPostFrameCallback((_) {
<#list providers?keys as objname>    
      _${dart.nameVariable(objname)}Provider.fetch${java.nameType(inflector.pluralize(objname))}();
</#list>  
    });
  }
  
  @override
  void didUpdateWidget(covariant Home oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [        
<#list advertisables as ad>
  <#assign mode = ad.getLabelledOptions("advertisable")["mode"]!"">
  <#if mode == "cyclenavigator">
<@gux.print_flutter_declare_cyclenavigator obj=ad indent=12 />
  </#if>
</#list>    
<#list enterables as enter>
</#list>   
<#if (enterables?size > 0)>
            SizedBox(height: padding),
            _buildEnterableSection(),
</#if>    
<#list advertisables as ad>
  <#assign mode = ad.getLabelledOptions("advertisable")["mode"]!"">
  <#if mode == "scrollnavigator">
            SizedBox(height: padding),
            Row(
              children: [
                SizedBox(width: padding,),
                Headline5(text: '${modelbase.get_object_label(ad)}'),
                const Spacer(),
                More(label: '查看更多', doTap: () => goto${dart.nameType(ad.name)}List(context)),
                SizedBox(width: padding,),
              ],
            ),
            SizedBox(height: padding),
<@gux.print_flutter_declare_scrollnavigator obj=ad indent=12 />
  </#if>
</#list>  
<#list browsables as browsable>
            SizedBox(height: padding),
            Row(
              children: [
                SizedBox(width: padding,),
                Headline5(text: '${modelbase.get_object_label(browsable)}'),
                const Spacer(),
                More(label: '查看更多', doTap: () => goto${dart.nameType(browsable.name)}Coll(context)),
                SizedBox(width: padding,),
              ],
            ),
            SizedBox(height: padding),
            _buildBrowsableSectionFor${dart.nameType(browsable.name)}(),
</#list>
            const SizedBox(height: padding),
          ],
        ),
      ),
    );
  }
<#if (enterables?size > 0)>
    
  Widget _buildEnterableSection() {
    return Container(
      width: screenWidth - padding * 2,
      margin: EdgeInsets.symmetric(horizontal: padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(padding),
      ),
      child: Wrap(
        spacing: padding,
        runSpacing: padding,
        children: [
  <#list enterables as enterable>
          _buildEnterableEntry(
            background: Colors.transparent, 
            foreground: colorPrimary,
            icon: Icon(Icons.search, color: colorPrimary,), 
            title: "${modelbase.get_object_label(enterable)}"),
  </#list>
        ],
      ),
    );
  }
  
  ///
  /// 构建入口按钮
  ///
  Widget _buildEnterableEntry({
    required Color foreground,
    required Color background,
    required Widget icon,
    required String title,
  }) {
    return Container(
      width: (screenWidth - padding * 4) / 3,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: background,
            shadowColor: Colors.transparent, 
          ),
          onPressed: () {
            
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(height: 5,),
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: foreground),)
            ],
          ),
        ),
      ),
    );
  }
</#if>  
<#list browsables as browsable>  
  <#assign idAttrs = modelbase.get_id_attributes(browsable)>
  
  ///
  /// 构建浏览部分
  ///
  Widget _buildBrowsableSectionFor${dart.nameType(browsable.name)}() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(padding),
      ),
      width: screenWidth - padding * 2,
      child: Consumer<${dart.nameType(browsable.name)}Provider>(
        builder: (BuildContext context, ${dart.nameType(browsable.name)}Provider value, Widget? child) {
          return Column(
            children: _${dart.nameVariable(browsable.name)}Provider.top4${inflector.pluralize(dart.nameType(browsable.name))}.map((item) {
              return Container(
                margin: EdgeInsets.only(bottom: padding,),
                child: GestureDetector(
                  onTap: () => goto${dart.nameType(browsable.name)}Detail(context,
<#list idAttrs as idAttr>
                    ${modelbase.get_attribute_sql_name(idAttr)}: item.${modelbase.get_attribute_sql_name(idAttr)}!,
</#list>                                 
                  ),
                  child: ${dart.nameType(browsable.name)}Card(
                    ${dart.nameVariable(browsable.name)}: item,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
</#list>
}