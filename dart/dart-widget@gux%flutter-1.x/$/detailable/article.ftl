<#assign obj = detailable>
<#assign idAttrs = modelbase.get_id_attributes(obj)>
<#assign levelledAttrs = modelbase.level_object_attributes(obj)>
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/rendering/sliver.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '/common/format.dart';
import '/design/all.dart';
import '/model/dto.dart';
import '/provider/${obj.name}_provider.dart';
import '/sdk/sdk.dart';
import '/page/route.dart';

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

  String? _text;

  final TextEditingController _controller = new TextEditingController();
  
  late ${dart.nameType(obj.name)}Provider _${dart.nameVariable(obj.name)}Provider;

  @override
  void initState() {
    super.initState();
    _${dart.nameVariable(obj.name)}Provider = context.read<${dart.nameType(obj.name)}Provider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _${dart.nameVariable(obj.name)}Provider.fetch${dart.nameType(obj.name)}(
<#list idAttrs as idAttr>
        ${modelbase.get_attribute_sql_name(idAttr)}: widget.${modelbase.get_attribute_sql_name(idAttr)},
</#list>         
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: Consumer<${dart.nameType(obj.name)}Provider>(
        builder: (BuildContext context, ${dart.nameType(obj.name)}Provider value, Widget? child) {
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 270,
                    floating: false,
                    pinned: true,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,                   
                      background: Cover(
<#if (levelledAttrs["image"]?size > 0)>                      
                        url: value.editing${dart.nameType(obj.name)}?.${modelbase.get_attribute_sql_name(levelledAttrs["image"][0])}??'',
<#else>           
                        url: 'https://gitee.com/christiangann/tatabase-image/raw/main/1024/0006.png',             
</#if>                        
                        height: 270,
                      ),
                    ),
                    leading: CloseIconButton(color: Colors.black,),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.ios_share, color: Colors.black),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (BuildContext context) {
                              return ShareSheet();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: Offset(0, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Headline1(
<#if (levelledAttrs["primary"]?size > 0)>  
                                    text: value.editing${dart.nameType(obj.name)}?.${modelbase.get_attribute_sql_name(levelledAttrs["primary"][0])}??'',
<#else>
                                    text: '这里是标题',
</#if>
                                    lines: 3,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Avatar(url: 'https://avatar.iran.liara.run/public/66', size: 24,),
                                      SizedBox(width: 8),
                                      Text('某某人', style: TextStyle(fontSize: 14, color: colorTextSecondary),),
                                      SizedBox(width: 4),
                                      Text('2024-01-19', style: TextStyle(fontSize: 14, color: colorTextSecondary),),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(_text??'', style: TextStyle(fontSize: 16),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 88,),
                  )
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                  color: Color(0xff000000).withOpacity(0.08),
                  height: 88,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Avatar(size: 36, url: 'https://avatar.iran.liara.run/public/99'),
                      SizedBox(width: 8),
                      Expanded(child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                maxLines: 1,
                                controller: _controller,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    left: 16, bottom: 13,
                                  ),
                                  hintText: '您也来说两句',
                                  hintStyle: TextStyle(fontSize: 14, color: colorTextPlaceholder,),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(fontSize: 14,),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.only(bottom: 1), // Symmetric
                              ),
                              child: Text('发送',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}